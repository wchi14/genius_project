/// Tunable knobs for Fatal Fold **PvE** opponent behavior.
///
/// Betting rows are `{ raiseOrCall | check | fold }` and must sum to `1.0`.
/// Call [assertValid] in tests / debug after editing weights.
class FatalFoldAiConfig {
  const FatalFoldAiConfig({
    required this.chipAdvantageMultiplier,
    required this.chipDisadvantageMultiplier,
    required this.memoryAggressionBiasStrength,
    required this.insuranceFoldBucketPassiveNudgeProbability,
    required this.bettingNormalAgainstGoodCard,
    required this.bettingNormalAgainstBadCard,
    required this.bettingAdvantageAgainstGoodCard,
    required this.bettingAdvantageAgainstBadCard,
    required this.bettingDisadvantageAgainstGoodCard,
    required this.bettingDisadvantageAgainstBadCard,
    required this.plusTwo,
    required this.doubleBlind,
    required this.penaltyInsurance,
    required this.rerollPassiveFacingBetCallShare,
  });

  /// Design-doc presets (see product spec).
  const FatalFoldAiConfig.standard()
      : chipAdvantageMultiplier = 1.3,
        chipDisadvantageMultiplier = 0.7,
        memoryAggressionBiasStrength = 0.22,
        insuranceFoldBucketPassiveNudgeProbability = 0.42,
        bettingNormalAgainstGoodCard =
            const FatalFoldAiBettingRow(raiseOrCall: 0.20, check: 0.60, fold: 0.20),
        bettingNormalAgainstBadCard =
            const FatalFoldAiBettingRow(raiseOrCall: 0.60, check: 0.20, fold: 0.20),
        bettingAdvantageAgainstGoodCard =
            const FatalFoldAiBettingRow(raiseOrCall: 0.30, check: 0.50, fold: 0.20),
        bettingAdvantageAgainstBadCard =
            const FatalFoldAiBettingRow(raiseOrCall: 0.80, check: 0.10, fold: 0.10),
        bettingDisadvantageAgainstGoodCard =
            const FatalFoldAiBettingRow(raiseOrCall: 0.10, check: 0.30, fold: 0.60),
        bettingDisadvantageAgainstBadCard =
            const FatalFoldAiBettingRow(raiseOrCall: 0.70, check: 0.20, fold: 0.10),
        plusTwo = const FatalFoldAiPlusTwoProbabilities(
          optimalChanceRank6Through9Inclusive: 0.40,
          bluffChanceRank1through5Rank10AndJoker: 0.10,
        ),
        doubleBlind = const FatalFoldAiDoubleBlindProbabilities(
          optimalChanceRank1Through4Inclusive: 0.50,
          bluffChanceRank5Through10AndJoker: 0.15,
        ),
        penaltyInsurance = const FatalFoldAiPenaltyInsuranceProbabilities(
          optimalChanceWhenBettingBucketIsFoldAtSkillSample: 0.60,
          bluffChanceWhenBettingBucketIsRaiseOrCallAtSkillSample: 0.10,
        ),
        rerollPassiveFacingBetCallShare = 0.72;

  final double chipAdvantageMultiplier;
  final double chipDisadvantageMultiplier;

  /// When holding **Penalty Insurance** and the betting matrix lands on fold, this
  /// probability softens to a passive stance (toward **call**/check semantics).
  final double insuranceFoldBucketPassiveNudgeProbability;

  /// Tilt from FIFO memory (see [MockBluffAi.memoryCards]): density of premium cards
  /// seen recently nudges aggression. Use `0` to disable memory → matrix coupling.
  final double memoryAggressionBiasStrength;

  final FatalFoldAiBettingRow bettingNormalAgainstGoodCard;
  final FatalFoldAiBettingRow bettingNormalAgainstBadCard;
  final FatalFoldAiBettingRow bettingAdvantageAgainstGoodCard;
  final FatalFoldAiBettingRow bettingAdvantageAgainstBadCard;
  final FatalFoldAiBettingRow bettingDisadvantageAgainstGoodCard;
  final FatalFoldAiBettingRow bettingDisadvantageAgainstBadCard;

