import 'package:genius_project/games/sniper_poker/models/sniper_player_id.dart';

/// Chip awards when a hand ends (stacks exclude the pot; awards come from [currentPot]).
class SniperPotAward {
  const SniperPotAward({
    required this.p1Award,
    required this.p2Award,
    required this.matchedPot,
  });

  final int p1Award;
  final int p2Award;
  final int matchedPot;
}

/// Heads-up pot split with short-stack / side-pot style refunds.
class SniperPotSettlement {
  SniperPotSettlement._();

  /// How much each seat receives from the pot when [winner] takes the contested portion.
  static SniperPotAward awardToWinner({
    required int p1Investment,
    required int p2Investment,
    required SniperPlayerId winner,
  }) {
    final matched = p1Investment < p2Investment ? p1Investment : p2Investment;
    final p1Extra = p1Investment - matched;
    final p2Extra = p2Investment - matched;
    final mainPot = matched * 2;

    return switch (winner) {
      SniperPlayerId.p1 => SniperPotAward(
          p1Award: mainPot + p1Extra,
          p2Award: p2Extra,
          matchedPot: mainPot,
        ),
      SniperPlayerId.p2 => SniperPotAward(
          p1Award: p1Extra,
          p2Award: mainPot + p2Extra,
          matchedPot: mainPot,
        ),
    };
  }

  /// Tie: return each player's investment (unmatched chips were never contested).
  static SniperPotAward awardSplit({
    required int p1Investment,
    required int p2Investment,
  }) {
    return SniperPotAward(
      p1Award: p1Investment,
      p2Award: p2Investment,
      matchedPot: (p1Investment < p2Investment ? p1Investment : p2Investment) * 2,
    );
  }
}
