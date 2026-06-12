import 'package:genius_project/games/bluff_cup/models/cup_player.dart';

/// Best-of-seven match framing for Blind Cup: Liar's dice.
abstract final class BluffMatchRules {
  static const int totalRounds = 7;

  static const int winsToWinMatch = 4;

  /// Dice per cup (one is blind).
  static const int dicePerCup = 6;

  /// All dice on the table in 1v1.
  static const int totalDiceInPlay = dicePerCup * 2;

  /// Highest legal bid quantity.
  static const int maxBidQuantity = totalDiceInPlay;

  /// One slot per round; `null` = not played yet.
  static const List<CupPlayerId?> emptyRoundResults = <CupPlayerId?>[
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  static int countWins(List<CupPlayerId?> results, CupPlayerId id) {
    var n = 0;
    for (final w in results) {
      if (w == id) {
        n++;
      }
    }
    return n;
  }

  /// Opening turns per round when [matchFirstPlayer] starts round 1: 1, then 2, then 2, then 2.
  static const List<int> roundOpeningBlockSizes = <int>[1, 2, 2, 2];

  /// Who bids first in round [roundIndex] (0-based), given who opened the match.
  static CupPlayerId openingPlayerForRound({
    required int roundIndex,
    required CupPlayerId matchFirstPlayer,
  }) {
    assert(roundIndex >= 0 && roundIndex < totalRounds);
    var remaining = roundIndex;
    var turn = matchFirstPlayer;
    for (final blockSize in roundOpeningBlockSizes) {
      if (remaining < blockSize) {
        return turn;
      }
      remaining -= blockSize;
      turn = turn.opponent;
    }
    return matchFirstPlayer;
  }
}
