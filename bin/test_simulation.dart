import 'dart:math';

import 'package:genius_project/core/models/coordinate.dart';
import 'package:genius_project/games/matrix_poker_25/logic/game_loop_manager.dart';
import 'package:genius_project/games/matrix_poker_25/logic/hand_rank.dart';
import 'package:genius_project/games/matrix_poker_25/logic/player_draft_manager.dart';
import 'package:genius_project/games/matrix_poker_25/models/matrix_grid_model.dart';

/// CLI sandbox: builds random boards, auto-drafts, runs twelve blind rounds.
void main() {
  final rng = Random();

  final gridP1 = MatrixGridModel();
  final gridP2 = MatrixGridModel();
  fillGridRandom(gridP1, rng);
  fillGridRandom(gridP2, rng);

  final draftsP1 = autoDraftTwelveCombos(gridP1, rng);
  final draftsP2 = autoDraftTwelveCombos(gridP2, rng);

  final duel = GameLoopManager(
    player1Drafts: draftsP1,
    player2Drafts: draftsP2,
  );

  print('=== Matrix Poker 25 — 12-round duel simulation ===\n');

  for (var roundIdx = 0; roundIdx < 12; roundIdx++) {
    final commitOrder = [0, 1]..shuffle(rng);
    RoundResolution? resolution;

    for (final playerIndex in commitOrder) {
      final comboIndex = pickRandomUnusedComboIndex(duel, playerIndex, rng);
      resolution = duel.commitCombo(playerIndex, comboIndex);
    }

    if (resolution == null) {
      throw StateError(
        'Expected round ${roundIdx + 1} to resolve after two commits.',
      );
    }

    print(formatRoundCommentary(resolution));
  }

  print('');
  print(formatFinalResult(duel.scorePlayer1, duel.scorePlayer2));
}

/// Writes a random integer `1..10` into every cell (Phase 1 shortcut).
void fillGridRandom(MatrixGridModel grid, Random rng) {
  for (var y = 0; y < 5; y++) {
    for (var x = 0; x < 5; x++) {
      final ok = grid.placeNumber(Coordinate(x, y), 1 + rng.nextInt(10));
      if (!ok) {
        throw StateError('Failed to fill cell ($x,$y).');
      }
    }
  }
}

/// Enumerates every distinct valid four-cell adjacent straight segment on a 5×5 board.
///
/// Deduplicates segments that appear from multiple start points / directions but
/// describe the same coordinate set.
List<List<Coordinate>> allValidFourCellLines() {
  bool inBounds(Coordinate c) =>
      c.x >= 0 && c.x <= 4 && c.y >= 0 && c.y <= 4;

  const dirs = <(int, int)>[
    (1, 0),
    (-1, 0),
    (0, 1),
    (0, -1),
    (1, 1),
    (1, -1),
    (-1, 1),
    (-1, -1),
  ];

  final seen = <String>{};
  final lines = <List<Coordinate>>[];

  for (var sx = 0; sx < 5; sx++) {
    for (var sy = 0; sy < 5; sy++) {
      for (final d in dirs) {
        final cells = <Coordinate>[
          for (var i = 0; i < 4; i++)
            Coordinate(sx + i * d.$1, sy + i * d.$2),
        ];
        if (!cells.every(inBounds)) continue;
        if (cells.toSet().length != 4) continue;

        final canonical = PlayerDraftManager.readingOrder(cells);
        final key = canonical.map((e) => '${e.x}:${e.y}').join(',');
        if (seen.add(key)) {
          lines.add(canonical);
        }
      }
    }
  }

  return lines;
}

/// Attempts to accept up to twelve distinct geometry-valid drafts for [grid].
///
/// Shuffles candidate lines so runs produce varied hands while staying legal.
PlayerDraftManager autoDraftTwelveCombos(MatrixGridModel grid, Random rng) {
  final manager = PlayerDraftManager();
  final candidates = allValidFourCellLines()..shuffle(rng);

  for (final line in candidates) {
    if (manager.draftCount == PlayerDraftManager.maxDrafts) break;
    manager.tryDraftCombo(grid, line);
  }

  if (manager.draftCount != PlayerDraftManager.maxDrafts) {
    throw StateError(
      'Auto-draft stopped at ${manager.draftCount} combos (need 12).',
    );
  }

  return manager;
}

/// Chooses a random combo slot (`0..11`) not yet consumed for [playerIndex].
int pickRandomUnusedComboIndex(
  GameLoopManager duel,
  int playerIndex,
  Random rng,
) {
  final unused = [
    for (var i = 0; i < PlayerDraftManager.maxDrafts; i++)
      if (!duel.isComboConsumed(playerIndex, i)) i,
  ];
  if (unused.isEmpty) {
    throw StateError('No unused combos left for player $playerIndex.');
  }
  return unused[rng.nextInt(unused.length)];
}

String formatRoundCommentary(RoundResolution r) {
  final p1 = '${handRankLabel(r.player1Combo.rank)} '
      '(Value: ${r.player1Combo.primaryKeyValue})';
  final p2 = '${handRankLabel(r.player2Combo.rank)} '
      '(Value: ${r.player2Combo.primaryKeyValue})';

  final outcome = switch (r.winner) {
    RoundWinner.player1 => 'P1 wins!',
    RoundWinner.player2 => 'P2 wins!',
    RoundWinner.tie => 'Tie — no points.',
  };

  return 'Round ${r.roundNumber}: '
      'P1 plays $p1, P2 plays $p2. '
      '$outcome '
      'Score: ${r.scorePlayer1After} - ${r.scorePlayer2After}';
}

String formatFinalResult(int scoreP1, int scoreP2) {
  final headline = 'Final score (P1 - P2): $scoreP1 - $scoreP2.';
  if (scoreP1 == scoreP2) {
    return '$headline Match tied overall.';
  }
  final winner = scoreP1 > scoreP2 ? 'Player 1' : 'Player 2';
  return '$headline $winner wins the duel!';
}

String handRankLabel(HandRank rank) => switch (rank) {
      HandRank.fourOfAKind => 'Four of a Kind',
      HandRank.straightInOrder => '4 Straight (In Order)',
      HandRank.straightNotInOrder => '4 Straight (Not in Order)',
      HandRank.twoPair => 'Two Pair',
      HandRank.threeOfAKind => 'Three of a Kind',
      HandRank.onePair => 'One Pair',
      HandRank.highCard => 'High Card',
    };
