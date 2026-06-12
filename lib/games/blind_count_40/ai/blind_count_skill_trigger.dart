import 'dart:math';

import 'package:genius_project/games/blind_count_40/ai/blind_count_ai_inputs.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai_config.dart';
import 'package:genius_project/games/blind_count_40/logic/blind_count_state.dart';
import 'package:genius_project/games/blind_count_40/models/block_model.dart';

/// §4 — When P2 may fire a once-per-match skill at turn start.
abstract final class BlindCountSkillTrigger {
  /// Skills only before the first guess; each id spent at most once per match.
  static bool canConsiderSkills(BlindCountAiInputs inputs) =>
      inputs.isP2Turn &&
      !inputs.isGameOver &&
      !inputs.isSkillPeekActive &&
      !inputs.isResolvingGuess &&
      inputs.canGiveBlockThisTurn &&
      !inputs.hasUsedSkillThisTurn;

  /// Unused skills that pass their trigger gates (match + situational).
  static List<String> eligibleSkillIds(
    BlindCountAiInputs inputs, {
    required bool planningToGuess,
    BlindCountOpponentAiConfig config = BlindCountOpponentAiConfig.standard,
  }) {
    if (!canConsiderSkills(inputs)) return const [];
    return [
      if (canTriggerSum(inputs, config)) BlindCountSkillId.sum,
      if (canTriggerRadar(inputs, config: config, planningToGuess: planningToGuess))
        BlindCountSkillId.radar,
      if (canTriggerBloatSkill(inputs, config)) BlindCountSkillId.bloat,
    ];
  }

  static bool hasCandidate(
    BlindCountAiInputs inputs, {
    required bool planningToGuess,
    BlindCountOpponentAiConfig config = BlindCountOpponentAiConfig.standard,
  }) =>
      eligibleSkillIds(
        inputs,
        planningToGuess: planningToGuess,
        config: config,
      ).isNotEmpty;

  /// Sum Reveal — late-deck precision strike on a small human row.
  static bool canTriggerSum(
    BlindCountAiInputs inputs,
    BlindCountOpponentAiConfig config,
  ) =>
      inputs.canUseSumSkill &&
      inputs.playerBlockCount <= config.sumRevealMaxPlayerBlocks &&
      inputs.poolRemaining < config.sumRevealDeckLessThan;

  /// Duplicate Radar — before a planned guess with a sizable human row.
  static bool canTriggerRadar(
    BlindCountAiInputs inputs, {
    required BlindCountOpponentAiConfig config,
    required bool planningToGuess,
  }) =>
      inputs.canUseRadarSkill &&
      inputs.playerBlockCount >= config.radarMinPlayerBlocks &&
      planningToGuess;

  /// Force Bloat (Add Block skill) — pushes human toward the block cap.
  static bool canTriggerBloatSkill(
    BlindCountAiInputs inputs,
    BlindCountOpponentAiConfig config,
  ) =>
      inputs.canUseBloatSkill &&
      inputs.playerBlockCount == config.forceBloatPlayerBlocks &&
      inputs.poolRemaining > 0;

  /// Roll [skillAttemptChance], then pick among [eligibleSkillIds].
  static String? tryPickSkill({
    required BlindCountAiInputs inputs,
    required bool planningToGuess,
    BlindCountOpponentAiConfig config = BlindCountOpponentAiConfig.standard,
    Random? random,
  }) {
    if (!hasCandidate(inputs, planningToGuess: planningToGuess, config: config)) {
      return null;
    }
    final rng = random ?? Random();
    if (rng.nextDouble() >= config.skillAttemptChance) return null;
    return pickSkill(
      inputs: inputs,
      planningToGuess: planningToGuess,
      config: config,
      random: rng,
    );
  }

  /// Weighted choice among eligible skills (caller ensures non-empty).
  static String pickSkill({
    required BlindCountAiInputs inputs,
    required bool planningToGuess,
    BlindCountOpponentAiConfig config = BlindCountOpponentAiConfig.standard,
    Random? random,
  }) {
    final candidates = eligibleSkillIds(
      inputs,
      planningToGuess: planningToGuess,
      config: config,
    );
    if (candidates.isEmpty) {
      throw StateError('pickSkill called with no eligible skills');
    }
    if (candidates.length == 1) return candidates.first;

    final rng = random ?? Random();
    final scored = <String, double>{};
    for (final id in candidates) {
      scored[id] = _scoreSkill(id, inputs, config);
    }
    return _weightedPick(scored, rng);
  }

  static double _scoreSkill(
    String skillId,
    BlindCountAiInputs inputs,
    BlindCountOpponentAiConfig config,
  ) =>
      switch (skillId) {
        BlindCountSkillId.sum
            when inputs.poolRemaining <= config.sumRevealMaxPoolRemaining ~/ 2 =>
          config.sumSkillWeightHigh,
        BlindCountSkillId.sum => config.sumSkillWeight,
        BlindCountSkillId.radar when _handHasDuplicate(inputs.aiHand) =>
          config.radarSkillWeightWithOwnDupes,
        BlindCountSkillId.radar => config.radarSkillWeight,
        BlindCountSkillId.bloat
            when inputs.playerBlockCount == config.forceBloatPlayerBlocks =>
          config.forceBloatSkillWeight,
        BlindCountSkillId.bloat => config.bloatSkillWeight,
        _ => 1.0,
      };

  static String _weightedPick(Map<String, double> weights, Random rng) {
    final total = weights.values.fold<double>(0, (a, b) => a + b);
    var roll = rng.nextDouble() * total;
    for (final entry in weights.entries) {
      roll -= entry.value;
      if (roll <= 0) return entry.key;
    }
    return weights.keys.first;
  }

  static bool _handHasDuplicate(List<BlockModel> hand) {
    final seen = <int>{};
    for (final block in hand) {
      if (!seen.add(block.value)) return true;
    }
    return false;
  }
}
