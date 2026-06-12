import '../models/blind_card.dart';

/// Fatal Fold penalty chip transfer amount.
const int fatalFoldPenaltyChips = 10;

/// Pure predicate implementing **Fatal Fold** payouts after a fold.
///
/// The folding player reveals their own card during resolution. They owe the
/// opponent [fatalFoldPenaltyChips] when **either**:
/// - they folded a **Joker**, or
/// - they folded a **10** while the opponent did **not** hold a Joker.
///
/// [hadPenaltyInsurance] mirrors the *Penalty Insurance* skill for this round.
bool owesFatalFoldPenalty({
  required BlindCard folderOwnCard,
  required BlindCard opponentVisibleCard,
  required bool hadPenaltyInsurance,
}) {
  if (hadPenaltyInsurance) {
    return false;
  }
  if (folderOwnCard.isJoker) {
    return true;
  }
  if (!folderOwnCard.isJoker &&
      folderOwnCard.rank == 10 &&
      !opponentVisibleCard.isJoker) {
    return true;
  }
  return false;
}
