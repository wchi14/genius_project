import 'package:genius_project/core/models/coordinate.dart';

import 'hand_rank.dart';

/// A drafted **line of four cells** with evaluated strength for duel resolution.
///
/// [coordinates] and [numbers] are parallel: index `i` is the same cell/value.
/// [primaryKeyValue] is **only** for comparing two combos that share the same
/// [rank] (tie-breaker); it must never mix in kickers beyond the rules given
/// for each [HandRank].
class Combo {
  /// Creates a combo after validation upstream (exactly four cells/values).
  Combo({
    required List<Coordinate> coordinates,
    required List<int> numbers,
    required this.rank,
    required this.primaryKeyValue,
  })  : coordinates = List.unmodifiable(coordinates),
        numbers = List.unmodifiable(numbers) {
    if (coordinates.length != 4) {
      throw ArgumentError.value(
        coordinates.length,
        'coordinates.length',
        'must be exactly 4',
      );
    }
    if (numbers.length != 4) {
      throw ArgumentError.value(
        numbers.length,
        'numbers.length',
        'must be exactly 4',
      );
    }
  }

  /// The four board cells in stable player-facing order.
  final List<Coordinate> coordinates;

  /// Face values at those cells (typically `1..10` after Phase 1).
  final List<int> numbers;

  /// Classified strength tier for Matrix Poker 25.
  final HandRank rank;

  /// Tie-breaker scalar when two combos share [rank] (see game spec).
  final int primaryKeyValue;
}
