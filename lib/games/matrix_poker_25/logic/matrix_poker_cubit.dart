import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genius_project/core/models/coordinate.dart';

import '../ai/matrix_poker_ai_agent.dart';
import '../models/matrix_grid_model.dart';
import 'combo.dart';
import 'game_loop_manager.dart';
import 'matrix_poker_state.dart';
import 'number_bag.dart';
import 'player_draft_manager.dart';

/// Online-first presenter for Matrix Poker 25 (phases 1–3).
///
/// Holds the pure Dart [GameLoopManager] **once the duel starts** plus both
/// [PlayerDraftManager]s at construction time. Until [submitDrafts] completes,
/// [_duel] stays null — the cubit still owns the same draft-manager instances
/// that will later be wired into [GameLoopManager] (mirroring how a real server
/// would persist both sides’ decks).
///
/// Mock **Player 2** behaviour uses [Future.delayed] to imitate latency.
class MatrixPokerCubit extends Cubit<MatrixPokerState> {
  MatrixPokerCubit({
    required PlayerDraftManager playerOneDrafts,
    required PlayerDraftManager playerTwoDrafts,
    required MatrixGridModel playerOneGrid,
    required MatrixPokerAiAgent opponentAgent,
    Random? random,
  })  : _playerOneDrafts = playerOneDrafts,
        _playerTwoDrafts = playerTwoDrafts,
        _playerOneGrid = playerOneGrid,
        _playerTwoGrid = MatrixGridModel(),
        _opponentAgent = opponentAgent,
        _rng = random ?? Random(),
        super(const MatrixPokerState.initial());

  static const int _phase1Seconds = 15;
  static const int _phase2Seconds = 180;
  static const int _phase3Seconds = 30;

  Timer? _phaseTimer;

  final PlayerDraftManager _playerOneDrafts;
  final PlayerDraftManager _playerTwoDrafts;

  /// Local human grid (filled in [startDrafting]).
  final MatrixGridModel _playerOneGrid;

  /// Synthetic opponent board — filled while mocking P2 drafts.
  final MatrixGridModel _playerTwoGrid;

  final MatrixPokerAiAgent _opponentAgent;

  final Random _rng;

  /// Human drafting surface — UI uses [PlayerDraftManager.tryDraftCombo] here.
  PlayerDraftManager get playerOneDrafts => _playerOneDrafts;

  /// P1’s filled board (read-only in duel UI).
  MatrixGridModel get playerOneGrid => _playerOneGrid;

  /// `true` if combo slot [comboIndex] (`0..11`) is already played for P1.
  bool isPlayerOneComboConsumed(int comboIndex) {
    if (_duel == null) {
      return false;
    }
    return _duel!.isComboConsumed(0, comboIndex);
  }

  GameLoopManager? _duel;

  /// Last duel resolution snapshot for UI overlays that need round metadata.
  RoundResolution? _latestRoundResolution;

  /// Shuffled 1–10 bag for Phase 1 dealer draws (30 values by default).
  NumberBag? _phaseOneDealerBag;

  /// Populated while [MatrixPokerState.roundResolved] is active (for overlays).
  RoundResolution? get latestRoundResolution => _latestRoundResolution;

  /// Header scores while the duel manager exists (used during [MatrixPokerState.waitingForOpponent]).
  ({int round, int p1Score, int p2Score}) get duelScoresHeader {
    final duel = _duel;
    if (duel == null) {
      throw StateError('duelScoresHeader called without an active duel.');
    }
    return (
      round: duel.currentRound,
      p1Score: duel.scorePlayer1,
      p2Score: duel.scorePlayer2,
    );
  }

  /// Starts a new match: **Phase 1** — empty grids and the first dealer draw.
  void startDrafting() {
    _cancelPhaseTimer();
    _duel = null;
    _playerOneDrafts.clear();
    _playerTwoDrafts.clear();
    _playerOneGrid.clear();
    _playerTwoGrid.clear();
    _phaseOneDealerBag = NumberBag(_rng);
    emit(
      MatrixPokerState.boardFilling(
        grid: _playerOneGrid,
        fillRound: 1,
        dealerValue: _drawDealerFromBag(),
        remainingSeconds: _phase1Seconds,
      ),
    );
    _startTimer(_phase1Seconds, () => unawaited(_onPhase1Timeout()));
  }

