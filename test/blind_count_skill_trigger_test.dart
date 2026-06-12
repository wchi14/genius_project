import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_ai_inputs.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai_config.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_memory.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_skill_trigger.dart';
import 'package:genius_project/games/blind_count_40/logic/blind_count_state.dart';
import 'package:genius_project/games/blind_count_40/models/block_model.dart';
import 'package:genius_project/games/blind_count_40/models/game_player.dart';

BlindCountState _state({
  int p1Blocks = 5,
  int poolRemaining = 20,
  List<String> p2UsedSkills = const [],
  bool hasUsedSkillThisTurn = false,
  bool hasGuessedThisTurn = false,
}) =>
    BlindCountState(
      currentTurn: BlindPlayerId.p2,
      p1Blocks: List.generate(
        p1Blocks,
        (i) => BlockModel(value: (i % 10) + 1, id: 'p1-$i'),
      ),
      p2BlockCount: 3,
      hiddenP2Blocks: const [
        BlockModel(value: 4, id: 'a'),
        BlockModel(value: 4, id: 'b'),
        BlockModel(value: 9, id: 'c'),
      ],
      p1Score: 0,
      p2Score: 0,
      currentTurnComboScore: 0,
      poolRemaining: poolRemaining,
      isSumRevealed: false,
      p1UsedSkills: const [],
      p2UsedSkills: p2UsedSkills,
      isGameOver: false,
      turnRemainingSeconds: 20,
      hasUsedSkillThisTurn: hasUsedSkillThisTurn,
      hasGuessedThisTurn: hasGuessedThisTurn,
    );

void main() {
  group('BlindCountSkillTrigger', () {
    test('once-per-match: spent skills are not eligible', () {
      final inputs = BlindCountAiInputs.fromTable(
        state: _state(p2UsedSkills: ['sum', 'radar'], p1Blocks: 7),
        memory: BlindCountOpponentMemory(),
      );

      expect(
        BlindCountSkillTrigger.canTriggerSum(
          inputs,
          BlindCountOpponentAiConfig.standard,
        ),
        isFalse,
      );
      expect(
        BlindCountSkillTrigger.canTriggerRadar(
          inputs,
          config: BlindCountOpponentAiConfig.standard,
          planningToGuess: true,
        ),
        isFalse,
      );
      expect(
        BlindCountSkillTrigger.canTriggerBloatSkill(
          inputs,
          BlindCountOpponentAiConfig.standard,
        ),
        isTrue,
      );
      expect(
        BlindCountSkillTrigger.eligibleSkillIds(
          inputs,
          planningToGuess: true,
        ),
        ['bloat'],
      );
    });

    test('Force Bloat triggers only at exactly 7 player blocks', () {
      final atSeven = BlindCountAiInputs.fromTable(
        state: _state(p1Blocks: 7),
        memory: BlindCountOpponentMemory(),
      );
      final atSix = BlindCountAiInputs.fromTable(
        state: _state(p1Blocks: 6),
        memory: BlindCountOpponentMemory(),
      );

      const cfg = BlindCountOpponentAiConfig.standard;
      expect(BlindCountSkillTrigger.canTriggerBloatSkill(atSeven, cfg), isTrue);
      expect(BlindCountSkillTrigger.canTriggerBloatSkill(atSix, cfg), isFalse);
    });

    test('turn guards: no skills after first guess or skill used this turn', () {
      final guessed = BlindCountAiInputs.fromTable(
        state: _state(hasGuessedThisTurn: true),
        memory: BlindCountOpponentMemory(),
      );
      expect(
        BlindCountSkillTrigger.hasCandidate(
          guessed,
          planningToGuess: true,
          config: BlindCountOpponentAiConfig.standard,
        ),
        isFalse,
      );

      final usedTurn = BlindCountAiInputs.fromTable(
        state: _state(hasUsedSkillThisTurn: true),
        memory: BlindCountOpponentMemory(),
      );
      expect(
        BlindCountSkillTrigger.hasCandidate(
          usedTurn,
          planningToGuess: true,
          config: BlindCountOpponentAiConfig.standard,
        ),
        isFalse,
      );
    });

    test('Add Block skill not eligible at player cap', () {
      final inputs = BlindCountAiInputs.fromTable(
        state: _state(p1Blocks: 8),
        memory: BlindCountOpponentMemory(),
      );
      expect(
        BlindCountSkillTrigger.canTriggerBloatSkill(
          inputs,
          BlindCountOpponentAiConfig.standard,
        ),
        isFalse,
      );
    });

    test('Sum Reveal needs <= 4 player blocks and pool < 15', () {
      final eligible = BlindCountAiInputs.fromTable(
        state: _state(p1Blocks: 4, poolRemaining: 14),
        memory: BlindCountOpponentMemory(),
      );
      final tooManyBlocks = BlindCountAiInputs.fromTable(
        state: _state(p1Blocks: 5, poolRemaining: 14),
        memory: BlindCountOpponentMemory(),
      );
      final earlyDeck = BlindCountAiInputs.fromTable(
        state: _state(p1Blocks: 3, poolRemaining: 20),
        memory: BlindCountOpponentMemory(),
      );

      const cfg = BlindCountOpponentAiConfig.standard;
      expect(BlindCountSkillTrigger.canTriggerSum(eligible, cfg), isTrue);
      expect(BlindCountSkillTrigger.canTriggerSum(tooManyBlocks, cfg), isFalse);
      expect(BlindCountSkillTrigger.canTriggerSum(earlyDeck, cfg), isFalse);
    });

    test('Duplicate Radar needs >= 5 blocks and a planned guess', () {
      final inputs = BlindCountAiInputs.fromTable(
        state: _state(p1Blocks: 5),
        memory: BlindCountOpponentMemory(),
      );

      expect(
        BlindCountSkillTrigger.canTriggerRadar(
          inputs,
          config: BlindCountOpponentAiConfig.standard,
          planningToGuess: true,
        ),
        isTrue,
      );
      expect(
        BlindCountSkillTrigger.canTriggerRadar(
          inputs,
          config: BlindCountOpponentAiConfig.standard,
          planningToGuess: false,
        ),
        isFalse,
      );
      expect(
        BlindCountSkillTrigger.canTriggerRadar(
          BlindCountAiInputs.fromTable(
            state: _state(p1Blocks: 4),
            memory: BlindCountOpponentMemory(),
          ),
          config: BlindCountOpponentAiConfig.standard,
          planningToGuess: true,
        ),
        isFalse,
      );
    });

    test('tryPickSkill returns id when roll passes', () {
      final inputs = BlindCountAiInputs.fromTable(
        state: _state(p1Blocks: 4, poolRemaining: 10),
        memory: BlindCountOpponentMemory(),
      );
      const always = BlindCountOpponentAiConfig(skillAttemptChance: 1.0);

      expect(
        BlindCountSkillTrigger.tryPickSkill(
          inputs: inputs,
          planningToGuess: true,
          config: always,
          random: Random(2),
        ),
        isNotNull,
      );
    });
  });
}
