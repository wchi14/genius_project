/// Arithmetic operator on an [EquationTile] (tiles 2 and 3 in a triplet).
enum OperatorType {
  add,
  subtract,
  multiply,
  divide,
}

/// One tile in an Apex Equation triplet: operator label + integer value.
///
/// In [MathEvaluator.evaluate], the **first** tile's [operator] is ignored;
/// only [value] participates in the expression.
class EquationTile {
  const EquationTile({
    required this.id,
    required this.operator,
    required this.value,
  });

  final String id;
  final OperatorType operator;
  final int value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquationTile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          operator == other.operator &&
          value == other.value;

  @override
  int get hashCode => Object.hash(id, operator, value);

  @override
  String toString() => 'EquationTile($id: $operator $value)';
}
