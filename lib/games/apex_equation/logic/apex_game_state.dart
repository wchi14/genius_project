import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:genius_project/games/apex_equation/models/apex_game_mode.dart';
import 'package:genius_project/games/apex_equation/models/equation_tile.dart';

part 'apex_game_state.freezed.dart';

/// Unified presenter state for Arena and Countdown modes.
@freezed
class ApexGameState with _$ApexGameState {
  const factory ApexGameState({
    required ApexGameMode mode,
    required int currentLevel,
    required List<EquationTile> availableTiles,
    required int targetNumber,
    required List<EquationTile> selectedTiles,
    required int currentScore,
    required int remainingSeconds,
    required int currentWrongTries,
    required bool isGameOver,

    /// One-shot flag for wrong-answer visual feedback (clear via cubit).
    @Default(false) bool wrongAnswerFlash,
  }) = _ApexGameState;
}
