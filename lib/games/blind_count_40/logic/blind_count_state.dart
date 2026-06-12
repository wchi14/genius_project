import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:genius_project/games/blind_count_40/models/block_model.dart';
import 'package:genius_project/games/blind_count_40/models/game_player.dart';
import 'package:genius_project/games/blind_count_40/models/opponent_slot_ui.dart';

part 'blind_count_state.freezed.dart';

/// Skill ids tracked in [BlindCountState.p1UsedSkills] / [BlindCountState.p2UsedSkills].
///
/// Each skill is **one-off per player per match**. At most **one** skill may be
/// used on a given turn ([BlindCountState.hasUsedSkillThisTurn]).
abstract final class BlindCountSkillId {
  static const sum = 'sum';
  static const radar = 'radar';
  static const bloat = 'bloat';

  static const String labelSum = 'Sum';
  static const String labelDuplicate = 'Duplicate';
  static const String labelAddBlock = 'Add Block';
}

/// Snapshot safe for hub UI — never exposes hidden opponent values.
class BlindCountUiSnapshot {
  const BlindCountUiSnapshot({
    required this.currentTurn,
    required this.p1Blocks,
    required this.opponentSlots,
    required this.p1Score,
    required this.p2Score,
    required this.currentTurnComboScore,
    required this.poolRemaining,
    required this.isSumRevealed,
    required this.p1UsedSkills,
    required this.p2UsedSkills,
    required this.isGameOver,
    required this.turnRemainingSeconds,
    this.activeSkillNotification,
    this.skillResultData,
    this.skillPeekRemainingSeconds,
    this.lastGuessFeedback,
    this.p1HandSumWhenPoolEmpty,
    this.p2HandSumWhenPoolEmpty,
    required this.canGiveBlockThisTurn,
    required this.canStopGuessing,
    required this.hasGuessedThisTurn,
    this.skillUsedBy,
    required this.showSkillIntelToLocalPlayer,
  });

  final BlindPlayerId currentTurn;
  final List<BlockModel> p1Blocks;
  final List<OpponentSlotUi> opponentSlots;
  final int p1Score;
  final int p2Score;
  final int currentTurnComboScore;
  final int poolRemaining;
  final bool isSumRevealed;
  final List<String> p1UsedSkills;
  final List<String> p2UsedSkills;
  final bool isGameOver;
  final int turnRemainingSeconds;
  final String? activeSkillNotification;
  final String? skillResultData;
  final BlindPlayerId? skillUsedBy;
  final int? skillPeekRemainingSeconds;
  final BlindCountGuessFeedback? lastGuessFeedback;

  /// Set when [poolRemaining] is 0 — both hand totals shown.
  final int? p1HandSumWhenPoolEmpty;
  final int? p2HandSumWhenPoolEmpty;
  final bool canGiveBlockThisTurn;
  final bool canStopGuessing;
  final bool hasGuessedThisTurn;
  final bool showSkillIntelToLocalPlayer;

  int get p2BlockCount => opponentSlots.length;
}

/// Full match snapshot (local seat is always [BlindPlayerId.p1]).
@freezed
class BlindCountState with _$BlindCountState {
  const BlindCountState._();

  const factory BlindCountState({
    required BlindPlayerId currentTurn,
    required List<BlockModel> p1Blocks,
    required int p2BlockCount,
    required List<BlockModel> hiddenP2Blocks,
    required int p1Score,
    required int p2Score,
    required int currentTurnComboScore,
    required int poolRemaining,
    required bool isSumRevealed,
    required List<String> p1UsedSkills,
    @Default(<String>[]) List<String> p2UsedSkills,
    required bool isGameOver,
    required int turnRemainingSeconds,
    String? activeSkillNotification,
    String? skillResultData,
    BlindPlayerId? skillUsedBy,
    int? skillPeekRemainingSeconds,
    BlindCountGuessFeedback? lastGuessFeedback,
    @Default(<String>{}) Set<String> revealedP2BlockIds,
    @Default(false) bool isResolvingGuess,
    @Default(false) bool hasGuessedThisTurn,
    @Default(false) bool hasUsedSkillThisTurn,
  }) = _BlindCountState;

  /// Add block only before the first guess of a turn.
  bool get canGiveBlockThisTurn => !hasGuessedThisTurn;

