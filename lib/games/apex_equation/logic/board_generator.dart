import 'dart:math';

import 'package:genius_project/games/apex_equation/logic/math_evaluator.dart';
import 'package:genius_project/games/apex_equation/models/equation_tile.dart';

/// Builds random tile pools and guaranteed-solvable Apex Equation levels.
class BoardGenerator {
  BoardGenerator._();

  static const int defaultTileCount = 10;
  static const int minTileValue = 1;
  static const int maxTileValue = 9;

  static const int _maxOrderedTriplesPerDeck = 720;
  static const int _maxDeckRegenerations = 48;

  /// Keys on [generateLevel] maps: `tiles`, `targetNumber`.
  static const String levelTilesKey = 'tiles';
  static const String levelTargetKey = 'targetNumber';

  /// [count] tiles with values in [minTileValue]..[maxTileValue] and operators
  /// spread evenly across [OperatorType] values (then shuffled).
  static List<EquationTile> generateRandomTiles(
    int count, {
    Random? random,
  }) {
    assert(count > 0, 'count must be positive');
    final rng = random ?? Random();
    final operators = _balancedOperators(count, rng);

    return List<EquationTile>.generate(count, (i) {
      return EquationTile(
        id: 'tile_$i',
        operator: operators[i],
        value: minTileValue + rng.nextInt(maxTileValue - minTileValue + 1),
      );
    });
  }

  /// Builds a solvable level: 10 tiles plus a positive integer target.
  ///
  /// Picks an ordered triple of distinct tiles whose [MathEvaluator.evaluate]
  /// is a positive integer; regenerates the tile pool if none is found.
  static Map<String, dynamic> generateLevel({Random? random}) {
    final rng = random ?? Random();

    for (var attempt = 0; attempt < _maxDeckRegenerations; attempt++) {
      final tiles = generateRandomTiles(defaultTileCount, random: rng);
      final target = _findValidTarget(tiles, rng);
      if (target != null) {
        return {
          levelTilesKey: tiles,
          levelTargetKey: target,
        };
      }
    }

    throw StateError(
      'Could not generate a solvable Apex Equation level after '
      '$_maxDeckRegenerations deck attempts.',
    );
  }

  static List<OperatorType> _balancedOperators(int count, Random rng) {
    const types = OperatorType.values;
    final list = List<OperatorType>.generate(
      count,
      (i) => types[i % types.length],
    );
    list.shuffle(rng);
    return list;
  }

  /// Tries random ordered triples of distinct tiles; returns first valid target.
  static int? _findValidTarget(List<EquationTile> tiles, Random rng) {
    final n = tiles.length;
    if (n < 3) {
      return null;
    }

    final triples = <List<int>>[];
    for (var i = 0; i < n; i++) {
      for (var j = 0; j < n; j++) {
        if (j == i) {
          continue;
        }
        for (var k = 0; k < n; k++) {
          if (k == i || k == j) {
            continue;
          }
          triples.add([i, j, k]);
        }
      }
    }

    triples.shuffle(rng);

    final tries = min(triples.length, _maxOrderedTriplesPerDeck);
    for (var t = 0; t < tries; t++) {
      final idx = triples[t];
      final result = MathEvaluator.evaluate(
        tiles[idx[0]],
        tiles[idx[1]],
        tiles[idx[2]],
      );
      if (result != null && result > 0) {
        return result;
      }
    }

    for (final idx in triples) {
      final result = MathEvaluator.evaluate(
        tiles[idx[0]],
        tiles[idx[1]],
        tiles[idx[2]],
      );
      if (result != null && result > 0) {
        return result;
      }
    }

    return null;
  }
}
