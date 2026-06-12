import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_action_matrix.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_ai_inputs.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai_config.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_memory.dart';
import 'package:genius_project/games/blind_count_40/logic/blind_count_state.dart';
import 'package:genius_project/games/blind_count_40/models/block_model.dart';
import 'package:genius_project/games/blind_count_40/models/game_player.dart';

BlindCountState _state({int p1Blocks = 5}) => BlindCountState(
      currentTurn: BlindPlayerId.p2,
      p1Blocks: List.generate(
        p1Blocks,
        (i) => BlockModel(value: (i % 10) + 1, id: 'p1-$i'),
      ),
      p2BlockCount: 3,
      hiddenP2Blocks: const [
        BlockModel(value: 4, id: 'a'),
        BlockModel(value: 7, id: 'b'),
        BlockModel(value: 9, id: 'c'),
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

void main() {
  group('BlindCountActionMatrix', () {
    test('Rule 1: player at 8 blocks forces guess at turn start', () {
      final inputs = BlindCountAiInputs.fromTable(
        state: _state(p1Blocks: 8),
        memory: BlindCountOpponentMemory(),
      );
      const alwaysSkill =
          BlindCountOpponentAiConfig(skillAttemptChance: 1.0);

      expect(
        BlindCountActionMatrix.decideTurnStartMain(
          inputs: inputs,
          guessWeights: {for (var v = 1; v <= 10; v++) v: 10.0},
        ),
        BlindCountTurnStartAction.guess,
      );
      expect(
        BlindCountActionMatrix.decideGuessVsBloat(
          inputs: inputs,
          guessWeights: {for (var v = 1; v <= 10; v++) v: 10.0},
        ),
        BlindCountMainAction.guess,
      );
    });

    test('forces guess when not allowed to bloat', () {
      final inputs = BlindCountAiInputs.fromTable(
        state: _state(),
        memory: BlindCountOpponentMemory(),
      ).copyWithManual(hasGuessed: true);

      expect(
        BlindCountActionMatrix.decideGuessVsBloat(
          inputs: inputs,
          guessWeights: {for (var v = 1; v <= 10; v++) v: 10.0},
        ),
        BlindCountMainAction.guess,
      );
    });

    test('Rule 2: highest weight >= 30 forces guess at turn start', () {
      final inputs = BlindCountAiInputs.fromTable(
        state: _state(p1Blocks: 5),
        memory: BlindCountOpponentMemory(),
      );
      const alwaysSkill =
          BlindCountOpponentAiConfig(skillAttemptChance: 1.0);
      final confident = {for (var v = 1; v <= 10; v++) v: 20.0}..[4] = 32.0;

      expect(
        BlindCountActionMatrix.decideTurnStartMain(
          inputs: inputs,
          guessWeights: confident,
        ),
        BlindCountTurnStartAction.guess,
      );
      expect(
        BlindCountActionMatrix.decideGuessVsBloat(
          inputs: inputs,
          guessWeights: confident,
        ),
        BlindCountMainAction.guess,
      );
    });

    test('Rule 3: tactical zone rolls 70% bloat / 30% guess', () {
      final inputs = BlindCountAiInputs.fromTable(
        state: _state(p1Blocks: 2),
        memory: BlindCountOpponentMemory(),
      );
      final lowConfidence = {for (var v = 1; v <= 10; v++) v: 25.0};

      expect(
        BlindCountActionMatrix.isTacticalBloatZone(
          inputs,
          lowConfidence,
          BlindCountOpponentAiConfig.standard,
        ),
        isTrue,
      );
      expect(
        BlindCountActionMatrix.decideGuessVsBloat(
          inputs: inputs,
          guessWeights: lowConfidence,
          config: const BlindCountOpponentAiConfig(tacticalBloatChance: 1.0),
          random: Random(0),
        ),
        BlindCountMainAction.bloat,
      );
      expect(
        BlindCountActionMatrix.decideGuessVsBloat(
          inputs: inputs,
          guessWeights: lowConfidence,
          config: const BlindCountOpponentAiConfig(tacticalBloatChance: 0.0),
          random: Random(0),
        ),
        BlindCountMainAction.guess,
      );
    });


    test('prefers guess when top weight is a clear leader', () {
      final inputs = BlindCountAiInputs.fromTable(
        state: _state(p1Blocks: 7),
        memory: BlindCountOpponentMemory(),
      );
      final peaked = {for (var v = 1; v <= 10; v++) v: 20.0}..[8] = 120.0;

      expect(
        BlindCountActionMatrix.decideGuessVsBloat(
          inputs: inputs,
          guessWeights: peaked,
          random: Random(2),
        ),
        BlindCountMainAction.guess,
      );
    });
  });
}

extension on BlindCountAiInputs {
  BlindCountAiInputs copyWithManual({bool? hasGuessed}) {
    return BlindCountAiInputs(
      aiHand: aiHand,
      playerBlockCount: playerBlockCount,
      memoryPool: memoryPool,
      playerLastGuess: playerLastGuess,
      poolRemaining: poolRemaining,
      currentTurnComboScore: currentTurnComboScore,
      turnRemainingSeconds: turnRemainingSeconds,
      canStopGuessing: false,
      canGiveBlockThisTurn: !(hasGuessed ?? false),
      hasUsedSkillThisTurn: hasUsedSkillThisTurn,
      isGameOver: isGameOver,
      isSkillPeekActive: isSkillPeekActive,
      isResolvingGuess: isResolvingGuess,
      isP2Turn: isP2Turn,
      canUseSumSkill: canUseSumSkill,
      canUseRadarSkill: canUseRadarSkill,
      canUseBloatSkill: canUseBloatSkill,
    );
  }
}
