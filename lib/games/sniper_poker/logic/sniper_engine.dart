import 'package:genius_project/games/sniper_poker/logic/poker_evaluator.dart';
import 'package:genius_project/games/sniper_poker/logic/sniper_match_state.dart';
import 'package:genius_project/games/sniper_poker/models/poker_models.dart';

/// Sniper / Shotgun hit verification for the second betting round.
class SniperEngine {
  SniperEngine._();

  /// Sniper mode: rank must match; [targetValue] must match [primaryValue]
  /// (±1 when [hasWideLens] is true).
  static bool verifySniperHit(
    HandRank targetRank,
    int targetValue,
    ParsedHand opponentHand,
    bool hasWideLens,
  ) {
    if (opponentHand.rank != targetRank) return false;

    if (hasWideLens) {
      return (targetValue - opponentHand.primaryValue).abs() <= 1;
    }
    return opponentHand.primaryValue == targetValue;
  }

  /// Shotgun mode: rank must match; card number / [primaryValue] is ignored.
  static bool verifyShotgunHit(
    HandRank targetRank,
    ParsedHand opponentHand,
  ) {
    return opponentHand.rank == targetRank;
  }

  /// Whether [hand] is eliminated by sniper — hit by the opponent and/or self-snipe.
  static bool isPlayerSniped({
    required ParsedHand hand,
    SniperRiverDeclaration? opponentDeclaration,
    SniperRiverDeclaration? ownDeclaration,
    required bool opponentWideLens,
    required bool ownWideLens,
  }) {
    if (_sniperDeclarationHits(
      opponentDeclaration,
      hand,
      opponentWideLens,
    )) {
      return true;
    }
    return _sniperDeclarationHits(ownDeclaration, hand, ownWideLens);
  }

  static bool _sniperDeclarationHits(
    SniperRiverDeclaration? declaration,
    ParsedHand hand,
    bool wideLens,
  ) {
    if (declaration == null ||
        declaration.mode != SniperModeSelection.sniper) {
      return false;
    }
    final value = declaration.targetValue;
    if (value == null) return false;
    return verifySniperHit(
      declaration.targetRank,
      value,
      hand,
      wideLens,
    );
  }
}
