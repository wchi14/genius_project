import 'dart:io';
import 'dart:math';

import 'package:genius_project/games/matrix_poker_25/ai/hard_ai.dart';
import 'package:genius_project/games/matrix_poker_25/ai/normal_ai.dart';
import 'package:genius_project/games/matrix_poker_25/logic/hand_rank.dart';
import 'package:genius_project/games/matrix_poker_25/logic/number_bag.dart';
import 'package:genius_project/games/matrix_poker_25/models/matrix_grid_model.dart';

/// Quick quality check:
/// - Fill a 5x5 grid with 25 dealer draws using an AI's `placeNumber`.
/// - Run universal `draftCombos` (top-12 best).
/// - Validate thresholds for drafted top-12.
void main(List<String> args) async {
  final trials = args.isNotEmpty ? int.tryParse(args.first) ?? 50 : 50;
  stdout.writeln('AI quality check — trials=$trials');
  stdout.writeln('Criteria: top-12 has **<=1 HighCard**.');
  stdout.writeln('          Normal: **<=3 OnePair**. Hard: **<=2 OnePair**.\n');

  await _runFor(
    'NormalAiAgent',
    trials,
    () => NormalAiAgent(),
    maxHighCard: 1,
    maxOnePair: 3,
  );
  stdout.writeln('');
  await _runFor(
    'HardAiAgent',
    trials,
    () => HardAiAgent(),
    maxHighCard: 1,
    maxOnePair: 2,
  );
}

Future<void> _runFor(
  String name,
  int trials,
  Object Function() factory,
  {required int maxHighCard, required int maxOnePair}
) async {
  var pass = 0;
  var totalHighCard = 0;
  var totalOnePair = 0;
  final rankTotals = <HandRank, int>{
    for (final r in HandRank.values) r: 0,
  };

  for (var seed = 0; seed < trials; seed++) {
    final rng = Random(seed);
    final ai = factory();
    final grid = MatrixGridModel();
    final bag = NumberBag(rng);

    for (var step = 0; step < 25; step++) {
      final drawn = bag.draw();
      final coord = await (ai as dynamic).placeNumber(grid, drawn);
      final ok = grid.placeNumber(coord, drawn);
      if (!ok) {
        throw StateError('$name invalid placement at seed=$seed step=$step');
      }
    }

    final combos = await (ai as dynamic).draftCombos(grid);
    var highCard = 0;
    var onePair = 0;
    for (final c in combos) {
      rankTotals[c.rank] = (rankTotals[c.rank] ?? 0) + 1;
      if (c.rank == HandRank.highCard) highCard++;
      if (c.rank == HandRank.onePair) onePair++;
    }
    totalHighCard += highCard;
    totalOnePair += onePair;

    final ok = highCard <= maxHighCard && onePair <= maxOnePair;
    if (ok) pass++;
  }

  stdout.writeln('== $name ==');
  stdout.writeln('Pass rate: $pass/$trials (${(pass * 100 / trials).toStringAsFixed(1)}%)');
  stdout.writeln('Avg HighCard in top-12: ${(totalHighCard / trials).toStringAsFixed(2)}');
  stdout.writeln('Avg OnePair  in top-12: ${(totalOnePair / trials).toStringAsFixed(2)}');
  stdout.writeln('Rank distribution over all drafted combos (${trials * 12} total):');
  for (final r in HandRank.values) {
    stdout.writeln('  - ${r.name.padRight(18)}: ${rankTotals[r]}');
  }
}

