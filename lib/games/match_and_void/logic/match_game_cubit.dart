import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genius_project/games/match_and_void/logic/board_generator.dart';
import 'package:genius_project/games/match_and_void/logic/match_game_state.dart';
import 'package:genius_project/games/match_and_void/logic/match_validator.dart';
import 'package:genius_project/games/match_and_void/models/match_card.dart';
import 'package:genius_project/games/match_and_void/models/match_game_feedback.dart';
import 'package:genius_project/games/match_and_void/models/match_game_mode.dart';

/// Arena (10 boards) and Countdown (90s) presenter for Match & Void.
class MatchGameCubit extends Cubit<MatchGameState> {
  MatchGameCubit({
    required MatchGameMode mode,
    Random? random,
    List<MatchCard>? initialBoard,
  })  : _random = random ?? Random(),
        super(
          MatchGameState(
            mode: mode,
            currentBoardIndex: 1,
            currentBoard:
                initialBoard ?? BoardGenerator.generateBoard(random: random),
            selectedIndices: const [],
            historyLog: const [],
            currentScore: 0,
            voidPenaltyLevel: 0,
            remainingSeconds: mode == MatchGameMode.countdown
                ? countdownStartSeconds
                : 0,
            isGameOver: false,
          ),
        ) {
    if (mode == MatchGameMode.countdown) {
      _startCountdownTimer();
    }
  }

  static const int countdownStartSeconds = 90;
  static const int countdownMatchPenaltySeconds = 3;
  static const int countdownVoidPenaltySeconds = 5;
  static const int maxConsecutiveWrongVoids = 5;
  static const int arenaVoidStreakBoardPenalty = 3;

  static const int arenaBoardCount = 10;
  static const int _arenaBoardLimit = arenaBoardCount;

  final Random _random;
  Timer? _countdownTimer;
  int _consecutiveWrongVoids = 0;

  /// Points lost on the next wrong void in Arena at [voidPenaltyLevel].
  static int arenaVoidFailurePenalty(int voidPenaltyLevel) {
    return _arenaVoidFailurePenalty(voidPenaltyLevel);
  }

  /// Countdown time bonus for a correct match on [boardIndex] (1-based).
  static int countdownMatchBonusForBoard(int boardIndex) {
    if (boardIndex <= 5) {
      return 15;
    }
    return 10;
  }

  /// Countdown time bonus for a correct void on [boardIndex] (1-based).
  static int countdownVoidBonusForBoard(int boardIndex) {
    if (boardIndex <= 5) {
      return 30;
    }
    if (boardIndex <= 10) {
      return 25;
    }
    return 20;
  }

  /// Arena VOID button label: includes streak −3 before the 5th wrong void.
  int arenaNextVoidPenaltyIfWrong() {
    if (state.mode != MatchGameMode.arena) {
      return countdownVoidPenaltySeconds;
    }
    if (_consecutiveWrongVoids >= maxConsecutiveWrongVoids - 1) {
      return arenaVoidStreakBoardPenalty;
    }
    return arenaVoidFailurePenalty(state.voidPenaltyLevel);
  }

  void clearPendingFeedback() {
    if (state.pendingFeedback == null) {
      return;
    }
    _emit(state.copyWith(pendingFeedback: null));
  }

  void acknowledgeVoidStreakAdvance() {
    if (!state.voidStreakAdvanceNotice) {
      return;
    }
    _emit(state.copyWith(voidStreakAdvanceNotice: false));
  }

  void toggleCardSelection(int index) {
    if (state.isGameOver) {
      return;
    }
    if (index < 0 || index >= state.currentBoard.length) {
      return;
    }

    final selected = List<int>.from(state.selectedIndices);
    if (selected.contains(index)) {
      selected.remove(index);
    } else {
      if (selected.length >= 3) {
        return;
      }
      selected.add(index);
    }
    _emit(state.copyWith(selectedIndices: selected));
  }

