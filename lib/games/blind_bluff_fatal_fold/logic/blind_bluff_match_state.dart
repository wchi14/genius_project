import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/blind_card.dart';
import '../models/player_id.dart';
import 'blind_bluff_skills.dart';
import 'showdown_comparator.dart';

part 'blind_bluff_match_state.freezed.dart';

/// Immutable betting segment snapshot for UI / tests.
class BlindBluffBettingPublicView {
  const BlindBluffBettingPublicView({
    required this.contributionPlayerOne,
    required this.contributionPlayerTwo,
    required this.actingPlayer,
    required this.foldingPlayer,
    required this.isClosed,
    required this.minRaise,
    required this.firstToAct,
  });

  final int contributionPlayerOne;
  final int contributionPlayerTwo;
  final BlindBluffPlayerId actingPlayer;
  final BlindBluffPlayerId? foldingPlayer;
  final bool isClosed;
  final int minRaise;

  /// Who opened this betting segment (alternates each round after the first).
  final BlindBluffPlayerId firstToAct;
}

/// Detailed ledger produced once betting completes.
@freezed
class BlindBluffRoundResolution with _$BlindBluffRoundResolution {
  /// Folder forfeits the pot — optional Fatal Fold surcharge applies afterward.
  const factory BlindBluffRoundResolution.fold({
    required BlindBluffPlayerId potWinner,
    required BlindBluffPlayerId foldingPlayer,
    required BlindCard foldingPlayersCard,
    required BlindCard opponentsVisibleCard,
    required int potAwarded,
    required bool fatalFoldPenaltyApplied,
    required int fatalFoldPenaltyPaid,
  }) = _FoldResolution;

  /// Includes ties which push the entire pot into [rolledPotNextRound].
  const factory BlindBluffRoundResolution.showdown({
    required ShowdownOutcome outcome,
    required BlindCard playerOneCard,
    required BlindCard playerTwoCard,
    required bool playerOneUsedPlusTwo,
    required bool playerTwoUsedPlusTwo,
    required int potAwardedToWinner,
    /// Chips each seat matched on this street (min of the two contributions).
    required int matchedWagerPerSeat,
    required int rolledPotNextRound,
  }) = _ShowdownResolution;
}

/// Session-facing state machine output for Blind Bluff: Fatal Fold.
@freezed
class BlindBluffSnapshot with _$BlindBluffSnapshot {
  /// Between rounds — call [BlindBluffMatchEngine.beginRound].
  const factory BlindBluffSnapshot.idleBetweenRounds({
    required int completedRounds,
    required int playerOneChips,
    required int playerTwoChips,
    required int baseAnte,
    required int rolledPotCarryover,
    required Set<BlindBluffSkill> skillsRemainingPlayerOne,
    required Set<BlindBluffSkill> skillsRemainingPlayerTwo,
  }) = _IdleBetweenRounds;

  /// Waiting on skill declarations (pass counts as a submission).
  const factory BlindBluffSnapshot.skillPhase({
    required int roundNumber,
    required int playerOneChips,
    required int playerTwoChips,
    required int baseAnteFrozenForRound,
    required int potAfterAnte,
    required BlindCard visibleOpponentCardToPlayerOne,
    required BlindCard visibleOpponentCardToPlayerTwo,
    required Set<BlindBluffSkill> skillsRemainingPlayerOne,
    required Set<BlindBluffSkill> skillsRemainingPlayerTwo,
    required bool playerOneLockedChoice,
    required bool playerTwoLockedChoice,

    /// Both seats locked; UI should play a reveal animation then call
    /// [BlindBluffMatchEngine.acknowledgeSkillReveal].
    required bool awaitingSkillRevealAck,

    /// Only defined once both seats locked; `null` means skipped skills.
    required BlindBluffSkill? declaredSkillPlayerOne,
    required BlindBluffSkill? declaredSkillPlayerTwo,
  }) = _SkillPhase;

  /// Post-skill wagering segment (timer enforcement lives outside).
  const factory BlindBluffSnapshot.bettingPhase({
    required int roundNumber,
    required int playerOneChips,
    required int playerTwoChips,
    required int pot,
    required int baseAnteFrozenForRound,
    required BlindCard visibleOpponentCardToPlayerOne,
    required BlindCard visibleOpponentCardToPlayerTwo,
    required BlindBluffBettingPublicView betting,
  }) = _BettingPhase;

  /// Terminal ledger for the round — call [BlindBluffMatchEngine.finishRound].
  const factory BlindBluffSnapshot.roundResolving({
    required int roundNumber,
    required BlindBluffRoundResolution resolution,
    required int playerOneChipsAfterPot,
    required int playerTwoChipsAfterPot,
  }) = _RoundResolving;

  /// Match ended — one seat bankrupted.
  const factory BlindBluffSnapshot.matchComplete({
    required BlindBluffPlayerId winner,
    required String reason,
    required int playerOneChips,
    required int playerTwoChips,

    /// Set when [BlindBluffMatchEngine.finishRound] closed out the decisive hand.
    BlindBluffRoundResolution? terminalRoundResolution,
    int? terminalRoundNumber,
  }) = _MatchComplete;
}
