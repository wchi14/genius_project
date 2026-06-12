import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genius_project/games/sniper_poker/logic/poker_evaluator.dart';
import 'package:genius_project/games/sniper_poker/logic/sniper_deck.dart';
import 'package:genius_project/games/sniper_poker/logic/sniper_engine.dart';
import 'package:genius_project/games/sniper_poker/ai/sniper_opponent_ai.dart';
import 'package:genius_project/games/sniper_poker/logic/sniper_match_state.dart';
import 'package:genius_project/games/sniper_poker/logic/sniper_pot_settlement.dart';
import 'package:genius_project/games/sniper_poker/models/poker_models.dart';
import 'package:genius_project/games/sniper_poker/models/sniper_player_id.dart';

/// Presenter for heads-up Sniper Poker (skills → flop bet → river bet → sniper).
class SniperMatchCubit extends Cubit<SniperMatchState> {
  SniperMatchCubit({Random? random, SniperOpponentAi? opponentAi})
      : _random = random ?? Random(),
        _deck = SniperDeck(random: random),
        _opponentAi = opponentAi ?? SniperOpponentAi(random: random),
        super(_initialMatchState());

  static const int startingChips = 50;
  static const int startingAnte = 1;
  static const int jackpotBonus = 10;
  static const int shotgunCooldownAfterUse = 2;
  static const int roundsPerAnteDouble = 10;
  static const int minRaise = 1;
  static const int p1TurnLimitSeconds = 15;

  static const String skillKevlar = 'kevlar';
  static const String skillFlashbang = 'flashbang';
  static const String skillLens = 'lens';

  final Random _random;
  final SniperDeck _deck;
  final SniperOpponentAi _opponentAi;
  Timer? _p1TurnTimer;
  Timer? _bannerClearTimer;

  static SniperMatchState _initialMatchState() {
    return const SniperMatchState(
      p1Chips: startingChips,
      p2Chips: startingChips,
      p1RoundInvestment: 0,
      p2RoundInvestment: 0,
      currentAnte: startingAnte,
      currentRoundCount: 0,
      currentPot: 0,
      carryOverPot: 0,
      p1HoleCards: [],
      p2HoleCards: [],
      communityCards: [],
      handPhase: SniperHandPhase.betweenHands,
      p1ShotgunCooldownRounds: 0,
      p2ShotgunCooldownRounds: 0,
      isGameOver: false,
      lastActionLog: '',
    );
  }

  @override
  Future<void> close() {
    _cancelP1TurnTimer();
    _bannerClearTimer?.cancel();
    return super.close();
  }

  /// Executes a one-off tactical skill for the local player (P1).
  void executeSkill(String skillId) {
    _executeSkill(SniperPlayerId.p1, skillId);
  }

  void passSkill() {
    if (state.handPhase != SniperHandPhase.skills || state.p1SkillLocked) return;
    if (state.handStarter == SniperPlayerId.p2 && !state.p2SkillLocked) return;
    emit(state.copyWith(p1SkillLocked: true));
    if (state.handStarter == SniperPlayerId.p1) {
      _resolveOpponentSkillPhase();
    } else {
      _advanceFromSkills();
    }
    _syncP1TurnTimer();
  }

  void passSniper() {
    if (state.handPhase != SniperHandPhase.sniper) return;
    if (state.actingPlayer != SniperPlayerId.p1 || state.p1SniperLocked) return;
    emit(
      state.copyWith(
        p1SniperLocked: true,
        lastActionLog: 'You passed on targeting.',
      ),
    );
    _afterSniperChoice(SniperPlayerId.p1);
    _syncP1TurnTimer();
  }

  /// Called by UI after the round-starter banner is shown (~2s).
  /// Clears the post-hand recap (e.g. before showing match game over).
  void dismissHandRecap() {
    if (!state.isShowdown) return;
    emit(
      state.copyWith(
        isShowdown: false,
        showdownSnapshot: null,
      ),
    );
  }

  void dismissRoundStarterBanner() {
    if (!state.showRoundStarterBanner) return;
    emit(state.copyWith(showRoundStarterBanner: false));
    _runOpponentIfNeeded();
    _syncP1TurnTimer();
  }

  void _executeSkill(SniperPlayerId player, String skillId) {
    if (state.handPhase != SniperHandPhase.skills) return;
    if (skillId != skillKevlar &&
        skillId != skillFlashbang &&
        skillId != skillLens) {
      return;
    }

    if (player == SniperPlayerId.p1 && state.p1SkillLocked) return;
    if (player == SniperPlayerId.p2 && state.p2SkillLocked) return;
    if (player == SniperPlayerId.p1 &&
        state.handStarter == SniperPlayerId.p2 &&
        !state.p2SkillLocked) {
      return;
    }

    final used = player == SniperPlayerId.p1
        ? state.p1UsedSkills
        : state.p2UsedSkills;
    if (used.contains(skillId)) return;

    final nextUsed = [...used, skillId];
    emit(
      switch (player) {
        SniperPlayerId.p1 => state.copyWith(
            p1ActiveSkill: skillId,
            p1UsedSkills: nextUsed,
            p1SkillLocked: true,
            lastActionLog: 'You deployed ${_skillLabel(skillId)}.',
          ),
        SniperPlayerId.p2 => state.copyWith(
            p2ActiveSkill: skillId,
            p2UsedSkills: nextUsed,
            p2SkillLocked: true,
            lastActionLog: 'Opponent deployed ${_skillLabel(skillId)}.',
            opponentActionBanner: 'Opponent used ${_skillLabel(skillId)}',
          ),
      },
    );
    _scheduleBannerClear();

    if (player == SniperPlayerId.p1) {
      if (state.handStarter == SniperPlayerId.p1) {
        _resolveOpponentSkillPhase();
      } else {
        _advanceFromSkills();
      }
    } else {
      _advanceFromSkills();
    }
    _syncP1TurnTimer();
  }

