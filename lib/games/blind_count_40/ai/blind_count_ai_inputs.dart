import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_memory.dart';
import 'package:genius_project/games/blind_count_40/logic/blind_count_state.dart';
import 'package:genius_project/games/blind_count_40/models/block_model.dart';
import 'package:genius_project/games/blind_count_40/models/game_player.dart';

/// Legal PvE data inputs for [BlindCountOpponentAi] (no hidden player values).
class BlindCountAiInputs {
  /// Upper bound for [playerBlockCount] (add-block cap).
  static const int maxPlayerBlockCount = 8;

  BlindCountAiInputs({
    required List<BlockModel> aiHand,
    required int playerBlockCount,
    required List<BlindCountMemoryPoolBlock> memoryPool,
    this.playerLastGuess,
    this.playerHandSumRevealed,
    required this.poolRemaining,
    required this.currentTurnComboScore,
    required this.turnRemainingSeconds,
    required this.canStopGuessing,
    required this.canGiveBlockThisTurn,
    required this.hasUsedSkillThisTurn,
    required this.isGameOver,
    required this.isSkillPeekActive,
    required this.isResolvingGuess,
    required this.isP2Turn,
    required this.canUseSumSkill,
    required this.canUseRadarSkill,
    required this.canUseBloatSkill,
  })  : aiHand = List.unmodifiable(aiHand),
        playerBlockCount = _clampPlayerBlockCount(playerBlockCount),
        memoryPool = List.unmodifiable(memoryPool);

  /// `ai_hand` — blocks currently hidden in front of the AI (values known).
  final List<BlockModel> aiHand;

  /// `player_block_count` — how many blocks sit in front of the human (1–8 in
  /// normal play; **0** if they were cleared). Block **values** are not exposed.
  final int playerBlockCount;

  bool get isPlayerBlockCap => playerBlockCount >= maxPlayerBlockCount;

  /// `memory_pool` — sliding window of the last blocks revealed/discarded
  /// (max [BlindCountOpponentMemory.memoryPoolSize], default 10).
  final List<BlindCountMemoryPoolBlock> memoryPool;

  /// `player_last_guess` — the number the human guessed last (1–10), or null
  /// before their first guess this match.
  final int? playerLastGuess;

  /// When the dealer pool is empty and sum is revealed to both players, this is
  /// the human player's (P1) hand sum. Otherwise null.
  final int? playerHandSumRevealed;

  static int _clampPlayerBlockCount(int count) {
    if (count < 0) return 0;
    if (count > maxPlayerBlockCount) return maxPlayerBlockCount;
    return count;
  }

  final int poolRemaining;
  final int currentTurnComboScore;
  final int turnRemainingSeconds;
  final bool canStopGuessing;
  final bool canGiveBlockThisTurn;
  final bool hasUsedSkillThisTurn;
  final bool isGameOver;
  final bool isSkillPeekActive;
  final bool isResolvingGuess;
  final bool isP2Turn;
  final bool canUseSumSkill;
  final bool canUseRadarSkill;
  final bool canUseBloatSkill;

  /// Values 1–10 present in [aiHand].
  Set<int> get aiHandValues => aiHand.map((b) => b.value).toSet();

  factory BlindCountAiInputs.fromState(BlindCountState state) {
    return BlindCountAiInputs.fromTable(
      state: state,
      memory: BlindCountOpponentMemory(),
    );
  }

  factory BlindCountAiInputs.fromTable({
    required BlindCountState state,
    required BlindCountOpponentMemory memory,
  }) {
    return BlindCountAiInputs(
      aiHand: state.hiddenP2Blocks,
      playerBlockCount: state.p1Blocks.length,
      memoryPool: memory.memoryPool,
      playerLastGuess: memory.playerLastGuess,
      playerHandSumRevealed:
          state.poolRemaining == 0 && state.isSumRevealed ? state.p1HandSum : null,
      poolRemaining: state.poolRemaining,
      currentTurnComboScore: state.currentTurnComboScore,
      turnRemainingSeconds: state.turnRemainingSeconds,
      canStopGuessing: state.canStopGuessing,
      canGiveBlockThisTurn: state.canGiveBlockThisTurn,
      hasUsedSkillThisTurn: state.hasUsedSkillThisTurn,
      isGameOver: state.isGameOver,
      isSkillPeekActive: state.isSkillPeekActive,
      isResolvingGuess: state.isResolvingGuess,
      isP2Turn: state.currentTurn == BlindPlayerId.p2,
      canUseSumSkill:
          state.canUseSkill(BlindPlayerId.p2, BlindCountSkillId.sum),
      canUseRadarSkill:
          state.canUseSkill(BlindPlayerId.p2, BlindCountSkillId.radar),
      canUseBloatSkill:
          state.canUseSkill(BlindPlayerId.p2, BlindCountSkillId.bloat),
    );
  }
}
