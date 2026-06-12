import 'dart:math';

import 'fatal_fold_ai_config.dart';
import 'fatal_fold_ai_raise_sizing.dart';
import '../logic/blind_bluff_betting.dart';
import '../logic/blind_bluff_match_engine.dart' show blindBluffStartingStack;
import '../logic/blind_bluff_skills.dart';
import '../models/blind_card.dart';

/// Design-doc alias → engine skill enum.
typedef SkillType = BlindBluffSkill;

/// Design-doc alias → engine betting command type (check/call/raise/fold).
typedef BettingAction = BlindBluffBettingAction;

enum _AiChipMomentum {
  advantage,
  normal,
  disadvantage,
}

enum _MatrixBucket { raiseOrCallAggressive, passiveCheck, foldAway }

/// Probabilistic **PvE** rival: chip momentum, limited FIFO memory, configurable
/// matrices from [FatalFoldAiConfig].
///
/// Only [visiblePlayerCard] ([humanCard] in betting) models perfect information;
/// AI never peeks at its hole during wagering.
class MockBluffAi {
  MockBluffAi({
    Random? random,
    FatalFoldAiConfig? config,
  })  : _rng = random ?? Random(),
        _config = config ?? const FatalFoldAiConfig.standard() {
    assert(() {
      _config.assertValid();
      return true;
    }());
  }

  final Random _rng;
  final FatalFoldAiConfig _config;

  /// When the visible opponent card is joker or 10, chance of a 1–2 BB bluff raise.
  static const double premiumVisibleBluffRaiseProbability = 0.10;

  /// Last five rounds’ hole cards (FIFO, max 10 entries). Only stored cards —
  /// deck composition is **not** inferred precisely.
  final List<BlindCard> _memoryPool = <BlindCard>[];

  /// Read-only view for debugging / future telemetry.
  List<BlindCard> get memoryCards => List<BlindCard>.unmodifiable(_memoryPool);

  /// Call when a round’s terminal resolution is known (human + AI holes).
  void recordRoundCards({
    required BlindCard humanHole,
    required BlindCard aiHole,
  }) {
    _memoryPool.add(humanHole);
    _memoryPool.add(aiHole);
    while (_memoryPool.length > 10) {
      _memoryPool.removeAt(0);
    }
  }

  bool _isGoodCard(BlindCard card) {
    if (card.isJoker) {
      return true;
    }
    return card.rank >= 7 && card.rank <= 10;
  }

  bool _visiblePlayerCardIsOptimalForPlusTwo(BlindCard c) {
    return !c.isJoker && c.rank >= 6 && c.rank <= 9;
  }

  bool _visiblePlayerCardIsBluffRangeForPlusTwo(BlindCard c) {
    return c.isJoker ||
        (!c.isJoker && (c.rank <= 5 || c.rank == 10));
  }

  bool _visiblePlayerCardIsOptimalForDoubleBlind(BlindCard c) {
    return !c.isJoker && c.rank >= 1 && c.rank <= 4;
  }

  bool _visiblePlayerCardIsBluffRangeForDoubleBlind(BlindCard c) {
    return c.isJoker || (!c.isJoker && c.rank >= 5 && c.rank <= 10);
  }

  _AiChipMomentum _chipMomentum(int aiChips, int playerChips) {
    final adv = (_config.chipAdvantageMultiplier * playerChips).round();
    final dis = (_config.chipDisadvantageMultiplier * playerChips).round();
    if (aiChips >= adv) {
      return _AiChipMomentum.advantage;
    }
    if (aiChips <= dis) {
      return _AiChipMomentum.disadvantage;
    }
    return _AiChipMomentum.normal;
  }

  FatalFoldAiBettingRow _bettingRow(_AiChipMomentum momentum, bool seesGood) {
    return switch (momentum) {
      _AiChipMomentum.normal => seesGood
          ? _config.bettingNormalAgainstGoodCard
          : _config.bettingNormalAgainstBadCard,
      _AiChipMomentum.advantage => seesGood
          ? _config.bettingAdvantageAgainstGoodCard
          : _config.bettingAdvantageAgainstBadCard,
      _AiChipMomentum.disadvantage => seesGood
          ? _config.bettingDisadvantageAgainstGoodCard
          : _config.bettingDisadvantageAgainstBadCard,
    };
  }

  /// Slight aggression tilt from recent strong cards seen in memory (spec: limited recall).
  FatalFoldAiBettingRow _memoryTiltRow(FatalFoldAiBettingRow row, bool seesGood) {
    if (_memoryPool.isEmpty || _config.memoryAggressionBiasStrength <= 0) {
      return row;
    }
    final goodSeen = _memoryPool.where(_isGoodCard).length;
    final density = goodSeen / _memoryPool.length;
    final skew = (density - 0.5) * 2.0 * _config.memoryAggressionBiasStrength;
    final sign = seesGood ? -1.0 : 1.0;
    var rc = row.raiseOrCall * exp(sign * skew * 0.35);
    var ch = row.check;
    var fo = row.fold * exp(-sign * skew * 0.22);
    final sum = rc + ch + fo;
    rc /= sum;
    ch /= sum;
    fo /= sum;
    return FatalFoldAiBettingRow(raiseOrCall: rc, check: ch, fold: fo);
  }

