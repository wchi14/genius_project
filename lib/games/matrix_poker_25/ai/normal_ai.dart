import 'dart:math';

import 'package:genius_project/core/models/coordinate.dart';

import '../logic/combo.dart';
import '../logic/four_cell_line_catalog.dart';
import '../models/matrix_grid_model.dart';
import 'matrix_poker_ai_agent.dart';

/// **Greedy** AI: heatmap placement for high draws, best 12 lines for drafts,
/// round-based duel curve on strength-sorted remaining combos.
///
/// **Duel curve** (indices refer to strength order, strongest first):
/// rounds 1–4 → medium band; 5–8 → strongest quarter; 9–12 → random pick from
/// the weakest third (dump “what’s left”).
class NormalAiAgent extends MatrixPokerAiAgent {
  NormalAiAgent({Random? random}) : _rng = random ?? Random();

  final Random _rng;

  static final List<List<Coordinate>> _allLines = allValidFourCellLines();
  static final Map<Coordinate, List<List<Coordinate>>> _linesByCell =
      _buildLinesByCell(_allLines);

  @override
  Future<Coordinate> placeNumber(MatrixGridModel myGrid, int drawnNumber) async {
    final empty = _listEmptyCells(myGrid);
    if (empty.isEmpty) {
      throw StateError('NormalAiAgent.placeNumber: no empty cells.');
    }

    var bestScore = double.negativeInfinity;
    final best = <Coordinate>[];

    for (final c in empty) {
      final score = _scorePlacement(myGrid, c, drawnNumber);
      if (score > bestScore + 1e-9) {
        bestScore = score;
        best
          ..clear()
          ..add(c);
      } else if ((score - bestScore).abs() <= 1e-9) {
        best.add(c);
      }
    }

    return best[_rng.nextInt(best.length)];
  }

  @override
  Future<int> playCombo(
    int round,
    List<Combo> myRemainingCombos,
    List<Combo> opponentHistory,
    MatrixGridModel opponentGrid,
  ) async {
    final n = myRemainingCombos.length;
    if (n == 0) {
      throw StateError('NormalAiAgent.playCombo: no remaining combos.');
    }
    if (n == 1) {
      return 0;
    }

    // Weakest → strongest so "strong" is at the end.
    final weakestToStrongest = List<int>.generate(n, (i) => i)
      ..sort((i, j) => _compareWeakestFirst(
            myRemainingCombos[i],
            myRemainingCombos[j],
          ));

    if (round >= 1 && round <= 4) {
      // Early: spend a medium/weak hand (near the middle of the curve).
      final mid = (n / 2).floor().clamp(0, n - 1);
      final lo = max(0, mid - 1);
      final hi = min(n - 1, mid + 1);
      final slot = lo + _rng.nextInt(hi - lo + 1);
      return weakestToStrongest[slot];
    }

    if (round >= 5 && round <= 8) {
      // Midgame: play strongest available.
      return weakestToStrongest.last;
    }

    // Late: play whatever is left (random).
    return _rng.nextInt(n);
  }
}

/// Weaker combo sorts **before** stronger (higher [HandRank.index], then lower primary).
int _compareWeakestFirst(Combo a, Combo b) {
  final byRank = b.rank.index.compareTo(a.rank.index);
  if (byRank != 0) return byRank;
  return a.primaryKeyValue.compareTo(b.primaryKeyValue);
}

