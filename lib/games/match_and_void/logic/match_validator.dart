import 'package:genius_project/games/match_and_void/models/match_card.dart';

/// SET-style triplet rules for Match & Void.
class MatchValidator {
  MatchValidator._();

  /// `true` when [c1], [c2], and [c3] form a valid match on every attribute.
  ///
  /// For shape, color, and fill, the three cards must be either all the same
  /// or all pairwise different (two-of-a-kind plus one odd card is invalid).
  static bool isValidMatch(MatchCard c1, MatchCard c2, MatchCard c3) {
    return _isValidAttributeSet([c1.shape, c2.shape, c3.shape]) &&
        _isValidAttributeSet([c1.color, c2.color, c3.color]) &&
        _isValidAttributeSet([c1.fill, c2.fill, c3.fill]);
  }

  /// All valid triplets on [board] (brute-force `n choose 3`).
  ///
  /// A standard 9-card board yields 84 combinations.
  static List<List<MatchCard>> findAllValidMatches(List<MatchCard> board) {
    if (board.length < 3) {
      return const [];
    }

    final matches = <List<MatchCard>>[];
    final n = board.length;
    for (var i = 0; i < n - 2; i++) {
      for (var j = i + 1; j < n - 1; j++) {
        for (var k = j + 1; k < n; k++) {
          final a = board[i];
          final b = board[j];
          final c = board[k];
          if (isValidMatch(a, b, c)) {
            matches.add([a, b, c]);
          }
        }
      }
    }
    return matches;
  }

  static bool _isValidAttributeSet<T>(List<T> values) {
    final distinct = values.toSet().length;
    return distinct == 1 || distinct == 3;
  }
}
