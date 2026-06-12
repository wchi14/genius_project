import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genius_project/games/bluff_cup/ai/cup_liar_ai.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_evaluator.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_match_rules.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_match_state.dart';
import 'package:genius_project/games/bluff_cup/logic/dice_roller.dart';
import 'package:genius_project/games/bluff_cup/models/bid_model.dart';
import 'package:genius_project/games/bluff_cup/models/cup_player.dart';

/// Presenter for Blind Cup: Liar's dice — best-of-seven (first to 4 round wins).
class BluffMatchCubit extends Cubit<BluffMatchState> {
  BluffMatchCubit({Random? random})
      : _random = random ?? Random(),
        super(_freshFullMatch(random: random ?? Random())) {
    scheduleMicrotask(_syncP1TurnCountdown);
  }

  static const int dicePerPlayer = BluffMatchRules.dicePerCup;

  /// Local player must bid or catch within this window or forfeit the round.
  static const int p1TurnLimitSeconds = 30;

  final Random _random;

  Timer? _p1TurnTimer;

  /// Face the AI bid with zero open dice; bailout when player raises on it.
  int? _aiPhantomMisdirectFace;

  static BluffMatchState _freshFullMatch({required Random random}) {
    final matchFirst =
        random.nextBool() ? CupPlayerId.p1 : CupPlayerId.p2;
    final opening = BluffMatchRules.openingPlayerForRound(
      roundIndex: 0,
      matchFirstPlayer: matchFirst,
    );
    return BluffMatchState(
      matchFirstPlayer: matchFirst,
      currentTurn: opening,
      p1Dice: DiceRoller.rollCup(dicePerPlayer, random: random),
      p2Dice: DiceRoller.rollCup(dicePerPlayer, random: random),
      currentBid: null,
      isShowdown: false,
      winner: null,
      p1TurnSecondsRemaining: null,
      endedByP1TimeForfeit: false,
      currentRoundIndex: 0,
      roundResults: List<CupPlayerId?>.from(BluffMatchRules.emptyRoundResults),
      matchWinner: null,
      showRoundOpenerOverlay: true,
      wildcardsActiveThisRound: true,
      playerBidsThisRound: const [],
    );
  }

  BluffMatchState _freshHandAfterRound({
    required int nextRoundIndex,
    required List<CupPlayerId?> roundResults,
    required CupPlayerId matchFirstPlayer,
  }) {
    final opening = BluffMatchRules.openingPlayerForRound(
      roundIndex: nextRoundIndex,
      matchFirstPlayer: matchFirstPlayer,
    );
    return BluffMatchState(
      matchFirstPlayer: matchFirstPlayer,
      currentTurn: opening,
      p1Dice: DiceRoller.rollCup(dicePerPlayer, random: _random),
      p2Dice: DiceRoller.rollCup(dicePerPlayer, random: _random),
      currentBid: null,
      isShowdown: false,
      winner: null,
      p1TurnSecondsRemaining: null,
      endedByP1TimeForfeit: false,
      currentRoundIndex: nextRoundIndex,
      roundResults: roundResults,
      matchWinner: null,
      showRoundOpenerOverlay: true,
      wildcardsActiveThisRound: true,
      playerBidsThisRound: const [],
    );
  }

  void _clearAiRoundMemory() {
    _aiPhantomMisdirectFace = null;
  }

  /// Runs opponent AI when it is [CupPlayerId.p2]'s turn.
  void runOpponentTurn() {
    if (state.matchWinner != null ||
        state.isShowdown ||
        state.showRoundOpenerOverlay ||
        state.currentTurn != CupPlayerId.p2) {
      return;
    }

    final action = CupLiarAi.decide(
      state,
      phantomMisdirectFace: _aiPhantomMisdirectFace,
      random: _random,
    );

    switch (action) {
      case CupAiCatch():
        _aiPhantomMisdirectFace = null;
        callCatch();
      case CupAiRaiseBid(
          :final quantity,
          :final faceValue,
          :final isPhantomMisdirect,
        ):
        if (isPhantomMisdirect) {
          _aiPhantomMisdirectFace = faceValue;
        } else {
          _aiPhantomMisdirectFace = null;
        }
        placeBid(quantity, faceValue);
    }
  }

  /// Clears the round-start “who bids first” banner; starts [p1] timer if needed.
  void dismissRoundOpenerOverlay() {
    if (!state.showRoundOpenerOverlay) {
      return;
    }
    final needsTimer = state.currentTurn == CupPlayerId.p1 &&
        !state.isShowdown &&
        state.matchWinner == null;
    emit(
      state.copyWith(
        showRoundOpenerOverlay: false,
        p1TurnSecondsRemaining:
            needsTimer ? p1TurnLimitSeconds : state.p1TurnSecondsRemaining,
      ),
    );
    _syncP1TurnCountdown();
  }

  void _cancelP1TurnTimer() {
    _p1TurnTimer?.cancel();
    _p1TurnTimer = null;
  }

