import 'package:genius_project/core/models/coordinate.dart';

/// One player's **5×5** board for Matrix Poker 25 (Phase 1 grid fill).
///
/// - Bounds are **0..4** on both axes; enforcement lives here, not on [Coordinate].
/// - `0` means empty; successful placements store drawn values **1..10**.
class MatrixGridModel {
  static const int _size = 5;
  static const int _empty = 0;

  /// `_cells[row][column]` → `_cells[y][x]`.
  final List<List<int>> _cells;

  MatrixGridModel()
      : _cells = List.generate(
          _size,
          (_) => List<int>.filled(_size, _empty),
        );

  /// Matrix Poker 25 uses a fixed 5×5 grid indexed from zero.
  bool _isInBounds(Coordinate coord) =>
      coord.x >= 0 &&
      coord.x < _size &&
      coord.y >= 0 &&
      coord.y < _size;

  /// Places [number] at [coord] for this game’s rules.
  ///
  /// Returns `true` only when [coord] is in range **0..4**, [number] is **1..10**,
  /// and the cell is currently empty. Otherwise returns `false`.
  bool placeNumber(Coordinate coord, int number) {
    if (!_isInBounds(coord)) return false;
    if (number < 1 || number > 10) return false;

    final row = coord.y;
    final col = coord.x;
    if (_cells[row][col] != _empty) return false;

    _cells[row][col] = number;
    return true;
  }

  /// Cell value at [coord], or `0` if empty.
  ///
  /// Throws [ArgumentError] if [coord] is outside the 5×5 board.
  int getNumberAt(Coordinate coord) {
    if (!_isInBounds(coord)) {
      throw ArgumentError.value(
        coord,
        'coord',
        'must be within 0..${_size - 1} for both x and y',
      );
    }
    return _cells[coord.y][coord.x];
  }

  /// Whether all **25** cells hold a non-zero value.
  bool isFull() {
    for (final row in _cells) {
      for (final value in row) {
        if (value == _empty) return false;
      }
    }
    return true;
  }

  /// Resets every cell to empty (`0`) for a new match.
  void clear() {
    for (final row in _cells) {
      for (var i = 0; i < row.length; i++) {
        row[i] = _empty;
      }
    }
  }
}
