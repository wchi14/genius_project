import 'package:genius_project/games/sniper_poker/models/poker_models.dart';

/// Result of classifying exactly four [SniperCard]s.
class ParsedHand {
  const ParsedHand({
    required this.rank,
    required this.primaryValue,
  });

  final HandRank rank;

  /// Tie-break scalar for the same [rank] (e.g. higher pair in two pair).
  final int primaryValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParsedHand &&
          rank == other.rank &&
          primaryValue == other.primaryValue;

  @override
  int get hashCode => Object.hash(rank, primaryValue);

  @override
  String toString() => '${rank.name} ($primaryValue)';
}

/// Brute-force best four-card hand from two hole cards and four community cards.
class PokerEvaluator {
  PokerEvaluator._();

  /// Picks the strongest of all 15 four-card subsets from six total cards.
  static ParsedHand evaluateBestFour(
    List<SniperCard> holeCards,
    List<SniperCard> communityCards,
  ) {
    if (holeCards.length != 2) {
      throw ArgumentError.value(
        holeCards.length,
        'holeCards.length',
        'evaluateBestFour expects exactly 2 hole cards',
      );
    }
    if (communityCards.length != 4) {
      throw ArgumentError.value(
        communityCards.length,
        'communityCards.length',
        'evaluateBestFour expects exactly 4 community cards',
      );
    }

    final allCards = [...holeCards, ...communityCards];
    ParsedHand? best;

    for (final combo in _combinationsOf(allCards, 4)) {
      final hand = _evaluateFour(combo);
      if (best == null || _compareHands(hand, best) > 0) {
        best = hand;
      }
    }

    return best!;
  }

  /// Classifies exactly four cards (internal helper, also usable standalone).
  static ParsedHand evaluateFour(List<SniperCard> cards) {
    if (cards.length != 4) {
      throw ArgumentError.value(
        cards.length,
        'cards.length',
        'evaluateFour expects exactly 4 cards',
      );
    }
    return _evaluateFour(cards);
  }

  static ParsedHand _evaluateFour(List<SniperCard> cards) {
    final values = cards.map((c) => c.value).toList();
    final counts = <int, int>{};
    var maxValue = values[0];

    for (final v in values) {
      counts[v] = (counts[v] ?? 0) + 1;
      if (v > maxValue) maxValue = v;
    }

    final freqDesc = counts.values.toList()..sort((a, b) => b.compareTo(a));
    final isFlush = cards.every((c) => c.suit == cards.first.suit);
    final sortedDistinct = counts.keys.toList()..sort();
    final isStraight = _isStraight(sortedDistinct);

    if (freqDesc.length == 1) {
      return ParsedHand(
        rank: HandRank.fourOfAKind,
        primaryValue: values.first,
      );
    }

    if (isStraight && isFlush) {
      return ParsedHand(
        rank: HandRank.straightFlush,
        primaryValue: sortedDistinct.last,
      );
    }

    if (isFlush) {
      return ParsedHand(rank: HandRank.flush, primaryValue: maxValue);
    }

    if (isStraight) {
      return ParsedHand(
        rank: HandRank.straight,
        primaryValue: sortedDistinct.last,
      );
    }

    if (freqDesc.length == 2 && freqDesc[0] == 3) {
      final triple =
          counts.entries.firstWhere((e) => e.value == 3).key;
      return ParsedHand(
        rank: HandRank.threeOfAKind,
        primaryValue: triple,
      );
    }

    if (freqDesc.length == 2 && freqDesc[0] == 2 && freqDesc[1] == 2) {
      final pairValues =
          counts.entries.where((e) => e.value == 2).map((e) => e.key).toList()
            ..sort();
      return ParsedHand(
        rank: HandRank.twoPair,
        primaryValue: pairValues.last,
      );
    }

    if (freqDesc.length == 3 && freqDesc[0] == 2) {
      final pairVal =
          counts.entries.firstWhere((e) => e.value == 2).key;
      return ParsedHand(rank: HandRank.pair, primaryValue: pairVal);
    }

    return ParsedHand(rank: HandRank.highCard, primaryValue: maxValue);
  }

  static bool _isStraight(List<int> sortedDistinct) {
    if (sortedDistinct.length != 4) return false;
    return sortedDistinct[3] - sortedDistinct[0] == 3 &&
        sortedDistinct[1] == sortedDistinct[0] + 1 &&
        sortedDistinct[2] == sortedDistinct[0] + 2;
  }

  /// Positive when [a] beats [b]; zero on tie.
  static int compareParsedHands(ParsedHand a, ParsedHand b) {
    return _compareHands(a, b);
  }

  static int _compareHands(ParsedHand a, ParsedHand b) {
    final rankCmp =
        _rankStrength(a.rank).compareTo(_rankStrength(b.rank));
    if (rankCmp != 0) return rankCmp;
    return a.primaryValue.compareTo(b.primaryValue);
  }

  static int _rankStrength(HandRank rank) => switch (rank) {
        HandRank.highCard => 0,
        HandRank.pair => 1,
        HandRank.twoPair => 2,
        HandRank.threeOfAKind => 3,
        HandRank.straight => 4,
        HandRank.flush => 5,
        HandRank.fourOfAKind => 6,
        HandRank.straightFlush => 7,
      };

  static Iterable<List<SniperCard>> _combinationsOf(
    List<SniperCard> items,
    int choose,
  ) sync* {
    if (choose == 0) {
      yield const [];
      return;
    }
    if (choose > items.length) return;

    for (var i = 0; i <= items.length - choose; i++) {
      for (final tail in _combinationsOf(items.sublist(i + 1), choose - 1)) {
        yield [items[i], ...tail];
      }
    }
  }
}
