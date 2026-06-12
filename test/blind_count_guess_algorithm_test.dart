import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_ai_inputs.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_guess_algorithm.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai_config.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_memory.dart';
import 'package:genius_project/games/blind_count_40/logic/blind_count_state.dart';
import 'package:genius_project/games/blind_count_40/models/block_model.dart';
import 'package:genius_project/games/blind_count_40/models/game_player.dart';

BlindCountState _state() => BlindCountState(
      currentTurn: BlindPlayerId.p2,
      p1Blocks: List.generate(
        4,
        (i) => BlockModel(value: i + 1, id: 'p1-$i'),
      ),
      p2BlockCount: 2,
      hiddenP2Blocks: const [
        BlockModel(value: 3, id: 'a'),
        BlockModel(value: 8, id: 'b'),
      ],
      p1Score: 0,
      p2Score: 0,
      currentTurnComboScore: 0,
      poolRemaining: 12,
      isSumRevealed: false,
      p1UsedSkills: const [],
      isGameOver: false,
      turnRemainingSeconds: 15,
    );

BlindCountAiInputs _inputs({
  required BlindCountOpponentMemory memory,
}) =>
    BlindCountAiInputs.fromTable(state: _state(), memory: memory);

void main() {
  group('BlindCountGuessAlgorithm', () {
    test('base weight is 40 per number before modifiers', () {
      expect(
        BlindCountOpponentAiConfig.standard.baseGuessWeight,
        40,
      );
    });

    test('returns 1..10', () {
      final memory = BlindCountOpponentMemory();
      for (var i = 0; i < 30; i++) {
        expect(
          BlindCountGuessAlgorithm.pickNumber(
            inputs: _inputs(memory: memory),
            memory: memory,
            random: Random(i),
          ),
          inInclusiveRange(1, 10),
        );
      }
    });

    test('picks the number with the highest weight', () {
      final memory = BlindCountOpponentMemory();
      final weights = BlindCountGuessAlgorithm.buildWeights(
        inputs: _inputs(memory: memory),
        memory: memory,
        random: Random(0),
      );
      expect(
        BlindCountGuessAlgorithm.pickNumber(
          inputs: _inputs(memory: memory),
          memory: memory,
          random: Random(0),
        ),
        BlindCountGuessAlgorithm.selectHighestWeight(weights, random: Random(0)),
      );
    });

    test('memory_pool modifier subtracts 10 per remembered block', () {
      final memory = BlindCountOpponentMemory();
      memory.recordRevealedFromPlayerHand([
        const BlockModel(value: 6, id: '1'),
        const BlockModel(value: 6, id: '2'),
      ]);
      final withPool = BlindCountGuessAlgorithm.buildWeights(
        inputs: _inputs(memory: memory),
        memory: memory,
        random: Random(0),
      );
      final baseline = BlindCountGuessAlgorithm.buildWeights(
        inputs: _inputs(memory: BlindCountOpponentMemory()),
        memory: BlindCountOpponentMemory(),
        random: Random(0),
      );
      expect(withPool[6]!, lessThan(baseline[6]! - 15));
    });

    test('self-hand modifier subtracts 10 per block in ai_hand', () {
      final memory = BlindCountOpponentMemory();
      final state = _state().copyWith(
        hiddenP2Blocks: const [
          BlockModel(value: 8, id: 'a'),
          BlockModel(value: 8, id: 'b'),
          BlockModel(value: 3, id: 'c'),
        ],
        p2BlockCount: 3,
      );
      final inputs = BlindCountAiInputs.fromTable(state: state, memory: memory);
      final weights = BlindCountGuessAlgorithm.buildWeights(
        inputs: inputs,
        memory: memory,
        random: Random(0),
      );
      final emptyHand = BlindCountGuessAlgorithm.buildWeights(
        inputs: BlindCountAiInputs.fromTable(
          state: _state().copyWith(hiddenP2Blocks: const [], p2BlockCount: 0),
          memory: memory,
        ),
        memory: memory,
        random: Random(0),
      );
      expect(weights[8]!, lessThan(emptyHand[8]! - 15));
      expect(weights[3]!, lessThan(emptyHand[3]!));
    });

    test('tie-break picks randomly among equal top weights', () {
      final weights = <int, double>{for (var v = 1; v <= 10; v++) v: 25.0};
      final picks = <int>{};
      for (var seed = 0; seed < 40; seed++) {
        picks.add(
          BlindCountGuessAlgorithm.selectHighestWeight(
            weights,
            random: Random(seed),
          ),
        );
      }
      expect(picks.length, greaterThan(1));
      for (final pick in picks) {
        expect(pick, inInclusiveRange(1, 10));
      }
    });

    test('psychological modifier adds 5 to player_last_guess value', () {
      final memory = BlindCountOpponentMemory();
      memory.recordPlayerGuess(value: 5, wasCorrect: false, matchCount: 0);
      final withLast = BlindCountGuessAlgorithm.buildWeights(
        inputs: _inputs(memory: memory),
        memory: memory,
        random: Random(0),
      );
      final withoutLast = BlindCountGuessAlgorithm.buildWeights(
        inputs: _inputs(memory: BlindCountOpponentMemory()),
        memory: BlindCountOpponentMemory(),
        random: Random(0),
      );
      expect(
        withLast[5]!,
        greaterThan(withoutLast[5]! + 4),
      );
    });

    test('player_last_guess wrong nudges that value', () {
      final memory = BlindCountOpponentMemory();
      memory.recordPlayerGuess(value: 5, wasCorrect: false, matchCount: 0);
      final withGuess = BlindCountGuessAlgorithm.buildWeights(
        inputs: _inputs(memory: memory),
        memory: memory,
        random: Random(0),
      );
      final baseline = BlindCountGuessAlgorithm.buildWeights(
        inputs: _inputs(memory: BlindCountOpponentMemory()),
        memory: BlindCountOpponentMemory(),
        random: Random(0),
      );
      expect(withGuess[5]! > baseline[5]!, isTrue);
    });
  });
}
