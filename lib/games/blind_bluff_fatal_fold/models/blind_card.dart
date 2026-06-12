/// Playing piece for the 32-card Fatal Fold deck.
///
/// Three copies of ranks **1–10** plus **two** jokers. Jokers outrank every
/// numbered card at showdown.
class BlindCard {
  /// Numbered card (1–10).
  const BlindCard.number(this.rank)
      : isJoker = false,
        assert(rank >= 1 && rank <= 10, 'rank must be between 1 and 10');

  /// Highest-ranked card in the shoe (two copies exist).
  const BlindCard.joker()
      : isJoker = true,
        rank = 0;

  final bool isJoker;

  /// Meaningful only when [isJoker] is `false`.
  final int rank;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlindCard &&
          runtimeType == other.runtimeType &&
          isJoker == other.isJoker &&
          rank == other.rank;

  @override
  int get hashCode => Object.hash(isJoker, rank);

  @override
  String toString() => isJoker ? 'Joker' : '$rank';
}
