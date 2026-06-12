/// Heads-up seats for Blind Cup: Liar's dice (1v1 Liar's Dice).
enum CupPlayerId {
  p1,
  p2;

  CupPlayerId get opponent => this == p1 ? p2 : p1;
}
