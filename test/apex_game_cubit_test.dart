import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/apex_equation/logic/apex_game_cubit.dart';
import 'package:genius_project/games/apex_equation/logic/math_evaluator.dart';
import 'package:genius_project/games/apex_equation/models/apex_game_mode.dart';
import 'package:genius_project/games/apex_equation/models/equation_tile.dart';

EquationTile _tile(String id, OperatorType op, int value) =>
    EquationTile(id: id, operator: op, value: value);

void main() {
  group('ApexGameCubit', () {
    test('countdown starts at level 1 with 60 seconds', () {
      final cubit =
          ApexGameCubit(mode: ApexGameMode.countdown, random: Random(1));
      addTearDown(cubit.close);

      expect(cubit.state.mode, ApexGameMode.countdown);
      expect(cubit.state.currentLevel, 1);
      expect(cubit.state.remainingSeconds, 60);
      expect(cubit.state.currentScore, 0);
      expect(cubit.state.currentWrongTries, 0);
      expect(cubit.state.isGameOver, isFalse);
      expect(cubit.state.availableTiles, hasLength(10));
    });

    test('arena starts at level 1 with elapsed time 0', () {
      final cubit = ApexGameCubit(mode: ApexGameMode.arena, random: Random(1));
      addTearDown(cubit.close);

      expect(cubit.state.mode, ApexGameMode.arena);
      expect(cubit.state.currentLevel, 1);
      expect(cubit.state.remainingSeconds, 0);
      expect(cubit.state.isGameOver, isFalse);
    });

    test('selectTile caps at three and deselect removes', () {
      final tiles = [
        _tile('a', OperatorType.add, 1),
        _tile('b', OperatorType.add, 2),
        _tile('c', OperatorType.add, 3),
        _tile('d', OperatorType.add, 4),
      ];
      final cubit = ApexGameCubit(
        mode: ApexGameMode.arena,
        initialTiles: tiles,
        initialTarget: 99,
      );
      addTearDown(cubit.close);

      cubit.selectTile(tiles[0]);
      cubit.selectTile(tiles[1]);
      cubit.selectTile(tiles[2]);
      cubit.selectTile(tiles[3]);
      expect(cubit.state.selectedTiles.map((t) => t.id), ['a', 'b', 'c']);

      cubit.deselectTile(tiles[1]);
      expect(cubit.state.selectedTiles.map((t) => t.id), ['a', 'c']);
    });

    test('correct submit advances level and scores in countdown', () {
      final t1 = _tile('a', OperatorType.add, 2);
      final t2 = _tile('b', OperatorType.add, 3);
      final t3 = _tile('c', OperatorType.add, 4);
      final target = MathEvaluator.evaluate(t1, t2, t3)!;

      final cubit = ApexGameCubit(
        mode: ApexGameMode.countdown,
        initialTiles: [t1, t2, t3, ...List.generate(7, (i) => _tile('x$i', OperatorType.add, 1))],
        initialTarget: target,
      );
      addTearDown(cubit.close);

      cubit.selectTile(t1);
      cubit.selectTile(t2);
      cubit.selectTile(t3);
      cubit.submitAnswer();

      expect(cubit.state.currentScore, 1);
      expect(cubit.state.currentLevel, 2);
      expect(cubit.state.selectedTiles, isEmpty);
      expect(
        cubit.state.remainingSeconds,
        ApexGameCubit.countdownStartSeconds +
            ApexGameCubit.countdownTimeBonusForLevel(1),
      );
    });

    test('wrong submit clears selection and sets flash', () {
      final t1 = _tile('a', OperatorType.add, 2);
      final t2 = _tile('b', OperatorType.add, 3);
      final t3 = _tile('c', OperatorType.add, 4);

      final cubit = ApexGameCubit(
        mode: ApexGameMode.arena,
        initialTiles: [t1, t2, t3],
        initialTarget: 999,
      );
      addTearDown(cubit.close);

      cubit.selectTile(t1);
      cubit.selectTile(t2);
      cubit.selectTile(t3);
      cubit.submitAnswer();

      expect(cubit.state.selectedTiles, isEmpty);
      expect(cubit.state.wrongAnswerFlash, isTrue);
      expect(cubit.state.currentWrongTries, 1);
      expect(cubit.state.currentScore, 0);
      expect(cubit.state.currentLevel, 1);

      cubit.clearWrongAnswerFlash();
      expect(cubit.state.wrongAnswerFlash, isFalse);
    });

    test('five wrong tries auto-skips without scoring', () {
      final t1 = _tile('a', OperatorType.add, 2);
      final t2 = _tile('b', OperatorType.add, 3);
      final t3 = _tile('c', OperatorType.add, 4);
      final board = [
        t1,
        t2,
        t3,
        ...List.generate(7, (i) => _tile('f$i', OperatorType.add, 1)),
      ];
      var levelCalls = 0;
      final cubit = ApexGameCubit(
        mode: ApexGameMode.arena,
        initialTiles: board,
        initialTarget: 999,
        levelGenerator: (_) {
          levelCalls += 1;
          return (tiles: board, target: 888);
        },
      );
      addTearDown(cubit.close);

      void wrongSubmit() {
        cubit.selectTile(t1);
        cubit.selectTile(t2);
        cubit.selectTile(t3);
        cubit.submitAnswer();
      }

      for (var i = 0; i < 4; i++) {
        wrongSubmit();
        expect(cubit.state.currentWrongTries, i + 1);
        expect(cubit.state.currentLevel, 1);
        expect(cubit.state.currentScore, 0);
      }

      wrongSubmit();
      expect(cubit.state.currentWrongTries, 0);
      expect(cubit.state.currentLevel, 2);
      expect(cubit.state.currentScore, 0);
      expect(cubit.state.targetNumber, 888);
      expect(levelCalls, 1);
    });

    test('arena solving level 15 ends at 15/15 not 16', () {
      final t1 = _tile('a', OperatorType.add, 2);
      final t2 = _tile('b', OperatorType.add, 3);
      final t3 = _tile('c', OperatorType.add, 4);
      final target = MathEvaluator.evaluate(t1, t2, t3)!;
      final board = [
        t1,
        t2,
        t3,
        ...List.generate(7, (i) => _tile('f$i', OperatorType.add, 1)),
      ];
      final level = (_) => (tiles: board, target: target);

      final cubit = ApexGameCubit(
        mode: ApexGameMode.arena,
        initialLevel: ApexGameCubit.arenaLevelCount,
        initialTiles: board,
        initialTarget: target,
        levelGenerator: level,
      );
      addTearDown(cubit.close);

      cubit.selectTile(t1);
      cubit.selectTile(t2);
      cubit.selectTile(t3);
      cubit.submitAnswer();

      expect(cubit.state.isGameOver, isTrue);
      expect(cubit.state.currentLevel, ApexGameCubit.arenaLevelCount);
      expect(cubit.state.currentScore, 1);
    });

    test('countdownTimeBonusForLevel uses level bands', () {
      expect(ApexGameCubit.countdownTimeBonusForLevel(1), 30);
      expect(ApexGameCubit.countdownTimeBonusForLevel(5), 30);
      expect(ApexGameCubit.countdownTimeBonusForLevel(6), 25);
      expect(ApexGameCubit.countdownTimeBonusForLevel(10), 25);
      expect(ApexGameCubit.countdownTimeBonusForLevel(11), 20);
      expect(ApexGameCubit.countdownTimeBonusForLevel(15), 20);
      expect(ApexGameCubit.countdownTimeBonusForLevel(16), 15);
    });
  });
}