  void submitMatch() {
    if (state.isGameOver || state.selectedIndices.length != 3) {
      return;
    }

    final triplet = _cardsAtIndices(state.selectedIndices);
    final valid = MatchValidator.isValidMatch(
      triplet[0],
      triplet[1],
      triplet[2],
    );
    final alreadyFound = _historyContainsTriplet(triplet);

    if (valid && !alreadyFound) {
      _consecutiveWrongVoids = 0;
      final history = List<List<MatchCard>>.from(state.historyLog)
        ..add(triplet);
      var score = state.currentScore + 1;
      var seconds = state.remainingSeconds;

      if (state.mode == MatchGameMode.countdown) {
        seconds += countdownMatchBonusForBoard(state.currentBoardIndex);
      }

      _emit(
        state.copyWith(
          historyLog: history,
          selectedIndices: const [],
          voidPenaltyLevel: 0,
          currentScore: score,
          remainingSeconds: seconds,
          pendingFeedback: null,
        ),
      );
      return;
    }

    _applyInvalidMatchAttempt();
  }

  void declareVoid() {
    if (state.isGameOver) {
      return;
    }

    if (_isBoardTrulyVoid()) {
      _consecutiveWrongVoids = 0;
      _applyVoidSuccess();
    } else {
      _applyVoidFailure();
    }
  }

  void _applyVoidSuccess() {
    final nextBoardIndex = state.currentBoardIndex + 1;
    var score = state.currentScore;
    var seconds = state.remainingSeconds;
    var gameOver = false;

    if (state.mode == MatchGameMode.arena) {
      score += 3;
      if (nextBoardIndex > _arenaBoardLimit) {
        gameOver = true;
      }
    } else {
      score += 5;
      seconds += countdownVoidBonusForBoard(state.currentBoardIndex);
    }

    _emit(
      state.copyWith(
        voidPenaltyLevel: 0,
        currentBoard: gameOver
            ? state.currentBoard
            : BoardGenerator.generateBoard(random: _random),
        historyLog: const [],
        selectedIndices: const [],
        currentBoardIndex: _boardIndexAfterAdvance(nextBoardIndex, gameOver),
        currentScore: score,
        remainingSeconds: seconds,
        isGameOver: gameOver,
        pendingFeedback: null,
        voidStreakAdvanceNotice: false,
      ),
    );

    if (gameOver) {
      _cancelCountdownTimer();
    }
  }

  void _applyVoidFailure() {
    _consecutiveWrongVoids += 1;

    if (_consecutiveWrongVoids >= maxConsecutiveWrongVoids) {
      _forceAdvanceAfterVoidStreak();
      return;
    }

    if (state.mode == MatchGameMode.arena) {
      final penalty = _arenaVoidFailurePenalty(state.voidPenaltyLevel);
      _emit(
        state.copyWith(
          currentScore: state.currentScore - penalty,
          voidPenaltyLevel: state.voidPenaltyLevel + 1,
          selectedIndices: const [],
          pendingFeedback: _wrongVoidFeedback(penalty),
        ),
      );
      return;
    }

    final seconds =
        state.remainingSeconds - countdownVoidPenaltySeconds;
    final gameOver = seconds <= 0;
    _emit(
      state.copyWith(
        remainingSeconds: gameOver ? 0 : seconds,
        selectedIndices: const [],
        pendingFeedback: _wrongVoidFeedback(countdownVoidPenaltySeconds),
        isGameOver: gameOver,
      ),
    );
    if (gameOver) {
      _cancelCountdownTimer();
    }
  }

  void _forceAdvanceAfterVoidStreak() {
    _consecutiveWrongVoids = 0;
    final nextBoardIndex = state.currentBoardIndex + 1;
    var gameOver = false;
    var score = state.currentScore;

    if (state.mode == MatchGameMode.arena) {
      score -= arenaVoidStreakBoardPenalty;
    }

    if (state.mode == MatchGameMode.arena &&
        nextBoardIndex > _arenaBoardLimit) {
      gameOver = true;
    }

    _emit(
      state.copyWith(
        voidPenaltyLevel: 0,
        currentScore: score,
        currentBoard: gameOver
            ? state.currentBoard
            : BoardGenerator.generateBoard(random: _random),
        historyLog: const [],
        selectedIndices: const [],
        currentBoardIndex: _boardIndexAfterAdvance(nextBoardIndex, gameOver),
        voidStreakAdvanceNotice: true,
        pendingFeedback: null,
        isGameOver: gameOver,
      ),
    );

    if (gameOver) {
      _cancelCountdownTimer();
    }
  }

