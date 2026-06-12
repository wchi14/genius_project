import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_memory.dart';

/// Tunable PvE parameters for [BlindCountOpponentAi] (memory, §2–§4, combo stop).
class BlindCountOpponentAiConfig {
  const BlindCountOpponentAiConfig({
    // §1 — limited memory
    this.memoryPoolSize = 10,
    this.maxPlayerGuessMemory = 8,
    this.maxOwnGuessMemory = 6,
    // §2 — guessing weights
    this.baseGuessWeight = 40,
    this.selfHandPenaltyPerBlock = 10,
    this.memoryPoolPenaltyPerBlock = 10,
    this.playerWrongGuessSignal = 1.08,
    this.playerLastGuessHitPenalty = 0.95,
    this.ownCorrectGuessPenalty = 0.38,
    this.ownWrongGuessPenalty = 0.62,
    this.repeatWrongGuessPenalty = 0.45,
    this.playerLastGuessPsychologicalBoost = 5,
    this.lowPlayerBlockCountThreshold = 2,
    this.lowPlayerBlockWeightMultiplier = 1.05,
    this.noiseSpread = 0.28,
    this.weightClampMinFactor = 0.05,
    this.weightClampMaxFactor = 24,
    // §3 — guess vs. bloat
    this.maxPlayerBlockCount = 8,
    this.highConfidenceGuessThreshold = 30,
    this.tacticalBloatChance = 0.70,
    // §4 — skills (once per match)
    this.skillAttemptChance = 0.42,
    this.sumRevealMaxPlayerBlocks = 4,
    this.sumRevealDeckLessThan = 15,
    this.radarMinPlayerBlocks = 5,
    this.forceBloatPlayerBlocks = 7,
    this.sumSkillWeight = 1.2,
    this.sumSkillWeightHigh = 2.4,
    this.radarSkillWeight = 1.0,
    this.radarSkillWeightWithOwnDupes = 1.8,
    this.bloatSkillWeight = 0.9,
    this.forceBloatSkillWeight = 3.0,
    // Combo — stop guessing
    this.stopComboChanceAt7 = 0.82,
    this.stopComboChanceAt5 = 0.62,
    this.stopComboChanceAt3 = 0.48,
    this.stopComboChanceAt2 = 0.32,
    this.stopComboChanceDefault = 0.12,
    this.lowBlockCountStopBias = 0.18,
    this.lowBlockCountStopThreshold = 2,
    this.lowTimerStopThresholdSeconds = 5,
    this.lowTimerStopBonus = 0.15,
    this.stopComboMaxChance = 0.92,
  });

  // §1 — limited memory (FIFO)
  final int memoryPoolSize;
  final int maxPlayerGuessMemory;
  final int maxOwnGuessMemory;

  // §2 — guessing algorithm
  final double baseGuessWeight;
  final double selfHandPenaltyPerBlock;
  final double memoryPoolPenaltyPerBlock;
  final double playerWrongGuessSignal;
  final double playerLastGuessHitPenalty;
  final double ownCorrectGuessPenalty;
  final double ownWrongGuessPenalty;
  final double repeatWrongGuessPenalty;
  final double playerLastGuessPsychologicalBoost;
  final int lowPlayerBlockCountThreshold;
  final double lowPlayerBlockWeightMultiplier;
  final double noiseSpread;
  final double weightClampMinFactor;
  final double weightClampMaxFactor;

  // §3 — action matrix
  final int maxPlayerBlockCount;
  final double highConfidenceGuessThreshold;
  final double tacticalBloatChance;

  // §4 — skill triggers & pick weights
  final double skillAttemptChance;
  final int sumRevealMaxPlayerBlocks;
  /// Sum Reveal when `poolRemaining < sumRevealDeckLessThan` (default: under 15).
  final int sumRevealDeckLessThan;
  final int radarMinPlayerBlocks;
  final int forceBloatPlayerBlocks;
  final double sumSkillWeight;
  final double sumSkillWeightHigh;
  final double radarSkillWeight;
  final double radarSkillWeightWithOwnDupes;
  final double bloatSkillWeight;
  final double forceBloatSkillWeight;

  // Combo stop
  final double stopComboChanceAt7;
  final double stopComboChanceAt5;
  final double stopComboChanceAt3;
  final double stopComboChanceAt2;
  final double stopComboChanceDefault;
  final double lowBlockCountStopBias;
  final int lowBlockCountStopThreshold;
  final int lowTimerStopThresholdSeconds;
  final double lowTimerStopBonus;
  final double stopComboMaxChance;

  /// Max pool count that still allows Sum Reveal (`pool < sumRevealDeckLessThan`).
  int get sumRevealMaxPoolRemaining => sumRevealDeckLessThan - 1;

  /// Builds [BlindCountOpponentMemory] using §1 size limits from this config.
  BlindCountOpponentMemory createMemory() => BlindCountOpponentMemory.fromConfig(this);

  static const standard = BlindCountOpponentAiConfig();
}
