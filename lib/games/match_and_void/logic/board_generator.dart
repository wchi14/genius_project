import 'dart:math';

import 'package:genius_project/games/match_and_void/models/match_card.dart';

/// Builds the 27-card deck and random 9-card boards for Match & Void.
class BoardGenerator {
  BoardGenerator._();

  /// All 27 unique cards (`id` 0 through 26).
  static List<MatchCard> generateFullDeck() {
    return List<MatchCard>.generate(27, MatchCard.fromId);
  }

  /// Shuffles the full deck and deals 9 cards for the play grid.
  ///
  /// Boards may contain zero valid triplets (Void-eligible); that is expected
  /// for MVP random deals.
  static List<MatchCard> generateBoard({Random? random}) {
    final deck = List<MatchCard>.from(generateFullDeck());
    final rng = random ?? Random();
    deck.shuffle(rng);
    return deck.sublist(0, 9);
  }
}
