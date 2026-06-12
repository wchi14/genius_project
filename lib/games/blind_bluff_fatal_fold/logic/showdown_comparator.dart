import '../models/blind_card.dart';

/// Result of comparing two revealed cards at showdown.
enum ShowdownOutcome {
  playerOneWins,
  playerTwoWins,
  tie,
}

/// Computes showdown winners honoring **+2 Modifier** (per-player bonus).
///
/// Rules encoded here:
/// - Any **Joker** beats any non‑joker (bonus never changes that).
/// - Two jokers **tie**.
/// - Otherwise compare `(rank + bonus)` where bonus is `0` or `2`.
///
/// Bonuses cannot change joker ordering; they apply only to numbered cards.

/// Numeric strengths top out at **rank 10 + +2 modifier = 12**.
/// This floor sits above that band so every Joker orders higher than any
/// numbered card in `_strength` comparisons.
const int _kShowdownJokerStrengthFloor = 1000;

ShowdownOutcome compareShowdown({
  required BlindCard playerOneCard,
  required BlindCard playerTwoCard,
  required bool playerOnePlusTwo,
  required bool playerTwoPlusTwo,
}) {
  final s1 = _strength(playerOneCard, playerOnePlusTwo ? 2 : 0);
  final s2 = _strength(playerTwoCard, playerTwoPlusTwo ? 2 : 0);
  if (s1 > s2) {
    return ShowdownOutcome.playerOneWins;
  }
  if (s2 > s1) {
    return ShowdownOutcome.playerTwoWins;
  }
  return ShowdownOutcome.tie;
}

/// Signed strength suitable for ordering; jokers dominate numbered cards.
int _strength(BlindCard card, int bonus) {
  if (card.isJoker) {
    return _kShowdownJokerStrengthFloor;
  }
  return card.rank + bonus;
}
