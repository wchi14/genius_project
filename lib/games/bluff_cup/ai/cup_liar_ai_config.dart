/// Tunable weights for Blind Cup PvE AI (playtesting).
class CupLiarAiConfig {
  const CupLiarAiConfig({
    this.unknownDiceCount = 6,
    this.wildUnknownProbability = 2 / 6,
    this.pureUnknownProbability = 1 / 6,
    this.catchMargin = 0.85,
    this.pureAssassinChance = 0.55,
    this.phantomBidChance = 0.12,
    this.weakCatchChance = 0.06,
    this.maxQuantityStepOverCurrent = 1,
    this.maxBidAboveConfidence = 1.25,
    this.phantomMaxAboveConfidence = 0.75,
    this.earlyRoundSkepticRounds = 2,
    this.earlyRoundUnknownTrust = 0.48,
    this.midRoundUnknownTrust = 0.72,
    this.suspiciousBidCatchChance = 0.82,
    this.likelyBluffCatchChance = 0.55,
  });

  final int unknownDiceCount;
  final double wildUnknownProbability;
  final double pureUnknownProbability;

  /// Catch when bid quantity exceeds expected table total by more than this.
  final double catchMargin;

  final double pureAssassinChance;
  final double phantomBidChance;
  final double weakCatchChance;
  final int maxQuantityStepOverCurrent;
  final double maxBidAboveConfidence;
  final double phantomMaxAboveConfidence;

  /// Rounds 0..[earlyRoundSkepticRounds)-1: discount hidden-cup EV (player may bluff).
  final int earlyRoundSkepticRounds;

  /// Multiplier on expected player-cup contribution in early rounds.
  final double earlyRoundUnknownTrust;

  /// Round index 2 when [earlyRoundSkepticRounds] is 3.
  final double midRoundUnknownTrust;

  /// Catch roll when bid clearly exceeds table EV.
  final double suspiciousBidCatchChance;

  /// Catch roll when bid moderately exceeds EV.
  final double likelyBluffCatchChance;

  static const CupLiarAiConfig standard = CupLiarAiConfig();
}