  final FatalFoldAiPlusTwoProbabilities plusTwo;
  final FatalFoldAiDoubleBlindProbabilities doubleBlind;
  final FatalFoldAiPenaltyInsuranceProbabilities penaltyInsurance;

  /// Facing an existing wager, if the matrix produced “check”: share for **call**
  /// vs **attempt raise/call aggression** on the passive reroll.
  final double rerollPassiveFacingBetCallShare;

  void assertValid() {
    assert(chipAdvantageMultiplier > chipDisadvantageMultiplier);
    bettingNormalAgainstGoodCard.assertSumsApproxOne();
    bettingNormalAgainstBadCard.assertSumsApproxOne();
    bettingAdvantageAgainstGoodCard.assertSumsApproxOne();
    bettingAdvantageAgainstBadCard.assertSumsApproxOne();
    bettingDisadvantageAgainstGoodCard.assertSumsApproxOne();
    bettingDisadvantageAgainstBadCard.assertSumsApproxOne();
    plusTwo.assertProbabilitiesValid();
    doubleBlind.assertProbabilitiesValid();
    penaltyInsurance.assertProbabilitiesValid();
    assert(rerollPassiveFacingBetCallShare >= 0 && rerollPassiveFacingBetCallShare <= 1);
    assert(memoryAggressionBiasStrength >= 0 && memoryAggressionBiasStrength <= 1);
    assert(insuranceFoldBucketPassiveNudgeProbability >= 0 &&
        insuranceFoldBucketPassiveNudgeProbability <= 1);
  }
}

class FatalFoldAiBettingRow {
  const FatalFoldAiBettingRow({
    required this.raiseOrCall,
    required this.check,
    required this.fold,
  });

  final double raiseOrCall;
  final double check;
  final double fold;

  void assertSumsApproxOne() {
    final s = raiseOrCall + check + fold;
    assert((s - 1.0).abs() < 1e-6, 'Betting row must sum to 1.0, got $s');
  }
}

/// +2 Modifier — optimal vs bluff probabilities (single roll attempt per skill / round).
class FatalFoldAiPlusTwoProbabilities {
  const FatalFoldAiPlusTwoProbabilities({
    required this.optimalChanceRank6Through9Inclusive,
    required this.bluffChanceRank1through5Rank10AndJoker,
  });

  final double optimalChanceRank6Through9Inclusive;
  final double bluffChanceRank1through5Rank10AndJoker;

  void assertProbabilitiesValid() {
    assert(_in01(optimalChanceRank6Through9Inclusive));
    assert(_in01(bluffChanceRank1through5Rank10AndJoker));
  }
}

class FatalFoldAiDoubleBlindProbabilities {
  const FatalFoldAiDoubleBlindProbabilities({
    required this.optimalChanceRank1Through4Inclusive,
    required this.bluffChanceRank5Through10AndJoker,
  });

  final double optimalChanceRank1Through4Inclusive;
  final double bluffChanceRank5Through10AndJoker;

  void assertProbabilitiesValid() {
    assert(_in01(optimalChanceRank1Through4Inclusive));
    assert(_in01(bluffChanceRank5Through10AndJoker));
  }
}

/// Penalty insurance — tied to betting-matrix buckets sampled at **skill declaration** time.
class FatalFoldAiPenaltyInsuranceProbabilities {
  const FatalFoldAiPenaltyInsuranceProbabilities({
    required this.optimalChanceWhenBettingBucketIsFoldAtSkillSample,
    required this.bluffChanceWhenBettingBucketIsRaiseOrCallAtSkillSample,
  });

  final double optimalChanceWhenBettingBucketIsFoldAtSkillSample;
  final double bluffChanceWhenBettingBucketIsRaiseOrCallAtSkillSample;

  void assertProbabilitiesValid() {
    assert(_in01(optimalChanceWhenBettingBucketIsFoldAtSkillSample));
    assert(_in01(bluffChanceWhenBettingBucketIsRaiseOrCallAtSkillSample));
  }
}

bool _in01(double x) => x >= 0 && x <= 1;
