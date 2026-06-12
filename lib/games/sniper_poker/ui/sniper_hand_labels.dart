import 'package:flutter/material.dart';
import 'package:genius_project/games/sniper_poker/models/poker_models.dart';

/// User-facing labels for [HandRank] pickers and showdown copy.
extension SniperHandRankLabel on HandRank {
  String get label => switch (this) {
        HandRank.highCard => 'High Card',
        HandRank.pair => 'Pair',
        HandRank.twoPair => 'Two Pair',
        HandRank.threeOfAKind => 'Three of a Kind',
        HandRank.straight => 'Straight',
        HandRank.flush => 'Flush',
        HandRank.fourOfAKind => 'Four of a Kind',
        HandRank.straightFlush => 'Straight Flush',
      };

  /// All hand ranks selectable in sniper / shotgun targeting.
  static List<HandRank> get targetingRanks =>
      List<HandRank>.unmodifiable(HandRank.values);
}

/// Suit glyph and ink color for card faces.
abstract final class SniperSuitStyle {
  static String glyph(PokerSuit suit) => switch (suit) {
        PokerSuit.hearts => '♥',
        PokerSuit.diamonds => '♦',
        PokerSuit.clubs => '♣',
        PokerSuit.spades => '♠',
      };

  static Color ink(PokerSuit suit) => switch (suit) {
        PokerSuit.hearts || PokerSuit.diamonds => const Color(0xFFDC2626),
        PokerSuit.clubs || PokerSuit.spades => const Color(0xFF111827),
      };
}
