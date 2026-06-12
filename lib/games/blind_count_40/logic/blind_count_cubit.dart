import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genius_project/games/blind_count_40/logic/blind_count_state.dart';
import 'package:genius_project/games/blind_count_40/logic/block_pool_manager.dart';
import 'package:genius_project/games/blind_count_40/logic/count_engine.dart';
import 'package:genius_project/games/blind_count_40/models/block_model.dart';
import 'package:genius_project/games/blind_count_40/models/game_player.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai_config.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_memory.dart';
import 'package:genius_project/games/blind_count_40/models/opponent_slot_ui.dart';

/// Thrown when [giveBlockToOpponent] would push the opponent past the cap.
class BlindCountOpponentBlockCapException implements Exception {
  BlindCountOpponentBlockCapException(this.playerId);

  final BlindPlayerId playerId;

  @override
  String toString() =>
      'BlindCountOpponentBlockCapException: opponent of $playerId already at '
      '${BlindCountCubit.maxOpponentBlocks} blocks';
}

/// Presenter for Blind Count 40 (local seat = [BlindPlayerId.p1]).
class BlindCountCubit extends Cubit<BlindCountState> {
  factory BlindCountCubit({
    BlockPoolManager? pool,
    Random? random,
    BlindPlayerId? firstPlayer,
    BlindCountOpponentAiConfig? opponentAiConfig,
  }) {
    final rng = random ?? Random();
    final manager = pool ?? BlockPoolManager(random: rng);
    final aiConfig = opponentAiConfig ?? BlindCountOpponentAiConfig.standard;
    final cubit = BlindCountCubit._(
      pool: manager,
      initial: _initialState(
        pool: manager,
        random: rng,
        firstPlayer: firstPlayer,
      ),
      opponentAi: BlindCountOpponentAi(
        config: aiConfig,
        memory: aiConfig.createMemory(),
        random: rng,
      ),
    );
    cubit._resetTurnTimer();
    return cubit;
  }

  BlindCountCubit._({
    required BlockPoolManager pool,
    required BlindCountState initial,
    required BlindCountOpponentAi opponentAi,
  })  : _pool = pool,
        _opponentAi = opponentAi,
        super(initial);

  static const int openingHandSize = 5;
  static const int maxOpponentBlocks = 8;
  static const int allClearBonus = 3;
  static const int turnLimitSeconds = 20;
  static const int skillPeekSeconds = 3;

  final BlockPoolManager _pool;
  final BlindCountOpponentAi _opponentAi;

  BlindCountOpponentMemory get _opponentMemory => _opponentAi.memory;
  Timer? _clock;
  Timer? _guessResolveTimer;
  static const Duration wrongGuessOverlayDelay = Duration(milliseconds: 1500);
  /// Time to play opponent flip reveal before blocks are removed from state.
  static const Duration correctRevealAnimDelay = Duration(milliseconds: 780);

  static BlindCountState _initialState({
    required BlockPoolManager pool,
    required Random random,
    BlindPlayerId? firstPlayer,
  }) {
    final p1 = pool.drawBlocks(openingHandSize);
    final p2 = pool.drawBlocks(openingHandSize);
    final opener = firstPlayer ??
        (random.nextBool() ? BlindPlayerId.p1 : BlindPlayerId.p2);
    return BlindCountState(
      currentTurn: opener,
      p1Blocks: p1,
      p2BlockCount: p2.length,
      hiddenP2Blocks: p2,
      p1Score: 0,
      p2Score: 0,
      currentTurnComboScore: 0,
      poolRemaining: pool.remainingCount,
      isSumRevealed: false,
      p1UsedSkills: const [],
      isGameOver: false,
      turnRemainingSeconds: turnLimitSeconds,
    );
  }

