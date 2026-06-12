import 'dart:math';

import 'package:genius_project/games/bluff_cup/ai/cup_liar_ai_config.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_evaluator.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_match_state.dart';
import 'package:genius_project/games/bluff_cup/models/bid_model.dart';
import 'package:genius_project/games/bluff_cup/models/cup_player.dart';
import 'package:genius_project/games/bluff_cup/models/dice_model.dart';

/// Opponent decision: challenge the table bid or raise.
sealed class CupAiAction {
  const CupAiAction();
}

final class CupAiCatch extends CupAiAction {
  const CupAiCatch();
}

final class CupAiRaiseBid extends CupAiAction {
  const CupAiRaiseBid({
    required this.quantity,
    required this.faceValue,
    this.isPhantomMisdirect = false,
  });

  final int quantity;
  final int faceValue;
  final bool isPhantomMisdirect;
}

/// Read on whether the player's bid is likely true on the table.
class PlayerBidAnalysis {
  const PlayerBidAnalysis({
    required this.expectedTableTotal,
    required this.bidGap,
    required this.playerImpliedInCup,
    required this.likelyBluff,
  });

  final double expectedTableTotal;
  final double bidGap;
  final int playerImpliedInCup;
  final bool likelyBluff;
}

/// Smart PvE rival — EV, bluff detection, and incremental raises (no cheating).
abstract final class CupLiarAi {
  static List<DiceModel> openDice(List<DiceModel> cup) =>
      cup.where((d) => !d.isBlind).toList();

  static CupAiAction decide(
    BluffMatchState state, {
    CupLiarAiConfig config = CupLiarAiConfig.standard,
    int? phantomMisdirectFace,
    Random? random,
  }) {
    final rng = random ?? Random();
    final open = openDice(state.p2Dice);
    final tableBid = state.currentBid;
    final wildActive = state.wildcardsActiveThisRound;

    if (tableBid != null &&
        tableBid.playerId == CupPlayerId.p1 &&
        state.currentTurn == CupPlayerId.p2) {
      final analysis = analyzePlayerBid(
        bid: tableBid,
        openDice: open,
        wildActive: wildActive,
        roundIndex: state.currentRoundIndex,
        playerBidsThisRound: state.playerBidsThisRound,
        config: config,
      );
      if (_shouldCatch(analysis: analysis, config: config, rng: rng)) {
        return const CupAiCatch();
      }

      if (phantomMisdirectFace != null &&
          tableBid.faceValue == phantomMisdirectFace) {
        final bailout = _pickBailoutRaise(
          current: tableBid,
          openDice: open,
          wildActive: wildActive,
          config: config,
        );
        if (bailout != null) {
          return CupAiRaiseBid(
            quantity: bailout.quantity,
            faceValue: bailout.faceValue,
          );
        }
      }
    }

    if (_rollPureAssassin(open, config, rng)) {
      final pure = _pickPureAssassinBid(tableBid, open, config);
      if (pure != null) {
        return CupAiRaiseBid(quantity: pure.quantity, faceValue: pure.faceValue);
      }
    }

    if (rng.nextDouble() < config.phantomBidChance) {
      final phantom = _pickPhantomBid(tableBid, open, config, rng);
      if (phantom != null) {
        return CupAiRaiseBid(
          quantity: phantom.quantity,
          faceValue: phantom.faceValue,
          isPhantomMisdirect: true,
        );
      }
    }

    final raise = _pickRaiseBid(
      current: tableBid,
      openDice: open,
      wildActive: wildActive,
      config: config,
      rng: rng,
    );
    return CupAiRaiseBid(
      quantity: raise.quantity,
      faceValue: raise.faceValue,
    );
  }

