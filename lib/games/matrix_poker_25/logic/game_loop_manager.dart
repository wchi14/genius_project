import 'combo.dart';
import 'player_draft_manager.dart';

/// Outcome of comparing two revealed combos in one duel round.
enum RoundWinner {
  /// Player 1 (index 0) wins the round (+1 point).
  player1,

  /// Player 2 (index 1) wins the round (+1 point).
  player2,

  /// Same [HandRank] and same [Combo.primaryKeyValue]; no points awarded.
  tie,
}

/// Snapshot produced after both players commit and the round resolves.
///
/// Lets callers (e.g. console simulations) print commentary without duplicating
/// comparison logic.
class RoundResolution {
  const RoundResolution({
    required this.roundNumber,
    required this.player1Combo,
    required this.player2Combo,
    required this.winner,
    required this.scorePlayer1After,
    required this.scorePlayer2After,
  });

  /// 1-based duel round that just finished.
  final int roundNumber;

  final Combo player1Combo;
  final Combo player2Combo;

  /// Which side earned the point this round ([RoundWinner.tie] → no change).
  final RoundWinner winner;

  final int scorePlayer1After;
  final int scorePlayer2After;
}

/// Where the state machine is waiting within the current round’s blind commits.
enum DuelCommitPhase {
  /// All 12 rounds finished.
  gameOver,

  /// Neither player has locked in a combo this round yet.
  awaitingCommits,

  /// Player 1 has committed; still blind to P2’s choice.
  awaitingPlayer2,

  /// Player 2 has committed; still blind to P1’s choice.
  awaitingPlayer1,
}

/// Phase **3** duel loop: twelve simultaneous blind picks, reveal, score, consume combos.
///
/// Each player’s [PlayerDraftManager] must already hold **12** legal drafts.
/// [commitCombo] enforces one submission per player per round and refuses reused
/// combo indices. Only past rounds appear in [revealedHistoryPlayer1] /
/// [revealedHistoryPlayer2] (information hiding for blind play).
class GameLoopManager {
  GameLoopManager({
    required PlayerDraftManager player1Drafts,
    required PlayerDraftManager player2Drafts,
  })  : _p1Drafts = player1Drafts,
        _p2Drafts = player2Drafts {
    if (_p1Drafts.draftCount != PlayerDraftManager.maxDrafts ||
        _p2Drafts.draftCount != PlayerDraftManager.maxDrafts) {
      throw ArgumentError(
        'Both players need exactly ${PlayerDraftManager.maxDrafts} drafted combos.',
      );
    }
  }

  final PlayerDraftManager _p1Drafts;
  final PlayerDraftManager _p2Drafts;

  /// 1-based index of the round currently accepting commits (`1..12`).
  int _activeRound = 1;

  int _scoreP1 = 0;
  int _scoreP2 = 0;

  final Set<int> _usedComboIndicesP1 = {};
  final Set<int> _usedComboIndicesP2 = {};

  int? _pendingP1ComboIndex;
  int? _pendingP2ComboIndex;

  bool _gameComplete = false;

  /// Combos player 1 has **already revealed** in resolved rounds (FIFO).
  final List<Combo> revealedHistoryPlayer1 = [];

  /// Combos player 2 has **already revealed** in resolved rounds (FIFO).
  final List<Combo> revealedHistoryPlayer2 = [];

  int get scorePlayer1 => _scoreP1;

  int get scorePlayer2 => _scoreP2;

  /// Round currently in progress (`1..12`), or `12` after the last resolution until observed.
  int get currentRound => _activeRound;

  bool get gameComplete => _gameComplete;

  DuelCommitPhase get commitPhase {
    if (_gameComplete) return DuelCommitPhase.gameOver;
    if (_pendingP1ComboIndex == null && _pendingP2ComboIndex == null) {
      return DuelCommitPhase.awaitingCommits;
    }
    if (_pendingP1ComboIndex == null) return DuelCommitPhase.awaitingPlayer1;
    if (_pendingP2ComboIndex == null) return DuelCommitPhase.awaitingPlayer2;
    throw StateError('Invalid phase: both players pending without resolution.');
  }