  void startNewHand() {
    if (state.isGameOver) return;
    if (!state.isBetweenHands && !state.isShowdown) return;
    if (state.p1Chips <= 0 || state.p2Chips <= 0) {
      _emitGameOver();
      return;
    }

    final carryIn = state.carryOverPot;
    final ante = state.currentAnte;
    final p1Post = state.p1Chips < ante ? state.p1Chips : ante;
    final p2Post = state.p2Chips < ante ? state.p2Chips : ante;
    if (p1Post <= 0 || p2Post <= 0) {
      _emitGameOver();
      return;
    }
    final pot = p1Post + p2Post + carryIn;

    final p1Cooldown = state.p1ShotgunCooldownRounds > 0
        ? state.p1ShotgunCooldownRounds - 1
        : 0;
    final p2Cooldown = state.p2ShotgunCooldownRounds > 0
        ? state.p2ShotgunCooldownRounds - 1
        : 0;

    if (_deck.remaining < 8) {
      _deck.reshuffle();
    }

    final starter = state.nextHandStarter ??
        (_random.nextBool() ? SniperPlayerId.p1 : SniperPlayerId.p2);
    final p1AfterAnte = state.p1Chips - p1Post;
    final p2AfterAnte = state.p2Chips - p2Post;

    emit(
      SniperMatchState(
        p1Chips: p1AfterAnte,
        p2Chips: p2AfterAnte,
        p1RoundInvestment: p1Post,
        p2RoundInvestment: p2Post,
        currentAnte: state.currentAnte,
        currentRoundCount: state.currentRoundCount,
        currentPot: pot,
        carryOverPot: 0,
        p1HoleCards: _deck.draw(2),
        p2HoleCards: _deck.draw(2),
        communityCards: _deck.draw(2),
        handPhase: SniperHandPhase.skills,
        p1ShotgunCooldownRounds: p1Cooldown,
        p2ShotgunCooldownRounds: p2Cooldown,
        p1UsedSkills: state.p1UsedSkills,
        p2UsedSkills: state.p2UsedSkills,
        isGameOver: false,
        isShowdown: false,
        showdownSnapshot: null,
        p1ActiveSkill: null,
        p2ActiveSkill: null,
        p1RiverDeclaration: null,
        p2RiverDeclaration: null,
        p1SkillLocked: false,
        p2SkillLocked: false,
        p1SniperLocked: false,
        p2SniperLocked: false,
        actingPlayer: null,
        lastActionLog: '',
        handStarter: starter,
        nextHandStarter: starter.opponent,
        p1ChipsAtHandStart: state.p1Chips,
        p2ChipsAtHandStart: state.p2Chips,
        carryInAtHandStart: carryIn,
        showRoundStarterBanner: true,
        opponentActionBanner: null,
        p1TurnSecondsRemaining: null,
      ),
    );
    _syncP1TurnTimer();
  }

  void fold(SniperPlayerId player) {
    if (!_canBet(player)) return;
    if (player == SniperPlayerId.p2) {
      _showOpponentBanner('Opponent folded');
    }
    final winner = player.opponent;
    _resolveFoldWin(winner, player);
  }

  void checkOrCall(SniperPlayerId player) {
    if (!_canBet(player)) return;
    final toCall = state.amountToCall(player);
    if (toCall > 0) {
      final stack =
          player == SniperPlayerId.p1 ? state.p1Chips : state.p2Chips;
      final pay = toCall > stack ? stack : toCall;
      if (!_commitChips(player, pay)) return;
      if (player == SniperPlayerId.p2) {
        _showOpponentBanner(
          pay >= stack ? 'Opponent all-in $pay' : 'Opponent called $pay',
        );
      }
    } else {
      if (player == SniperPlayerId.p2) {
        _showOpponentBanner('Opponent checked');
      }
    }
    _markActed(player);
    _advanceBetting();
    _syncP1TurnTimer();
  }

  /// Largest raise increment [player] can add on top of the amount to call.
  int maxRaiseFor(SniperPlayerId player) {
    final stack = player == SniperPlayerId.p1 ? state.p1Chips : state.p2Chips;
    final toCall = state.amountToCall(player);
    final room = stack - toCall;
    if (room <= 0) return 0;
    return room;
  }

  /// Returns false if the raise could not be committed (e.g. insufficient chips).
  bool raise(SniperPlayerId player, int raiseAmount) {
    if (!_canBet(player)) return false;
    final toCall = state.amountToCall(player);
    final stack =
        player == SniperPlayerId.p1 ? state.p1Chips : state.p2Chips;
    final cap = maxRaiseFor(player);
    final extra = raiseAmount.clamp(minRaise, cap);
    final total = (toCall + extra).clamp(0, stack);
    if (total <= 0 || !_commitChips(player, total)) return false;

    if (player == SniperPlayerId.p2) {
      final isShove = total >= stack;
      _showOpponentBanner(
        isShove ? 'Opponent all-in $total' : 'Opponent raised +$extra',
      );
    }

    _markActed(player);
    _clearOpponentActed(player);
    _setActing(player.opponent);
    _syncP1TurnTimer();
    return true;
  }

