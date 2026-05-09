import 'dart:io';
import 'dart:math';

import 'package:genius_project/core/models/coordinate.dart';
import 'package:genius_project/games/matrix_poker_25/logic/combo.dart';
import 'package:genius_project/games/matrix_poker_25/logic/game_loop_manager.dart';
import 'package:genius_project/games/matrix_poker_25/logic/hand_rank.dart';
import 'package:genius_project/games/matrix_poker_25/logic/four_cell_line_catalog.dart';
import 'package:genius_project/games/matrix_poker_25/logic/number_bag.dart';
import 'package:genius_project/games/matrix_poker_25/logic/player_draft_manager.dart';
import 'package:genius_project/games/matrix_poker_25/models/matrix_grid_model.dart';

/// Printable **end-to-end** Matrix Poker 25 run:
/// Phase 1 (25 shared dealer draws → two independent placements),
/// Phase 2 (12 valid line drafts per player, logged),
/// Phase 3 (blind duel via [GameLoopManager]).
void main() {
  final rng = Random();

  stdout.writeln('══════════════════════════════════════════════════════════════');
  stdout.writeln('  Matrix Poker 25 — full step-by-step simulation (E2E)');
  stdout.writeln('══════════════════════════════════════════════════════════════');

  final gridP1 = MatrixGridModel();
  final gridP2 = MatrixGridModel();

  // ── Phase 1 ───────────────────────────────────────────────────────
  stdout.writeln('\n▶ PHASE 1 — Board filling');
  stdout.writeln(
    '    Rules: each step the dealer draws one integer in 1..10 (shared). '
    'Each player picks any empty cell on their own 5×5 grid.\n',
  );

  final dealerBag = NumberBag(rng);
  for (var step = 1; step <= 25; step++) {
    final dealer = dealerBag.draw();
    stdout.writeln('── Step $step/25 — Dealer draws: $dealer ──');

    final p1Cell = pickRandomEmptyCell(gridP1, rng);
    final placedP1 = gridP1.placeNumber(p1Cell, dealer);
    if (!placedP1) {
      throw StateError('P1 placement failed at step $step.');
    }
    stdout.writeln(
      '    P1 places $dealer at ${coordLabel(p1Cell)} '
      '(reading order index: x=${p1Cell.x}, y=${p1Cell.y}).',
    );

    final p2Cell = pickRandomEmptyCell(gridP2, rng);
    final placedP2 = gridP2.placeNumber(p2Cell, dealer);
    if (!placedP2) {
      throw StateError('P2 placement failed at step $step.');
    }
    stdout.writeln(
      '    P2 places $dealer at ${coordLabel(p2Cell)} '
      '(x=${p2Cell.x}, y=${p2Cell.y}).',
    );

    stdout.writeln('');
    printGrid('    [ P1 board ]', gridP1);
    stdout.writeln('');
    printGrid('    [ P2 board ]', gridP2);
    stdout.writeln('');
  }

  if (!gridP1.isFull() || !gridP2.isFull()) {
    throw StateError('Phase 1 ended but a grid is not full.');
  }

  // ── Phase 2 ───────────────────────────────────────────────────────
  stdout.writeln('\n▶ PHASE 2 — Combo drafting (12 lines each)');
  stdout.writeln(
    '    Each player selects 12 distinct valid 4-cell adjacent straight lines '
    'on their own board (simulated: random valid candidates).\n',
  );

  final draftsP1 = draftTwelveWithLogging(gridP1, rng, 'P1');
  stdout.writeln('');
  final draftsP2 = draftTwelveWithLogging(gridP2, rng, 'P2');

  // ── Phase 3 ───────────────────────────────────────────────────────
  stdout.writeln('\n▶ PHASE 3 — 12-round blind duel');
  stdout.writeln(
    '    Both players reveal one unused combo per round; strongest hand wins '
    '(tie-break: primary key). Commit order is randomized each round.\n',
  );

  final duel = GameLoopManager(
    player1Drafts: draftsP1,
    player2Drafts: draftsP2,
  );

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

    stdout.writeln(formatRoundCommentary(resolution));
  }

  stdout.writeln('');
  stdout.writeln(formatFinalResult(duel.scorePlayer1, duel.scorePlayer2));
  stdout.writeln('\n══ Simulation complete ══');
}

// ── Phase 1 helpers ─────────────────────────────────────────────────

/// Chooses a uniformly random empty cell (`value == 0`).
Coordinate pickRandomEmptyCell(MatrixGridModel grid, Random rng) {
  final empty = listEmptyCells(grid);
  if (empty.isEmpty) {
    throw StateError('No empty cells left.');
  }
  return empty[rng.nextInt(empty.length)];
}

List<Coordinate> listEmptyCells(MatrixGridModel grid) {
  final out = <Coordinate>[];
  for (var y = 0; y < 5; y++) {
    for (var x = 0; x < 5; x++) {
      final c = Coordinate(x, y);
      if (grid.getNumberAt(c) == 0) {
        out.add(c);
      }
    }
  }
  return out;
}

/// Spreadsheet-style cell label: columns A–E, rows 1–5 (top row = 1).
String coordLabel(Coordinate c) {
  const letters = 'ABCDE';
  return '${letters[c.x]}${c.y + 1}';
}

void printGrid(String title, MatrixGridModel grid) {
  stdout.writeln(title);
  const header = '      A  B  C  D  E';
  stdout.writeln(header);
  for (var y = 0; y < 5; y++) {
    final buf = StringBuffer('   ${y + 1} ');
    for (var x = 0; x < 5; x++) {
      final v = grid.getNumberAt(Coordinate(x, y));
      buf.write(v.toString().padLeft(3));
    }
    stdout.writeln(buf.toString());
  }
}

// ── Phase 2 helpers ─────────────────────────────────────────────────

/// Walks shuffled geometry-valid lines until twelve drafts succeed; prints each pick.
PlayerDraftManager draftTwelveWithLogging(
  MatrixGridModel grid,
  Random rng,
  String playerLabel,
) {
  final manager = PlayerDraftManager();
  final candidates = allValidFourCellLines()..shuffle(rng);
  var i = 0;

  for (var draftNum = 1; draftNum <= PlayerDraftManager.maxDrafts; draftNum++) {
    var accepted = false;
    while (i < candidates.length) {
      final line = candidates[i++];
      if (manager.tryDraftCombo(grid, line)) {
        final combo = manager.combos.last;
        stdout.writeln(
          '  $playerLabel — Draft $draftNum/${PlayerDraftManager.maxDrafts}: '
          '${formatComboSummary(combo)}',
        );
        accepted = true;
        break;
      }
    }
    if (!accepted) {
      throw StateError(
        '$playerLabel: could not place draft #$draftNum '
        '(exhausted ${candidates.length} candidates).',
      );
    }
  }

  return manager;
}

String formatComboSummary(Combo c) {
  final cells = c.coordinates.map(coordLabel).join(' → ');
  final nums = c.numbers.join(', ');
  return 'cells $cells | nums [$nums] | ${handRankLabel(c.rank)} '
      '(primary ${c.primaryKeyValue})';
}

// ── Phase 3 helpers ─────────────────────────────────────────────────

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