  _MatrixBucket _sampleBucket(FatalFoldAiBettingRow row) {
    final u = _rng.nextDouble();
    if (u < row.raiseOrCall) {
      return _MatrixBucket.raiseOrCallAggressive;
    }
    if (u < row.raiseOrCall + row.check) {
      return _MatrixBucket.passiveCheck;
    }
    return _MatrixBucket.foldAway;
  }

  /// Samples the same matrix used in betting, at `chipsToCall == 0`, to tag
  /// **insurance** buckets before skills lock in.
  _MatrixBucket _sampleOpeningBucket({
    required BlindCard visiblePlayerCard,
    required int aiChips,
    required int playerChips,
  }) {
    final seesGood = _isGoodCard(visiblePlayerCard);
    final mom = _chipMomentum(aiChips, playerChips);
    final row = _memoryTiltRow(_bettingRow(mom, seesGood), seesGood);
    return _sampleBucket(row);
  }

  Future<SkillType?> decideSkill(
    BlindCard visiblePlayerCard, {
    required Set<SkillType> availableSkills,
    required int myChips,
    required int roundBaseAnte,
    required int playerChips,
  }) async {
    if (availableSkills.isEmpty) {
      return null;
    }

    final openingBucket = _sampleOpeningBucket(
      visiblePlayerCard: visiblePlayerCard,
      aiChips: myChips,
      playerChips: playerChips,
    );

    final picks = <SkillType>[];

    if (availableSkills.contains(SkillType.plusTwoModifier)) {
      final p = _visiblePlayerCardIsOptimalForPlusTwo(visiblePlayerCard)
          ? _config.plusTwo.optimalChanceRank6Through9Inclusive
          : (_visiblePlayerCardIsBluffRangeForPlusTwo(visiblePlayerCard)
              ? _config.plusTwo.bluffChanceRank1through5Rank10AndJoker
              : 0.0);
      if (_rng.nextDouble() < p) {
        picks.add(SkillType.plusTwoModifier);
      }
    }

    final canDoubleBlind = myChips >= roundBaseAnte;
    if (canDoubleBlind && availableSkills.contains(SkillType.doubleBlind)) {
      final p = _visiblePlayerCardIsOptimalForDoubleBlind(visiblePlayerCard)
          ? _config.doubleBlind.optimalChanceRank1Through4Inclusive
          : (_visiblePlayerCardIsBluffRangeForDoubleBlind(visiblePlayerCard)
              ? _config.doubleBlind.bluffChanceRank5Through10AndJoker
              : 0.0);
      if (_rng.nextDouble() < p) {
        picks.add(SkillType.doubleBlind);
      }
    }

    if (availableSkills.contains(SkillType.penaltyInsurance)) {
      final optimalFold = openingBucket == _MatrixBucket.foldAway;
      final bluffAggressive = openingBucket == _MatrixBucket.raiseOrCallAggressive;
      final double pIns;
      if (optimalFold) {
        pIns = _config
            .penaltyInsurance.optimalChanceWhenBettingBucketIsFoldAtSkillSample;
      } else if (bluffAggressive) {
        pIns = _config.penaltyInsurance
            .bluffChanceWhenBettingBucketIsRaiseOrCallAtSkillSample;
      } else {
        pIns = 0.0;
      }
      if (pIns > 0 && _rng.nextDouble() < pIns) {
        picks.add(SkillType.penaltyInsurance);
      }
    }

    if (picks.isEmpty) {
      return null;
    }
    return picks[_rng.nextInt(picks.length)];
  }

  Future<BettingAction> decideAction({
    required BlindCard humanCard,
    required int currentCallAmount,
    required int myChips,
    required int minRaise,
    required bool hasPenaltyInsuranceThisRound,
    required int playerChips,
  }) async {
    final chipsToCall = currentCallAmount;
    if (chipsToCall > myChips) {
      return const BettingAction.fold();
    }

    final bluffRaise = tryPremiumVisibleBluffRaise(
      visibleOpponentCard: humanCard,
      chipsToCall: chipsToCall,
      myChips: myChips,
      opponentChips: playerChips,
      minRaise: minRaise,
      probability: premiumVisibleBluffRaiseProbability,
      rng: _rng,
    );
    if (bluffRaise != null) {
      return bluffRaise;
    }

    final seesGood = _isGoodCard(humanCard);
    final mom = _chipMomentum(myChips, playerChips);
    final row = _memoryTiltRow(_bettingRow(mom, seesGood), seesGood);
    var bucket = _sampleBucket(row);

    bucket = _adjustBucketForInsuranceIfNeeded(
      bucket: bucket,
      hasInsurance: hasPenaltyInsuranceThisRound,
    );

    return _bucketToAction(
      bucket: bucket,
      chipsToCall: chipsToCall,
      myChips: myChips,
      opponentChips: playerChips,
      minRaise: minRaise,
      humanCard: humanCard,
      row: row,
    );
  }

