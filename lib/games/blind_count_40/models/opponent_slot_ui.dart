import 'package:genius_project/games/blind_count_40/models/game_player.dart';

/// One opponent block slot safe for UI (no hidden values unless [isRevealed]).
class OpponentSlotUi {
  const OpponentSlotUi({
    required this.id,
    required this.isRevealed,
    this.value,
  });

  final String id;
  final bool isRevealed;

  /// Only set when [isRevealed] is true.
  final int? value;
}

/// Banner after a guess resolves (shown to both seats).
class BlindCountGuessFeedback {
  const BlindCountGuessFeedback({
    required this.guesser,
    required this.guessedValue,
    required this.isCorrect,
    this.matchCount = 0,
    this.flippedBlockIds = const [],
    this.awardedAllClearBonus = false,
  });

  final BlindPlayerId guesser;
  final int guessedValue;
  final bool isCorrect;
  final int matchCount;

  /// Block ids involved in a correct guess (for flip / vanish animations).
  final List<String> flippedBlockIds;
  final bool awardedAllClearBonus;

  String get headline {
    final who = guesser == BlindPlayerId.p1 ? 'You' : 'Opponent';
    final result = isCorrect ? 'CORRECT' : 'WRONG';
    if (isCorrect && matchCount > 0) {
      final bonus = awardedAllClearBonus ? ' · ALL CLEAR +3' : '';
      return '$who guessed $guessedValue — $result ($matchCount flipped)$bonus';
    }
    return '$who guessed $guessedValue — $result';
  }
}