  bool declareSniperOrShotgun(
    SniperPlayerId player,
    SniperModeSelection mode,
    HandRank rank,
    int? value,
  ) {
    if (state.handPhase != SniperHandPhase.sniper) return false;
    if (state.actingPlayer != player) return false;
    if (player == SniperPlayerId.p1 && state.p1SniperLocked) return false;
    if (player == SniperPlayerId.p2 && state.p2SniperLocked) return false;
    if (mode == SniperModeSelection.none) return false;
    if (_isDeclarationBlocked(player)) return false;

    if (mode == SniperModeSelection.sniper) {
      if (value == null || value < 1 || value > 10) return false;
    }

    var p1Cooldown = state.p1ShotgunCooldownRounds;
    var p2Cooldown = state.p2ShotgunCooldownRounds;

    if (mode == SniperModeSelection.shotgun) {
      final cooldown = player == SniperPlayerId.p1 ? p1Cooldown : p2Cooldown;
      if (cooldown > 0) return false;
      if (player == SniperPlayerId.p1) {
        p1Cooldown = shotgunCooldownAfterUse;
      } else {
        p2Cooldown = shotgunCooldownAfterUse;
      }
    }

    final declaration = SniperRiverDeclaration(
      mode: mode,
      targetRank: rank,
      targetValue: mode == SniperModeSelection.sniper ? value : null,
    );

    final banner = _targetBanner(player, declaration);

    emit(
      switch (player) {
        SniperPlayerId.p1 => state.copyWith(
            p1RiverDeclaration: declaration,
            p1ShotgunCooldownRounds: p1Cooldown,
            p1SniperLocked: true,
          ),
        SniperPlayerId.p2 => state.copyWith(
            p2RiverDeclaration: declaration,
            p2ShotgunCooldownRounds: p2Cooldown,
            p2SniperLocked: true,
            opponentActionBanner: banner,
          ),
      },
    );
    if (player == SniperPlayerId.p2) {
      _scheduleBannerClear();
    }

    _afterSniperChoice(player);
    _syncP1TurnTimer();
    return true;
  }

  void evaluateShowdown() {
    if (state.isGameOver || state.isShowdown) return;
    if (state.handPhase != SniperHandPhase.sniper) return;
    if (!state.p1SniperLocked || !state.p2SniperLocked) return;
    if (state.communityCards.length != 4) return;

    _cancelP1TurnTimer();

    final p1Hand = PokerEvaluator.evaluateBestFour(
      state.p1HoleCards,
      state.communityCards,
    );
    final p2Hand = PokerEvaluator.evaluateBestFour(
      state.p2HoleCards,
      state.communityCards,
    );

    final p1Sniped = _wasSniped(SniperPlayerId.p1, p1Hand);
    final p2Sniped = _wasSniped(SniperPlayerId.p2, p2Hand);

    final winner = _resolveWinner(
      p1Sniped: p1Sniped,
      p2Sniped: p2Sniped,
      p1Hand: p1Hand,
      p2Hand: p2Hand,
    );

    var p1Chips = state.p1Chips;
    var p2Chips = state.p2Chips;
    var carryOverPot = state.carryOverPot;
    var potAwarded = 0;
    var hedgeApplied = false;
    var jackpotAwarded = false;

    if (winner != null) {
      final loser = winner.opponent;
      final winnerHand = winner == SniperPlayerId.p1 ? p1Hand : p2Hand;
      hedgeApplied = _applyPotAward(
        winner: winner,
        loser: loser,
        winnerHand: winnerHand,
        p1Chips: p1Chips,
        p2Chips: p2Chips,
        onP1Chips: (v) => p1Chips = v,
        onP2Chips: (v) => p2Chips = v,
        onCarryOver: (v) => carryOverPot = v,
        onPotAwarded: (v) => potAwarded = v,
      );

      if (!hedgeApplied) {
        final award = SniperPotSettlement.awardToWinner(
          p1Investment: state.p1RoundInvestment,
          p2Investment: state.p2RoundInvestment,
          winner: winner,
        );
        potAwarded = winner == SniperPlayerId.p1
            ? award.p1Award
            : award.p2Award;
        p1Chips += award.p1Award;
        p2Chips += award.p2Award;
      }

      final jackpotRecipient = _jackpotRecipient(
        winner: winner,
        loser: loser,
        winnerHand: winnerHand,
        p1Sniped: p1Sniped,
        p2Sniped: p2Sniped,
        p1Hand: p1Hand,
        p2Hand: p2Hand,
      );
      if (jackpotRecipient != null) {
        jackpotAwarded = true;
        if (jackpotRecipient == SniperPlayerId.p1) {
          p1Chips += jackpotBonus;
        } else {
          p2Chips += jackpotBonus;
        }
      }
    } else {
      final split = SniperPotSettlement.awardSplit(
        p1Investment: state.p1RoundInvestment,
        p2Investment: state.p2RoundInvestment,
      );
      p1Chips += split.p1Award;
      p2Chips += split.p2Award;
      potAwarded = state.currentPot;
    }

    final nextRoundCount = state.currentRoundCount + 1;
    var nextAnte = state.currentAnte;
    if (nextRoundCount % roundsPerAnteDouble == 0) {
      nextAnte *= 2;
    }

    final gameOver = p1Chips <= 0 || p2Chips <= 0;
    final snapshot = _buildShowdownSnapshot(
      winner: winner,
      p1Hand: p1Hand,
      p2Hand: p2Hand,
      jackpotAwarded: jackpotAwarded,
      potAwarded: potAwarded,
      hedgeApplied: hedgeApplied,
      endedByFold: false,
      foldedPlayer: null,
      p1ChipsEnd: p1Chips,
      p2ChipsEnd: p2Chips,
      carryOverEnd: carryOverPot,
    );

    emit(
      state.copyWith(
        p1Chips: p1Chips,
        p2Chips: p2Chips,
        p1RoundInvestment: 0,
        p2RoundInvestment: 0,
        currentAnte: nextAnte,
        currentRoundCount: nextRoundCount,
        currentPot: 0,
        carryOverPot: carryOverPot,
        handPhase: SniperHandPhase.betweenHands,
        isShowdown: true,
        actingPlayer: null,
        p1StreetBet: 0,
        p2StreetBet: 0,
        p1ActedThisStreet: false,
        p2ActedThisStreet: false,
        isGameOver: gameOver,
        showdownSnapshot: snapshot,
        p1TurnSecondsRemaining: null,
        opponentActionBanner: null,
      ),
    );
  }

