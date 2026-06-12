import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:genius_project/games/sniper_poker/logic/poker_evaluator.dart';
import 'package:genius_project/games/sniper_poker/models/poker_models.dart';
import 'package:genius_project/games/sniper_poker/models/sniper_player_id.dart';

part 'sniper_match_state.freezed.dart';

/// River-phase target declaration for one seat.
@freezed
class SniperRiverDeclaration with _$SniperRiverDeclaration {
  const factory SniperRiverDeclaration({
    required SniperModeSelection mode,
    required HandRank targetRank,
    int? targetValue,
  }) = _SniperRiverDeclaration;
}

/// Round recap shown on the brief post-hand overlay.
@freezed
class SniperShowdownSnapshot with _$SniperShowdownSnapshot {
  const factory SniperShowdownSnapshot({
    SniperPlayerId? winner,
    required ParsedHand p1Hand,
    required ParsedHand p2Hand,
    required bool jackpotAwarded,
    required int potAwarded,
    required bool shotgunHedgeApplied,
    required bool endedByFold,
    SniperPlayerId? foldedPlayer,
    required int p1ChipsEnd,
    required int p2ChipsEnd,
    required int p1ChipDelta,
    required int p2ChipDelta,
    required String p1SkillLine,
    required String p2SkillLine,
    required String p1TargetLine,
    required String p2TargetLine,
    /// Opponent's sniper successfully hit this seat's hand.
    @Default(false) bool p1SnipedLabel,
    @Default(false) bool p2SnipedLabel,
    /// Shotgun hit the winner's hand but this seat lost the pot.
    @Default(false) bool p1ShotgunLabel,
    @Default(false) bool p2ShotgunLabel,
  }) = _SniperShowdownSnapshot;
}

/// Full 1v1 match snapshot for Sniper Poker.
@freezed
class SniperMatchState with _$SniperMatchState {
  const SniperMatchState._();

  const factory SniperMatchState({
    required int p1Chips,
    required int p2Chips,
    required int p1RoundInvestment,
    required int p2RoundInvestment,
    required int currentAnte,
    required int currentRoundCount,
    required int currentPot,
    required int carryOverPot,
    required List<SniperCard> p1HoleCards,
    required List<SniperCard> p2HoleCards,
    required List<SniperCard> communityCards,
    required SniperHandPhase handPhase,
    required int p1ShotgunCooldownRounds,
    required int p2ShotgunCooldownRounds,
    String? p1ActiveSkill,
    String? p2ActiveSkill,
    required bool isGameOver,
    SniperRiverDeclaration? p1RiverDeclaration,
    SniperRiverDeclaration? p2RiverDeclaration,
    @Default(false) bool isShowdown,
    SniperShowdownSnapshot? showdownSnapshot,
    @Default('') String lastActionLog,
    @Default(<String>[]) List<String> p1UsedSkills,
    @Default(<String>[]) List<String> p2UsedSkills,
    SniperPlayerId? actingPlayer,
    @Default(0) int p1StreetBet,
    @Default(0) int p2StreetBet,
    @Default(false) bool p1ActedThisStreet,
    @Default(false) bool p2ActedThisStreet,
    @Default(false) bool p1SkillLocked,
    @Default(false) bool p2SkillLocked,
    @Default(false) bool p1SniperLocked,
    @Default(false) bool p2SniperLocked,
    SniperPlayerId? handStarter,
    SniperPlayerId? nextHandStarter,
    @Default(0) int p1ChipsAtHandStart,
    @Default(0) int p2ChipsAtHandStart,
    /// Carry-over merged into this hand's pot at deal (not in stacks).
    @Default(0) int carryInAtHandStart,
    int? p1TurnSecondsRemaining,
    @Default(false) bool showRoundStarterBanner,
    String? opponentActionBanner,
  }) = _SniperMatchState;

  bool get isBetweenHands =>
      handPhase == SniperHandPhase.betweenHands && !isGameOver && !isShowdown;

  bool get isBettingPhase =>
      handPhase == SniperHandPhase.betting1 ||
      handPhase == SniperHandPhase.betting2;

  bool get riverDealt => communityCards.length >= 4;

  bool get canP1Act {
    if (isShowdown || isGameOver || showRoundStarterBanner) return false;
    return switch (handPhase) {
      SniperHandPhase.skills =>
        !p1SkillLocked &&
        (handStarter == SniperPlayerId.p1 || p2SkillLocked),
      SniperHandPhase.betting1 || SniperHandPhase.betting2 =>
        actingPlayer == SniperPlayerId.p1,
      SniperHandPhase.sniper =>
        actingPlayer == SniperPlayerId.p1 && !p1SniperLocked,
      SniperHandPhase.betweenHands => false,
    };
  }

  int streetBetFor(SniperPlayerId player) =>
      player == SniperPlayerId.p1 ? p1StreetBet : p2StreetBet;

  int amountToCall(SniperPlayerId player) {
    final mine = streetBetFor(player);
    final theirs = streetBetFor(player.opponent);
    return (theirs - mine).clamp(0, 999999);
  }

  bool get streetBetsMatched => p1StreetBet == p2StreetBet;

  bool get bothActedThisStreet => p1ActedThisStreet && p2ActedThisStreet;

  /// Whether the current flop/river betting street can advance.
  bool get bettingStreetComplete {
    if (isAllIn(SniperPlayerId.p1) && isAllIn(SniperPlayerId.p2)) return true;
    if (isAllIn(SniperPlayerId.p2)) return p1ActedThisStreet;
    if (isAllIn(SniperPlayerId.p1)) return p2ActedThisStreet;
    return streetBetsMatched && bothActedThisStreet;
  }

  bool isAllIn(SniperPlayerId player) {
    final chips = player == SniperPlayerId.p1 ? p1Chips : p2Chips;
    final invested =
        player == SniperPlayerId.p1 ? p1RoundInvestment : p2RoundInvestment;
    return chips == 0 && invested > 0;
  }

  /// Winner when [isGameOver] (one seat busted or cannot continue).
  SniperPlayerId? get matchWinner {
    if (!isGameOver) return null;
    if (p1Chips <= 0 && p2Chips > 0) return SniperPlayerId.p2;
    if (p2Chips <= 0 && p1Chips > 0) return SniperPlayerId.p1;
    if (p1Chips > p2Chips) return SniperPlayerId.p1;
    if (p2Chips > p1Chips) return SniperPlayerId.p2;
    return null;
  }
}