  /// Guesses whether the player's bid is supported on the table (bluff or not).
  static PlayerBidAnalysis analyzePlayerBid({
    required BidModel bid,
    required List<DiceModel> openDice,
    required bool wildActive,
    required int roundIndex,
    required List<BidModel> playerBidsThisRound,
    required CupLiarAiConfig config,
  }) {
    final unknownTrust = _unknownTrustForRound(roundIndex, config);
    final expectedTable = expectedTableTotal(
      openDice: openDice,
      targetFace: bid.faceValue,
      wildcardsActive: wildActive,
      config: config,
      unknownTrust: unknownTrust,
    );

    final aiOnFace = _aiOpenMatchingFace(
      openDice: openDice,
      targetFace: bid.faceValue,
      wildcardsActive: wildActive,
    );
    final playerImplied = mathMax(
      0,
      bid.quantity - aiOnFace,
    ).clamp(0, config.unknownDiceCount);

    final bidGap = bid.quantity - expectedTable;
    final aggressiveRepeat = _playerRepeatedAggressiveFace(
      playerBidsThisRound,
      bid,
    );
    final likelyBluff = bidGap > config.catchMargin * 0.5 ||
        (roundIndex < config.earlyRoundSkepticRounds &&
            bidGap > 0 &&
            playerImplied >= 3) ||
        (aggressiveRepeat && bidGap > 0.2);

    return PlayerBidAnalysis(
      expectedTableTotal: expectedTable,
      bidGap: bidGap,
      playerImpliedInCup: playerImplied,
      likelyBluff: likelyBluff,
    );
  }

  static double _unknownTrustForRound(int roundIndex, CupLiarAiConfig config) {
    if (roundIndex < config.earlyRoundSkepticRounds) {
      return config.earlyRoundUnknownTrust;
    }
    if (roundIndex == config.earlyRoundSkepticRounds) {
      return config.midRoundUnknownTrust;
    }
    return 1.0;
  }

  static int _aiOpenMatchingFace({
    required List<DiceModel> openDice,
    required int targetFace,
    required bool wildcardsActive,
  }) {
    if (targetFace == 1) {
      return openDice.where((d) => d.faceValue == 1).length;
    }
    if (!wildcardsActive) {
      return openDice.where((d) => d.faceValue == targetFace).length;
    }
    return openDice
        .where((d) => d.faceValue == targetFace || d.faceValue == 1)
        .length;
  }

  /// Expected matching dice on the table (AI open cup + discounted hidden cup).
  static double expectedTableTotal({
    required List<DiceModel> openDice,
    required int targetFace,
    required bool wildcardsActive,
    required CupLiarAiConfig config,
    required double unknownTrust,
  }) {
    final aiOnFace = _aiOpenMatchingFace(
      openDice: openDice,
      targetFace: targetFace,
      wildcardsActive: wildcardsActive,
    );
    final useWild = wildcardsActive && targetFace != 1;
    final p = useWild ? config.wildUnknownProbability : config.pureUnknownProbability;
    final hiddenEv = config.unknownDiceCount * p * unknownTrust;
    return aiOnFace + hiddenEv;
  }

  static bool _playerRepeatedAggressiveFace(
    List<BidModel> roundBids,
    BidModel current,
  ) {
    if (roundBids.length < 2) {
      return false;
    }
    var sameFace = 0;
    for (final b in roundBids) {
      if (b.faceValue == current.faceValue && b.quantity >= current.quantity - 1) {
        sameFace++;
      }
    }
    return sameFace >= 2;
  }

  static bool _shouldCatch({
    required PlayerBidAnalysis analysis,
    required CupLiarAiConfig config,
    required Random rng,
  }) {
    final gap = analysis.bidGap;

    if (gap > config.catchMargin) {
      return rng.nextDouble() < config.suspiciousBidCatchChance;
    }
    if (analysis.likelyBluff && gap > 0.15) {
      return rng.nextDouble() < config.likelyBluffCatchChance;
    }
    if (gap <= 0) {
      return rng.nextDouble() < config.weakCatchChance;
    }
    return false;
  }

  static List<({int quantity, int faceValue})> _credibleRaises({
    required BidModel? current,
    required List<DiceModel> openDice,
    required bool wildActive,
    required CupLiarAiConfig config,
    required double maxAboveConfidence,
  }) {
    final legal = BluffEvaluator.legalNextBids(currentBid: current);
    final capped = <({int quantity, int faceValue})>[];
    for (final b in legal) {
      final conf = expectedTableTotal(
        openDice: openDice,
        targetFace: b.faceValue,
        wildcardsActive: wildActive,
        config: config,
        unknownTrust: 1.0,
      );
      if (b.quantity <= conf + maxAboveConfidence) {
        capped.add(b);
      }
    }
    if (current == null) {
      return capped;
    }
    final maxQty = current.quantity + config.maxQuantityStepOverCurrent;
    return capped.where((b) => b.quantity <= maxQty).toList();
  }

  static int _raiseDistance(BidModel? current, ({int quantity, int faceValue}) b) {
    if (current == null) {
      return b.quantity * 10 + b.faceValue;
    }
    if (b.quantity != current.quantity) {
      return (b.quantity - current.quantity) * 100 + b.faceValue;
    }
    return b.faceValue - current.faceValue;
  }

