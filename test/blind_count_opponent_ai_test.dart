import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_ai_inputs.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_guess_algorithm.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai_config.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_memory.dart';
import 'package:genius_project/games/blind_count_40/logic/blind_count_state.dart';
import 'package:genius_project/games/blind_count_40/models/block_model.dart';
import 'package:genius_project/games/blind_count_40/models/game_player.dart';

BlindCountOpponentAi _testAi(
  BlindCountOpponentMemory memory, {
  BlindCountOpponentAiConfig config = BlindCountOpponentAiConfig.standard,
  Random? random,
}) =>
    BlindCountOpponentAi(config: config, memory: memory, random: random);

BlindCountState _baseState() {
  return BlindCountState(
    currentTurn: BlindPlayerId.p2,
    p1Blocks: List.generate(
      5,
      (i) => BlockModel(value: (i % 10) + 1, id: 'p1-$i'),
    ),
    p2BlockCount: 3,
    hiddenP2Blocks: const [
      BlockModel(value: 4, id: 'p2-a'),
      BlockModel(value: 7, id: 'p2-b'),
      BlockModel(value: 9, id: 'p2-c'),
    ],
    p1Score: 0,
    p2Score: 0,
    currentTurnComboScore: 0,
    poolRemaining: 20,
    isSumRevealed: false,
    p1UsedSkills: const [],
    isGameOver: false,
    turnRemainingSeconds: 20,
  );
}

