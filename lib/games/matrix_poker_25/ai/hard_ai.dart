import 'dart:math';

import 'package:genius_project/core/models/coordinate.dart';

import '../logic/combo.dart';
import '../logic/four_cell_line_catalog.dart';
import '../logic/hand_evaluator.dart';
import '../logic/hand_rank.dart';
import '../models/matrix_grid_model.dart';
import 'matrix_poker_ai_agent.dart';

/// **Hard** AI: master board-builder (Phase 1).
///
/// This file currently focuses on **placement only**. Drafting/duel logic will
/// be implemented in later tasks.
class HardAiAgent extends MatrixPokerAiAgent {
  HardAiAgent({Random? random}) : _rng = random ?? Random();

  final Random _rng;

  // Cache the ~28 valid 4-cell straight segments and their cell→lines index.
  static final List<List<Coordinate>> _allLines = allValidFourCellLines();
  static final Map<Coordinate, List<List<Coordinate>>> _linesByCell =
      _buildLinesByCell(_allLines);

  @override
  Future<Coordinate> placeNumber(MatrixGridModel myGrid, int drawnNumber) async {
    final empty = _listEmptyCells(myGrid);
    if (empty.isEmpty) {
      throw StateError('HardAiAgent.placeNumber: no empty cells.');
    }

    var bestScore = double.negativeInfinity;
    final bestCells = <Coordinate>[];

    for (final c in empty) {
      final score = _scorePlacement(myGrid, c, drawnNumber);
      if (score > bestScore + 1e-9) {
        bestScore = score;
        bestCells
          ..clear()
          ..add(c);
      } else if ((score - bestScore).abs() <= 1e-9) {
        bestCells.add(c);
      }
    }

    return bestCells[_rng.nextInt(bestCells.length)];
  }

  double _scorePlacement(MatrixGridModel grid, Coordinate target, int drawn) {
    final lines = _linesIntersecting(target);
    final category = _categoryOf(drawn);

    // Factor 1: heatmap principle (base score).
    var score = _baseHeatScore(target, category, drawn).toDouble();

    // Local magnetic field keeps HighCard low; line-potential avoids pure one-pair spam.
    score += _localMagnetScore(grid, target, drawn, category).toDouble() * 0.35;

    // Planning focus for this version: build **duplicate engines** (two-pair / trips / quads).
    // We rank candidate cells by how much they strengthen the *best few* intersecting lines,
    // heavily prioritizing:
    // - placing onto a line that already contains `drawn` (make pairs/trips),
    // - placing onto a line that already has some other pair AND contains `drawn` (two-pair),
    // - avoiding "isolated pairs" that don't have a straight window or other pair.
    final lineScores = <int>[];
    for (final line in lines) {
      lineScores.add(_scoreLineForPlacement(grid, line, target, drawn, category));
    }
    lineScores.sort((a, b) => b.compareTo(a));
    if (lineScores.isNotEmpty) score += lineScores[0];
    if (lineScores.length >= 2) score += lineScores[1] * 0.55;
    if (lineScores.length >= 3) score += lineScores[2] * 0.25;

    return score;
  }

