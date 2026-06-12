import 'dart:math';

import '../models/blind_card.dart';

/// Builds and owns the 32-card Fatal Fold shoe (discard + draw piles).
class BlindBluffDeck {
  BlindBluffDeck({Random? random}) : _rng = random ?? Random() {
    _seedDrawPile();
  }

  final Random _rng;

  final List<BlindCard> _draw = [];
  final List<BlindCard> _discard = [];

  /// Cards remaining before the next draw (does not include discards).
  int get drawPileLength => _draw.length;

  /// Exposed for diagnostics / AI — do not mutate.
  List<BlindCard> get discardPileView => List.unmodifiable(_discard);

  void _seedDrawPile() {
    _draw
      ..clear()
      ..addAll(buildStandardDeck());
    _shuffle(_draw);
    _discard.clear();
  }

  /// Standard composition: ranks **1–10** × **3** + **2** jokers.
  static List<BlindCard> buildStandardDeck() {
    final cards = <BlindCard>[];
    for (var r = 1; r <= 10; r++) {
      for (var i = 0; i < 3; i++) {
        cards.add(BlindCard.number(r));
      }
    }
    cards.add(const BlindCard.joker());
    cards.add(const BlindCard.joker());
    return cards;
  }

  void _shuffle(List<BlindCard> pile) {
    for (var i = pile.length - 1; i > 0; i--) {
      final j = _rng.nextInt(i + 1);
      final tmp = pile[i];
      pile[i] = pile[j];
      pile[j] = tmp;
    }
  }

  /// Removes two cards from the draw pile and returns `(playerOne, playerTwo)`.
  BlindCardPair drawTwo() {
    if (_draw.length < 2) {
      throw StateError(
        'drawTwo called with fewer than two cards — reshuffle via '
        '[reshuffleDiscardIfNeeded] first.',
      );
    }
    final a = _draw.removeLast();
    final b = _draw.removeLast();
    return BlindCardPair(first: a, second: b);
  }

  /// Sends resolved round cards to the discard pile.
  void discardPlayedCards(BlindCard p1, BlindCard p2) {
    _discard.addAll([p1, p2]);
  }

  /// Empty deck rule: recycle discards into a fresh draw pile.
  ///
  /// Call when fewer than two cards remain **before** dealing.
  void reshuffleDiscardIntoDraw() {
    if (_draw.isNotEmpty) {
      throw StateError('reshuffle called while draw pile still has cards.');
    }
    if (_discard.isEmpty) {
      throw StateError('Cannot reshuffle — discard is also empty.');
    }
    _draw.addAll(_discard);
    _discard.clear();
    _shuffle(_draw);
  }

  /// Whether the engine must reshuffle before the next deal.
  bool get needsReshuffleBeforeDeal => _draw.length < 2;
}

/// Convenience holder for a fresh deal.
class BlindCardPair {
  const BlindCardPair({required this.first, required this.second});

  final BlindCard first;
  final BlindCard second;
}
