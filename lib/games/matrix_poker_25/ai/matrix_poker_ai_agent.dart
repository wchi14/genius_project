import 'package:genius_project/core/models/coordinate.dart';

import '../logic/combo.dart';
import '../logic/four_cell_line_catalog.dart';
import '../logic/hand_evaluator.dart';
import '../logic/player_draft_manager.dart';
import '../models/matrix_grid_model.dart';

/// Strategy interface for a **single-player AI** opponent in Matrix Poker 25.
///
/// Implementations map one method per game phase. All calls are asynchronous
/// so agents may simulate latency, run isolates, or call remote models later.
abstract class MatrixPokerAiAgent {
  const MatrixPokerAiAgent();

  static final List<List<Coordinate>> allLines = allValidFourCellLines();

  /// **Phase 1** — After a shared dealer draw, choose where to place [drawnNumber]
  /// on this agent’s own board.
  ///
  /// [myGrid] is the AI’s current 5×5 grid (`0` = empty). The returned
  /// [Coordinate] must refer to an empty cell at call time; invalid choices are
  /// rejected by the game loop (callers should validate or retry).
  Future<Coordinate> placeNumber(MatrixGridModel myGrid, int drawnNumber);

  /// **Phase 2** — After the board is full, return exactly **12** legal line
  /// combos evaluated on [myGrid].
  ///
  /// The list is the AI’s full draft set in submission order (or any order the
  /// host will normalize before duel wiring).
  Future<List<Combo>> draftCombos(MatrixGridModel myGrid) async {
    final combos = computeAllDraftCombos(myGrid)..sort(compareStrongestFirst);

    if (combos.length < PlayerDraftManager.maxDrafts) {
      throw StateError(
        'MatrixPokerAiAgent.draftCombos: only ${combos.length} distinct valid combos.',
      );
    }
    return combos.take(PlayerDraftManager.maxDrafts).toList();
  }

  /// **Phase 3** — Given the current duel [round] (e.g. `1..12`), this agent’s
  /// still-available combos, and everything revealed about the human so far,
  /// return the **index into [myRemainingCombos]** of the combo to commit this
  /// turn.
  ///
  /// [opponentHistory] is the sequence of combos the opponent has already played
  /// (oldest first, or as defined by the host). [opponentGrid] is the human’s
  /// filled board — exposed for stronger agents that infer possible remaining
  /// lines (card-counting / lookahead).
  Future<int> playCombo(
    int round,
    List<Combo> myRemainingCombos,
    List<Combo> opponentHistory,
    MatrixGridModel opponentGrid,
  );
}

List<Combo> computeAllDraftCombos(MatrixGridModel grid) {
  final combos = <Combo>[];
  final seen = <String>{};
  for (final line in MatrixPokerAiAgent.allLines) {
    final combo = tryBuildCombo(grid, line);
    if (combo == null) continue;
    final key = comboKey(combo);
    if (!seen.add(key)) continue;
    combos.add(combo);
  }
  return combos;
}

Combo? tryBuildCombo(MatrixGridModel grid, List<Coordinate> line) {
  final ordered = PlayerDraftManager.readingOrder(line);
  final numbers = <int>[];

  for (final c in ordered) {
    final v = grid.getNumberAt(c);
    if (v == 0) return null;
    numbers.add(v);
  }

  final e = HandEvaluator.evaluate(numbers);
  return Combo(
    coordinates: ordered,
    numbers: numbers,
    rank: e.rank,
    primaryKeyValue: e.primaryKeyValue,
  );
}

String comboKey(Combo combo) =>
    combo.coordinates.map((c) => '${c.x}:${c.y}').join('|');

/// Stronger combo sorts **before** weaker (lower rank index, then higher primary).
int compareStrongestFirst(Combo a, Combo b) {
  final byRank = a.rank.index.compareTo(b.rank.index);
  if (byRank != 0) return byRank;
  return b.primaryKeyValue.compareTo(a.primaryKeyValue);
}
