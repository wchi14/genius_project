import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/bluff_cup/ai/cup_liar_ai.dart';
import 'package:genius_project/games/bluff_cup/ai/cup_liar_ai_config.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_evaluator.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_match_rules.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_match_state.dart';
import 'package:genius_project/games/bluff_cup/models/bid_model.dart';
import 'package:genius_project/games/bluff_cup/models/cup_player.dart';
import 'package:genius_project/games/bluff_cup/models/dice_model.dart';

DiceModel _die(int face, {bool blind = false, String? id}) =>
    DiceModel(
      id: id ?? 'd$face$blind',
      faceValue: face,
      isBlind: blind,
    );

List<DiceModel> _cup(List<int> openFaces, {int blindFace = 3}) {
  final dice = <DiceModel>[
    for (var i = 0; i < openFaces.length; i++)
      _die(openFaces[i], id: 'o$i'),
    _die(blindFace, blind: true, id: 'blind'),
  ];
  return dice;
}

BluffMatchState _state({
  required List<DiceModel> p2Dice,
  BidModel? bid,
  CupPlayerId turn = CupPlayerId.p2,
  bool wildcardsActive = true,
}) {
  return BluffMatchState(
    matchFirstPlayer: CupPlayerId.p1,
    currentTurn: turn,
    p1Dice: _cup([2, 3, 4, 5, 6, 2]),
    p2Dice: p2Dice,
    currentBid: bid,
    isShowdown: false,
    winner: null,
    p1TurnSecondsRemaining: null,
    endedByP1TimeForfeit: false,
    currentRoundIndex: 0,
    roundResults: List<CupPlayerId?>.from(BluffMatchRules.emptyRoundResults),
    matchWinner: null,
    wildcardsActiveThisRound: wildcardsActive,
  );
}

void main() {
  test('legalNextBids allows up to 12 dice', () {
    final legal = BluffEvaluator.legalNextBids(currentBid: null);
    expect(legal.any((b) => b.quantity == 12), isTrue);
  });

  test('EV uses wild probability when wildcards active', () {
    final open = [_die(5), _die(1), _die(5), _die(2)];
    const config = CupLiarAiConfig.standard;
    final conf = CupLiarAi.expectedTableTotal(
      openDice: open,
      targetFace: 5,
      wildcardsActive: true,
      config: config,
      unknownTrust: 1.0,
    );
    expect(
      conf,
      closeTo(2 + 1 + config.unknownDiceCount * (2 / 6), 0.01),
    );
  });

  test('early rounds discount hidden cup when analyzing player bid', () {
    final open = [_die(2), _die(3), _die(4), _die(5)];
    const config = CupLiarAiConfig.standard;
    final early = CupLiarAi.analyzePlayerBid(
      bid: BidModel(
        playerId: CupPlayerId.p1,
        quantity: 6,
        faceValue: 2,
      ),
      openDice: open,
      wildActive: true,
      roundIndex: 0,
      playerBidsThisRound: const [],
      config: config,
    );
    final late = CupLiarAi.analyzePlayerBid(
      bid: BidModel(
        playerId: CupPlayerId.p1,
        quantity: 6,
        faceValue: 2,
      ),
      openDice: open,
      wildActive: true,
      roundIndex: 3,
      playerBidsThisRound: const [],
      config: config,
    );
    expect(early.expectedTableTotal, lessThan(late.expectedTableTotal));
    expect(early.likelyBluff, isTrue);
  });

  test('repeated aggressive face on same bid marks likely bluff', () {
    final bid = BidModel(
      playerId: CupPlayerId.p1,
      quantity: 5,
      faceValue: 4,
    );
    final analysis = CupLiarAi.analyzePlayerBid(
      bid: bid,
      openDice: [_die(2), _die(3), _die(5), _die(6)],
      wildActive: true,
      roundIndex: 2,
      playerBidsThisRound: [
        BidModel(playerId: CupPlayerId.p1, quantity: 4, faceValue: 4),
        bid,
      ],
      config: CupLiarAiConfig.standard,
    );
    expect(analysis.likelyBluff, isTrue);
  });

  test('AI catches inflated player bid', () {
    final action = CupLiarAi.decide(
      _state(
        p2Dice: _cup([2, 3, 4, 5, 6, 2]),
        bid: BidModel(
          playerId: CupPlayerId.p1,
          quantity: 10,
          faceValue: 2,
        ),
      ),
      random: _FixedRandom(0.0),
    );
    expect(action, isA<CupAiCatch>());
  });

  test('pure assassin bids on 1s with zero open ones', () {
    final action = CupLiarAi.decide(
      _state(p2Dice: _cup([2, 3, 4, 5, 6, 2])),
      random: _FixedRandom(0.0),
    );
    expect(action, isA<CupAiRaiseBid>());
    expect((action as CupAiRaiseBid).faceValue, 1);
  });

  test('after credible player bid AI raises incrementally not a huge leap', () {
    final action = CupLiarAi.decide(
      _state(
        p2Dice: _cup([2, 2, 3, 4, 5, 6]),
        bid: BidModel(
          playerId: CupPlayerId.p1,
          quantity: 3,
          faceValue: 2,
        ),
      ),
      config: const CupLiarAiConfig(
        pureAssassinChance: 0,
        phantomBidChance: 0,
        catchMargin: 2.5,
        suspiciousBidCatchChance: 0,
        likelyBluffCatchChance: 0,
        weakCatchChance: 0,
      ),
      random: Random(99),
    );
    expect(action, isA<CupAiRaiseBid>());
    final raise = action as CupAiRaiseBid;
    expect(raise.quantity, lessThanOrEqualTo(4));
    expect(
      raise.quantity == 3 && raise.faceValue > 2 || raise.quantity == 4,
      isTrue,
    );
  });

  test('phantom bid marks misdirect when raising on empty face', () {
    final action = CupLiarAi.decide(
      _state(p2Dice: _cup([2, 2, 2, 2, 2, 2])),
      config: const CupLiarAiConfig(
        pureAssassinChance: 0,
        phantomBidChance: 1,
      ),
      random: Random(42),
    );
    expect(action, isA<CupAiRaiseBid>());
    expect((action as CupAiRaiseBid).isPhantomMisdirect, isTrue);
  });
}

class _FixedRandom implements Random {
  _FixedRandom(this.value);

  final double value;

  @override
  double nextDouble() => value;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
