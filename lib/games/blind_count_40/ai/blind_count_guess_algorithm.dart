import 'dart:math';

import 'package:genius_project/games/blind_count_40/ai/blind_count_ai_inputs.dart';
import 'package:genius_project/games/blind_count_40/models/block_model.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai_config.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_memory.dart';

/// PvE guess selection for Blind Count 40 (§2 — what number to guess?).
///
/// Uses only [BlindCountAiInputs] + limited [BlindCountOpponentMemory]:
/// - `ai_hand`, `player_block_count`, `memory_pool`, `player_last_guess`
/// - older player/own guess buffers (no hidden player block values).
///
/// Returns an integer **1–10** by picking the **highest** deduction weight.
abstract final class BlindCountGuessAlgorithm {
  /// Builds per-number weights, then selects the maximum.
  static int pickNumber({
    required BlindCountAiInputs inputs,
    required BlindCountOpponentMemory memory,
    BlindCountOpponentAiConfig config = BlindCountOpponentAiConfig.standard,
    Random? random,
  }) {
    final rng = random ?? Random();
    final weights = buildWeights(
      inputs: inputs,
      memory: memory,
      config: config,
      random: rng,
    );
    return selectHighestWeight(weights, random: rng);
  }

  /// Highest final weight; ties broken uniformly at random.
  static int selectHighestWeight(
    Map<int, double> weights, {
    Random? random,
  }) {
    final rng = random ?? Random();
    final tied = <int>[];
    var bestWeight = double.negativeInfinity;

    for (var value = 1; value <= 10; value++) {
      final weight = weights[value] ?? 0.0;
      if (weight > bestWeight) {
        bestWeight = weight;
        tied
          ..clear()
          ..add(value);
      } else if (weight == bestWeight) {
        tied.add(value);
      }
    }

    if (tied.isEmpty) {
      return rng.nextInt(10) + 1;
    }
    return tied[rng.nextInt(tied.length)];
  }

  /// Deduction weights for each value 1–10 (testable).
  static Map<int, double> buildWeights({
    required BlindCountAiInputs inputs,
    required BlindCountOpponentMemory memory,
    BlindCountOpponentAiConfig config = BlindCountOpponentAiConfig.standard,
    Random? random,
  }) {
    final rng = random ?? Random();

    // Step 1 — base weight per value (4 copies each in the full shoe).
    final base = config.baseGuessWeight;
    final weights = <int, double>{for (var v = 1; v <= 10; v++) v: base};

    // Step 2 — `ai_hand`: −10 per block AI holds (player less likely to have it).
    _applySelfHandModifier(weights, inputs.aiHand, config);

    // Step 3 — `memory_pool`: −10 per remembered reveal/discard.
    _applyMemoryPoolModifier(weights, inputs.memoryPool, config);

    // Step 4 — `player_last_guess` + older wrong player guesses.
    _applyPlayerGuessSignals(weights, inputs, memory, config);

    // Step 4b — psychological: +5 on `player_last_guess` value.
    _applyPsychologicalModifier(weights, inputs, config);

    // Step 5 — own recent guesses (hits / misses on the human row).
    for (final guess in memory.recentOwnGuesses) {
      final factor = guess.wasCorrect
          ? config.ownCorrectGuessPenalty
          : config.ownWrongGuessPenalty;
      weights[guess.value] = weights[guess.value]! * factor;
    }

    final lastOwn = memory.recentOwnGuesses.isEmpty
        ? null
        : memory.recentOwnGuesses.last;
    if (lastOwn != null && !lastOwn.wasCorrect) {
      weights[lastOwn.value] =
          weights[lastOwn.value]! * config.repeatWrongGuessPenalty;
    }

    // Step 6 — `player_block_count` low: spread guesses (finish them off).
    if (inputs.playerBlockCount <= config.lowPlayerBlockCountThreshold) {
      for (var v = 1; v <= 10; v++) {
        weights[v] = weights[v]! * config.lowPlayerBlockWeightMultiplier;
      }
    }

    // Step 6b — endgame intel: if P1 hand sum is revealed, eliminate impossible values.
    _applyRevealedSumFeasibility(weights, inputs);

    // Step 6c — do not repeat "known wrong" values until P1 refills/gains a block.
    for (final banned in memory.bannedUntilPlayerRefill) {
      if (weights.containsKey(banned)) {
        weights[banned] = 0;
      }
    }

    // Step 7 — human noise (imperfect deduction).
    final minWeight = base * config.weightClampMinFactor;
    final maxWeight = base * config.weightClampMaxFactor;
    for (var v = 1; v <= 10; v++) {
      final jitter =
          1 - config.noiseSpread / 2 + rng.nextDouble() * config.noiseSpread;
      weights[v] = (weights[v]! * jitter).clamp(minWeight, maxWeight);
    }

    return weights;
  }