  /// Only at the start of a turn, before any guess.
  void giveBlockToOpponent() {
    if (!_canTakeMainTurnAction() || !state.canGiveBlockThisTurn) return;

    final actor = state.currentTurn;
    final opponentCount = _opponentBlockCount(actor);
    if (opponentCount >= maxOpponentBlocks) {
      throw BlindCountOpponentBlockCapException(actor);
    }

    final drawn = _drawFromPoolOrEmpty(1);
    if (drawn.isEmpty) {
      _emitPoolFlags();
      return;
    }

    final hands = _handsAfterAddingToOpponent(actor, drawn);
    emit(
      _clearSkillPeekFields(
        state.copyWith(
          p1Blocks: hands.p1,
          hiddenP2Blocks: hands.p2Hidden,
          p2BlockCount: hands.p2Hidden.length,
          poolRemaining: _pool.remainingCount,
          isSumRevealed: state.isSumRevealed || _pool.remainingCount == 0,
        ),
      ),
    );
    _endTurn(actor, refillOther: false);
  }

  /// End combo voluntarily after at least one correct guess.
  void stopGuessing() {
    if (state.isGameOver || state.isSkillPeekActive || state.isResolvingGuess) {
      return;
    }
    if (!state.canStopGuessing) return;
    _endTurn(state.currentTurn);
  }

  void guessNumber(int guessedValue) {
    if (!_canTakeMainTurnAction()) return;

    final actor = state.currentTurn;
    final opponentHand = _opponentHand(actor);
    final result = CountEngine.processGuess(opponentHand, guessedValue);
    final correct = result[CountGuessResultKeys.isCorrect]! as bool;
    final matching =
        result[CountGuessResultKeys.matchingBlocks]! as List<BlockModel>;
    final remaining =
        result[CountGuessResultKeys.remainingBlocks]! as List<BlockModel>;

    final flippedIds = matching.map((b) => b.id).toList();
    final allClear = remaining.isEmpty;

    _recordGuessObservation(
      actor: actor,
      guessedValue: guessedValue,
      correct: correct,
      matching: matching,
    );

    if (!correct) {
      final feedback = BlindCountGuessFeedback(
        guesser: actor,
        guessedValue: guessedValue,
        isCorrect: false,
        flippedBlockIds: flippedIds,
      );
      _applyWrongGuess(actor, feedback);
      return;
    }

    _guessResolveTimer?.cancel();
    var newP1Score = state.p1Score;
    var newP2Score = state.p2Score;
    final points = matching.length;
    final combo = state.currentTurnComboScore + points;

    if (actor == BlindPlayerId.p1) {
      newP1Score += points;
    } else {
      newP2Score += points;
    }

    if (allClear) {
      if (actor == BlindPlayerId.p1) {
        newP1Score += allClearBonus;
      } else {
        newP2Score += allClearBonus;
      }
    }

    final poolEmpty = _pool.remainingCount == 0;

    final feedback = BlindCountGuessFeedback(
      guesser: actor,
      guessedValue: guessedValue,
      isCorrect: true,
      matchCount: matching.length,
      flippedBlockIds: flippedIds,
      awardedAllClearBonus: allClear,
    );

    final opponentAfterRemoval = List<BlockModel>.from(remaining);

    emit(
      _clearSkillPeekFields(
        state.copyWith(
          p1Score: newP1Score,
          p2Score: newP2Score,
          currentTurnComboScore: combo,
          poolRemaining: _pool.remainingCount,
          isSumRevealed: state.isSumRevealed || poolEmpty,
          lastGuessFeedback: feedback,
          isResolvingGuess: true,
          hasGuessedThisTurn: true,
        ),
      ),
    );

    _guessResolveTimer = Timer(wrongGuessOverlayDelay, () {
      if (isClosed) return;

      // Keep `isResolvingGuess` true until blocks are actually removed; otherwise
      // the UI can schedule the next action and cancel this removal timer.
      var next = state;
      if (actor == BlindPlayerId.p1) {
        next = next.copyWith(
          revealedP2BlockIds: {
            ...state.revealedP2BlockIds,
            ...flippedIds,
          },
        );
      }
      emit(next);

      // Symmetric behaviour: correct guess removal is delayed so the UI can play
      // the vanish animation on whichever row is being reduced.
      // For P2-correct: start vanish immediately after overlay is gone.
      if (actor == BlindPlayerId.p2) {
        _emitAfterGuessResolution(
          next.copyWith(
            p1Blocks: opponentAfterRemoval,
            isResolvingGuess: false,
            poolRemaining: _pool.remainingCount,
            isSumRevealed: next.isSumRevealed || _pool.remainingCount == 0,
          ),
        );
        return;
      }

      // For P1-correct: keep a short delay to allow opponent reveal animation.
      _guessResolveTimer = Timer(correctRevealAnimDelay, () {
        if (isClosed) return;
        final hiddenP2 = opponentAfterRemoval;
        final clearedReveal =
            next.revealedP2BlockIds.difference(flippedIds.toSet());
        _emitAfterGuessResolution(
          next.copyWith(
            hiddenP2Blocks: hiddenP2,
            p2BlockCount: hiddenP2.length,
            revealedP2BlockIds: clearedReveal,
            isResolvingGuess: false,
            poolRemaining: _pool.remainingCount,
            isSumRevealed: next.isSumRevealed || _pool.remainingCount == 0,
          ),
        );
      });
    });
  }

