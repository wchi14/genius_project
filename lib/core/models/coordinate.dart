/// A generic integer pair for 2D indexing (column [x], row [y]).
///
/// No axis limits are enforced here; games enforce their own board bounds.
class Coordinate {
  const Coordinate(this.x, this.y);

  final int x;
  final int y;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinate && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Coordinate($x, $y)';
}
