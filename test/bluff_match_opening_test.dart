import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_match_rules.dart';
import 'package:genius_project/games/bluff_cup/models/cup_player.dart';

void main() {
  test('when player opens match, rounds 1,4,5 are player and 2,3,6,7 opponent', () {
    const first = CupPlayerId.p1;
    expect(
      BluffMatchRules.openingPlayerForRound(roundIndex: 0, matchFirstPlayer: first),
      CupPlayerId.p1,
    );
    expect(
      BluffMatchRules.openingPlayerForRound(roundIndex: 1, matchFirstPlayer: first),
      CupPlayerId.p2,
    );
    expect(
      BluffMatchRules.openingPlayerForRound(roundIndex: 2, matchFirstPlayer: first),
      CupPlayerId.p2,
    );
    expect(
      BluffMatchRules.openingPlayerForRound(roundIndex: 3, matchFirstPlayer: first),
      CupPlayerId.p1,
    );
    expect(
      BluffMatchRules.openingPlayerForRound(roundIndex: 4, matchFirstPlayer: first),
      CupPlayerId.p1,
    );
    expect(
      BluffMatchRules.openingPlayerForRound(roundIndex: 5, matchFirstPlayer: first),
      CupPlayerId.p2,
    );
    expect(
      BluffMatchRules.openingPlayerForRound(roundIndex: 6, matchFirstPlayer: first),
      CupPlayerId.p2,
    );
  });

  test('when opponent opens match, round 1 is opponent and 2–3 are player', () {
    const first = CupPlayerId.p2;
    expect(
      BluffMatchRules.openingPlayerForRound(roundIndex: 0, matchFirstPlayer: first),
      CupPlayerId.p2,
    );
    expect(
      BluffMatchRules.openingPlayerForRound(roundIndex: 1, matchFirstPlayer: first),
      CupPlayerId.p1,
    );
    expect(
      BluffMatchRules.openingPlayerForRound(roundIndex: 2, matchFirstPlayer: first),
      CupPlayerId.p1,
    );
  });
}