  bool canUseP1Skill(String skillId) =>
      state.canUseSkill(BlindPlayerId.p1, skillId);

  void useSumRevealSkill() {
    if (!canUseP1Skill(BlindCountSkillId.sum)) return;
    _activateSkill(BlindPlayerId.p1, BlindCountSkillId.sum);
  }

  bool useRadarSkill() {
    if (!canUseP1Skill(BlindCountSkillId.radar)) return false;
    final hasDuplicate = _handHasDuplicateValues(state.hiddenP2Blocks);
    _activateSkill(BlindPlayerId.p1, BlindCountSkillId.radar);
    return hasDuplicate;
  }

  void useForceBloatSkill() {
    if (!canUseP1Skill(BlindCountSkillId.bloat)) return;
    _activateSkill(BlindPlayerId.p1, BlindCountSkillId.bloat);
  }

  /// Runs one P2 action from deduction AI (skill, stop, give block, or guess).
  void runOpponentTurn({Random? random}) {
    final rng = random ?? Random();
    if (state.currentTurn != BlindPlayerId.p2 ||
        state.isGameOver ||
        state.isSkillPeekActive ||
        state.isResolvingGuess) {
      return;
    }

    final action = _opponentAi.decideFromState(state, random: rng);

    switch (action) {
      case BlindCountAiUseSkill(:final skillId):
        _activateSkill(BlindPlayerId.p2, skillId);
      case BlindCountAiStopGuessing():
        stopGuessing();
      case BlindCountAiGiveBlock():
        try {
          giveBlockToOpponent();
        } on BlindCountOpponentBlockCapException {
          guessNumber(_opponentAi.pickGuessFromState(state, random: rng));
        }
      case BlindCountAiGuess(:final value):
        guessNumber(value);
    }
  }

  /// Whether the last decided action was a skill (peek in progress).
  bool get opponentSkillJustUsed => state.isSkillPeekActive;

  /// AI: may fire one unused skill at the start of P2's turn.
  @Deprecated('Use runOpponentTurn')
  bool tryOpponentSkill({Random? random}) {
    final rng = random ?? Random();
    final action = _opponentAi.decideFromState(state, random: rng);
    if (action is BlindCountAiUseSkill) {
      _activateSkill(BlindPlayerId.p2, action.skillId);
      return true;
    }
    return false;
  }