  void runOpponentTurn() {
    if (state.isGameOver || state.isShowdown || state.showRoundStarterBanner) {
      return;
    }
    if (!state.isBettingPhase) return;
    if (state.actingPlayer != SniperPlayerId.p2) return;
    if (state.isAllIn(SniperPlayerId.p2)) return;

    final decision = _opponentAi.decideBetting(state);
    switch (decision) {
      case SniperBettingFold():
        fold(SniperPlayerId.p2);
      case SniperBettingCheckCall():
        checkOrCall(SniperPlayerId.p2);
      case SniperBettingRaise(:final bbUnits):
        final bb = state.currentAnte;
        final extra = bbUnits >= 99
            ? maxRaiseFor(SniperPlayerId.p2)
            : (bb * bbUnits).clamp(minRaise, maxRaiseFor(SniperPlayerId.p2));
        if (extra >= minRaise && raise(SniperPlayerId.p2, extra)) {
          return;
        }
        checkOrCall(SniperPlayerId.p2);
    }
  }

  /// Runs P2 AI immediately when it is their turn (betting, skills, or sniper).
  void _runOpponentIfNeeded() {
    if (state.isGameOver || state.isShowdown || state.showRoundStarterBanner) {
      return;
    }

    if (_fastForwardBettingIfBothAllIn()) {
      return;
    }

    if (state.isBettingPhase &&
        state.actingPlayer == SniperPlayerId.p2 &&
        state.isAllIn(SniperPlayerId.p2)) {
      return;
    }

    if (state.isBettingPhase && state.actingPlayer == SniperPlayerId.p2) {
      runOpponentTurn();
      return;
    }

    if (state.handPhase == SniperHandPhase.sniper &&
        state.actingPlayer == SniperPlayerId.p2 &&
        !state.p2SniperLocked) {
      _runOpponentSniperTurn();
      return;
    }

    if (state.handPhase == SniperHandPhase.skills &&
        state.handStarter == SniperPlayerId.p2 &&
        !state.p2SkillLocked) {
      _opponentPickSkill();
    }
  }

  void _afterSniperChoice(SniperPlayerId player) {
    if (player == SniperPlayerId.p2) {
      if (state.p1SniperLocked) {
        _tryCompleteSniperPhase();
      } else {
        emit(state.copyWith(actingPlayer: SniperPlayerId.p1));
        _syncP1TurnTimer();
      }
      return;
    }

    if (state.p2SniperLocked) {
      _tryCompleteSniperPhase();
    } else {
      emit(state.copyWith(actingPlayer: SniperPlayerId.p2));
      _runOpponentIfNeeded();
    }
  }

  void _runOpponentSniperTurn() {
    if (state.handPhase != SniperHandPhase.sniper ||
        state.actingPlayer != SniperPlayerId.p2 ||
        state.p2SniperLocked) {
      return;
    }

    if (_isDeclarationBlocked(SniperPlayerId.p2)) {
      emit(
        state.copyWith(
          p2SniperLocked: true,
          opponentActionBanner: 'Opponent could not target',
        ),
      );
      _scheduleBannerClear();
      _afterSniperChoice(SniperPlayerId.p2);
      return;
    }

    final target = _opponentAi.decideSniper(state);
    switch (target) {
      case SniperTargetPass():
        emit(
          state.copyWith(
            p2SniperLocked: true,
            opponentActionBanner: 'Opponent passed on targeting',
          ),
        );
        _scheduleBannerClear();
        _afterSniperChoice(SniperPlayerId.p2);
      case SniperTargetSniper(:final rank, :final value):
        declareSniperOrShotgun(
          SniperPlayerId.p2,
          SniperModeSelection.sniper,
          rank,
          value,
        );
      case SniperTargetShotgun(:final rank):
        declareSniperOrShotgun(
          SniperPlayerId.p2,
          SniperModeSelection.shotgun,
          rank,
          null,
        );
    }
  }

