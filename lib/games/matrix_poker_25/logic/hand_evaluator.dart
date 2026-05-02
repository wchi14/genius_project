import 'hand_rank.dart';

/// Result of classifying four integers into a [HandRank] plus tie-break data.
class HandEvaluation {
  const HandEvaluation({
    required this.rank,
    required this.primaryKeyValue,
  });

  final HandRank rank;

  /// Highest relevant value **for ties on [rank] only** (kickers ignored where
  /// the rules say so).
  final int primaryKeyValue;
}

/// Stateless classifier for Matrix Poker 25 four-cell hands.
///
/// [evaluate] inspects frequency patterns first, then straight shape on the
/// four distinct-value consecutive case, following the enum ordering in
/// [HandRank].
class HandEvaluator {
  HandEvaluator._();

  /// Classifies exactly four integers from one drafted line.
  ///
  /// Throws [ArgumentError] if [numbers.length] ≠ 4.
  static HandEvaluation evaluate(List<int> numbers) {
    if (numbers.length != 4) {
      throw ArgumentError.value(
        numbers.length,
        'numbers.length',
        'HandEvaluator.evaluate expects exactly 4 numbers',
      );
    }

    // Frequency map: value → count (used for kind / pair detection).
    final counts = <int, int>{};
    var maxSingle = numbers[0];
    for (final n in numbers) {
      counts[n] = (counts[n] ?? 0) + 1;
      if (n > maxSingle) maxSingle = n;
    }

    final freqDesc = counts.values.toList()..sort((a, b) => b.compareTo(a));

    // Four of a Kind — primary key is the quadruple value.
    if (freqDesc.length == 1) {
      final v = numbers[0];
      return HandEvaluation(rank: HandRank.fourOfAKind, primaryKeyValue: v);
    }

    // Straight detection needs four distinct values forming n..n+3.
    final sortedDistinct = counts.keys.toList()..sort();
    final isConsecutiveRun =
        sortedDistinct.length == 4 &&
            sortedDistinct[3] - sortedDistinct[0] == 3 &&
            sortedDistinct[1] == sortedDistinct[0] + 1 &&
            sortedDistinct[2] == sortedDistinct[0] + 2;

    if (isConsecutiveRun) {
      // Highest card in the straight resolves straight ties.
      final straightHigh = sortedDistinct[3];

      final inOrder =
          _isStrictAscendingByOne(numbers) ||
          _isStrictDescendingByOne(numbers);

      if (inOrder) {
        return HandEvaluation(
          rank: HandRank.straightInOrder,
          primaryKeyValue: straightHigh,
        );
      }
      return HandEvaluation(
        rank: HandRank.straightNotInOrder,
        primaryKeyValue: straightHigh,
      );
    }

    // Two Pair — compare **only** the higher pair value.
    if (freqDesc.length == 2 && freqDesc[0] == 2 && freqDesc[1] == 2) {
      final pairValues =
          counts.entries.where((e) => e.value == 2).map((e) => e.key).toList()
            ..sort();
      final higherPair = pairValues[1];
      return HandEvaluation(rank: HandRank.twoPair, primaryKeyValue: higherPair);
    }

    // Three of a Kind — key is the triple’s rank.
    if (freqDesc.length == 2 && freqDesc[0] == 3) {
      final triple =
          counts.entries.firstWhere((e) => e.value == 3).key;
      return HandEvaluation(
        rank: HandRank.threeOfAKind,
        primaryKeyValue: triple,
      );
    }

    // One Pair — key is the duplicated value only.
    if (freqDesc.length == 3 && freqDesc[0] == 2) {
      final pairVal =
          counts.entries.firstWhere((e) => e.value == 2).key;
      return HandEvaluation(rank: HandRank.onePair, primaryKeyValue: pairVal);
    }

    // High Card — single highest cell among the four (no pair / no straight).
    return HandEvaluation(rank: HandRank.highCard, primaryKeyValue: maxSingle);
  }

  /// `a, a+1, a+2, a+3` when read left-to-right in [values].
  static bool _isStrictAscendingByOne(List<int> values) {
    for (var i = 0; i < 3; i++) {
      if (values[i + 1] != values[i] + 1) return false;
    }
    return true;
  }

  /// `a, a-1, a-2, a-3` when read left-to-right in [values].
  static bool _isStrictDescendingByOne(List<int> values) {
    for (var i = 0; i < 3; i++) {
      if (values[i + 1] != values[i] - 1) return false;
    }
    return true;
  }
}