  /// P1 places the current dealer number on an empty cell; mock P2 mirrors on their grid.
  ///
  /// Returns `false` if the cell is invalid or occupied. When all **25** cells are filled,
  /// emits [MatrixPokerState.drafting].
  Future<bool> tryPlaceDealerNumber(Coordinate coord) async {
    final filling = state.maybeWhen(
      boardFilling:
          (_, fillRound, dealerValue, remainingSeconds, totalRounds) => (
        fillRound: fillRound,
        dealerValue: dealerValue,
        totalRounds: totalRounds,
      ),
      orElse: () => null,
    );
    if (filling == null) {
      return false;
    }

    _cancelPhaseTimer();

    if (!_playerOneGrid.placeNumber(coord, filling.dealerValue)) {
      _startTimer(_phase1Seconds, () => unawaited(_onPhase1Timeout()));
      return false;
    }

    // AI opponent mirrors the same dealer draw on its own board.
    final pick =
        await _opponentAgent.placeNumber(_playerTwoGrid, filling.dealerValue);
    final ok = _playerTwoGrid.placeNumber(pick, filling.dealerValue);
    if (!ok) {
      // Fallback: if AI picked an occupied cell (shouldn't), revert to random.
      _placeOpponentRandom(_playerTwoGrid, filling.dealerValue);
    }

    if (_playerOneGrid.isFull()) {
      if (!_playerTwoGrid.isFull()) {
        throw StateError('P1 board full but mock P2 board is not.');
      }
      emit(
        MatrixPokerState.drafting(
          grid: _playerOneGrid,
          draftedCombos: List.of(_playerOneDrafts.combos),
          remainingSeconds: _phase2Seconds,
        ),
      );
      _startTimer(_phase2Seconds, () => unawaited(_onPhase2Timeout()));
      return true;
    }

    emit(
      MatrixPokerState.boardFilling(
        grid: _playerOneGrid,
        fillRound: filling.fillRound + 1,
        dealerValue: _drawDealerFromBag(),
        remainingSeconds: _phase1Seconds,
        totalRounds: filling.totalRounds,
      ),
    );
    _startTimer(_phase1Seconds, () => unawaited(_onPhase1Timeout()));
    return true;
  }

  /// Locks in twelve local combos, waits **1s** (mock sync), then mock P2 drafts on [_playerTwoGrid].
  ///
  /// Afterwards constructs [GameLoopManager] and emits [MatrixPokerState.duelTurn].
  Future<void> submitDrafts(List<Combo> myCombos) async {
    _cancelPhaseTimer();
    if (myCombos.length != PlayerDraftManager.maxDrafts) {
      throw ArgumentError.value(
        myCombos.length,
        'myCombos.length',
        'Expected exactly ${PlayerDraftManager.maxDrafts} combos.',
      );
    }

    _playerOneDrafts.installDrafts(myCombos);

    await Future<void>.delayed(const Duration(seconds: 1));
    if (isClosed) {
      return;
    }

    _playerTwoDrafts.clear();

    if (!_playerTwoGrid.isFull()) {
      _fillBoardFromBag(_playerTwoGrid, NumberBag(_rng));
    }
    final opponentCombos = await _opponentAgent.draftCombos(_playerTwoGrid);
    _playerTwoDrafts.installDrafts(opponentCombos);

    _duel = GameLoopManager(
      player1Drafts: _playerOneDrafts,
      player2Drafts: _playerTwoDrafts,
    );

    emit(_buildDuelTurnState(remainingSeconds: _phase3Seconds));
    _startTimer(_phase3Seconds, () => unawaited(_onPhase3Timeout()));
  }