  void _opponentPickSkill() {
    if (state.p2SkillLocked) return;

    final pick = _opponentAi.pickSkill(state);
    if (pick != null) {
      _executeSkill(SniperPlayerId.p2, pick);
      return;
    }

    emit(
      state.copyWith(
        p2SkillLocked: true,
        opponentActionBanner: 'Opponent passed on skill',
      ),
    );
    _scheduleBannerClear();

    if (state.handStarter == SniperPlayerId.p2 && !state.p1SkillLocked) {
      _syncP1TurnTimer();
      return;
    }
    _advanceFromSkills();
    _syncP1TurnTimer();
  }

  void _resolveOpponentSkillPhase() {
    if (!state.p1SkillLocked || state.p2SkillLocked) return;
    _opponentPickSkill();
  }

  void _advanceFromSkills() {
    if (!state.p1SkillLocked || !state.p2SkillLocked) return;
    final starter = state.handStarter ?? SniperPlayerId.p1;
    emit(
      state.copyWith(
        handPhase: SniperHandPhase.betting1,
        actingPlayer: starter,
        p1StreetBet: 0,
        p2StreetBet: 0,
        p1ActedThisStreet: false,
        p2ActedThisStreet: false,
        lastActionLog: '',
      ),
    );
    if (!_fastForwardBettingIfBothAllIn()) {
      _runOpponentIfNeeded();
    }
    _syncP1TurnTimer();
  }

  void _advanceToBetting2() {
    if (state.handPhase != SniperHandPhase.betting1) return;
    if (_deck.remaining < 2) {
      _deck.reshuffle();
    }

    final starter = state.handStarter ?? SniperPlayerId.p1;
    emit(
      state.copyWith(
        handPhase: SniperHandPhase.betting2,
        communityCards: [...state.communityCards, ..._deck.draw(2)],
        p1StreetBet: 0,
        p2StreetBet: 0,
        p1ActedThisStreet: false,
        p2ActedThisStreet: false,
        actingPlayer: starter,
        lastActionLog: '',
      ),
    );
    if (!_fastForwardBettingIfBothAllIn()) {
      _runOpponentIfNeeded();
    }
    _syncP1TurnTimer();
  }

  void _advanceToSniperPhase() {
    if (state.handPhase != SniperHandPhase.betting2) return;

    final starter = state.handStarter ?? SniperPlayerId.p1;
    emit(
      state.copyWith(
        handPhase: SniperHandPhase.sniper,
        actingPlayer: starter,
        p1SniperLocked: false,
        p2SniperLocked: false,
        p1RiverDeclaration: null,
        p2RiverDeclaration: null,
        lastActionLog: '',
      ),
    );
    _runOpponentIfNeeded();
    _syncP1TurnTimer();
  }

  void _tryCompleteSniperPhase() {
    if (!state.p1SniperLocked || !state.p2SniperLocked) return;
    evaluateShowdown();
  }

  void _resolveFoldWin(SniperPlayerId winner, SniperPlayerId folder) {
    _cancelP1TurnTimer();

    var p1Chips = state.p1Chips;
    var p2Chips = state.p2Chips;
    final award = SniperPotSettlement.awardToWinner(
      p1Investment: state.p1RoundInvestment,
      p2Investment: state.p2RoundInvestment,
      winner: winner,
    );
    final potAwarded =
        winner == SniperPlayerId.p1 ? award.p1Award : award.p2Award;
    p1Chips += award.p1Award;
    p2Chips += award.p2Award;

    final nextRoundCount = state.currentRoundCount + 1;
    var nextAnte = state.currentAnte;
    if (nextRoundCount % roundsPerAnteDouble == 0) {
      nextAnte *= 2;
    }

    final gameOver = p1Chips <= 0 || p2Chips <= 0;
    final p1Hand = state.communityCards.length >= 4
        ? PokerEvaluator.evaluateBestFour(
            state.p1HoleCards,
            state.communityCards,
          )
        : const ParsedHand(rank: HandRank.highCard, primaryValue: 0);
    final p2Hand = state.communityCards.length >= 4
        ? PokerEvaluator.evaluateBestFour(
            state.p2HoleCards,
            state.communityCards,
          )
        : const ParsedHand(rank: HandRank.highCard, primaryValue: 0);

    final snapshot = _buildShowdownSnapshot(
      winner: winner,
      p1Hand: p1Hand,
      p2Hand: p2Hand,
      jackpotAwarded: false,
      potAwarded: potAwarded,
      hedgeApplied: false,
      endedByFold: true,
      foldedPlayer: folder,
      p1ChipsEnd: p1Chips,
      p2ChipsEnd: p2Chips,
      carryOverEnd: state.carryOverPot,
    );

    emit(
      state.copyWith(
        p1Chips: p1Chips,
        p2Chips: p2Chips,
        p1RoundInvestment: 0,
        p2RoundInvestment: 0,
        currentAnte: nextAnte,
        currentRoundCount: nextRoundCount,
        currentPot: 0,
        handPhase: SniperHandPhase.betweenHands,
        isShowdown: true,
        actingPlayer: null,
        isGameOver: gameOver,
        showdownSnapshot: snapshot,
        p1TurnSecondsRemaining: null,
        opponentActionBanner: null,
      ),
    );
  }

