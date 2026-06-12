/// Skills usable **once per match** each, declared during the skill phase.
enum BlindBluffSkill {
  /// +2 effective strength at showdown for numbered cards (still loses to any Joker).
  plusTwoModifier,

  /// Doubles the ante chips sitting in the pot after the ante phase finishes.
  doubleBlind,

  /// Grants immunity to **Fatal Fold** penalties if the player folds later this round.
  penaltyInsurance,
}
