import 'dart:math';

import 'package:genius_project/games/bluff_cup/models/dice_model.dart';

/// Rolls dice for a single player's cup.
abstract final class DiceRoller {
  /// Rolls [totalDice] dice with faces `1`..`6`.
  ///
  /// Exactly one die has [DiceModel.isBlind] set to `true`; the rest are
  /// `false`. Die [DiceModel.id] values are `d0`..`d{n-1}`.
  static List<DiceModel> rollCup(int totalDice, {Random? random}) {
    assert(totalDice >= 1, 'totalDice must be at least 1');

    final rng = random ?? Random();
    final blindIndex = rng.nextInt(totalDice);

    return List<DiceModel>.generate(totalDice, (index) {
      return DiceModel(
        id: 'd$index',
        faceValue: rng.nextInt(6) + 1,
        isBlind: index == blindIndex,
      );
    });
  }
}
