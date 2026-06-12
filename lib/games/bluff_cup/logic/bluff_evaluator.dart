import 'package:genius_project/games/bluff_cup/logic/bluff_match_rules.dart';
import 'package:genius_project/games/bluff_cup/models/bid_model.dart';
import 'package:genius_project/games/bluff_cup/models/dice_model.dart';

/// Outcome of resolving a "Catch" against [finalBid].
class BluffShowdownResult {
  const BluffShowdownResult({
    required this.bidderWon,
    required this.matchingCount,
    required this.isPure,
  });

  /// `true` when the challenged bid is upheld (caller loses a die).
  final bool bidderWon;

  /// Dice that counted toward [finalBid] (all cups combined).
  final int matchingCount;

  /// `true` when the bid face is 1 (叫齋): ones are not wild.
  final bool isPure;
}

/// Bid ordering and Liar's Dice showdown counting for Blind Cup: Liar's dice.
abstract final class BluffEvaluator {
  /// Whether `(newQuantity, newFaceValue)` is a legal raise over [currentBid].
  ///
  /// With no [currentBid], any quantity ≥ 1 and face `1`..`6` is allowed.
  /// Otherwise the new bid must be strictly greater: higher quantity, or the
  /// same quantity with a higher face.
  static bool isValidNextBid({
    BidModel? currentBid,
    required int newQuantity,
    required int newFaceValue,
  }) {
    if (newQuantity < 1 || newFaceValue < 1 || newFaceValue > 6) {
      return false;
    }
    if (currentBid == null) {
      return true;
    }
    if (newQuantity > currentBid.quantity) {
      return true;
    }
    return newQuantity == currentBid.quantity &&
        newFaceValue > currentBid.faceValue;
  }

  /// Resolves a catch against [finalBid] using revealed [p1Dice] and [p2Dice].
  ///
  /// **Pure** (bid face `1`): only dice showing `1` count.
  /// **Non-pure** (faces `2`..`6`): dice showing the bid face plus all `1`s
  /// (wild). [DiceModel.isBlind] does not affect counting.
  ///
  /// The bidder wins when [matchingCount] ≥ [finalBid.quantity].
  /// How many dice in [dice] count toward a bid on [bidFace] (wild `1`s unless pure).
  static int countMatchingOnDice({
    required List<DiceModel> dice,
    required int bidFace,
    bool wildcardsActive = true,
  }) {
    final isPure = bidFace == 1;
    final useWild = wildcardsActive && !isPure;
    return _countMatchingDice(
      dice: dice,
      bidFace: bidFace,
      countOnesAsWild: useWild,
    );
  }

  /// Every legal raise over [currentBid] (quantity 1–[maxBidQuantity], face 1–6).
  static List<({int quantity, int faceValue})> legalNextBids({
    BidModel? currentBid,
    int maxQuantity = BluffMatchRules.maxBidQuantity,
  }) {
    final out = <({int quantity, int faceValue})>[];
    for (var q = 1; q <= maxQuantity; q++) {
      for (var f = 1; f <= 6; f++) {
        if (isValidNextBid(
          currentBid: currentBid,
          newQuantity: q,
          newFaceValue: f,
        )) {
          out.add((quantity: q, faceValue: f));
        }
      }
    }
    return out;
  }

  static BluffShowdownResult calculateShowdown({
    required BidModel finalBid,
    required List<DiceModel> p1Dice,
    required List<DiceModel> p2Dice,
    bool wildcardsActiveThisRound = true,
  }) {
    final isPure = finalBid.faceValue == 1;
    final matchingCount = countMatchingOnDice(
      dice: [...p1Dice, ...p2Dice],
      bidFace: finalBid.faceValue,
      wildcardsActive: wildcardsActiveThisRound,
    );

    return BluffShowdownResult(
      bidderWon: matchingCount >= finalBid.quantity,
      matchingCount: matchingCount,
      isPure: isPure,
    );
  }

  static int _countMatchingDice({
    required List<DiceModel> dice,
    required int bidFace,
    required bool countOnesAsWild,
  }) {
    if (bidFace == 1) {
      return dice.where((d) => d.faceValue == 1).length;
    }
    if (countOnesAsWild) {
      return dice
          .where((d) => d.faceValue == bidFace || d.faceValue == 1)
          .length;
    }
    return dice.where((d) => d.faceValue == bidFace).length;
  }
}