  /// Human selects a combo slot for the current duel round.
  ///
  /// Emits [MatrixPokerState.waitingForOpponent] immediately, waits **1.5s**, performs
  /// mock-opponent commitment, resolves via [GameLoopManager], then emits
  /// [MatrixPokerState.roundResolved]. Call [advanceAfterRoundResolved] to return to
  /// [MatrixPokerState.duelTurn] or enter [MatrixPokerState.gameOver].
  Future<void> commitCombo(int comboIndex) async {
    final inDuelTurn = state.maybeWhen(
      duelTurn: (_, __, ___, ____, _____) => true,
      orElse: () => false,
    );
    if (!inDuelTurn || _duel == null) {
      throw StateError(
        'commitCombo requires MatrixPokerState.duelTurn and an active duel.',
      );
    }

    _cancelPhaseTimer();

    if (comboIndex < 0 || comboIndex >= PlayerDraftManager.maxDrafts) {
      throw RangeError.range(
        comboIndex,
        0,
        PlayerDraftManager.maxDrafts - 1,
        'comboIndex',
      );
    }

    if (_duel!.isComboConsumed(0, comboIndex)) {
      throw StateError('Combo #$comboIndex is already consumed for Player 1.');
    }

    emit(const MatrixPokerState.waitingForOpponent());

    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (isClosed) {
      return;
    }

    final duel = _duel!;
    duel.commitCombo(0, comboIndex);

    final p2Pick = _pickRandomUnusedComboIndexForPlayer(duel, 1, _rng);
    final resolution = duel.commitCombo(1, p2Pick);
    if (resolution == null) {
      throw StateError('Duel did not resolve after mock opponent commit.');
    }

    _latestRoundResolution = resolution;
    emit(
      MatrixPokerState.roundResolved(
        p1Revealed: resolution.player1Combo,
        p2Revealed: resolution.player2Combo,
        resultMessage: _formatRoundResultMessage(resolution),
        isGameOver: duel.gameComplete,
      ),
    );
  }

  /// Transition out of [MatrixPokerState.roundResolved] into the next duel setup or game-over banner.
  void advanceAfterRoundResolved() {
    final isRoundResolved = state.maybeWhen(
      roundResolved: (_, __, ___, ____) => true,
      orElse: () => false,
    );
    if (!isRoundResolved || _duel == null) {
      return;
    }

    final duel = _duel!;
    _latestRoundResolution = null;
    if (duel.gameComplete) {
      _cancelPhaseTimer();
      emit(
        MatrixPokerState.gameOver(
          finalP1Score: duel.scorePlayer1,
          finalP2Score: duel.scorePlayer2,
          winner: _overallWinnerLabel(duel),
        ),
      );
    } else {
      emit(_buildDuelTurnState(remainingSeconds: _phase3Seconds));
      _startTimer(_phase3Seconds, () => unawaited(_onPhase3Timeout()));
    }
  }

  // ── Internal helpers ───────────────────────────────────────────────

  int _drawDealerFromBag() {
    final bag = _phaseOneDealerBag;
    if (bag == null || bag.isEmpty) {
      _phaseOneDealerBag = NumberBag(_rng);
    }
    return _phaseOneDealerBag!.draw();
  }

  void _placeOpponentRandom(MatrixGridModel grid, int dealerValue) {
    final empty = <Coordinate>[];
    for (var y = 0; y < 5; y++) {
      for (var x = 0; x < 5; x++) {
        final c = Coordinate(x, y);
        if (grid.getNumberAt(c) == 0) {
          empty.add(c);
        }
      }
    }
    if (empty.isEmpty) {
      throw StateError('Opponent grid has no empty cell during Phase 1.');
    }
    final pick = empty[_rng.nextInt(empty.length)];
    final ok = grid.placeNumber(pick, dealerValue);
    if (!ok) {
      throw StateError(
          'Mock opponent placement failed at (${pick.x},${pick.y}).');
    }
  }

  MatrixPokerState _buildDuelTurnState({required int remainingSeconds}) {
    final duel = _duel!;
    return MatrixPokerState.duelTurn(
      round: duel.currentRound,
      p1Score: duel.scorePlayer1,
      p2Score: duel.scorePlayer2,
      remainingSeconds: remainingSeconds,
      p1RemainingCombos: List<Combo>.of(_playerOneDrafts.combos),
    );
  }

  static String _formatRoundResultMessage(RoundResolution r) {
    final headline = switch (r.winner) {
      RoundWinner.player1 => 'Player 1 wins the round.',
      RoundWinner.player2 => 'Player 2 wins the round.',
      RoundWinner.tie => 'Tie — no point this round.',
    };
    return '$headline Score: ${r.scorePlayer1After} – ${r.scorePlayer2After}.';
  }

  static String _overallWinnerLabel(GameLoopManager duel) {
    final p1 = duel.scorePlayer1;
    final p2 = duel.scorePlayer2;
    if (p1 == p2) {
      return 'Draw';
    }
    return p1 > p2 ? 'Player 1 wins the duel.' : 'Player 2 wins the duel.';
  }