  int _scoreLineForPlacement(
    MatrixGridModel grid,
    List<Coordinate> line,
    Coordinate target,
    int drawn,
    _NumberCategory category,
  ) {
    // Collect filled values in this line excluding the target cell.
    final values = <int>[];
    var exactMatches = 0;
    var minusCount = 0;
    var plusCount = 0;

    // Track whether the line already contains a non-drawn pair (helps form two-pair).
    final counts = <int, int>{};

    for (final c in line) {
      if (c == target) continue;
      final v = grid.getNumberAt(c);
      if (v == 0) continue;
      values.add(v);
      counts[v] = (counts[v] ?? 0) + 1;
      if (v == drawn) exactMatches++;
      if (v == drawn - 1) minusCount++;
      if (v == drawn + 1) plusCount++;
    }

    // Core: optimize the *future* top-12 drafts by scoring this line's potential
    // after placing `drawn` into `target`, with duplicates > straights.
    var score = _linePotentialScore(values, counts, drawn, category);

    // Extra duplicate-engine bonuses.
    final drawnCount = (counts[drawn] ?? 0) + 1;
    final createsPair = drawnCount == 2;
    final createsTrips = drawnCount == 3;
    final createsQuads = drawnCount >= 4;

    // Identify whether the line already has another pair (two-pair engine).
    var hasOtherPair = false;
    for (final e in counts.entries) {
      if (e.key == drawn) continue;
      if (e.value >= 2) {
        hasOtherPair = true;
        break;
      }
    }

    if (createsQuads) score += 1200;
    if (createsTrips) score += 520;
    if (createsPair && exactMatches >= 1) score += 240;
    if (createsPair && hasOtherPair) score += 600; // two-pair setup
    // If the line already contains `drawn` and also has some other pair,
    // then we're building a strong two-pair line with future drawn copies.
    if (exactMatches >= 1 && hasOtherPair) {
      score += 360;
    }

    // Straight bridging (low priority): if the line already has both neighbours,
    // placing the missing middle helps form a 4-straight later (e.g. 2 _ 4 waiting 3).
    // Keep this smaller than duplicate-engine bonuses.
    if (minusCount > 0 && plusCount > 0) {
      score += 180;
    }

    // Reduce "isolated pair" creation unless it's in a straight window.
    final afterDistinct = <int>{...values, drawn}.toList()..sort();
    final span = afterDistinct.isEmpty ? 0 : afterDistinct.last - afterDistinct.first;
    final inStraightWindow = span <= 3;
    if (createsPair && !hasOtherPair && !inStraightWindow) {
      score -= 420;
    }

    // If this move completes this 4-cell line right now, score the *actual* resulting
    // hand to directly optimize the top-12 draft quality.
    if (values.length == 3) {
      final numbers = <int>[
        for (final c in line) c == target ? drawn : grid.getNumberAt(c),
      ];
      final eval = HandEvaluator.evaluate(numbers);
      score += _completedLineBonus(eval.rank);
      if (eval.rank == HandRank.onePair) score -= 260;
    }

    // Factor 4a: don't block good lines (fatal penalty).
    // If this line already looks "promising" for high-value hands and the drawn number
    // neither matches nor extends the current structure, avoid poisoning it.
    final hasGoodPair = _hasPairOfPremiumOrMid(values);
    final hasGoodStraightSetup = _hasThreeNumberStraightSetup(values);
    final doesNotHelp = exactMatches == 0 && minusCount == 0 && plusCount == 0;
    if (doesNotHelp && (hasGoodPair || hasGoodStraightSetup)) {
      score -= 500;
    }

    // Factor 4b: trash dump bonus — teach trash to go into already dead lines.
    if (category == _NumberCategory.trash && _isRuinedLine(values)) {
      score += 50;
    }

    return score;
  }

  /// All valid 4-cell lines (from the catalog) that pass through [cell].
  List<List<Coordinate>> _linesIntersecting(Coordinate cell) =>
      _linesByCell[cell] ?? const [];

