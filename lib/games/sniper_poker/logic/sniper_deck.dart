import 'dart:math';

import 'package:genius_project/games/sniper_poker/models/poker_models.dart';

/// Standard 40-card shoe (values 1–10 × four suits).
class SniperDeck {
  SniperDeck({Random? random}) : _random = random ?? Random() {
    _reset();
  }

  final Random _random;
  final List<SniperCard> _cards = [];

  int get remaining => _cards.length;

  void _reset() {
    _cards
      ..clear()
      ..addAll([
        for (final suit in PokerSuit.values)
          for (var value = 1; value <= 10; value++)
            SniperCard(suit: suit, value: value),
      ]);
    _cards.shuffle(_random);
  }

  /// Discards any undealt cards and rebuilds a shuffled shoe.
  void reshuffle() => _reset();

  List<SniperCard> draw(int count) {
    if (count > _cards.length) {
      throw StateError('SniperDeck.draw($count): only ${_cards.length} left');
    }
    final drawn = List<SniperCard>.from(_cards.sublist(0, count));
    _cards.removeRange(0, count);
    return drawn;
  }
}
