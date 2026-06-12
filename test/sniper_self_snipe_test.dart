import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/sniper_poker/logic/poker_evaluator.dart';
import 'package:genius_project/games/sniper_poker/logic/sniper_engine.dart';
import 'package:genius_project/games/sniper_poker/logic/sniper_match_state.dart';
import 'package:genius_project/games/sniper_poker/models/poker_models.dart';

void main() {
  group('SniperEngine.isPlayerSniped', () {
    const hand = ParsedHand(rank: HandRank.twoPair, primaryValue: 6);

    test('opponent sniper hit marks sniped', () {
      final opp = SniperRiverDeclaration(
        mode: SniperModeSelection.sniper,
        targetRank: HandRank.twoPair,
        targetValue: 6,
      );
      expect(
        SniperEngine.isPlayerSniped(
          hand: hand,
          opponentDeclaration: opp,
          ownDeclaration: null,
          opponentWideLens: false,
          ownWideLens: false,
        ),
        isTrue,
      );
    });

    test('self snipe marks sniped', () {
      final own = SniperRiverDeclaration(
        mode: SniperModeSelection.sniper,
        targetRank: HandRank.twoPair,
        targetValue: 6,
      );
      expect(
        SniperEngine.isPlayerSniped(
          hand: hand,
          opponentDeclaration: null,
          ownDeclaration: own,
          opponentWideLens: false,
          ownWideLens: false,
        ),
        isTrue,
      );
    });

    test('wrong self target does not snipe', () {
      final own = SniperRiverDeclaration(
        mode: SniperModeSelection.sniper,
        targetRank: HandRank.pair,
        targetValue: 6,
      );
      expect(
        SniperEngine.isPlayerSniped(
          hand: hand,
          opponentDeclaration: null,
          ownDeclaration: own,
          opponentWideLens: false,
          ownWideLens: false,
        ),
        isFalse,
      );
    });

    test('both self and opponent snipe still sniped', () {
      final decl = SniperRiverDeclaration(
        mode: SniperModeSelection.sniper,
        targetRank: HandRank.twoPair,
        targetValue: 6,
      );
      expect(
        SniperEngine.isPlayerSniped(
          hand: hand,
          opponentDeclaration: decl,
          ownDeclaration: decl,
          opponentWideLens: false,
          ownWideLens: false,
        ),
        isTrue,
      );
    });
  });
}