  /// With insurance, Fatal Fold risk is damped — small **extra** fold hesitation
  /// on premium player cards (psychology, not omniscience).
  _MatrixBucket _adjustBucketForInsuranceIfNeeded({
    required _MatrixBucket bucket,
    required bool hasInsurance,
  }) {
    if (!hasInsurance) {
      return bucket;
    }
    if (bucket != _MatrixBucket.foldAway) {
      return bucket;
    }
    if (_rng.nextDouble() <
        _config.insuranceFoldBucketPassiveNudgeProbability) {
      return _MatrixBucket.passiveCheck;
    }
    return bucket;
  }

  BettingAction _bucketToAction({
    required _MatrixBucket bucket,
    required int chipsToCall,
    required int myChips,
    required int opponentChips,
    required int minRaise,
    required BlindCard humanCard,
    required FatalFoldAiBettingRow row,
  }) {
    var b = bucket;

    if (chipsToCall > 0 && b == _MatrixBucket.passiveCheck) {
      return _passiveFacingBet(
        chipsToCall: chipsToCall,
        myChips: myChips,
        opponentChips: opponentChips,
        minRaise: minRaise,
        row: row,
      );
    }

    if (chipsToCall == 0 && b == _MatrixBucket.foldAway) {
      b = _MatrixBucket.passiveCheck;
    }

    if (b == _MatrixBucket.raiseOrCallAggressive) {
      return _pickRaiseOrFallbackCall(
        chipsToCall: chipsToCall,
        myChips: myChips,
        opponentChips: opponentChips,
        minRaise: minRaise,
        aggressionBias: _aggressionBias(humanCard, myChips),
      );
    }

    if (b == _MatrixBucket.passiveCheck) {
      return chipsToCall == 0
          ? const BettingAction.check()
          : _passiveFacingBet(
              chipsToCall: chipsToCall,
              myChips: myChips,
              opponentChips: opponentChips,
              minRaise: minRaise,
              row: row,
            );
    }

    return chipsToCall == 0
        ? const BettingAction.check()
        : const BettingAction.fold();
  }

  BettingAction _passiveFacingBet({
    required int chipsToCall,
    required int myChips,
    required int opponentChips,
    required int minRaise,
    required FatalFoldAiBettingRow row,
  }) {
    final rc = row.raiseOrCall;
    final ck = row.check;
    final mass = rc + ck;
    double pCallFromMix;
    if (mass <= 1e-9) {
      pCallFromMix = _config.rerollPassiveFacingBetCallShare;
    } else {
      final passiveShare = ck / mass;
      pCallFromMix =
          passiveShare + (1.0 - passiveShare) * _config.rerollPassiveFacingBetCallShare;
    }

    if (_rng.nextDouble() < pCallFromMix.clamp(0.0, 1.0)) {
      return const BettingAction.call();
    }
    return _pickRaiseOrFallbackCall(
      chipsToCall: chipsToCall,
      myChips: myChips,
      opponentChips: opponentChips,
      minRaise: minRaise,
      aggressionBias: 0.58,
    );
  }

  double _aggressionBias(BlindCard humanCard, int stackChips) {
    final facesPremium =
        humanCard.isJoker || (!humanCard.isJoker && humanCard.rank >= 10);
    final facesWeak =
        !humanCard.isJoker && humanCard.rank >= 1 && humanCard.rank <= 4;
    final stackDepth =
        (stackChips / blindBluffStartingStack).clamp(0.55, 1.4);
    if (facesPremium) {
      return (0.42 / stackDepth).clamp(0.35, 0.55);
    }
    if (facesWeak) {
      return (0.78 * sqrt(stackDepth)).clamp(0.72, 0.88);
    }
    return (0.62 * stackDepth).clamp(0.52, 0.72);
  }

  BettingAction _pickRaiseOrFallbackCall({
    required int chipsToCall,
    required int myChips,
    required int opponentChips,
    required int minRaise,
    required double aggressionBias,
  }) {
    final maxBump = myChips - chipsToCall;
    if (maxBump <= 0) {
      return chipsToCall == 0
          ? const BettingAction.check()
          : const BettingAction.call();
    }
    if (maxBump < minRaise) {
      if (_rng.nextDouble() <= aggressionBias) {
        return BlindBluffBettingAction.raise(raiseBy: maxBump);
      }
      return chipsToCall == 0
          ? const BettingAction.check()
          : const BettingAction.call();
    }
    if (_rng.nextDouble() > aggressionBias) {
      return chipsToCall == 0
          ? const BettingAction.check()
          : const BettingAction.call();
    }

    final bump = pickRaiseBumpBbSized(
      chipsToCall: chipsToCall,
      myChips: myChips,
      opponentChips: opponentChips,
      minRaise: minRaise,
      aggressionBias: aggressionBias,
      rng: _rng,
    );
    return BettingAction.raise(raiseBy: bump);
  }
}