  /// After a correct guess, the active player may stop and end the turn.
  bool get canStopGuessing =>
      hasGuessedThisTurn && currentTurnComboScore > 0 && !isResolvingGuess;

  bool get isSkillPeekActive =>
      skillPeekRemainingSeconds != null && skillPeekRemainingSeconds! > 0;

  /// Private intel overlay — only when local player (P1) used the skill.
  bool get showSkillIntelToLocalPlayer =>
      isSkillPeekActive &&
      skillUsedBy == BlindPlayerId.p1 &&
      skillResultData != null;

  bool get isPoolEmpty => poolRemaining == 0;

  /// Cleared to zero blocks while the dealer cannot refill anyone.
  bool get isTerminalNoRefill =>
      isPoolEmpty && (p1Blocks.isEmpty || hiddenP2Blocks.isEmpty);

  /// Seat cleared with an empty dealer pool (match should end).
  BlindPlayerId? get clearedSeatWhenPoolEmpty {
    if (!isPoolEmpty) return null;
    if (p1Blocks.isEmpty) return BlindPlayerId.p1;
    if (hiddenP2Blocks.isEmpty) return BlindPlayerId.p2;
    return null;
  }

  /// Winner when [isTerminalNoRefill] — the player who still has blocks.
  BlindPlayerId? get matchWinner {
    final cleared = clearedSeatWhenPoolEmpty;
    if (cleared == null) return null;
    return cleared.opponent;
  }

  BlindCountState endedIfNoRefill() {
    if (!isTerminalNoRefill) return this;
    return copyWith(isGameOver: true, isSumRevealed: true, poolRemaining: 0);
  }

  List<String> _usedSkillsFor(BlindPlayerId seat) =>
      seat == BlindPlayerId.p1 ? p1UsedSkills : p2UsedSkills;

  /// Whether [seat] may activate [skillId] now (their turn, not spent, none yet this turn).
  bool canUseSkill(
    BlindPlayerId seat,
    String skillId, {
    bool allowDuringSkillPeek = false,
  }) {
    if (isGameOver || isResolvingGuess) return false;
    if (!allowDuringSkillPeek && isSkillPeekActive) return false;
    if (currentTurn != seat) return false;
    if (hasUsedSkillThisTurn) return false;
    return !_usedSkillsFor(seat).contains(skillId);
  }

  int get p1HandSum =>
      p1Blocks.fold<int>(0, (sum, block) => sum + block.value);

  int get p2HandSum =>
      hiddenP2Blocks.fold<int>(0, (sum, block) => sum + block.value);

  List<OpponentSlotUi> buildOpponentSlots() => [
        for (final block in hiddenP2Blocks)
          OpponentSlotUi(
            id: block.id,
            isRevealed: revealedP2BlockIds.contains(block.id),
            value: revealedP2BlockIds.contains(block.id) ? block.value : null,
          ),
      ];

  BlindCountUiSnapshot toUiSnapshot() => BlindCountUiSnapshot(
        currentTurn: currentTurn,
        p1Blocks: p1Blocks,
        opponentSlots: buildOpponentSlots(),
        p1Score: p1Score,
        p2Score: p2Score,
        currentTurnComboScore: currentTurnComboScore,
        poolRemaining: poolRemaining,
        isSumRevealed: isSumRevealed,
        p1UsedSkills: p1UsedSkills,
        p2UsedSkills: p2UsedSkills,
        isGameOver: isGameOver,
        turnRemainingSeconds: turnRemainingSeconds,
        activeSkillNotification: activeSkillNotification,
        skillResultData: skillResultData,
        skillUsedBy: skillUsedBy,
        skillPeekRemainingSeconds: skillPeekRemainingSeconds,
        lastGuessFeedback: lastGuessFeedback,
        p1HandSumWhenPoolEmpty: isPoolEmpty ? p1HandSum : null,
        p2HandSumWhenPoolEmpty: isPoolEmpty ? p2HandSum : null,
        canGiveBlockThisTurn: canGiveBlockThisTurn,
        canStopGuessing: canStopGuessing,
        hasGuessedThisTurn: hasGuessedThisTurn,
        showSkillIntelToLocalPlayer: showSkillIntelToLocalPlayer,
      );
}