  static void _applyRevealedSumFeasibility(
    Map<int, double> weights,
    BlindCountAiInputs inputs,
  ) {
    final sum = inputs.playerHandSumRevealed;
    final count = inputs.playerBlockCount;
    if (sum == null) return;
    if (count <= 0) return;

    // For any candidate value v, the remaining sum must be achievable with (count-1) blocks in [1..10].
    // minRemaining = (count-1)*1, maxRemaining = (count-1)*10
    final minRemaining = (count - 1) * 1;
    final maxRemaining = (count - 1) * 10;
    for (var v = 1; v <= 10; v++) {
      final remaining = sum - v;
      if (remaining < minRemaining || remaining > maxRemaining) {
        weights[v] = 0;
      }
    }
  }

  static void _applySelfHandModifier(
    Map<int, double> weights,
    List<BlockModel> aiHand,
    BlindCountOpponentAiConfig config,
  ) {
    _subtractPerValueCount(
      weights,
      aiHand.map((b) => b.value),
      config.selfHandPenaltyPerBlock,
    );
  }

  static void _applyMemoryPoolModifier(
    Map<int, double> weights,
    List<BlindCountMemoryPoolBlock> memoryPool,
    BlindCountOpponentAiConfig config,
  ) {
    _subtractPerValueCount(
      weights,
      memoryPool.map((b) => b.value),
      config.memoryPoolPenaltyPerBlock,
    );
  }

  static void _subtractPerValueCount(
    Map<int, double> weights,
    Iterable<int> values,
    double penaltyPerInstance,
  ) {
    final counts = <int, int>{};
    for (final value in values) {
      counts[value] = (counts[value] ?? 0) + 1;
    }
    for (final entry in counts.entries) {
      weights[entry.key] =
          max(0, weights[entry.key]! - penaltyPerInstance * entry.value);
    }
  }

  static void _applyPsychologicalModifier(
    Map<int, double> weights,
    BlindCountAiInputs inputs,
    BlindCountOpponentAiConfig config,
  ) {
    final lastGuess = inputs.playerLastGuess;
    if (lastGuess == null) return;
    weights[lastGuess] =
        weights[lastGuess]! + config.playerLastGuessPsychologicalBoost;
  }

  static void _applyPlayerGuessSignals(
    Map<int, double> weights,
    BlindCountAiInputs inputs,
    BlindCountOpponentMemory memory,
    BlindCountOpponentAiConfig config,
  ) {
    final last = inputs.playerLastGuess;
    if (last != null) {
      final lastRecord = memory.recentPlayerGuesses.isEmpty
          ? null
          : memory.recentPlayerGuesses.last;
      if (lastRecord != null && !lastRecord.wasCorrect) {
        weights[last] = weights[last]! * config.playerWrongGuessSignal;
      }
      if (lastRecord != null && lastRecord.wasCorrect) {
        weights[last] = weights[last]! * config.playerLastGuessHitPenalty;
      }
    }

    for (final guess in memory.recentPlayerGuesses) {
      if (guess.value == last) continue;
      if (!guess.wasCorrect) {
        weights[guess.value] =
            weights[guess.value]! * config.playerWrongGuessSignal;
      }
    }
  }

  /// When inputs are unavailable (wrong phase), guess from memory only.
  static int fallback({
    required BlindCountOpponentMemory memory,
    Random? random,
  }) {
    final rng = random ?? Random();
    final fromPool = memory.memoryPool
        .where((b) => b.source == BlindCountDiscardSource.playerHand)
        .map((b) => b.value)
        .toList();
    if (fromPool.isNotEmpty && rng.nextBool()) {
      return fromPool[rng.nextInt(fromPool.length)];
    }
    return rng.nextInt(10) + 1;
  }
}
