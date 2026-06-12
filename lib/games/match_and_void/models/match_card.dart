/// Shape attribute on a Match & Void card.
enum CardShape {
  circle,
  square,
  triangle,
}

/// Color attribute on a Match & Void card.
enum CardColor {
  red,
  blue,
  yellow,
}

/// Fill attribute on a Match & Void card.
enum CardFill {
  solid,
  empty,
  striped,
}

/// One card in the 27-card deck (3 shapes × 3 colors × 3 fills).
///
/// [id] is unique in `0..26` and encodes attributes as
/// `shape.index * 9 + color.index * 3 + fill.index`.
class MatchCard {
  MatchCard({
    required this.id,
    required this.shape,
    required this.color,
    required this.fill,
  })  : assert(id >= 0 && id <= 26, 'id must be between 0 and 26'),
        assert(
          id ==
              shape.index * 9 + color.index * 3 + fill.index,
          'id must match shape, color, and fill',
        );

  /// Builds a card from a deck index `0..26`.
  factory MatchCard.fromId(int id) {
    assert(id >= 0 && id <= 26, 'id must be between 0 and 26');
    final fill = CardFill.values[id % 3];
    final color = CardColor.values[(id ~/ 3) % 3];
    final shape = CardShape.values[id ~/ 9];
    return MatchCard(
      id: id,
      shape: shape,
      color: color,
      fill: fill,
    );
  }

  final int id;
  final CardShape shape;
  final CardColor color;
  final CardFill fill;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchCard &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          shape == other.shape &&
          color == other.color &&
          fill == other.fill;

  @override
  int get hashCode => Object.hash(id, shape, color, fill);

  @override
  String toString() =>
      'MatchCard#$id(${shape.name}, ${color.name}, ${fill.name})';
}