  SniperShowdownSnapshot _buildShowdownSnapshot({
    required SniperPlayerId? winner,
    required ParsedHand p1Hand,
    required ParsedHand p2Hand,
    required bool jackpotAwarded,
    required int potAwarded,
    required bool hedgeApplied,
    required bool endedByFold,
    required SniperPlayerId? foldedPlayer,
    required int p1ChipsEnd,
    required int p2ChipsEnd,
    required int carryOverEnd,
  }) {
    final p1SnipedLabel =
        _attackerSnipeHit(SniperPlayerId.p2, p1Hand);
    final p2SnipedLabel =
        _attackerSnipeHit(SniperPlayerId.p1, p2Hand);
    final p1ShotgunLabel = winner == SniperPlayerId.p2 &&
        _attackerShotgunHit(SniperPlayerId.p1, p2Hand);
    final p2ShotgunLabel = winner == SniperPlayerId.p1 &&
        _attackerShotgunHit(SniperPlayerId.p2, p1Hand);
    final (p1ChipDelta, p2ChipDelta) = _computeDisplayChipDeltas(
      p1ChipsEnd: p1ChipsEnd,
      p2ChipsEnd: p2ChipsEnd,
      winner: winner,
      jackpotAwarded: jackpotAwarded,
      carryOverEnd: carryOverEnd,
    );

    return SniperShowdownSnapshot(
      winner: winner,
      p1Hand: p1Hand,
      p2Hand: p2Hand,
      jackpotAwarded: jackpotAwarded,
      potAwarded: potAwarded,
      shotgunHedgeApplied: hedgeApplied,
      endedByFold: endedByFold,
      foldedPlayer: foldedPlayer,
      p1ChipsEnd: p1ChipsEnd,
      p2ChipsEnd: p2ChipsEnd,
      p1ChipDelta: p1ChipDelta,
      p2ChipDelta: p2ChipDelta,
      p1SkillLine: _skillLine(SniperPlayerId.p1),
      p2SkillLine: _skillLine(SniperPlayerId.p2),
      p1TargetLine: _targetLine(SniperPlayerId.p1),
      p2TargetLine: _targetLine(SniperPlayerId.p2),
      p1SnipedLabel: p1SnipedLabel,
      p2SnipedLabel: p2SnipedLabel,
      p1ShotgunLabel: p1ShotgunLabel,
      p2ShotgunLabel: p2ShotgunLabel,
    );
  }

  bool _attackerSnipeHit(SniperPlayerId attacker, ParsedHand victimHand) {
    final declaration = _declaration(attacker);
    if (declaration == null ||
        declaration.mode != SniperModeSelection.sniper) {
      return false;
    }
    final value = declaration.targetValue;
    if (value == null) return false;
    final wideLens = _activeSkill(attacker) == skillLens;
    return SniperEngine.verifySniperHit(
      declaration.targetRank,
      value,
      victimHand,
      wideLens,
    );
  }

  bool _attackerShotgunHit(SniperPlayerId attacker, ParsedHand victimHand) {
    final declaration = _declaration(attacker);
    if (declaration == null ||
        declaration.mode != SniperModeSelection.shotgun) {
      return false;
    }
    return SniperEngine.verifyShotgunHit(declaration.targetRank, victimHand);
  }

  /// Stack deltas for the result overlay.
  ///
  /// Raw stack change can fail zero-sum when chips sit in [carryOverPot] or
  /// when carry-in from a prior split is paid out. Adjust so
  /// `p1Delta + p2Delta == jackpotBonus` (or 0 when no jackpot).
  (int, int) _computeDisplayChipDeltas({
    required int p1ChipsEnd,
    required int p2ChipsEnd,
    required SniperPlayerId? winner,
    required bool jackpotAwarded,
    required int carryOverEnd,
  }) {
    final p1Raw = p1ChipsEnd - state.p1ChipsAtHandStart;
    final p2Raw = p2ChipsEnd - state.p2ChipsAtHandStart;
    final escrowNet = carryOverEnd - state.carryInAtHandStart;
    final jackpotTotal = jackpotAwarded ? jackpotBonus : 0;

    if (escrowNet > 0) {
      final totalInv = state.p1RoundInvestment + state.p2RoundInvestment;
      if (totalInv > 0) {
        final p1Adj = (escrowNet * state.p1RoundInvestment / totalInv).round();
        final p2Adj = escrowNet - p1Adj;
        return (p1Raw + p1Adj, p2Raw + p2Adj);
      }
      final half = escrowNet ~/ 2;
      return (p1Raw + half + (escrowNet % 2), p2Raw + half);
    }

    final imbalance = p1Raw + p2Raw - jackpotTotal;
    if (imbalance == 0) {
      return (p1Raw, p2Raw);
    }

    if (winner == SniperPlayerId.p1) {
      return (p1Raw - imbalance, p2Raw);
    }
    if (winner == SniperPlayerId.p2) {
      return (p1Raw, p2Raw - imbalance);
    }

    return (p1Raw, p2Raw);
  }