  /// Arena stays at board [arenaBoardCount] when the run ends (no "11/10" HUD).
  int _boardIndexAfterAdvance(int nextBoardIndex, bool gameOver) {
    if (gameOver && state.mode == MatchGameMode.arena) {
      return _arenaBoardLimit;
    }
    return nextBoardIndex;
  }

  void _applyInvalidMatchAttempt() {
    if (state.mode == MatchGameMode.arena) {
      _emit(
        state.copyWith(
          currentScore: state.currentScore - 1,
          selectedIndices: const [],
          pendingFeedback: _wrongMatchFeedback(1),
        ),
      );
      return;
    }

    final seconds =
        state.remainingSeconds - countdownMatchPenaltySeconds;
    final gameOver = seconds <= 0;
    _emit(
      state.copyWith(
        remainingSeconds: gameOver ? 0 : seconds,
        selectedIndices: const [],
        pendingFeedback: _wrongMatchFeedback(countdownMatchPenaltySeconds),
        isGameOver: gameOver,
      ),
    );
    if (gameOver) {
      _cancelCountdownTimer();
    }
  }

  MatchGameFeedback _wrongMatchFeedback(int amount) {
    if (state.mode == MatchGameMode.arena) {
      return MatchGameFeedback(
        kind: MatchGameFeedbackKind.wrongMatch,
        title: 'Wrong match',
        body:
            'Those three cards are not a valid match, or you already found that triplet.',
        penaltySummary: '−$amount pt',
      );
    }
    return MatchGameFeedback(
      kind: MatchGameFeedbackKind.wrongMatch,
      title: 'Wrong match',
      body:
          'Those three cards are not a valid match, or you already found that triplet.',
      penaltySummary: '−${amount}s',
    );
  }

  MatchGameFeedback _wrongVoidFeedback(int amount) {
    if (state.mode == MatchGameMode.arena) {
      return MatchGameFeedback(
        kind: MatchGameFeedbackKind.wrongVoid,
        title: 'Wrong void',
        body:
            'This board still has a valid triplet you have not found. Void is only allowed when no matches remain.',
        penaltySummary: '−$amount pt',
      );
    }
    return MatchGameFeedback(
      kind: MatchGameFeedbackKind.wrongVoid,
      title: 'Wrong void',
      body:
          'This board still has a valid triplet you have not found. Void is only allowed when no matches remain.',
      penaltySummary: '−${amount}s',
    );
  }

  /// Arena wrong-void cost by [voidPenaltyLevel] before the attempt:
  /// 1st–2nd wrong void → 1, 3rd–4th → 2 (5th triggers streak −3 separately).
  static int _arenaVoidFailurePenalty(int level) {
    if (level <= 1) {
      return 1;
    }
    return 2;
  }

  bool _isBoardTrulyVoid() {
    final outstanding = MatchValidator.findAllValidMatches(state.currentBoard)
        .where((triplet) => !_historyContainsTriplet(triplet));
    return outstanding.isEmpty;
  }

  bool _historyContainsTriplet(List<MatchCard> triplet) {
    final key = _tripletKey(triplet);
    return state.historyLog.any((entry) => _tripletKey(entry) == key);
  }

  static String _tripletKey(List<MatchCard> cards) {
    final ids = cards.map((c) => c.id).toList()..sort();
    return ids.join(',');
  }

  List<MatchCard> _cardsAtIndices(List<int> indices) {
    final sorted = List<int>.from(indices)..sort();
    return sorted.map((i) => state.currentBoard[i]).toList();
  }

  void _startCountdownTimer() {
    _cancelCountdownTimer();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _onCountdownTick();
    });
  }

  void _onCountdownTick() {
    if (state.isGameOver) {
      _cancelCountdownTimer();
      return;
    }
    if (state.mode != MatchGameMode.countdown) {
      return;
    }

    final next = state.remainingSeconds - 1;
    if (next <= 0) {
      _emit(
        state.copyWith(
          remainingSeconds: 0,
          isGameOver: true,
          selectedIndices: const [],
        ),
      );
      _cancelCountdownTimer();
      return;
    }
    _emit(state.copyWith(remainingSeconds: next));
  }

  void _cancelCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  void _emit(MatchGameState next) {
    if (isClosed) {
      return;
    }
    emit(next);
  }

  @override
  Future<void> close() {
    _cancelCountdownTimer();
    return super.close();
  }
}