  void _activateSkill(BlindPlayerId user, String skillId) {
    if (state.isGameOver || state.isSkillPeekActive || state.isResolvingGuess) {
      return;
    }
    if (state.currentTurn != user) return;
    if (!state.canUseSkill(user, skillId)) return;

    final who = user == BlindPlayerId.p1 ? 'You' : 'Opponent';
    String notification;
    String? intel;

    switch (skillId) {
      case BlindCountSkillId.sum:
        final sum =
            user == BlindPlayerId.p1 ? state.p2HandSum : state.p1HandSum;
        notification = '$who used ${BlindCountSkillId.labelSum}';
        intel = user == BlindPlayerId.p1 ? 'Sum: $sum' : null;
        _commitSkillPeek(user, skillId, notification, intel);
      case BlindCountSkillId.radar:
        final hand = user == BlindPlayerId.p1
            ? state.hiddenP2Blocks
            : state.p1Blocks;
        final hasDuplicate = _handHasDuplicateValues(hand);
        notification = '$who used ${BlindCountSkillId.labelDuplicate}';
        intel = user == BlindPlayerId.p1
            ? 'Has Duplicates: ${hasDuplicate ? 'TRUE' : 'FALSE'}'
            : null;
        _commitSkillPeek(user, skillId, notification, intel);
      case BlindCountSkillId.bloat:
        _applyAddBlockSkill(user, skillId, who);
    }
  }

  void _applyAddBlockSkill(BlindPlayerId user, String skillId, String who) {
    final targetCount = user == BlindPlayerId.p1
        ? state.p2BlockCount
        : state.p1Blocks.length;
    if (targetCount >= maxOpponentBlocks) {
      _commitSkillPeek(
        user,
        skillId,
        '$who used ${BlindCountSkillId.labelAddBlock}',
        user == BlindPlayerId.p1 ? 'Opponent at block cap' : null,
      );
      return;
    }

    final drawn = _drawFromPoolOrEmpty(1);
    if (drawn.isEmpty) {
      emit(
        state.copyWith(
          poolRemaining: _pool.remainingCount,
          isSumRevealed: true,
        ),
      );
      _commitSkillPeek(
        user,
        skillId,
        '$who used ${BlindCountSkillId.labelAddBlock}',
        user == BlindPlayerId.p1 ? 'Pool empty — no block drawn' : null,
      );
      return;
    }

    if (user == BlindPlayerId.p1) {
      final nextHidden = [...state.hiddenP2Blocks, ...drawn];
      emit(
        state.copyWith(
          hiddenP2Blocks: nextHidden,
          p2BlockCount: nextHidden.length,
          poolRemaining: _pool.remainingCount,
          isSumRevealed: state.isSumRevealed || _pool.remainingCount == 0,
        ),
      );
    } else {
      emit(
        state.copyWith(
          p1Blocks: [...state.p1Blocks, ...drawn],
          poolRemaining: _pool.remainingCount,
          isSumRevealed: state.isSumRevealed || _pool.remainingCount == 0,
        ),
      );
    }

    _commitSkillPeek(
      user,
      skillId,
      '$who used ${BlindCountSkillId.labelAddBlock}',
      user == BlindPlayerId.p1 ? 'Opponent received +1 block' : null,
    );
  }

  void _commitSkillPeek(
    BlindPlayerId user,
    String skillId,
    String notification,
    String? intel,
  ) {
    final p1Used = user == BlindPlayerId.p1
        ? [...state.p1UsedSkills, skillId]
        : state.p1UsedSkills;
    final p2Used = user == BlindPlayerId.p2
        ? [...state.p2UsedSkills, skillId]
        : state.p2UsedSkills;

    emit(
      state.copyWith(
        p1UsedSkills: p1Used,
        p2UsedSkills: p2Used,
        hasUsedSkillThisTurn: true,
        activeSkillNotification: notification,
        skillResultData: intel,
        skillUsedBy: user,
        skillPeekRemainingSeconds: skillPeekSeconds,
      ),
    );
    _ensureClock();
  }

  @override
  Future<void> close() {
    _cancelClock();
    _guessResolveTimer?.cancel();
    return super.close();
  }

