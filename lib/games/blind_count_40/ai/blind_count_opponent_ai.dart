import 'dart:math';

import 'package:genius_project/games/blind_count_40/ai/blind_count_ai_inputs.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_action_matrix.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_guess_algorithm.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_skill_trigger.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai_config.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_memory.dart';
import 'package:genius_project/games/blind_count_40/logic/blind_count_state.dart';

/// Opponent turn action (PvE — no hidden cheat reads).
sealed class BlindCountOpponentAction {
  const BlindCountOpponentAction();
}

final class BlindCountAiUseSkill extends BlindCountOpponentAction {
  const BlindCountAiUseSkill(this.skillId);

  final String skillId;
}

final class BlindCountAiStopGuessing extends BlindCountOpponentAction {
  const BlindCountAiStopGuessing();
}

final class BlindCountAiGiveBlock extends BlindCountOpponentAction {
  const BlindCountAiGiveBlock();
}

final class BlindCountAiGuess extends BlindCountOpponentAction {
  const BlindCountAiGuess(this.value);

  final int value;
}

/// PvE opponent: limited [memory], weighted §2 guesses, §3 actions, §4 skills.
///
/// Tune behaviour via [BlindCountOpponentAiConfig] (pool size, thresholds, weights).
class BlindCountOpponentAi {
  BlindCountOpponentAi({
    BlindCountOpponentAiConfig? config,
    BlindCountOpponentMemory? memory,
    Random? random,
  })  : config = config ?? BlindCountOpponentAiConfig.standard,
        memory = memory ??
            (config ?? BlindCountOpponentAiConfig.standard).createMemory(),
        _random = random ?? Random();

  final BlindCountOpponentAiConfig config;
  final BlindCountOpponentMemory memory;
  final Random _random;

  int get maxOpponentBlocks => config.maxPlayerBlockCount;

  BlindCountOpponentAction decideFromState(
    BlindCountState state, {
    Random? random,
  }) =>
      decide(
        BlindCountAiInputs.fromTable(state: state, memory: memory),
        random: random,
      );

  BlindCountOpponentAction decide(
    BlindCountAiInputs inputs, {
    Random? random,
  }) {
    final rng = random ?? _random;
    if (!inputs.isP2Turn ||
        inputs.isGameOver ||
        inputs.isSkillPeekActive ||
        inputs.isResolvingGuess) {
      return BlindCountAiGuess(
        BlindCountGuessAlgorithm.fallback(memory: memory, random: rng),
      );
    }

    if (inputs.canGiveBlockThisTurn) {
      return _decideAtTurnStart(inputs, rng);
    }
    return _decideDuringCombo(inputs, rng);
  }

  int pickGuess(BlindCountAiInputs inputs, {Random? random}) =>
      BlindCountGuessAlgorithm.pickNumber(
        inputs: inputs,
        memory: memory,
        config: config,
        random: random ?? _random,
      );

  int pickGuessFromState(BlindCountState state, {Random? random}) =>
      pickGuess(
        BlindCountAiInputs.fromTable(state: state, memory: memory),
        random: random,
      );

  BlindCountOpponentAction _decideAtTurnStart(
    BlindCountAiInputs inputs,
    Random rng,
  ) {
    final guessWeights = BlindCountGuessAlgorithm.buildWeights(
      inputs: inputs,
      memory: memory,
      config: config,
      random: rng,
    );

    final forcedGuess = BlindCountActionMatrix.mustGuessHardCap(inputs, config) ||
        BlindCountActionMatrix.hasHighConfidenceGuess(guessWeights, config);

    final plan = forcedGuess
        ? const BlindCountTurnStartPlan(
            planningToGuess: true,
            mainAction: BlindCountTurnStartAction.guess,
          )
        : BlindCountActionMatrix.planTurnStartMain(
            inputs: inputs,
            guessWeights: guessWeights,
            config: config,
            random: rng,
          );

    final skillId = forcedGuess
        ? null
        : BlindCountSkillTrigger.tryPickSkill(
            inputs: inputs,
            planningToGuess: plan.planningToGuess,
            config: config,
            random: rng,
          );
    if (skillId != null) {
      return BlindCountAiUseSkill(skillId);
    }

    if (plan.mainAction == BlindCountTurnStartAction.bloat) {
      return const BlindCountAiGiveBlock();
    }
    return BlindCountAiGuess(
      BlindCountGuessAlgorithm.selectHighestWeight(
        guessWeights,
        random: rng,
      ),
    );
  }

  BlindCountOpponentAction _decideDuringCombo(
    BlindCountAiInputs inputs,
    Random rng,
  ) {
    if (inputs.canStopGuessing && _shouldStopCombo(inputs, rng)) {
      return const BlindCountAiStopGuessing();
    }

    return BlindCountAiGuess(
      BlindCountGuessAlgorithm.pickNumber(
        inputs: inputs,
        memory: memory,
        config: config,
        random: rng,
      ),
    );
  }

  bool _shouldStopCombo(BlindCountAiInputs inputs, Random rng) {
    final combo = inputs.currentTurnComboScore;
    var chance = switch (combo) {
      >= 7 => config.stopComboChanceAt7,
      >= 5 => config.stopComboChanceAt5,
      >= 3 => config.stopComboChanceAt3,
      >= 2 => config.stopComboChanceAt2,
      _ => config.stopComboChanceDefault,
    };
    if (inputs.playerBlockCount <= config.lowBlockCountStopThreshold) {
      chance += config.lowBlockCountStopBias;
    }
    if (inputs.turnRemainingSeconds <= config.lowTimerStopThresholdSeconds) {
      chance += config.lowTimerStopBonus;
    }
    return rng.nextDouble() < chance.clamp(0.0, config.stopComboMaxChance);
  }
}
