import 'dart:math';

import 'package:genius_project/games/blind_count_40/ai/blind_count_ai_inputs.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai_config.dart';

/// Main action before the first guess of a turn (add block vs. guess number).
enum BlindCountMainAction {
  /// `guessNumber` using [BlindCountGuessAlgorithm] weights.
  guess,

  /// `giveBlockToOpponent` (add one block from pool to the human).
  bloat,
}

/// Actions legal only at the **start** of P2's turn (before any guess).
enum BlindCountTurnStartAction {
  /// One unused skill (Sum / Duplicate / Add Block) — at most once per turn.
  useSkill,

  /// `guessNumber` via §2 weights.
  guess,

  /// `giveBlockToOpponent` (§3 Rule 3 tactical bloat roll).
  bloat,
}

/// §3 — Turn-start and guess-vs-bloat decision matrix.
abstract final class BlindCountActionMatrix {
  /// §3 Rule 1 — human at the block cap cannot receive another block.
  static bool mustGuessHardCap(
    BlindCountAiInputs inputs,
    BlindCountOpponentAiConfig config,
  ) =>
      inputs.playerBlockCount >= config.maxPlayerBlockCount;

  /// §3 Rule 2 — highest §2 weight at or above threshold → guess (high confidence).
  static bool hasHighConfidenceGuess(
    Map<int, double> guessWeights,
    BlindCountOpponentAiConfig config,
  ) =>
      highestGuessWeight(guessWeights) >= config.highConfidenceGuessThreshold;

  static double highestGuessWeight(Map<int, double> guessWeights) =>
      _topTwoWeights(guessWeights).$1;

  /// §3 Rule 3 — low confidence and room to add blocks (not Rules 1–2).
  static bool isTacticalBloatZone(
    BlindCountAiInputs inputs,
    Map<int, double> guessWeights,
    BlindCountOpponentAiConfig config,
  ) =>
      !mustGuessHardCap(inputs, config) &&
      !hasHighConfidenceGuess(guessWeights, config);

  /// Planned turn-start main action (single Rule 3 roll shared with skills).
  static BlindCountTurnStartPlan planTurnStartMain({
    required BlindCountAiInputs inputs,
    required Map<int, double> guessWeights,
    BlindCountOpponentAiConfig config = BlindCountOpponentAiConfig.standard,
    Random? random,
  }) {
    if (mustGuessHardCap(inputs, config) ||
        hasHighConfidenceGuess(guessWeights, config)) {
      return const BlindCountTurnStartPlan(
        planningToGuess: true,
        mainAction: BlindCountTurnStartAction.guess,
      );
    }

    final main = decideGuessVsBloat(
      inputs: inputs,
      guessWeights: guessWeights,
      config: config,
      random: random,
    );
    return BlindCountTurnStartPlan(
      planningToGuess: main == BlindCountMainAction.guess,
      mainAction: main == BlindCountMainAction.bloat
          ? BlindCountTurnStartAction.bloat
          : BlindCountTurnStartAction.guess,
    );
  }

  /// Turn-start main action after §3 Rules 1–2 (guess vs. bloat only).
  ///
  /// §4 skills are handled in [BlindCountSkillTrigger] before this runs.
  static BlindCountTurnStartAction decideTurnStartMain({
    required BlindCountAiInputs inputs,
    required Map<int, double> guessWeights,
    BlindCountOpponentAiConfig config = BlindCountOpponentAiConfig.standard,
    Random? random,
  }) {
    return planTurnStartMain(
      inputs: inputs,
      guessWeights: guessWeights,
      config: config,
      random: random,
    ).mainAction;
  }

  @Deprecated('Use decideTurnStartMain; skills via BlindCountSkillTrigger')
  static BlindCountTurnStartAction decideTurnStart({
    required BlindCountAiInputs inputs,
    required Map<int, double> guessWeights,
    required bool hasSkillCandidate,
    BlindCountOpponentAiConfig config = BlindCountOpponentAiConfig.standard,
    Random? random,
  }) =>
      decideTurnStartMain(
        inputs: inputs,
        guessWeights: guessWeights,
        config: config,
        random: random,
      );

  /// Chooses guess or bloat when the AI may still add a block before guessing.
  static BlindCountMainAction decideGuessVsBloat({
    required BlindCountAiInputs inputs,
    required Map<int, double> guessWeights,
    BlindCountOpponentAiConfig config = BlindCountOpponentAiConfig.standard,
    Random? random,
  }) {
    if (!inputs.canGiveBlockThisTurn) {
      return BlindCountMainAction.guess;
    }
    if (inputs.poolRemaining <= 0) {
      return BlindCountMainAction.guess;
    }
    // §3 Rule 1
    if (mustGuessHardCap(inputs, config)) {
      return BlindCountMainAction.guess;
    }
    // §3 Rule 2
    if (hasHighConfidenceGuess(guessWeights, config)) {
      return BlindCountMainAction.guess;
    }

    // §3 Rule 3 — tactical bloat / guess roll in low-confidence zone.
    if (isTacticalBloatZone(inputs, guessWeights, config)) {
      final rng = random ?? Random();
      return rng.nextDouble() < config.tacticalBloatChance
          ? BlindCountMainAction.bloat
          : BlindCountMainAction.guess;
    }

    return BlindCountMainAction.guess;
  }

  static (double top, double second) _topTwoWeights(Map<int, double> weights) {
    var top = 0.0;
    var second = 0.0;
    for (var v = 1; v <= 10; v++) {
      final w = weights[v] ?? 0.0;
      if (w >= top) {
        second = top;
        top = w;
      } else if (w > second) {
        second = w;
      }
    }
    return (top, second);
  }
}

/// Turn-start resolution used by §3 main action and §4 Duplicate Radar.
class BlindCountTurnStartPlan {
  const BlindCountTurnStartPlan({
    required this.planningToGuess,
    required this.mainAction,
  });

  /// Whether the AI will [BlindCountTurnStartAction.guess] (not bloat-only).
  final bool planningToGuess;

  final BlindCountTurnStartAction mainAction;
}