  void _resetTurnTimer() {
    if (state.isGameOver) {
      _cancelClock();
      return;
    }
    emit(
      state.copyWith(turnRemainingSeconds: turnLimitSeconds),
    );
    _ensureClock();
  }

  void _ensureClock() {
    if (_clock != null) return;
    _clock = Timer.periodic(const Duration(seconds: 1), (_) => _tickClock());
  }

  void _cancelClock() {
    _clock?.cancel();
    _clock = null;
  }

  void _tickClock() {
    if (state.isGameOver) {
      _cancelClock();
      return;
    }

    final peek = state.skillPeekRemainingSeconds;
    if (peek != null) {
      if (peek <= 1) {
        _endSkillPeek();
      } else {
        emit(state.copyWith(skillPeekRemainingSeconds: peek - 1));
      }
      return;
    }

    final remaining = state.turnRemainingSeconds;
    if (remaining <= 1) {
      _handleTurnTimeout();
      return;
    }
    emit(state.copyWith(turnRemainingSeconds: remaining - 1));
  }

  void _endSkillPeek() {
    emit(_clearSkillPeekFields(state));
    _resetTurnTimer();
  }

  void _handleTurnTimeout() {
    if (state.isGameOver || state.isSkillPeekActive) return;
    _endTurn(state.currentTurn);
  }

  void _endTurn(BlindPlayerId finishedPlayer, {bool refillOther = true}) {
    if (state.isGameOver) return;

    var next = state;
    if (refillOther) {
      next = _refillSeatToOpeningSize(next, finishedPlayer.opponent);
    }
    next = next.endedIfNoRefill();
    if (next.isGameOver) {
      _emitMatchOver(
        _clearSkillPeekFields(
          next.copyWith(
            isResolvingGuess: false,
            lastGuessFeedback: null,
          ),
        ),
      );
      return;
    }

    next = _clearSkillPeekFields(
      next.copyWith(
        currentTurn: finishedPlayer.opponent,
        currentTurnComboScore: 0,
        hasGuessedThisTurn: false,
        hasUsedSkillThisTurn: false,
        lastGuessFeedback: null,
        isResolvingGuess: false,
      ),
    );
    emit(next);
    _resetTurnTimer();
  }

  BlindCountState _refillSeatToOpeningSize(
    BlindCountState base,
    BlindPlayerId seat,
  ) {
    if (_pool.remainingCount == 0) {
      return base.copyWith(poolRemaining: 0);
    }

    if (seat == BlindPlayerId.p1) {
      final need = openingHandSize - base.p1Blocks.length;
      if (need <= 0) return base.copyWith(poolRemaining: _pool.remainingCount);
      final drawn = _drawFromPoolOrEmpty(need);
      final next = base.copyWith(
        p1Blocks: [...base.p1Blocks, ...drawn],
        poolRemaining: _pool.remainingCount,
        isSumRevealed: base.isSumRevealed || _pool.remainingCount == 0,
      );
      if (drawn.isNotEmpty) {
        _opponentMemory.clearBansOnPlayerRefill();
      }
      return next;
    }

    final need = openingHandSize - base.hiddenP2Blocks.length;
    if (need <= 0) return base.copyWith(poolRemaining: _pool.remainingCount);
    final drawn = _drawFromPoolOrEmpty(need);
    final nextHidden = [...base.hiddenP2Blocks, ...drawn];
    return base.copyWith(
      hiddenP2Blocks: nextHidden,
      p2BlockCount: nextHidden.length,
      poolRemaining: _pool.remainingCount,
      isSumRevealed: base.isSumRevealed || _pool.remainingCount == 0,
    );
  }

