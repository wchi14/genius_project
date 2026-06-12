import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_match_cubit.dart';
import 'package:genius_project/games/bluff_cup/models/cup_player.dart';

void main() {
  test('fresh match can open with opponent turn and no bid', () {
    BluffMatchCubit? cubit;
    for (var i = 0; i < 50; i++) {
      final c = BluffMatchCubit();
      if (c.state.currentTurn == CupPlayerId.p2 &&
          c.state.currentBid == null) {
        cubit = c;
        break;
      }
      c.close();
    }
    expect(cubit, isNotNull);
    addTearDown(cubit!.close);
    expect(cubit.state.isShowdown, isFalse);
  });
}
