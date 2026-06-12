import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_match_rules.dart';
import 'package:genius_project/games/bluff_cup/models/bid_model.dart';
import 'package:genius_project/games/bluff_cup/models/cup_player.dart';
import 'package:genius_project/games/bluff_cup/models/dice_model.dart';

part 'bluff_match_state.freezed.dart';

/// Heads-up Liar's Dice session state for Blind Cup: Liar's dice.
@freezed
class BluffMatchState with _$BluffMatchState {
  const factory BluffMatchState({
    /// Seat whose action is expected (bid or catch).
    required CupPlayerId currentTurn,

    /// Local player cup (six dice, one blind).
    required List<DiceModel> p1Dice,

    /// Opponent cup (six dice, one blind).
    required List<DiceModel> p2Dice,

    /// Latest bid this round; `null` before the first bid.
    BidModel? currentBid,

    /// `true` after [BluffMatchCubit.callCatch] until [nextRound].
    required bool isShowdown,

    /// Set when [isShowdown] is resolved; cleared on [nextRound].
    CupPlayerId? winner,

    /// Seconds left for the local player (`p1`) to act; `null` on opponent turn or after round ends.
    int? p1TurnSecondsRemaining,

    /// `true` when [winner] is [CupPlayerId.p2] because [p1] did not act in time.
    @Default(false) bool endedByP1TimeForfeit,

    /// Which round is in progress (`0`..[BluffMatchRules.totalRounds] - 1).
    @Default(0) int currentRoundIndex,

    /// Randomly chosen opener for round 1; later rounds follow [BluffMatchRules.openingPlayerForRound].
    required CupPlayerId matchFirstPlayer,

    /// Outcome per round slot; `null` = not played yet.
    @Default(BluffMatchRules.emptyRoundResults) List<CupPlayerId?> roundResults,

    /// Set when either side reaches [BluffMatchRules.winsToWinMatch] round wins.
    CupPlayerId? matchWinner,

    /// Brief banner at the start of each round showing who bids first.
    @Default(false) bool showRoundOpenerOverlay,

    /// `false` after any bid on face `1` this round (pure / 叫齋).
    @Default(true) bool wildcardsActiveThisRound,

    /// Local player's bids this round (for AI bluff reads).
    @Default(<BidModel>[]) List<BidModel> playerBidsThisRound,
  }) = _BluffMatchState;
}
