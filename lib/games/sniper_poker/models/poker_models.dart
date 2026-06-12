/// Playing-card suit for Sniper Poker (values 1–10 per suit).
enum PokerSuit {
  hearts,
  diamonds,
  clubs,
  spades,
}

/// Four-card hand strength tiers (no full house in this game).
///
/// Weakest → strongest: [highCard] … [straightFlush].
enum HandRank {
  highCard,
  pair,
  twoPair,
  threeOfAKind,
  straight,
  flush,
  fourOfAKind,
  straightFlush,
}

/// Player's second betting-round weapon choice.
enum SniperModeSelection {
  none,
  sniper,
  shotgun,
}

/// Turn order within one hand.
enum SniperHandPhase {
  betweenHands,
  skills,
  betting1,
  betting2,
  sniper,
}

/// One card in the Sniper Poker deck (value 1–10 plus suit).
class SniperCard {
  const SniperCard({
    required this.suit,
    required this.value,
  }) : assert(value >= 1 && value <= 10, 'value must be between 1 and 10');

  final PokerSuit suit;
  final int value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SniperCard && suit == other.suit && value == other.value;

  @override
  int get hashCode => Object.hash(suit, value);

  @override
  String toString() => '$value of ${suit.name}';
}