  void _syncP1TurnTimer() {
    _cancelP1TurnTimer();

    if (isClosed) return;

    if (!state.canP1Act) {
      if (state.p1TurnSecondsRemaining != null) {
        emit(state.copyWith(p1TurnSecondsRemaining: null));
      }
      return;
    }

    emit(state.copyWith(p1TurnSecondsRemaining: p1TurnLimitSeconds));

    _p1TurnTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isClosed) return;
      final sec = state.p1TurnSecondsRemaining;
      if (sec == null || !state.canP1Act) {
        _cancelP1TurnTimer();
        return;
      }
      if (sec <= 1) {
        _cancelP1TurnTimer();
        _onP1TurnTimeout();
        return;
      }
      emit(state.copyWith(p1TurnSecondsRemaining: sec - 1));
    });
  }

  void _onP1TurnTimeout() {
    switch (state.handPhase) {
      case SniperHandPhase.skills:
        passSkill();
      case SniperHandPhase.betting1:
      case SniperHandPhase.betting2:
        if (state.amountToCall(SniperPlayerId.p1) == 0) {
          checkOrCall(SniperPlayerId.p1);
        } else {
          fold(SniperPlayerId.p1);
        }
      case SniperHandPhase.sniper:
        passSniper();
      case SniperHandPhase.betweenHands:
        break;
    }
  }

  void _cancelP1TurnTimer() {
    _p1TurnTimer?.cancel();
    _p1TurnTimer = null;
  }

  void _showOpponentBanner(String message) {
    emit(state.copyWith(opponentActionBanner: message));
    _scheduleBannerClear();
  }

  void _scheduleBannerClear() {
    _bannerClearTimer?.cancel();
    _bannerClearTimer = Timer(const Duration(seconds: 2), () {
      if (isClosed) return;
      if (state.opponentActionBanner != null) {
        emit(state.copyWith(opponentActionBanner: null));
      }
    });
  }

  bool _canBet(SniperPlayerId player) =>
      !state.isGameOver &&
      !state.isShowdown &&
      !state.showRoundStarterBanner &&
      state.isBettingPhase &&
      state.actingPlayer == player &&
      !state.isAllIn(player) &&
      (player == SniperPlayerId.p1 ? state.p1Chips : state.p2Chips) > 0;

  void _emitGameOver() {
    emit(
      state.copyWith(
        isGameOver: true,
        isShowdown: false,
        handPhase: SniperHandPhase.betweenHands,
        actingPlayer: null,
        showdownSnapshot: null,
        showRoundStarterBanner: false,
        opponentActionBanner: null,
        p1TurnSecondsRemaining: null,
      ),
    );
    _cancelP1TurnTimer();
  }

  bool _commitChips(SniperPlayerId player, int amount) {
    if (amount <= 0) return true;
    if (player == SniperPlayerId.p1) {
      if (state.p1Chips < amount) return false;
      emit(
        state.copyWith(
          p1Chips: state.p1Chips - amount,
          p1RoundInvestment: state.p1RoundInvestment + amount,
          p1StreetBet: state.p1StreetBet + amount,
          currentPot: state.currentPot + amount,
        ),
      );
    } else {
      if (state.p2Chips < amount) return false;
      emit(
        state.copyWith(
          p2Chips: state.p2Chips - amount,
          p2RoundInvestment: state.p2RoundInvestment + amount,
          p2StreetBet: state.p2StreetBet + amount,
          currentPot: state.currentPot + amount,
        ),
      );
    }
    return true;
  }

  void _markActed(SniperPlayerId player) {
    emit(
      switch (player) {
        SniperPlayerId.p1 => state.copyWith(p1ActedThisStreet: true),
        SniperPlayerId.p2 => state.copyWith(p2ActedThisStreet: true),
      },
    );
  }

  void _clearOpponentActed(SniperPlayerId player) {
    emit(
      switch (player) {
        SniperPlayerId.p1 => state.copyWith(p2ActedThisStreet: false),
        SniperPlayerId.p2 => state.copyWith(p1ActedThisStreet: false),
      },
    );
  }

  void _setActing(SniperPlayerId? player) {
    var next = player;
    while (next != null && state.isAllIn(next)) {
      next = next.opponent;
      if (state.isAllIn(next)) break;
    }
    emit(state.copyWith(actingPlayer: next));
    if (next != null &&
        state.isBettingPhase &&
        state.bettingStreetComplete) {
      _advanceBetting();
      return;
    }
    _runOpponentIfNeeded();
  }

  void _advanceBetting() {
    if (!state.bettingStreetComplete) {
      _setActing(state.actingPlayer!.opponent);
      return;
    }

    if (state.handPhase == SniperHandPhase.betting1) {
      _advanceToBetting2();
      _fastForwardBettingIfBothAllIn();
      return;
    }

    if (state.handPhase == SniperHandPhase.betting2) {
      _advanceToSniperPhase();
      return;
    }

    _setActing(null);
  }

  /// When both seats are all-in, skip remaining betting and deal to sniper.
  bool _fastForwardBettingIfBothAllIn() {
    if (!state.isAllIn(SniperPlayerId.p1) ||
        !state.isAllIn(SniperPlayerId.p2)) {
      return false;
    }

    if (state.handPhase == SniperHandPhase.betting1) {
      _advanceToBetting2();
    }

    if (state.handPhase == SniperHandPhase.betting2) {
      _advanceToSniperPhase();
      return true;
    }

    return state.handPhase == SniperHandPhase.sniper;
  }

  bool _isDeclarationBlocked(SniperPlayerId player) {
    final opponent = player.opponent;
    if (_activeSkill(opponent) == skillKevlar) return true;
    if (_activeSkill(opponent) == skillFlashbang) return true;
    return false;
  }

  String? _activeSkill(SniperPlayerId player) =>
      player == SniperPlayerId.p1 ? state.p1ActiveSkill : state.p2ActiveSkill;

  SniperRiverDeclaration? _declaration(SniperPlayerId player) =>
      player == SniperPlayerId.p1
          ? state.p1RiverDeclaration
          : state.p2RiverDeclaration;

  String _skillLine(SniperPlayerId player) {
    final skill = _activeSkill(player);
    if (skill == null) return 'No skill';
    return _skillLabel(skill);
  }

  String _targetLine(SniperPlayerId player) {
    final decl = _declaration(player);
    if (decl == null) return 'Pass';
    if (decl.mode == SniperModeSelection.shotgun) {
      return 'Shotgun → ${_handRankLabel(decl.targetRank)}';
    }
    return 'Sniper → ${_handRankLabel(decl.targetRank)} @${decl.targetValue}';
  }

  String _targetBanner(SniperPlayerId player, SniperRiverDeclaration decl) {
    if (player == SniperPlayerId.p1) return '';
    final rank = _handRankLabel(decl.targetRank);
    if (decl.mode == SniperModeSelection.shotgun) {
      return 'Opponent shotgun → $rank';
    }
    return 'Opponent sniper → $rank @${decl.targetValue}';
  }

  static String _handRankLabel(HandRank rank) => switch (rank) {
        HandRank.highCard => 'High card',
        HandRank.pair => 'Pair',
        HandRank.twoPair => 'Two pair',
        HandRank.threeOfAKind => 'Three of a kind',
        HandRank.straight => 'Straight',
        HandRank.flush => 'Flush',
        HandRank.fourOfAKind => 'Four of a kind',
        HandRank.straightFlush => 'Straight flush',
      };

  bool _wasSniped(SniperPlayerId target, ParsedHand targetHand) {
    return SniperEngine.isPlayerSniped(
      hand: targetHand,
      opponentDeclaration: _declaration(target.opponent),
      ownDeclaration: _declaration(target),
      opponentWideLens: _activeSkill(target.opponent) == skillLens,
      ownWideLens: _activeSkill(target) == skillLens,
    );
  }

  SniperPlayerId? _resolveWinner({
    required bool p1Sniped,
    required bool p2Sniped,
    required ParsedHand p1Hand,
    required ParsedHand p2Hand,
  }) {
    if (p1Sniped && p2Sniped) return null;
    if (p1Sniped) return SniperPlayerId.p2;
    if (p2Sniped) return SniperPlayerId.p1;

    final cmp = PokerEvaluator.compareParsedHands(p1Hand, p2Hand);
    if (cmp > 0) return SniperPlayerId.p1;
    if (cmp < 0) return SniperPlayerId.p2;
    return null;
  }

  bool _applyPotAward({
    required SniperPlayerId winner,
    required SniperPlayerId loser,
    required ParsedHand winnerHand,
    required int p1Chips,
    required int p2Chips,
    required void Function(int) onP1Chips,
    required void Function(int) onP2Chips,
    required void Function(int) onCarryOver,
    required void Function(int) onPotAwarded,
  }) {
    final loserDecl = _declaration(loser);
    if (loserDecl == null ||
        loserDecl.mode != SniperModeSelection.shotgun ||
        !SniperEngine.verifyShotgunHit(loserDecl.targetRank, winnerHand)) {
      return false;
    }

    final loserInvestment = loser == SniperPlayerId.p1
        ? state.p1RoundInvestment
        : state.p2RoundInvestment;
    final winnerInvestment = winner == SniperPlayerId.p1
        ? state.p1RoundInvestment
        : state.p2RoundInvestment;
    final carryInThisHand = state.currentPot -
        state.p1RoundInvestment -
        state.p2RoundInvestment;

    final winnerShare = (loserInvestment / 2).ceil();
    final nextRoundShare = (loserInvestment / 2).floor();
    final payout = winnerInvestment + carryInThisHand + winnerShare;

    if (winner == SniperPlayerId.p1) {
      onP1Chips(p1Chips + payout);
    } else {
      onP2Chips(p2Chips + payout);
    }
    onCarryOver(nextRoundShare);
    onPotAwarded(payout);
    return true;
  }

  SniperPlayerId? _jackpotRecipient({
    required SniperPlayerId winner,
    required SniperPlayerId loser,
    required ParsedHand winnerHand,
    required bool p1Sniped,
    required bool p2Sniped,
    required ParsedHand p1Hand,
    required ParsedHand p2Hand,
  }) {
    final winnerSniped = winner == SniperPlayerId.p1 ? p1Sniped : p2Sniped;
    if (_isPremiumHand(winnerHand) && !winnerSniped) {
      return winner;
    }

    final loserHand = loser == SniperPlayerId.p1 ? p1Hand : p2Hand;
    if (!_isPremiumHand(loserHand)) return null;

    final winnerDecl = _declaration(winner);
    if (winnerDecl == null || winnerDecl.mode != SniperModeSelection.sniper) {
      return null;
    }
    final value = winnerDecl.targetValue;
    if (value == null) return null;

    final wideLens = _activeSkill(winner) == skillLens;
    if (SniperEngine.verifySniperHit(
      winnerDecl.targetRank,
      value,
      loserHand,
      wideLens,
    )) {
      return winner;
    }
    return null;
  }

  static bool _isPremiumHand(ParsedHand hand) =>
      hand.rank == HandRank.fourOfAKind ||
      hand.rank == HandRank.straightFlush;

  static String _skillLabel(String id) => switch (id) {
        skillKevlar => 'Kevlar Vest',
        skillFlashbang => 'Flashbang',
        skillLens => 'Wide Lens',
        _ => id,
      };
}
