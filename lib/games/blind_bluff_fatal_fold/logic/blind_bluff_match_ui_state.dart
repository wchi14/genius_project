import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/blind_card.dart';
import '../models/player_id.dart';
import 'blind_bluff_match_state.dart';
import 'blind_bluff_skills.dart';

part 'blind_bluff_match_ui_state.freezed.dart';

/// Flutter-facing union for [BlindBluffCubit] (greybox UI).
///
/// Maps from [BlindBluffSnapshot] plus presentation-only fields like timers/logs.
@freezed
class BlindBluffMatchState with _$BlindBluffMatchState {
  const factory BlindBluffMatchState.loading() = _BbLoading;

  /// Skill / “staredown” declarations before wagering begins.
  ///
  /// [awaitingIntroSequence]: UI shows ante + deal beats first; call
  /// [BlindBluffCubit.notifySkillIntroComplete] after that. Skill timer starts only then.
  const factory BlindBluffMatchState.staredownPhase({
    required int roundNumber,
    required int playerChips,
    required int opponentChips,
    required int pot,
    required int baseAnteFrozenForRound,
    required BlindCard opponentCard,

    /// Human hole card (what you hold; also what seat two “sees”).
    required BlindCard playerCard,
    required Set<BlindBluffSkill> playerSkillsRemaining,
    required Set<BlindBluffSkill> opponentSkillsRemaining,
    required bool playerLockedSkill,
    required bool opponentLockedSkill,
    required bool awaitingIntroSequence,

    /// Countdown for the first skill-phase segment (reflection); skills may be
    /// chosen during this window as well as the follow-up timer.
    required int skillReflectionSecondsRemaining,

    /// Engine is waiting on [BlindBluffCubit.notifySkillRevealAnimationComplete].
    required bool awaitingSkillRevealAnimation,
    required BlindBluffSkill? revealedPlayerSkill,
    required BlindBluffSkill? revealedOpponentSkill,
    required int secondsRemaining,
    required List<String> actionLog,

    /// Set once when the shoe recycled and ante doubled before this round.
    int? anteDoubledFrom,
    int? anteDoubledTo,
  }) = _BbStaredownPhase;

  /// Post-skill betting segment (human is always [BlindBluffPlayerId.playerOne]).
  const factory BlindBluffMatchState.bettingPhase({
    required int roundNumber,
    required int playerChips,
    required int opponentChips,
    required int pot,
    required int baseAnteFrozenForRound,
    required BlindCard opponentCard,
    required BlindCard playerCard,
    required BlindBluffBettingPublicView betting,
    required int chipsToCallPlayer,
    required bool playerHasPenaltyInsurance,
    required bool opponentHasPenaltyInsurance,
    required int secondsRemaining,
    required List<String> actionLog,
    required Set<BlindBluffSkill> playerSkillsRemaining,
    required Set<BlindBluffSkill> opponentSkillsRemaining,

    /// Chips opponent put in **beyond** matching your wager (shown ~1s in UI once).
    int? opponentRaiseNoticeChips,

    /// One-shot: show ~1s banner that opponent checked.
    required bool opponentCheckNotice,
  }) = _BbBettingPhase;

  /// Round ledger / reveal step — tap **Next Round** to call [BlindBluffMatchEngine.finishRound].
  const factory BlindBluffMatchState.showdown({
    required int roundNumber,
    required BlindBluffRoundResolution resolution,
    required int playerChips,
    required int opponentChips,
    required List<String> actionLog,

    /// True when stacks already reflect match end — UI shows hand, then summary.
    required bool matchCompletePending,
  }) = _BbShowdown;

  /// Match ended.
  const factory BlindBluffMatchState.gameOver({
    required BlindBluffPlayerId winner,
    required String reason,
    required int playerChips,
    required int opponentChips,
    BlindBluffRoundResolution? terminalRoundResolution,
    int? terminalRoundNumber,
  }) = _BbGameOver;
}