  static int mathMax(int a, int b) => a > b ? a : b;

  static bool _rollPureAssassin(
    List<DiceModel> openDice,
    CupLiarAiConfig config,
    Random rng,
  ) {
    final openOnes = openDice.where((d) => d.faceValue == 1).length;
    if (openOnes != 0) {
      return false;
    }
    return rng.nextDouble() < config.pureAssassinChance;
  }

  static ({int quantity, int faceValue})? _pickPureAssassinBid(
    BidModel? current,
    List<DiceModel> openDice,
    CupLiarAiConfig config,
  ) {
    final legalOnes = BluffEvaluator.legalNextBids(currentBid: current)
        .where((b) => b.faceValue == 1)
        .toList();
    if (legalOnes.isEmpty) {
      return null;
    }
    final credible = _credibleRaises(
      current: current,
      openDice: openDice,
      wildActive: true,
      config: config,
      maxAboveConfidence: config.maxBidAboveConfidence,
    );
    final onOnes = credible.where((b) => b.faceValue == 1).toList()
      ..sort((a, b) => _raiseDistance(current, a).compareTo(_raiseDistance(current, b)));
    if (onOnes.isNotEmpty) {
      return onOnes.first;
    }
    return legalOnes.first;
  }

  static ({int quantity, int faceValue})? _pickPhantomBid(
    BidModel? current,
    List<DiceModel> openDice,
    CupLiarAiConfig config,
    Random rng,
  ) {
    final zeroFaces = <int>[];
    for (var f = 2; f <= 6; f++) {
      if (openDice.where((d) => d.faceValue == f).isEmpty) {
        zeroFaces.add(f);
      }
    }
    if (zeroFaces.isEmpty) {
      return null;
    }
    final face = zeroFaces[rng.nextInt(zeroFaces.length)];
    final credible = _credibleRaises(
      current: current,
      openDice: openDice,
      wildActive: true,
      config: config,
      maxAboveConfidence: config.phantomMaxAboveConfidence,
    );
    final onFace = credible.where((b) => b.faceValue == face).toList()
      ..sort((a, b) => _raiseDistance(current, a).compareTo(_raiseDistance(current, b)));
    if (onFace.isEmpty) {
      return null;
    }
    return onFace.first;
  }

  static ({int quantity, int faceValue})? _pickBailoutRaise({
    required BidModel? current,
    required List<DiceModel> openDice,
    required bool wildActive,
    required CupLiarAiConfig config,
  }) {
    var bestFace = 2;
    var bestCount = -1;
    for (var f = 2; f <= 6; f++) {
      final c = openDice.where((d) => d.faceValue == f).length;
      if (c > bestCount) {
        bestCount = c;
        bestFace = f;
      }
    }
    final credible = _credibleRaises(
      current: current,
      openDice: openDice,
      wildActive: wildActive,
      config: config,
      maxAboveConfidence: config.maxBidAboveConfidence,
    );
    final onFace = credible.where((b) => b.faceValue == bestFace).toList()
      ..sort((a, b) => _raiseDistance(current, a).compareTo(_raiseDistance(current, b)));
    if (onFace.isNotEmpty) {
      return onFace.first;
    }
    return _pickRaiseBid(
      current: current,
      openDice: openDice,
      wildActive: wildActive,
      config: config,
      rng: Random(),
    );
  }

  static ({int quantity, int faceValue}) _pickRaiseBid({
    required BidModel? current,
    required List<DiceModel> openDice,
    required bool wildActive,
    required CupLiarAiConfig config,
    required Random rng,
  }) {
    var credible = _credibleRaises(
      current: current,
      openDice: openDice,
      wildActive: wildActive,
      config: config,
      maxAboveConfidence: config.maxBidAboveConfidence,
    );

    if (credible.isEmpty) {
      credible = BluffEvaluator.legalNextBids(currentBid: current);
    }

    if (current != null) {
      final sameQty = credible
          .where(
            (b) =>
                b.quantity == current.quantity &&
                b.faceValue > current.faceValue,
          )
          .toList()
        ..sort((a, b) => a.faceValue.compareTo(b.faceValue));
      if (sameQty.isNotEmpty) {
        return sameQty.first;
      }
    }

    credible.sort(
      (a, b) => _raiseDistance(current, a).compareTo(_raiseDistance(current, b)),
    );
    return credible.first;
  }
}