void main() {
  group('BlindCountOpponentMemory', () {
    test('memory_pool keeps only the last N revealed blocks', () {
      final memory = BlindCountOpponentMemory(memoryPoolSize: 3);
      memory.recordDiscardsFromPlayerHand([1, 2, 3, 4]);
      expect(memory.memoryPool.map((d) => d.value), [2, 3, 4]);
    });

    test('memory_pool default size is 10', () {
      expect(BlindCountOpponentMemory().memoryPoolSize, 10);
    });

    test('recordRevealed stores block ids when available', () {
      final memory = BlindCountOpponentMemory(memoryPoolSize: 2);
      memory.recordRevealedFromPlayerHand([
        const BlockModel(value: 5, id: 'x'),
        const BlockModel(value: 5, id: 'y'),
      ]);
      expect(memory.memoryPool.map((b) => b.blockId), ['x', 'y']);
    });

    test('player_last_guess is the most recent human guess', () {
      final memory = BlindCountOpponentMemory();
      expect(memory.playerLastGuess, isNull);

      memory.recordPlayerGuess(value: 4, wasCorrect: true, matchCount: 1);
      expect(memory.playerLastGuess, 4);

      memory.recordPlayerGuess(value: 9, wasCorrect: false, matchCount: 0);
      expect(memory.playerLastGuess, 9);
    });

    test('tracks player and own guesses separately', () {
      final memory = BlindCountOpponentMemory(
        maxPlayerGuesses: 2,
        maxOwnGuesses: 2,
      );
      memory.recordPlayerGuess(value: 5, wasCorrect: true, matchCount: 2);
      memory.recordOwnGuess(value: 8, wasCorrect: false, matchCount: 0);
      memory.recordPlayerGuess(value: 3, wasCorrect: false, matchCount: 0);
      memory.recordOwnGuess(value: 1, wasCorrect: true, matchCount: 1);

      expect(memory.recentPlayerGuesses.length, 2);
      expect(memory.recentOwnGuesses.length, 2);
      expect(memory.recentPlayerGuesses.last.value, 3);
      expect(memory.recentOwnGuesses.first.value, 8);
    });
  });

  group('BlindCountAiInputs', () {
    test('ai_hand mirrors hidden P2 blocks only', () {
      final state = _baseState();
      final memory = BlindCountOpponentMemory();
      memory.recordDiscardsFromPlayerHand([2]);
      final inputs = BlindCountAiInputs.fromTable(state: state, memory: memory);
      expect(inputs.aiHand, state.hiddenP2Blocks);
      expect(inputs.aiHandValues, {4, 7, 9});
      expect(inputs.playerBlockCount, 5);
      expect(inputs.memoryPool.single.value, 2);
      expect(inputs.playerLastGuess, isNull);
    });

    test('player_last_guess exposed on inputs from memory', () {
      final memory = BlindCountOpponentMemory();
      memory.recordPlayerGuess(value: 6, wasCorrect: false, matchCount: 0);
      final inputs = BlindCountAiInputs.fromTable(
        state: _baseState(),
        memory: memory,
      );
      expect(inputs.playerLastGuess, 6);
    });

    test('player_block_count is integer in 0..8 from face-down row length', () {
      final state = _baseState().copyWith(
        p1Blocks: List.generate(
          8,
          (i) => BlockModel(value: 2, id: 'cap-$i'),
        ),
      );
      final inputs = BlindCountAiInputs.fromTable(
        state: state,
        memory: BlindCountOpponentMemory(),
      );
      expect(inputs.playerBlockCount, 8);
      expect(inputs.isPlayerBlockCap, isTrue);

      final cleared = BlindCountAiInputs(
        aiHand: const [BlockModel(value: 1, id: 'a')],
        playerBlockCount: 0,
        memoryPool: const [],
        playerLastGuess: null,
        poolRemaining: 0,
        currentTurnComboScore: 0,
        turnRemainingSeconds: 20,
        canStopGuessing: false,
        canGiveBlockThisTurn: true,
        hasUsedSkillThisTurn: false,
        isGameOver: false,
        isSkillPeekActive: false,
        isResolvingGuess: false,
        isP2Turn: true,
        canUseSumSkill: false,
        canUseRadarSkill: false,
        canUseBloatSkill: false,
      );
      expect(cleared.playerBlockCount, 0);
      expect(cleared.isPlayerBlockCap, isFalse);
    });
  });

  group('BlindCountOpponentAi', () {
    test('Rule 2: high confidence weight forces guess at turn start', () {
      final memory = BlindCountOpponentMemory();
      final inputs = BlindCountAiInputs.fromTable(
        state: _baseState(),
        memory: memory,
      );

      for (var seed = 0; seed < 20; seed++) {
        final action = _testAi(
          memory,
          config: const BlindCountOpponentAiConfig(skillAttemptChance: 1.0),
          random: Random(seed),
        ).decide(inputs);
        expect(action, isA<BlindCountAiGuess>());
      }
    });

    test('Rule 1: at 8 player blocks turn start is always guess', () {
      final memory = BlindCountOpponentMemory();
      final state = _baseState().copyWith(
        p1Blocks: List.generate(
          8,
          (i) => BlockModel(value: 3, id: 'cap-$i'),
        ),
      );
      final inputs = BlindCountAiInputs.fromTable(state: state, memory: memory);

      for (var seed = 0; seed < 40; seed++) {
        final action = _testAi(
          memory,
          config: const BlindCountOpponentAiConfig(skillAttemptChance: 1.0),
          random: Random(seed),
        ).decide(inputs);
        expect(action, isA<BlindCountAiGuess>());
      }
    });

    test('during combo never chooses give block', () {
      final memory = BlindCountOpponentMemory();
      final state = _baseState().copyWith(
        hasGuessedThisTurn: true,
        currentTurnComboScore: 4,
      );
      final inputs = BlindCountAiInputs.fromTable(state: state, memory: memory);

      for (var seed = 0; seed < 40; seed++) {
        final action = _testAi(memory, random: Random(seed)).decide(inputs);
        expect(action, isNot(isA<BlindCountAiGiveBlock>()));
      }
    });

    test('pickGuess stays in 1..10', () {
      final memory = BlindCountOpponentMemory();
      final inputs = BlindCountAiInputs.fromTable(
        state: _baseState(),
        memory: memory,
      );
      for (var i = 0; i < 40; i++) {
        final guess = _testAi(memory, random: Random(i)).pickGuess(inputs);
        expect(guess, inInclusiveRange(1, 10));
      }
    });

    test('guesses the highest-weight value after deductions', () {
      final memory = BlindCountOpponentMemory();
      memory.recordOwnGuess(value: 2, wasCorrect: false, matchCount: 0);

      final inputs = BlindCountAiInputs.fromTable(
        state: _baseState(),
        memory: memory,
      );
      final weights = BlindCountGuessAlgorithm.buildWeights(
        inputs: inputs,
        memory: memory,
        random: Random(0),
      );
      expect(
        _testAi(memory, random: Random(0)).pickGuess(inputs),
        BlindCountGuessAlgorithm.selectHighestWeight(weights, random: Random(0)),
      );
    });

    test('does not read hidden player blocks', () {
      final memory = BlindCountOpponentMemory();
      final state = _baseState().copyWith(
        p1Blocks: List.generate(
          5,
          (_) => const BlockModel(value: 1, id: 'secret'),
        ),
      );
      final guess = _testAi(memory, random: Random(1)).pickGuess(
        BlindCountAiInputs.fromTable(state: state, memory: memory),
      );
      expect(guess, inInclusiveRange(1, 10));
    });
  });
}