  void _startTimer(int seconds, void Function() onTimeout) {
    _cancelPhaseTimer();
    var remaining = seconds;
    _setRemainingSeconds(remaining);

    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      remaining--;
      if (remaining <= 0) {
        _cancelPhaseTimer();
        _setRemainingSeconds(0);
        onTimeout();
        return;
      }
      _setRemainingSeconds(remaining);
    });
  }

  void _setRemainingSeconds(int remainingSeconds) {
    state.maybeMap(
      boardFilling: (s) => emit(s.copyWith(remainingSeconds: remainingSeconds)),
      drafting: (s) => emit(
        s.copyWith(
          remainingSeconds: remainingSeconds,
          // Keep state drafts in sync so UI doesn't reset to 0/12 on timer ticks.
          draftedCombos: List<Combo>.of(_playerOneDrafts.combos),
        ),
      ),
      duelTurn: (s) => emit(
        s.copyWith(
          remainingSeconds: remainingSeconds,
          p1RemainingCombos: List<Combo>.of(_playerOneDrafts.combos),
        ),
      ),
      orElse: () {},
    );
  }

  void _cancelPhaseTimer() {
    _phaseTimer?.cancel();
    _phaseTimer = null;
  }

  Future<void> _onPhase1Timeout() async {
    final dealerValue = state.maybeWhen(
      boardFilling: (_, __, dealerValue, ___, ____) => dealerValue,
      orElse: () => null,
    );
    if (dealerValue == null) return;

    final empty = <Coordinate>[];
    for (var y = 0; y < 5; y++) {
      for (var x = 0; x < 5; x++) {
        final c = Coordinate(x, y);
        if (_playerOneGrid.getNumberAt(c) == 0) {
          empty.add(c);
        }
      }
    }
    if (empty.isEmpty) return;
    final pick = empty[_rng.nextInt(empty.length)];
    await tryPlaceDealerNumber(pick);
  }

  Future<void> _onPhase2Timeout() async {
    final drafting = state.maybeWhen(
      drafting: (grid, draftedCombos, remainingSeconds) => grid,
      orElse: () => null,
    );
    if (drafting == null) return;

    final current = List<Combo>.of(_playerOneDrafts.combos);
    final existingKeys = current.map(comboKey).toSet();

    final all = computeAllDraftCombos(drafting)..sort(compareStrongestFirst);
    for (final c in all) {
      if (current.length >= PlayerDraftManager.maxDrafts) break;
      final key = comboKey(c);
      if (existingKeys.contains(key)) continue;
      current.add(c);
      existingKeys.add(key);
    }

    if (current.length != PlayerDraftManager.maxDrafts) return;
    await submitDrafts(current);
  }

  Future<void> _onPhase3Timeout() async {
    final duel = _duel;
    if (duel == null) return;
    final inDuelTurn = state.maybeWhen(
      duelTurn: (_, __, ___, ____, _____) => true,
      orElse: () => false,
    );
    if (!inDuelTurn) return;

    final idx = _pickRandomUnusedComboIndexForPlayer(duel, 0, _rng);
    await commitCombo(idx);
  }

  @override
  Future<void> close() {
    _cancelPhaseTimer();
    return super.close();
  }
}

int _pickRandomUnusedComboIndexForPlayer(
  GameLoopManager duel,
  int playerIndex,
  Random rng,
) {
  final unused = [
    for (var i = 0; i < PlayerDraftManager.maxDrafts; i++)
      if (!duel.isComboConsumed(playerIndex, i)) i,
  ];
  if (unused.isEmpty) {
    throw StateError('No unused combos for mock player $playerIndex.');
  }
  return unused[rng.nextInt(unused.length)];
}

void _fillBoardFromBag(MatrixGridModel grid, NumberBag bag) {
  for (var y = 0; y < 5; y++) {
    for (var x = 0; x < 5; x++) {
      final ok = grid.placeNumber(Coordinate(x, y), bag.draw());
      if (!ok) {
        throw StateError('Failed bag fill at ($x,$y).');
      }
    }
  }
}

// Legacy mock draft helper (kept for older transcripts); unused now that AI agents
// draft directly via MatrixPokerAiAgent.draftCombos().
