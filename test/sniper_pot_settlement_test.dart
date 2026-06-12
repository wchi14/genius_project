import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/sniper_poker/logic/sniper_pot_settlement.dart';
import 'package:genius_project/games/sniper_poker/models/sniper_player_id.dart';

void main() {
  group('SniperPotSettlement', () {
    test('short stack winner receives matched pot only', () {
      final award = SniperPotSettlement.awardToWinner(
        p1Investment: 5,
        p2Investment: 8,
        winner: SniperPlayerId.p1,
      );
      expect(award.p1Award, 10);
      expect(award.p2Award, 3);
    });

    test('deep stack winner takes full pot', () {
      final award = SniperPotSettlement.awardToWinner(
        p1Investment: 5,
        p2Investment: 8,
        winner: SniperPlayerId.p2,
      );
      expect(award.p1Award, 0);
      expect(award.p2Award, 13);
    });

    test('split returns each investment', () {
      final award = SniperPotSettlement.awardSplit(
        p1Investment: 5,
        p2Investment: 8,
      );
      expect(award.p1Award, 5);
      expect(award.p2Award, 8);
    });
  });
}
