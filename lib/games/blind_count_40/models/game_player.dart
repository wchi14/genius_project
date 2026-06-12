/// Heads-up seats for Blind Count 40.
enum BlindPlayerId {
  p1,
  p2;

  BlindPlayerId get opponent => this == p1 ? p2 : p1;
}
