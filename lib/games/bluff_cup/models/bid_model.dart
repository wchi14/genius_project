import 'package:genius_project/games/bluff_cup/models/cup_player.dart';

/// A player's quantity + face bid in Liar's Dice.
class BidModel {
  BidModel({
    required this.playerId,
    required this.quantity,
    required this.faceValue,
  })  : assert(quantity >= 1, 'quantity must be at least 1'),
        assert(faceValue >= 1 && faceValue <= 6, 'faceValue must be 1..6');

  final CupPlayerId playerId;

  /// How many dice of [faceValue] the bidder claims exist (all cups).
  final int quantity;

  /// Claimed pip value (`1`..`6`).
  final int faceValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BidModel &&
          runtimeType == other.runtimeType &&
          playerId == other.playerId &&
          quantity == other.quantity &&
          faceValue == other.faceValue;

  @override
  int get hashCode => Object.hash(playerId, quantity, faceValue);

  @override
  String toString() =>
      'BidModel(${playerId.name}: $quantity × $faceValue)';
}
