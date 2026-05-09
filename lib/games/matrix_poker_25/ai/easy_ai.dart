import 'dart:math';

import 'package:genius_project/core/models/coordinate.dart';

import '../logic/combo.dart';
import '../models/matrix_grid_model.dart';
import 'matrix_poker_ai_agent.dart';

/// **Clueless** AI: random placement, first 12 valid lines found for drafts,
/// always plays index `0` in the remaining-combo list.
class EasyAiAgent extends MatrixPokerAiAgent {
  EasyAiAgent({Random? random}) : _rng = random ?? Random();

  final Random _rng;

  @override
  Future<Coordinate> placeNumber(MatrixGridModel myGrid, int drawnNumber) async {
    final empty = _listEmptyCells(myGrid);
    if (empty.isEmpty) {
      throw StateError('EasyAiAgent.placeNumber: no empty cells.');
    }
    return empty[_rng.nextInt(empty.length)];
  }

  @override
  Future<int> playCombo(
    int round,
    List<Combo> myRemainingCombos,
    List<Combo> opponentHistory,
    MatrixGridModel opponentGrid,
  ) async {
    if (myRemainingCombos.isEmpty) {
      throw StateError('EasyAiAgent.playCombo: no remaining combos.');
    }
    return 0;
  }
}

List<Coordinate> _listEmptyCells(MatrixGridModel grid) {
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
