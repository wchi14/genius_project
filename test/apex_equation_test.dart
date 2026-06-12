import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/apex_equation/logic/board_generator.dart';
import 'package:genius_project/games/apex_equation/logic/math_evaluator.dart';
import 'package:genius_project/games/apex_equation/models/equation_tile.dart';

EquationTile _tile(String id, OperatorType op, int value) =>
    EquationTile(id: id, operator: op, value: value);

void main() {
  group('EquationTile', () {
    test('equality includes id operator and value', () {
      const a = EquationTile(id: 'a', operator: OperatorType.add, value: 1);
      const b = EquationTile(id: 'a', operator: OperatorType.add, value: 1);
      const c = EquationTile(id: 'a', operator: OperatorType.multiply, value: 9);
      expect(a, b);
      expect(a == c, isFalse);
    });
  });

  group('MathEvaluator', () {
    test('ignores first tile operator', () {
      final r = MathEvaluator.evaluate(
        _tile('t1', OperatorType.divide, 2),
        _tile('t2', OperatorType.add, 3),
        _tile('t3', OperatorType.add, 4),
      );
      expect(r, 9);
    });

    test('BODMAS: multiply before add', () {
      final r = MathEvaluator.evaluate(
        _tile('t1', OperatorType.add, 2),
        _tile('t2', OperatorType.add, 3),
        _tile('t3', OperatorType.multiply, 4),
      );
      expect(r, 14);
    });

    test('BODMAS: divide before subtract', () {
      final r = MathEvaluator.evaluate(
        _tile('t1', OperatorType.add, 10),
        _tile('t2', OperatorType.subtract, 8),
        _tile('t3', OperatorType.divide, 2),
      );
      expect(r, 6);
    });

    test('same precedence left to right', () {
      final r = MathEvaluator.evaluate(
        _tile('t1', OperatorType.add, 8),
        _tile('t2', OperatorType.divide, 2),
        _tile('t3', OperatorType.multiply, 4),
      );
      expect(r, 16);
    });

    test('null when result is not an integer', () {
      final r = MathEvaluator.evaluate(
        _tile('t1', OperatorType.add, 5),
        _tile('t2', OperatorType.divide, 2),
        _tile('t3', OperatorType.add, 0),
      );
      expect(r, isNull);
    });

    test('null on divide by zero', () {
      final r = MathEvaluator.evaluate(
        _tile('t1', OperatorType.add, 1),
        _tile('t2', OperatorType.divide, 4),
        _tile('t3', OperatorType.divide, 0),
      );
      expect(r, isNull);
    });
  });

  group('BoardGenerator', () {
    test('generateRandomTiles returns count with balanced ops and values 1-9', () {
      final tiles = BoardGenerator.generateRandomTiles(10, random: Random(1));
      expect(tiles, hasLength(10));
      expect(tiles.map((t) => t.id).toSet(), hasLength(10));

      for (final tile in tiles) {
        expect(tile.value, inInclusiveRange(1, 9));
      }

      final opCounts = <OperatorType, int>{};
      for (final tile in tiles) {
        opCounts[tile.operator] = (opCounts[tile.operator] ?? 0) + 1;
      }
      expect(opCounts.length, OperatorType.values.length);
      for (final count in opCounts.values) {
        expect(count, greaterThanOrEqualTo(2));
      }
    });

    test('generateLevel returns solvable positive target', () {
      final level = BoardGenerator.generateLevel(random: Random(42));
      final tiles = level[BoardGenerator.levelTilesKey]! as List<EquationTile>;
      final target = level[BoardGenerator.levelTargetKey]! as int;

      expect(tiles, hasLength(10));
      expect(target, greaterThan(0));

      var matchesTarget = false;
      for (var i = 0; i < tiles.length; i++) {
        for (var j = 0; j < tiles.length; j++) {
          if (j == i) {
            continue;
          }
          for (var k = 0; k < tiles.length; k++) {
            if (k == i || k == j) {
              continue;
            }
            if (MathEvaluator.evaluate(tiles[i], tiles[j], tiles[k]) ==
                target) {
              matchesTarget = true;
            }
          }
        }
      }
      expect(matchesTarget, isTrue);
    });
  });
}