  void _emitRoundResolved({
    required CupPlayerId roundWinner,
    required bool endedByP1TimeForfeit,
  }) {
    if (state.isShowdown) {
      return;
    }
    final idx =
        state.currentRoundIndex.clamp(0, BluffMatchRules.totalRounds - 1);
    final results = List<CupPlayerId?>.from(state.roundResults);
    if (idx < results.length) {
      results[idx] = roundWinner;
    }
    final p1w = BluffMatchRules.countWins(results, CupPlayerId.p1);
    final p2w = BluffMatchRules.countWins(results, CupPlayerId.p2);
    CupPlayerId? matchWinner;
    if (p1w >= BluffMatchRules.winsToWinMatch) {
      matchWinner = CupPlayerId.p1;
    } else if (p2w >= BluffMatchRules.winsToWinMatch) {
      matchWinner = CupPlayerId.p2;
    }
    emit(
      state.copyWith(
        isShowdown: true,
        winner: roundWinner,
        roundResults: results,
        matchWinner: matchWinner,
        p1TurnSecondsRemaining: null,
        endedByP1TimeForfeit: endedByP1TimeForfeit,
      ),
    );
    _cancelP1TurnTimer();
  }

  /// Starts or clears the 30s countdown when it is [CupPlayerId.p1]'s turn.
  void _syncP1TurnCountdown() {
    _cancelP1TurnTimer();

    if (isClosed) {
      return;
    }

    if (state.matchWinner != null ||
        state.isShowdown ||
        state.showRoundOpenerOverlay ||
        state.currentTurn != CupPlayerId.p1) {
      if (state.p1TurnSecondsRemaining != null) {
        emit(state.copyWith(p1TurnSecondsRemaining: null));
      }
      return;
    }

    final start = state.p1TurnSecondsRemaining ?? p1TurnLimitSeconds;
    emit(
      state.copyWith(
        p1TurnSecondsRemaining: start,
        endedByP1TimeForfeit: false,
      ),
    );

    _p1TurnTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isClosed) {
        return;
      }
      final sec = state.p1TurnSecondsRemaining;
      if (sec == null) {
        _cancelP1TurnTimer();
        return;
      }
      if (state.matchWinner != null ||
          state.isShowdown ||
          state.showRoundOpenerOverlay ||
          state.currentTurn != CupPlayerId.p1) {
        _cancelP1TurnTimer();
        return;
      }
      if (sec <= 1) {
        _cancelP1TurnTimer();
        _emitRoundResolved(
          roundWinner: CupPlayerId.p2,
          endedByP1TimeForfeit: true,
        );
        return;
      }
      emit(state.copyWith(p1TurnSecondsRemaining: sec - 1));
    });
  }

  /// Raises the bid if legal; passes [currentTurn] to the opponent.
  void placeBid(int quantity, int faceValue) {
    if (state.matchWinner != null ||
        state.isShowdown ||
        state.showRoundOpenerOverlay) {
      return;
    }
    if (!BluffEvaluator.isValidNextBid(
      currentBid: state.currentBid,
      newQuantity: quantity,
      newFaceValue: faceValue,
    )) {
      return;
    }

    final wildOff = faceValue == 1;
    final bid = BidModel(
      playerId: state.currentTurn,
      quantity: quantity,
      faceValue: faceValue,
    );
    final playerBids = state.currentTurn == CupPlayerId.p1
        ? [...state.playerBidsThisRound, bid]
        : state.playerBidsThisRound;
    emit(
      state.copyWith(
        currentBid: bid,
        currentTurn: state.currentTurn.opponent,
        p1TurnSecondsRemaining: null,
        endedByP1TimeForfeit: false,
        wildcardsActiveThisRound:
            wildOff ? false : state.wildcardsActiveThisRound,
        playerBidsThisRound: playerBids,
      ),
    );

    _syncP1TurnCountdown();
  }

  /// [currentTurn] calls catch on [currentBid]; resolves winner from all dice.
  void callCatch() {
    if (state.matchWinner != null ||
        state.isShowdown ||
        state.showRoundOpenerOverlay) {
      return;
    }
    final bid = state.currentBid;
    if (bid == null) {
      return;
    }

    final caller = state.currentTurn;
    final result = BluffEvaluator.calculateShowdown(
      finalBid: bid,
      p1Dice: state.p1Dice,
      p2Dice: state.p2Dice,
      wildcardsActiveThisRound: state.wildcardsActiveThisRound,
    );
    final roundWinner = result.bidderWon ? bid.playerId : caller;

    _emitRoundResolved(
      roundWinner: roundWinner,
      endedByP1TimeForfeit: false,
    );
  }

  /// After a round or match: new hand, or full reset if the match just ended.
  void nextRound() {
    _cancelP1TurnTimer();
    _clearAiRoundMemory();
    final s = state;
    if (s.matchWinner != null) {
      emit(_freshFullMatch(random: _random));
      _syncP1TurnCountdown();
      return;
    }
    if (!s.isShowdown) {
      return;
    }
    final nextIndex = s.currentRoundIndex + 1;
    if (nextIndex > BluffMatchRules.totalRounds - 1) {
      emit(_freshFullMatch(random: _random));
      _syncP1TurnCountdown();
      return;
    }
    emit(
      _freshHandAfterRound(
        nextRoundIndex: nextIndex,
        roundResults: List<CupPlayerId?>.from(s.roundResults),
        matchFirstPlayer: s.matchFirstPlayer,
      ),
    );
    _syncP1TurnCountdown();
  }

  @override
  Future<void> close() {
    _cancelP1TurnTimer();
    return super.close();
  }
}
