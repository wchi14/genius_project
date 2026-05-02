/// Poker-style strength ordering for a **4-number** Matrix Poker 25 combo.
///
/// Declaration order matches strength: **first entry is strongest**, last is weakest.
enum HandRank {
  /// Four identical values.
  fourOfAKind,

  /// Four consecutive distinct values appearing in strict ascending **or**
  /// strict descending order (each step ±1).
  straightInOrder,

  /// Four consecutive distinct values, but not strictly ascending/descending
  /// as played (still the same integer run, e.g. `5,3,6,4`).
  straightNotInOrder,

  /// Two different pairs (pattern `aabb`, `a ≠ b`).
  twoPair,

  /// Three of one value and one kicker (`aaab`).
  threeOfAKind,

  /// Exactly one pair (`aabc` with distinct `a,b,c` aside from the pair).
  onePair,

  /// No stronger pattern matched (all distinct, non-consecutive run).
  highCard,
}
