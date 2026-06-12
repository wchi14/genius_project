import 'dart:math';

import '../logic/blind_bluff_betting.dart';
import '../models/blind_card.dart';

/// Heads-up raise sizing in **big-blind (ante) multiples** — avoids uniform
/// random bumps up to full stack.
int pickRaiseBumpBbSized({
  required int chipsToCall,
  required int myChips,
  required int opponentChips,
  required int minRaise,
  required double aggressionBias,
  required Random rng,
}) {
  final bb = max(1, minRaise);
  final maxBump = myChips - chipsToCall;
  if (maxBump <= 0) {
    return 0;
  }
  if (maxBump < bb) {
    return maxBump;
  }

  final stackBb = myChips / bb;
  final maxBbMult = _maxBbMultiplier(
    stackBb: stackBb,
    facingBet: chipsToCall > 0,
  );

  final bbMults = chipsToCall == 0
      ? const <double>[1.0, 1.5, 2.0, 2.5, 3.0]
      : const <double>[1.0, 2.0, 2.5, 3.0];

  final opponentCoverBump = chipsToCall == 0
      ? opponentChips
      : chipsToCall + opponentChips;
  final effectiveMaxBump = min(maxBump, opponentCoverBump);

  final viable = <int>[];
  for (final mult in bbMults) {
    if (mult > maxBbMult) {
      continue;
    }
    final bump = max(bb, (bb * mult).round());
    if (bump >= bb && bump <= effectiveMaxBump) {
      viable.add(bump);
    }
  }

  if (viable.isEmpty) {
    if (effectiveMaxBump >= bb) {
      return effectiveMaxBump;
    }
    return maxBump;
  }

  viable.sort();

  // Shove only when very short and no smaller tier is attractive.
  if (viable.length == 1 &&
      stackBb <= 5 &&
      aggressionBias >= 0.7 &&
      effectiveMaxBump <= bb * 4) {
    return viable.single;
  }
  if (stackBb <= 4 &&
      aggressionBias >= 0.75 &&
      effectiveMaxBump <= bb * 3 &&
      rng.nextDouble() < 0.2) {
    return effectiveMaxBump;
  }

  final weights = List<double>.generate(viable.length, (i) {
    final sizeScore = viable.length <= 1 ? 0.0 : i / (viable.length - 1);
    return exp((aggressionBias.clamp(0.35, 0.9) - 0.55) * 3.2 * sizeScore);
  });

  return _weightedPick(viable, weights, rng);
}

double _maxBbMultiplier({
  required double stackBb,
  required bool facingBet,
}) {
  if (stackBb <= 10) {
    return facingBet ? 3.0 : 3.0;
  }
  if (stackBb <= 16) {
    return facingBet ? 2.5 : 2.5;
  }
  return facingBet ? 2.5 : 2.0;
}

/// Small open bluff when the visible opponent card is joker / 10.
///
/// Returns `null` if [rng] does not hit [probability] or a 1–2 BB raise is illegal.
BlindBluffBettingAction? tryPremiumVisibleBluffRaise({
  required BlindCard visibleOpponentCard,
  required int chipsToCall,
  required int myChips,
  required int opponentChips,
  required int minRaise,
  required double probability,
  required Random rng,
}) {
  final facesPremium = visibleOpponentCard.isJoker ||
      (!visibleOpponentCard.isJoker && visibleOpponentCard.rank == 10);
  if (!facesPremium || rng.nextDouble() >= probability) {
    return null;
  }

  final bb = max(1, minRaise);
  final maxBump = myChips - chipsToCall;
  if (maxBump < bb) {
    return null;
  }

  final oneBb = bb;
  final twoBb = min(bb * 2, maxBump);
  final bumps = <int>{oneBb, twoBb}.where((b) => b >= bb && b <= maxBump).toList();
  if (bumps.isEmpty) {
    return null;
  }
  bumps.sort();
  final bump = bumps[rng.nextInt(bumps.length)];
  return BlindBluffBettingAction.raise(raiseBy: bump);
}

int _weightedPick(List<int> values, List<double> weights, Random rng) {
  final total = weights.fold<double>(0, (a, b) => a + b);
  var roll = rng.nextDouble() * total;
  for (var i = 0; i < values.length; i++) {
    roll -= weights[i];
    if (roll <= 0) {
      return values[i];
    }
  }
  return values.last;
}