  void _applyWrongGuess(
    BlindPlayerId actor,
    BlindCountGuessFeedback feedback,
  ) {
    var newP1 = state.p1Score;
    var newP2 = state.p2Score;
    if (state.currentTurnComboScore > 0) {
      if (actor == BlindPlayerId.p1) {
        newP1 = max(0, newP1 - 1);
      } else {
        newP2 = max(0, newP2 - 1);
      }
    }

    emit(
      _clearSkillPeekFields(
        state.copyWith(
          p1Score: newP1,
          p2Score: newP2,
          lastGuessFeedback: feedback,
          isResolvingGuess: true,
          hasGuessedThisTurn: true,
        ),
      ),
    );

    _guessResolveTimer?.cancel();
    _guessResolveTimer = Timer(wrongGuessOverlayDelay, () {
      if (isClosed) return;
      // AI: if the dealer cannot refill (pool empty), don't re-guess this value
      // until the human row gains a new block again.
      if (actor == BlindPlayerId.p2 && state.poolRemaining == 0) {
        _opponentMemory.banUntilPlayerRefill(feedback.guessedValue);
      }
      _endTurn(actor);
    });
  }

  bool _canTakeMainTurnAction() =>
      !state.isGameOver &&
      !state.isSkillPeekActive &&
      !state.isResolvingGuess;

  BlindCountState _clearSkillPeekFields(BlindCountState s) => s.copyWith(
        activeSkillNotification: null,
        skillResultData: null,
        skillUsedBy: null,
        skillPeekRemainingSeconds: null,
      );

  void _emitAfterGuessResolution(BlindCountState next) {
    final ended = next.endedIfNoRefill();
    if (ended.isGameOver) {
      _emitMatchOver(ended);
      return;
    }
    emit(ended);
  }

  void _emitMatchOver(BlindCountState next) {
    emit(next);
    _cancelClock();
    _guessResolveTimer?.cancel();
  }

  List<BlockModel> _opponentHand(BlindPlayerId actor) =>
      actor == BlindPlayerId.p1 ? state.hiddenP2Blocks : state.p1Blocks;

  int _opponentBlockCount(BlindPlayerId actor) =>
      actor == BlindPlayerId.p1 ? state.p2BlockCount : state.p1Blocks.length;

  ({List<BlockModel> p1, List<BlockModel> p2Hidden}) _handsAfterAddingToOpponent(
    BlindPlayerId actor,
    List<BlockModel> blocks,
  ) {
    if (actor == BlindPlayerId.p1) {
      final nextHidden = [...state.hiddenP2Blocks, ...blocks];
      return (p1: state.p1Blocks, p2Hidden: nextHidden);
    }
    return (p1: [...state.p1Blocks, ...blocks], p2Hidden: state.hiddenP2Blocks);
  }

  List<BlockModel> _drawFromPoolOrEmpty(int count) {
    if (count <= 0 || _pool.remainingCount == 0) return const [];
    final toDraw = min(count, _pool.remainingCount);
    return _pool.drawBlocks(toDraw);
  }

  void _emitPoolFlags() {
    emit(
      state.copyWith(
        poolRemaining: _pool.remainingCount,
        isSumRevealed: state.isSumRevealed || _pool.remainingCount == 0,
      ),
    );
  }

  void _recordGuessObservation({
    required BlindPlayerId actor,
    required int guessedValue,
    required bool correct,
    required List<BlockModel> matching,
  }) {
    if (actor == BlindPlayerId.p1) {
      _opponentMemory.recordPlayerGuess(
        value: guessedValue,
        wasCorrect: correct,
        matchCount: matching.length,
      );
      if (correct) {
        _opponentMemory.recordRevealedFromOwnHand(matching);
      }
    } else {
      _opponentMemory.recordOwnGuess(
        value: guessedValue,
        wasCorrect: correct,
        matchCount: matching.length,
      );
      if (correct) {
        _opponentMemory.recordRevealedFromPlayerHand(matching);
      }
    }
  }

  static bool _handHasDuplicateValues(List<BlockModel> hand) {
    final seen = <int>{};
    for (final block in hand) {
      if (!seen.add(block.value)) return true;
    }
    return false;
  }
}
