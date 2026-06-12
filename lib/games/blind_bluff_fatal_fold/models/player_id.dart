/// Heads-up seats for Fatal Fold.
enum BlindBluffPlayerId {
  playerOne,
  playerTwo;

  BlindBluffPlayerId get opponent =>
      this == playerOne ? playerTwo : playerOne;
}