  /// Whether [comboIndex] (`0..11`) has already been played by [playerIndex].
  bool isComboConsumed(int playerIndex, int comboIndex) {
    final used = playerIndex == 0 ? _usedComboIndicesP1 : _usedComboIndicesP2;
    return used.contains(comboIndex);
  }

  /// Locks in [comboIndex] for [playerIndex] (`0` = P1, `1` = P2).
  ///
  /// Returns a [RoundResolution] when this commit completes the pair (both
  /// players locked in) and the round resolves immediately. Returns `null` if
  /// the duel still waits for the opponent’s blind choice.
  ///
  /// Throws [StateError] on illegal double-commit, reused combo, or commits after
  /// the twelfth round resolves.
  RoundResolution? commitCombo(int playerIndex, int comboIndex) {
    if (_gameComplete) {
      throw StateError('Game already finished.');
    }
    if (playerIndex != 0 && playerIndex != 1) {
      throw ArgumentError.value(playerIndex, 'playerIndex', 'must be 0 or 1.');
    }
    if (comboIndex < 0 || comboIndex >= PlayerDraftManager.maxDrafts) {
      throw RangeError.range(
        comboIndex,
        0,
        PlayerDraftManager.maxDrafts - 1,
        'comboIndex',
      );
    }

    if (playerIndex == 0) {
      if (_pendingP1ComboIndex != null) {
        throw StateError('Player 1 already committed this round.');
      }
      if (_usedComboIndicesP1.contains(comboIndex)) {
        throw StateError('Player 1 combo #$comboIndex was already used.');
      }
      _pendingP1ComboIndex = comboIndex;
    } else {
      if (_pendingP2ComboIndex != null) {
        throw StateError('Player 2 already committed this round.');
      }
      if (_usedComboIndicesP2.contains(comboIndex)) {
        throw StateError('Player 2 combo #$comboIndex was already used.');
      }
      _pendingP2ComboIndex = comboIndex;
    }

    if (_pendingP1ComboIndex != null && _pendingP2ComboIndex != null) {
      return resolveRound();
    }
    return null;
  }

  /// Reveals both pending combos, updates scores/history, consumes indices, advances round.
  ///
  /// Normally invoked automatically by [commitCombo] once **both** players lock in.
  /// Calling this manually without two pending commits throws [StateError].
  RoundResolution resolveRound() {
    if (_pendingP1ComboIndex == null || _pendingP2ComboIndex == null) {
      throw StateError(
        'resolveRound requires both players to commit first.',
      );
    }
    final roundNumber = _activeRound;
    final i1 = _pendingP1ComboIndex!;
    final i2 = _pendingP2ComboIndex!;

    final c1 = _p1Drafts.combos[i1];
    final c2 = _p2Drafts.combos[i2];

    _usedComboIndicesP1.add(i1);
    _usedComboIndicesP2.add(i2);

    revealedHistoryPlayer1.add(c1);
    revealedHistoryPlayer2.add(c2);

    final winner = compareCombos(c1, c2);
    switch (winner) {
      case RoundWinner.player1:
        _scoreP1++;
      case RoundWinner.player2:
        _scoreP2++;
      case RoundWinner.tie:
        break;
    }

    _pendingP1ComboIndex = null;
    _pendingP2ComboIndex = null;

    if (_activeRound == 12) {
      _gameComplete = true;
    } else {
      _activeRound++;
    }

    return RoundResolution(
      roundNumber: roundNumber,
      player1Combo: c1,
      player2Combo: c2,
      winner: winner,
      scorePlayer1After: _scoreP1,
      scorePlayer2After: _scoreP2,
    );
  }

  /// Compares two combos using Matrix Poker rules (rank order, then primary key).
  ///
  /// Returns [RoundWinner.player1] if [player1Combo] beats [player2Combo].
  static RoundWinner compareCombos(Combo player1Combo, Combo player2Combo) {
    final r1 = player1Combo.rank;
    final r2 = player2Combo.rank;
    if (r1.index != r2.index) {
      return r1.index < r2.index
          ? RoundWinner.player1
          : RoundWinner.player2;
    }
    final k1 = player1Combo.primaryKeyValue;
    final k2 = player2Combo.primaryKeyValue;
    if (k1 != k2) {
      return k1 > k2 ? RoundWinner.player1 : RoundWinner.player2;
    }
    return RoundWinner.tie;
  }
}
