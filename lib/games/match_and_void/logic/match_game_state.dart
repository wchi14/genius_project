import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:genius_project/games/match_and_void/models/match_card.dart';
import 'package:genius_project/games/match_and_void/models/match_game_feedback.dart';
import 'package:genius_project/games/match_and_void/models/match_game_mode.dart';

part 'match_game_state.freezed.dart';

/// Unified presenter state for Arena and Countdown modes.
@freezed
class MatchGameState with _$MatchGameState {
  const factory MatchGameState({
    required MatchGameMode mode,
    required int currentBoardIndex,
    required List<MatchCard> currentBoard,
    required List<int> selectedIndices,
    required List<List<MatchCard>> historyLog,
    required int currentScore,
    required int voidPenaltyLevel,
    required int remainingSeconds,
    required bool isGameOver,

    /// One-shot penalty dialog for wrong match / wrong void.
    MatchGameFeedback? pendingFeedback,

    /// True when five wrong voids in a row force-advance the board (show dialog).
    @Default(false) bool voidStreakAdvanceNotice,
  }) = _MatchGameState;
}
