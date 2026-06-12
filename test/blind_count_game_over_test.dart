import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/blind_count_40/logic/blind_count_state.dart';
import 'package:genius_project/games/blind_count_40/models/block_model.dart';
import 'package:genius_project/games/blind_count_40/models/game_player.dart';

BlindCountState _state({
  List<BlockModel> p1 = const [],
  List<BlockModel> p2 = const [],
  int pool = 0,
}) {
  return BlindCountState(
    currentTurn: BlindPlayerId.p1,
    p1Blocks: p1,
    p2BlockCount: p2.length,
    hiddenP2Blocks: p2,
    p1Score: 12,
    p2Score: 8,
    currentTurnComboScore: 0,
    poolRemaining: pool,
    isSumRevealed: pool == 0,
    p1UsedSkills: const [],
    isGameOver: false,
    turnRemainingSeconds: 20,
  );
}

void main() {
  test('match ends when cleared seat cannot be refilled', () {
    final cleared = _state(
      p1: const [],
      p2: [BlockModel(value: 3, id: 'p2-a')],
      pool: 0,
    );
    expect(cleared.isTerminalNoRefill, isTrue);
    expect(cleared.clearedSeatWhenPoolEmpty, BlindPlayerId.p1);
    expect(cleared.matchWinner, BlindPlayerId.p2);

    final ended = cleared.endedIfNoRefill();
    expect(ended.isGameOver, isTrue);
  });

  test('match continues when dealer can still refill', () {
    final refillable = _state(
      p1: const [],
      p2: [BlockModel(value: 1, id: 'p2-b')],
      pool: 5,
    );
    expect(refillable.isTerminalNoRefill, isFalse);
    expect(refillable.endedIfNoRefill().isGameOver, isFalse);
  });

  test('match continues when pool empty but both still have blocks', () {
    final bothHands = _state(
      p1: [BlockModel(value: 2, id: 'p1-a')],
      p2: [BlockModel(value: 4, id: 'p2-c')],
      pool: 0,
    );
    expect(bothHands.isTerminalNoRefill, isFalse);
  });
}
