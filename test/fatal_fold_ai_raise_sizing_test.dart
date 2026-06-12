import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:genius_project/games/blind_bluff_fatal_fold/ai/fatal_fold_ai_raise_sizing.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/ai/mock_bluff_ai.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/logic/blind_bluff_betting.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/models/blind_card.dart';

void main() {
  group('pickRaiseBumpBbSized', () {
    test('open raise stays within 3BB when deep stacked', () {
      const bb = 1;
      var maxBump = 0;
      for (var seed = 0; seed < 80; seed++) {
        final bump = pickRaiseBumpBbSized(
          chipsToCall: 0,
          myChips: 30,
          opponentChips: 30,
          minRaise: bb,
          aggressionBias: 0.75,
          rng: Random(seed),
        );
        maxBump = max(maxBump, bump);
      }
      expect(maxBump, lessThanOrEqualTo(bb * 3));
      expect(maxBump, greaterThanOrEqualTo(bb));
    });

    test('does not open above what opponent can cover', () {
      const bb = 8;
      for (var seed = 0; seed < 40; seed++) {
        final bump = pickRaiseBumpBbSized(
          chipsToCall: 0,
          myChips: 30,
          opponentChips: 8,
          minRaise: bb,
          aggressionBias: 0.85,
          rng: Random(seed),
        );
        expect(bump, lessThanOrEqualTo(8));
      }
    });

    test('facing bet uses BB tiers not full stack', () {
      const bb = 5;
      var maxBump = 0;
      for (var seed = 0; seed < 60; seed++) {
        final bump = pickRaiseBumpBbSized(
          chipsToCall: 10,
          myChips: 28,
          opponentChips: 25,
          minRaise: bb,
          aggressionBias: 0.7,
          rng: Random(seed),
        );
        maxBump = max(maxBump, bump);
      }
      expect(maxBump, lessThanOrEqualTo(10 + bb * 3));
    });
  });

  group('tryPremiumVisibleBluffRaise', () {
    test('returns 1–2 BB raise when probability hits', () {
      const human = BlindCard.joker();
      final action = tryPremiumVisibleBluffRaise(
        visibleOpponentCard: human,
        chipsToCall: 0,
        myChips: 30,
        opponentChips: 30,
        minRaise: 1,
        probability: 1.0,
        rng: Random(0),
      );
      expect(action?.kind, BlindBluffBettingActionKind.raise);
      expect(action!.raiseBy, inInclusiveRange(1, 2));
    });

    test('does not fire on non-premium visible card', () {
      final action = tryPremiumVisibleBluffRaise(
        visibleOpponentCard: const BlindCard.number(7),
        chipsToCall: 0,
        myChips: 30,
        opponentChips: 30,
        minRaise: 1,
        probability: 1.0,
        rng: Random(0),
      );
      expect(action, isNull);
    });
  });

  group('MockBluffAi integration', () {
    test('aggressive line prefers small BB raises over pot-sized', () async {
      final ai = MockBluffAi(random: Random(42));
      const human = BlindCard.number(3);
      var maxRaiseBy = 0;
      var raiseCount = 0;

      for (var i = 0; i < 120; i++) {
        final action = await ai.decideAction(
          humanCard: human,
          currentCallAmount: 0,
          myChips: 30,
          minRaise: 1,
          hasPenaltyInsuranceThisRound: false,
          playerChips: 30,
        );
        if (action.kind == BlindBluffBettingActionKind.raise &&
            action.raiseBy != null) {
          raiseCount++;
          maxRaiseBy = max(maxRaiseBy, action.raiseBy!);
        }
      }

      expect(raiseCount, greaterThan(10));
      expect(maxRaiseBy, lessThanOrEqualTo(3));
      expect(maxRaiseBy, greaterThanOrEqualTo(1));
    });

    test('joker visible can produce 1–2 BB bluff raises', () async {
      final ai = MockBluffAi(random: Random(99));
      const human = BlindCard.joker();
      var bluffSizedRaises = 0;

      for (var i = 0; i < 400; i++) {
        final action = await ai.decideAction(
          humanCard: human,
          currentCallAmount: 0,
          myChips: 30,
          minRaise: 1,
          hasPenaltyInsuranceThisRound: false,
          playerChips: 30,
        );
        if (action.kind == BlindBluffBettingActionKind.raise &&
            action.raiseBy != null &&
            action.raiseBy! <= 2) {
          bluffSizedRaises++;
        }
      }

      expect(bluffSizedRaises, greaterThan(0));
    });
  });
}
