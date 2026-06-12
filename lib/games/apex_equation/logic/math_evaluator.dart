import 'package:genius_project/games/apex_equation/models/equation_tile.dart';

/// Evaluates Apex Equation triplets with BODMAS and strict integer results.
class MathEvaluator {
  MathEvaluator._();

  /// Evaluates `t1.value [t2.operator] t2.value [t3.operator] t3.value`.
  ///
  /// [t1.operator] is ignored. Multiply/divide bind tighter than add/subtract;
  /// same-precedence operators group left-to-right. Intermediate steps use
  /// [double]. Returns a whole [int] only when the final value is finite and
  /// has no fractional part; otherwise `null` (e.g. divide by zero, 5 / 2).
  static int? evaluate(EquationTile t1, EquationTile t2, EquationTile t3) {
    final v0 = t1.value.toDouble();
    final v1 = t2.value.toDouble();
    final v2 = t3.value.toDouble();
    final op0 = t2.operator;
    final op1 = t3.operator;

    final double result;
    if (_precedence(op1) > _precedence(op0)) {
      final mid = _apply(op1, v1, v2);
      if (!_isFinite(mid)) {
        return null;
      }
      result = _apply(op0, v0, mid);
    } else {
      final mid = _apply(op0, v0, v1);
      if (!_isFinite(mid)) {
        return null;
      }
      result = _apply(op1, mid, v2);
    }

    if (!_isFinite(result) || !_isPerfectInteger(result)) {
      return null;
    }
    return result.round();
  }

  static int _precedence(OperatorType op) {
    switch (op) {
      case OperatorType.multiply:
      case OperatorType.divide:
        return 2;
      case OperatorType.add:
      case OperatorType.subtract:
        return 1;
    }
  }

  static double _apply(OperatorType op, double left, double right) {
    switch (op) {
      case OperatorType.add:
        return left + right;
      case OperatorType.subtract:
        return left - right;
      case OperatorType.multiply:
        return left * right;
      case OperatorType.divide:
        if (right == 0) {
          return double.nan;
        }
        return left / right;
    }
  }

  static bool _isFinite(double x) => !x.isNaN && !x.isInfinite;

  static bool _isPerfectInteger(double x) {
    if (!_isFinite(x)) {
      return false;
    }
    final rounded = x.roundToDouble();
    return (x - rounded).abs() < 1e-9;
  }
}
