import 'package:genius_project/core/models/coordinate.dart';

import '../models/matrix_grid_model.dart';
import 'combo.dart';
import 'hand_evaluator.dart';

/// Tracks up to **12** legally drafted line combos for one player (Phase 2).
///
/// Geometry rules mirror the game spec: four **distinct** cells in one straight
/// axis-aligned or diagonal line with king-neighbour steps (length-3 segment on
/// the 5×5 grid).
///
/// Valid combos are stored in **reading order**: sort by row increasing [Coordinate.y],
/// then column increasing [Coordinate.x] (top → bottom, left → right). Hand
/// evaluation therefore does not depend on the order the player tapped cells.
class PlayerDraftManager {
  PlayerDraftManager();

  static const int maxDrafts = 12;

  final List<Combo> _combos = [];

  /// Immutable view of accepted drafts (FIFO order).
  List<Combo> get combos => List.unmodifiable(_combos);

  /// Current draft count (`0..12`).
  int get draftCount => _combos.length;

  /// Attempts to commit a new combo from [grid] using [coords].
  ///
  /// Returns `true` if stored; `false` if any validation fails or capacity is full.
  ///
  /// Validations:
  /// 1. Exactly four coordinates.
  /// 2. On-board, distinct cells forming one adjacent straight line (H/V/diag).
  /// 3. Coordinate **set** must not duplicate a prior draft (order ignored).
  /// 4. All four cells must contain non-zero values (filled board expected).
  bool tryDraftCombo(MatrixGridModel grid, List<Coordinate> coords) {
    if (_combos.length >= maxDrafts) return false;
    if (coords.length != 4) return false;

    if (!_fourDistinctInBounds(coords)) return false;
    if (!_isStraightAdjacentLine(coords)) return false;
    if (_duplicatesExistingCoordinateSet(coords)) return false;

    final orderedCoords = readingOrder(coords);

    final numbers = <int>[];
    for (final c in orderedCoords) {
      final v = grid.getNumberAt(c);
      if (v == 0) return false;
      numbers.add(v);
    }

    final evaluation = HandEvaluator.evaluate(numbers);
    _combos.add(
      Combo(
        coordinates: orderedCoords,
        numbers: numbers,
        rank: evaluation.rank,
        primaryKeyValue: evaluation.primaryKeyValue,
      ),
    );
    return true;
  }

  /// Clears all drafts (e.g. when resetting a training session).
  void clear() => _combos.clear();

  /// Removes the draft at [index] (`0..draftCount-1`) for UI undo.
  void removeDraftAt(int index) {
    if (index < 0 || index >= _combos.length) {
      throw RangeError.index(index, _combos, 'removeDraftAt', null, _combos.length);
    }
    _combos.removeAt(index);
  }

  /// Replaces the current draft list with exactly [maxDrafts] combos (e.g. UI submit).
  ///
  /// Used when drafts were assembled elsewhere but must match [GameLoopManager]’s
  /// expectation of twelve entries.
  void installDrafts(List<Combo> combos) {
    if (combos.length != maxDrafts) {
      throw ArgumentError.value(
        combos.length,
        'combos.length',
        'installDrafts requires exactly $maxDrafts combos',
      );
    }
    _combos
      ..clear()
      ..addAll(combos);
  }

  static const int _gridMin = 0;
  static const int _gridMax = 4;

  static bool _inBounds(Coordinate c) =>
      c.x >= _gridMin && c.x <= _gridMax && c.y >= _gridMin && c.y <= _gridMax;

  /// Distinct coordinates and each inside Matrix Poker 25 bounds.
  static bool _fourDistinctInBounds(List<Coordinate> coords) {
    if (coords.toSet().length != 4) return false;
    return coords.every(_inBounds);
  }

  /// Whether [coords] is exactly four cells on one **adjacent straight segment**.
  ///
  /// **Click order does not matter.** Callers already enforce four distinct
  /// in-bounds cells. We sort with [readingOrder] so points are walked in a fixed
  /// direction along the candidate line; then we require three identical step
  /// vectors between neighbours. Same `(dx,dy)` ⇒ collinear and evenly spaced;
  /// `_isKingStep` forces each hop to length one (horizontal, vertical, or 45°),
  /// which matches “strictly adjacent” on this grid.
  ///
  /// Performance: only four points — sorting + three comparisons is trivial (same
  /// Big-O class as the earlier ray brute-force, both effectively constant time).
  ///
  /// Slopes outside {-1, 0, 1, ∞} never appear on king-adjacent runs; those sets
  /// fail this check after sorting.
  static bool _isStraightAdjacentLine(List<Coordinate> coords) {
    final sorted = readingOrder(coords);

    final dx0 = sorted[1].x - sorted[0].x;
    final dy0 = sorted[1].y - sorted[0].y;
    if (!_isKingStep(dx0, dy0)) return false;

    for (var i = 1; i < 3; i++) {
      final dx = sorted[i + 1].x - sorted[i].x;
      final dy = sorted[i + 1].y - sorted[i].y;
      if (dx != dx0 || dy != dy0) return false;
    }
    return true;
  }

  /// True for the eight neighbour directions (each axis in {-1,0,1}, not both 0).
  static bool _isKingStep(int dx, int dy) {
    if (dx == 0 && dy == 0) return false;
    return dx.abs() <= 1 && dy.abs() <= 1;
  }

  bool _duplicatesExistingCoordinateSet(List<Coordinate> coords) {
    final candidate = _canonicalCoordSet(coords);
    for (final existing in _combos) {
      if (_coordsListsEqual(candidate, _canonicalCoordSet(existing.coordinates))) {
        return true;
      }
    }
    return false;
  }

  /// Same ordering as [readingOrder]: row (y) then column (x), for stable dedupe keys.
  static List<Coordinate> _canonicalCoordSet(List<Coordinate> coords) =>
      readingOrder(coords);

  /// Top-left → bottom-right reading: smaller [Coordinate.y] first (top row),
  /// then smaller [Coordinate.x] (left column).
  static List<Coordinate> readingOrder(List<Coordinate> coords) {
    final copy = [...coords]..sort((a, b) {
      final byY = a.y.compareTo(b.y);
      if (byY != 0) return byY;
      return a.x.compareTo(b.x);
    });
    return copy;
  }

  static bool _coordsListsEqual(List<Coordinate> a, List<Coordinate> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