double _scorePlacement(MatrixGridModel grid, Coordinate target, int drawn) {
  final lines = NormalAiAgent._linesByCell[target] ?? const [];

  final isCenter = target.x == 2 && target.y == 2;
  final isEdge = target.x == 0 || target.x == 4 || target.y == 0 || target.y == 4;
  final isCorner =
      (target.x == 0 || target.x == 4) && (target.y == 0 || target.y == 4);
  final isInnerRing = !isCenter && !isEdge;

  // Base heatmap: keep extremes away from core; mid numbers are more flexible.
  var score = 0.0;
  // Center should be reserved for "connectors" (4-8), not extremes.
  final isExtreme = drawn == 1 || drawn == 10;
  if (isExtreme) {
    score += (isCorner || isEdge) ? 10 : ((isCenter || isInnerRing) ? -40 : 0);
  } else if (drawn <= 3) {
    score += (isCorner || isEdge) ? 8 : ((isCenter || isInnerRing) ? -25 : 0);
  } else if (drawn >= 8) {
    score += isCenter ? 2 : (isInnerRing ? 1 : 0);
  } else {
    score += isCenter ? 8 : (isInnerRing ? 4 : 0);
  }

  // Local magnetic field (same/±1 clustering).
  var sameAdj = 0;
  var nearAdj = 0;
  var near2Adj = 0;
  for (var dy = -1; dy <= 1; dy++) {
    for (var dx = -1; dx <= 1; dx++) {
      if (dx == 0 && dy == 0) continue;
      final x = target.x + dx;
      final y = target.y + dy;
      if (x < 0 || x > 4 || y < 0 || y > 4) continue;
      final v = grid.getNumberAt(Coordinate(x, y));
      if (v == 0) continue;
      final diff = (v - drawn).abs();
      if (diff == 0) sameAdj++;
      if (diff == 1) nearAdj++;
      if (diff == 2) near2Adj++;
    }
  }
  score += 90.0 * sameAdj;
  score += 35.0 * nearAdj;
  score += 10.0 * near2Adj;

  // Duplicate-engine line bonus (simple): strongly prefer placing onto lines that
  // already contain `drawn` (so drafts skew to onePair/twoPair/trips instead of highCard).
  var linesWithSame = 0;
  var linesWithTwoPairSetup = 0;
  var linesWithBridge = 0;
  for (final line in lines) {
    var sameInLine = 0;
    var hasMinus = false;
    var hasPlus = false;
    final counts = <int, int>{};
    for (final c in line) {
      if (c == target) continue;
      final v = grid.getNumberAt(c);
      if (v == 0) continue;
      counts[v] = (counts[v] ?? 0) + 1;
      if (v == drawn) sameInLine++;
      if (v == drawn - 1) hasMinus = true;
      if (v == drawn + 1) hasPlus = true;
    }
    if (sameInLine > 0) linesWithSame++;
    if (hasMinus && hasPlus) linesWithBridge++;

    // if line already has some other pair and also has drawn, this placement can
    // later form two pair with one more drawn.
    if (sameInLine > 0 &&
        counts.entries.any((e) => e.key != drawn && e.value >= 2)) {
      linesWithTwoPairSetup++;
    }
  }
  score += 140.0 * linesWithSame;
  score += 220.0 * linesWithTwoPairSetup;
  score += 65.0 * linesWithBridge;

  // Penalize mixing far-apart values locally (reduces "ruined" distinct lines).
  if (sameAdj == 0 && nearAdj == 0) {
    var farAdj = 0;
    for (var dy = -1; dy <= 1; dy++) {
      for (var dx = -1; dx <= 1; dx++) {
        if (dx == 0 && dy == 0) continue;
        final x = target.x + dx;
        final y = target.y + dy;
        if (x < 0 || x > 4 || y < 0 || y > 4) continue;
        final v = grid.getNumberAt(Coordinate(x, y));
        if (v == 0) continue;
        if ((v - drawn).abs() >= 5) farAdj++;
      }
    }
    score -= 22.0 * farAdj;
  }

  // Line potential scoring (lightweight).
  for (final line in lines) {
    score += _scoreLinePotential(grid, line, target, drawn);
  }

  return score;
}

double _scoreLinePotential(
  MatrixGridModel grid,
  List<Coordinate> line,
  Coordinate target,
  int drawn,
) {
  final after = <int>[drawn];
  final counts = <int, int>{drawn: 1};

  for (final c in line) {
    if (c == target) continue;
    final v = grid.getNumberAt(c);
    if (v == 0) continue;
    after.add(v);
    counts[v] = (counts[v] ?? 0) + 1;
  }

  final distinct = after.toSet().toList()..sort();
  final span = distinct.last - distinct.first;
  var score = 0.0;

  // Straight window encouragement.
  if (span <= 3) score += 90;
  if (span == 4) score += 20;
  if (span >= 5) score -= 90;

  // Avoid isolated one-pair creation.
  final drawnCount = counts[drawn] ?? 0;
  final hasOtherPair = counts.entries.any((e) => e.key != drawn && e.value >= 2);
  if (drawnCount == 2 && !hasOtherPair && after.length >= 3) {
    score -= 140;
  }

  // Reward two-pair setup.
  if (drawnCount >= 2 && hasOtherPair) score += 180;

  // Reward building trips.
  if (drawnCount >= 3) score += 220;

  return score;
}

Map<Coordinate, List<List<Coordinate>>> _buildLinesByCell(
  List<List<Coordinate>> lines,
) {
  final out = <Coordinate, List<List<Coordinate>>>{};
  for (final line in lines) {
    for (final c in line) {
      (out[c] ??= <List<Coordinate>>[]).add(line);
    }
  }
  return out;
}

List<Coordinate> _listEmptyCells(MatrixGridModel grid) {
  final out = <Coordinate>[];
  for (var y = 0; y < 5; y++) {
    for (var x = 0; x < 5; x++) {
      final c = Coordinate(x, y);
      if (grid.getNumberAt(c) == 0) {
        out.add(c);
      }
    }
  }
  return out;
}