  @override
  Future<int> playCombo(
    int round,
    List<Combo> myRemainingCombos,
    List<Combo> opponentHistory,
    MatrixGridModel opponentGrid,
  ) async {
    if (myRemainingCombos.isEmpty) {
      throw StateError('HardAiAgent.playCombo: no remaining combos.');
    }

    // Optional: first round probing — play mid-tier to "test the waters".
    if (round == 1 && myRemainingCombos.length >= 3) {
      final strongestToWeakest = _sortedByStrengthIndices(myRemainingCombos);
      return strongestToWeakest[strongestToWeakest.length ~/ 2];
    }

    // Step A: simulate opponent's best 12 drafts from their grid, then remove what
    // they've already played to estimate what's left.
    final guessedOpponentDrafts = await super.draftCombos(opponentGrid);
    final historyKeys =
        opponentHistory.map(_comboKey).toSet();
    final estimatedRemainingOpp =
        guessedOpponentDrafts.where((c) => !historyKeys.contains(_comboKey(c))).toList();

    // Step B: strongest remaining opponent combo (maxThreat).
    Combo? maxThreat;
    for (final c in estimatedRemainingOpp) {
      if (maxThreat == null || _compareStrongestFirst(c, maxThreat) < 0) {
        maxThreat = c;
      }
    }

    // Sort myRemainingCombos strongest → weakest (return original indices).
    final strongestToWeakest = _sortedByStrengthIndices(myRemainingCombos);
    final myStrongestIdx = strongestToWeakest.first;
    final myWeakestIdx = strongestToWeakest.last;

    // If we have no estimate, just secure with strongest.
    if (maxThreat == null) return myStrongestIdx;

    final myStrongest = myRemainingCombos[myStrongestIdx];

    // Step C: Tian Ji's sacrifice strategy.
    // If opponent's maxThreat is strictly stronger than our strongest, sacrifice weakest.
    final oppStrongerThanMine = _compareStrongestFirst(maxThreat, myStrongest) < 0;
    if (oppStrongerThanMine) return myWeakestIdx;

    // Otherwise beat or tie: play strongest to secure point.
    return myStrongestIdx;
  }
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

String _comboKey(Combo combo) =>
    combo.coordinates.map((c) => '${c.x}:${c.y}').join('|');

int _compareStrongestFirst(Combo a, Combo b) {
  final byRank = a.rank.index.compareTo(b.rank.index);
  if (byRank != 0) return byRank;
  return b.primaryKeyValue.compareTo(a.primaryKeyValue);
}

List<int> _sortedByStrengthIndices(List<Combo> combos) {
  final idx = List<int>.generate(combos.length, (i) => i);
  idx.sort((i, j) => _compareStrongestFirst(combos[i], combos[j]));
  return idx;
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

enum _NumberCategory { premium, mid, trash }

_NumberCategory _categoryOf(int drawnNumber) {
  if (drawnNumber >= 8) return _NumberCategory.premium;
  if (drawnNumber <= 3) return _NumberCategory.trash;
  return _NumberCategory.mid;
}

int _baseHeatScore(Coordinate c, _NumberCategory category, int drawn) {
  final isCenter = c.x == 2 && c.y == 2;
  final isCorner =
      (c.x == 0 || c.x == 4) && (c.y == 0 || c.y == 4);
  final isEdge = c.x == 0 || c.x == 4 || c.y == 0 || c.y == 4;
  final isInnerRing = !isCenter && !isEdge; // the 3×3 excluding center

  // Key fix: extremes (1 and 10) should not go into the core unless pairing.
  final isExtreme = drawn == 1 || drawn == 10;
  if (isExtreme) {
    return (isCorner || isEdge) ? 12 : ((isCenter || isInnerRing) ? -45 : 0);
  }

  return switch (category) {
    // Premium: mild center preference; line/adjacency bonuses should dominate.
    _NumberCategory.premium => isCenter ? 3 : (isInnerRing ? 2 : 0),
    _NumberCategory.trash => isCorner || isEdge
        ? 10
        : (isCenter || isInnerRing)
            ? -50
            : 0,
    // Mid numbers are the best straight-builders — keep them central.
    _NumberCategory.mid => isCenter ? 8 : (isInnerRing ? 4 : 0),
  };
}

int _completedLineBonus(HandRank rank) => switch (rank) {
      HandRank.fourOfAKind => 420,
      HandRank.straightInOrder => 280,
      HandRank.straightNotInOrder => 240,
      HandRank.twoPair => 320,
      HandRank.threeOfAKind => 260,
      HandRank.onePair => 60,
      HandRank.highCard => -120,
    };

bool _hasPairOfPremiumOrMid(List<int> values) {
  final counts = <int, int>{};
  for (final v in values) {
    if (v < 4) continue; // premium/mid only
    counts[v] = (counts[v] ?? 0) + 1;
    if (counts[v]! >= 2) return true;
  }
  return false;
}

bool _hasThreeNumberStraightSetup(List<int> values) {
  if (values.length < 3) return false;
  final distinct = values.toSet().toList()..sort();
  if (distinct.length < 3) return false;

  // "Good 3-number straight setup": three (or more) distinct values that fit inside
  // a potential 4-long straight window (span <= 3).
  final span = distinct.last - distinct.first;
  return span <= 3;
}

bool _isRuinedLine(List<int> values) {
  // "Ruined": mixed disconnected numbers with no pair or straight potential.
  // We treat a line as ruined if it has >=3 filled cells, no duplicates,
  // and its distinct values cannot fit inside a 4-long straight window.
  if (values.length < 3) return false;
  final distinct = values.toSet().toList()..sort();
  if (distinct.length != values.length) return false; // has a pair => not "ruined"
  final span = distinct.last - distinct.first;
  return span > 3;
}

int _linePotentialScore(
  List<int> existingValues,
  Map<int, int> counts,
  int drawn,
  _NumberCategory category,
) {
  final after = <int>[...existingValues, drawn];
  final emptySlots = 4 - after.length;

  // Quick span/straight window check.
  final distinct = after.toSet().toList()..sort();
  final span = distinct.last - distinct.first;

  var score = 0;

  // Reward being inside a possible straight window; penalize being "blown out".
  if (span <= 3) {
    score += 140;
  } else if (span == 4) {
    score += 40;
  } else {
    score -= 180;
  }

  // Duplicate patterns.
  final maxCount = counts.isEmpty ? 1 : counts.values.fold(1, max);
  final drawnCount = (counts[drawn] ?? 0) + 1;

  // Prefer building trips/4-kind, but not at the cost of ruining other lines.
  if (drawnCount >= 3) score += 260;
  // Pairing is good (suppresses HighCard); we handle "onePair spam" with other penalties.
  if (drawnCount == 2) score += 120;

  // Two-pair setups: one existing pair + we pair drawn.
  var hasOtherPair = false;
  for (final e in counts.entries) {
    if (e.key == drawn) continue;
    if (e.value >= 2) {
      hasOtherPair = true;
      break;
    }
  }
  if (hasOtherPair && drawnCount >= 2) score += 260;

  // Avoid creating lines that are very likely to end as "onePair".
  // If we already have 3 filled numbers after placement and it's exactly one pair,
  // heavily penalize — this tends to produce onePair in the final draft.
  if (after.length == 3 && emptySlots == 1) {
    final hasAnyPair = counts.values.any((c) => c >= 2) || drawnCount >= 2;
    final pairKinds =
        (counts.values.where((c) => c >= 2).length) + (drawnCount >= 2 ? 1 : 0);
    final hasTrips = maxCount >= 3 || drawnCount >= 3;
    if (hasAnyPair && !hasTrips && pairKinds == 1 && span > 3) {
      score -= 340;
    }
  }

  // Strong anti-scatter: if placing `drawn` creates a pair but the resulting
  // value set is NOT in a straight window and doesn't make two-pair/trips,
  // it will almost certainly become a onePair draft later.
  final hasAnyOtherPair =
      counts.entries.any((e) => e.key != drawn && e.value >= 2);
  final createsPair = drawnCount == 2;
  final inStraightWindow = span <= 3;
  final createsTrips = drawnCount >= 3;
  final createsTwoPair = createsPair && hasAnyOtherPair;
  if (createsPair && !inStraightWindow && !createsTrips && !createsTwoPair) {
    // Scale penalty by how "early" we are on the line (more empty slots = more risk).
    score -= emptySlots >= 2 ? 520 : 900;
  }

  // Trash dumping: if trash and line already looks ruined, it's ok to dump.
  if (category == _NumberCategory.trash && span > 3 && after.length >= 3) {
    score += 55;
  }

  return score;
}

int _localMagnetScore(
  MatrixGridModel grid,
  Coordinate target,
  int drawn,
  _NumberCategory category,
) {
  // Strongly encourage "same / similar numbers together" spatially.
  // Use king-neighbour adjacency (8 directions).
  var score = 0;
  for (var dy = -1; dy <= 1; dy++) {
    for (var dx = -1; dx <= 1; dx++) {
      if (dx == 0 && dy == 0) continue;
      final x = target.x + dx;
      final y = target.y + dy;
      if (x < 0 || x > 4 || y < 0 || y > 4) continue;
      final v = grid.getNumberAt(Coordinate(x, y));
      if (v == 0) continue;

      final diff = (v - drawn).abs();
      if (diff == 0) {
        // Same number next to each other is very good for building 4-kind lines.
        score += 60;
      } else if (diff == 1) {
        score += 24;
      } else if (diff == 2 && category != _NumberCategory.trash) {
        // Only reward +/-2 clustering for mid/premium.
        score += 8;
      }
    }
  }
  return score;
}

