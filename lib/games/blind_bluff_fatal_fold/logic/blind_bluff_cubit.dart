import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../ai/mock_bluff_ai.dart';
import '../models/player_id.dart';
import 'blind_bluff_betting.dart';
import 'blind_bluff_match_engine.dart';
import 'blind_bluff_match_state.dart';
import 'blind_bluff_match_ui_state.dart';
import 'blind_bluff_skills.dart';

enum _SnapPhase { idle, skill, betting, showdown, complete }

extension on _SnapPhase {
  bool get isTimed => this == _SnapPhase.skill || this == _SnapPhase.betting;
}

const int _kBettingTurnSeconds = 30;

/// Human always sits in [BlindBluffPlayerId.playerOne]; seat two uses [MockBluffAi].
class BlindBluffCubit extends Cubit<BlindBluffMatchState> {
  BlindBluffCubit({
    BlindBluffMatchEngine? engine,
    MockBluffAi? ai,
    Random? random,
  })  : _engine = engine ?? BlindBluffMatchEngine(random: random),
        _ai = ai ?? MockBluffAi(random: random),
        super(const BlindBluffMatchState.loading()) {
    _bootstrap();
  }

  final BlindBluffMatchEngine _engine;
  final MockBluffAi _ai;

  Timer? _timer;
  Timer? _introUiFailsafeTimer;
  int _secondsRemaining = _kBettingTurnSeconds;
  _SnapPhase? _trackedPhase;

  /// One beat after skills: UI shows who opens betting; clock / AI start after this.
  bool _deferBettingSyncForFirstMoveBanner = false;

  /// Last [BlindBluffBettingPublicView.actingPlayer] we applied a timer / AI kick for.
  BlindBluffPlayerId? _lastSyncedBettingActor;

  /// Until [notifySkillIntroComplete], no skill-phase timer / reflection.
  bool _skillIntroPending = false;

  /// Countdown for the first skill-phase segment after intro; skills may be
  /// chosen during this window and the follow-up timer.
  int _skillReflectionSecondsRemaining = 0;

  bool _skillRevealAnimScheduled = false;

  final List<String> _log = <String>[];

  int _lastSkillRoundSerial = -1;
  bool _playerInsuranceRound = false;
  bool _opponentInsuranceRound = false;

  bool _aiBusy = false;

  Set<BlindBluffSkill> _cachedPlayerSkills =
      BlindBluffSkill.values.toSet();
  Set<BlindBluffSkill> _cachedOpponentSkills =
      BlindBluffSkill.values.toSet();

  /// One-shot UX: chips the rival added **beyond** the call on a raise action.
  /// Consumed next time [_mapSnapshot] maps a betting phase.
  int? _opponentRaiseNoticeChips;

  /// One-shot UX: show banner when opponent checks.
  bool _opponentCheckNotice = false;

  int? _stashedAnteDoubledFrom;
  int? _stashedAnteDoubledTo;
  int? _stashedAnteDoubleRound;

  /// Last decisive hand when the match ended on [roundResolving] (popup fallback).
  BlindBluffRoundResolution? _cachedTerminalRoundResolution;
  int? _cachedTerminalRoundNumber;

  Future<void> _bootstrap() async {
    emit(const BlindBluffMatchState.loading());
    await Future<void>.delayed(Duration.zero);
    try {
      _engine.beginRound();
    } catch (_) {}
    _skillRevealAnimScheduled = false;
    _skillReflectionSecondsRemaining = 0;
    _refreshSkillCaches();
    _emitView();
  }

  /// Call after UI finishes **ante → deal** intro; starts a 10s reflection
  /// countdown (skills may be chosen here), then a 10s follow‑up window if needed.
  void notifySkillIntroComplete() {
    _introUiFailsafeTimer?.cancel();
    _introUiFailsafeTimer = null;
    if (!_skillIntroPending) {
      return;
    }
    if (_engine.snapshot.mapOrNull(skillPhase: (_) => true) != true) {
      return;
    }
    _skillIntroPending = false;
    if (_skipSkillPhaseWhenBothExhausted()) {
      return;
    }
    if (_tryAutoSkipPlayerSkillsWhenSpent()) {
      return;
    }
    _skillReflectionSecondsRemaining = 10;
    _startTurnTimer(10);
    emit(_mapSnapshot(_engine.snapshot));
    unawaited(_kickAi());
  }

  /// No skills left for either seat — skip reflection, declare, and reveal.
  bool _skipSkillPhaseWhenBothExhausted() {
    if (!_bothSeatsHaveNoSkillsRemaining()) {
      return false;
    }
    if (_engine.skipSkillPhaseIfNoSkillsRemain()) {
      _skillRevealAnimScheduled = false;
      _skillReflectionSecondsRemaining = 0;
      _timer?.cancel();
      _appendLog('No skills left — betting opens.');
      _emitView();
      return true;
    }
    return false;
  }

  /// Human has spent every skill chip — locking as skip without a tap.
  bool _tryAutoSkipPlayerSkillsWhenSpent() {
    if (_skillIntroPending) {
      return false;
    }
    final phase = _engine.snapshot.mapOrNull(skillPhase: (x) => x);
    if (phase == null) {
      return false;
    }
    if (phase.skillsRemainingPlayerOne.isNotEmpty) {
      return false;
    }
    if (phase.playerOneLockedChoice || phase.awaitingSkillRevealAck) {
      return false;
    }

    declarePlayerSkill(null);
    return true;
  }

  bool _bothSeatsHaveNoSkillsRemaining() {
    return _engine.snapshot.maybeMap(
          skillPhase: (p) =>
              p.skillsRemainingPlayerOne.isEmpty &&
              p.skillsRemainingPlayerTwo.isEmpty,
          orElse: () => false,
        ) ??
        false;
  }

  /// Call after the skill reveal overlay animation so betting can begin.
  void notifySkillRevealAnimationComplete() {
    final ok = _engine.acknowledgeSkillReveal();
    _skillRevealAnimScheduled = false;
    if (ok) {
      _emitView();
    }
  }

  void declarePlayerSkill(BlindBluffSkill? skill) {
    if (_skillIntroPending ||
        _engine.snapshot.mapOrNull(
              skillPhase: (p) => p.awaitingSkillRevealAck,
            ) ==
            true) {
      return;
    }
    final ok = _engine.submitSkillDeclaration(
      seat: BlindBluffPlayerId.playerOne,
      skill: skill,
    );
    if (!ok) {
      return;
    }

    if (skill == BlindBluffSkill.penaltyInsurance) {
      _playerInsuranceRound = true;
    }

    _appendLog(
      skill == null
          ? 'You skipped skills.'
          : switch (skill) {
              BlindBluffSkill.plusTwoModifier => 'You used +2 Value.',
              BlindBluffSkill.doubleBlind => 'You used Double Ante.',
              BlindBluffSkill.penaltyInsurance => 'You used Immunity.',
            },
    );

    _refreshSkillCaches();
    _emitView();
    unawaited(_kickAi());
  }

  Future<void> submitPlayerBetting(BlindBluffBettingAction action) async {
    final before = _engine.snapshot.mapOrNull(bettingPhase: (p) => p);
    if (before == null) {
      return;
    }

    final p1Before = before.betting.contributionPlayerOne;
    final p2Before = before.betting.contributionPlayerTwo;

    final ok = _engine.submitBettingAction(
      seat: BlindBluffPlayerId.playerOne,
      action: action,
    );
    if (!ok) {
      return;
    }

    final after = _engine.snapshot.mapOrNull(bettingPhase: (p) => p);
    final deltaP1 = after == null
        ? 0
        : after.betting.contributionPlayerOne - p1Before;
    final deltaP2 = after == null
        ? 0
        : after.betting.contributionPlayerTwo - p2Before;

    _logHumanBetting(action, deltaP1);
    if (deltaP2 > 0) {
      _appendLog('Opponent added $deltaP2 chips this street.');
    }

    _emitView();
  }

  void advanceFromShowdown() {
    final resolving = _engine.snapshot.mapOrNull(
      roundResolving: (p) => p,
    );
    if (resolving != null) {
      resolving.resolution.map(
        fold: (f) {
          final foldingPlayer = f.foldingPlayer;
          final foldingPlayersCard = f.foldingPlayersCard;
          final opponentsVisibleCard = f.opponentsVisibleCard;
          final humanHole = foldingPlayer == BlindBluffPlayerId.playerOne
              ? foldingPlayersCard
              : opponentsVisibleCard;
          final aiHole = foldingPlayer == BlindBluffPlayerId.playerTwo
              ? foldingPlayersCard
              : opponentsVisibleCard;
          _ai.recordRoundCards(humanHole: humanHole, aiHole: aiHole);
        },
        showdown: (s) {
          _ai.recordRoundCards(
            humanHole: s.playerOneCard,
            aiHole: s.playerTwoCard,
          );
        },
      );
    }

    try {
      _engine.finishRound();
    } catch (_) {
      return;
    }

    _appendLog('Round closed.');

    if (_engine.isMatchComplete) {
      _timer?.cancel();
      _emitView();
      return;
    }

    try {
      _engine.beginRound();
    } catch (_) {
      _emitView();
      return;
    }

    _skillRevealAnimScheduled = false;
    _skillReflectionSecondsRemaining = 0;
    _refreshSkillCaches();
    _emitView();
  }

  String _matchEndLogLine() {
    return _engine.snapshot.maybeMap(
          matchComplete: (m) => m.winner == BlindBluffPlayerId.playerOne
              ? 'Match over — you win.'
              : 'Match over — opponent wins.',
          orElse: () => 'Match over.',
        ) ??
        'Match over.';
  }

  void _startTurnTimer(int seconds) {
    _timer?.cancel();
    _secondsRemaining = seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _introUiFailsafeTimer?.cancel();
    return super.close();
  }

  void _bootstrapInsuranceForRound(int roundNumber) {
    if (roundNumber != _lastSkillRoundSerial) {
      _lastSkillRoundSerial = roundNumber;
      _playerInsuranceRound = false;
      _opponentInsuranceRound = false;
    }
  }

  void _refreshSkillCaches() {
    _engine.snapshot.maybeMap(
      skillPhase: (p) {
        _cachedPlayerSkills =
            Set<BlindBluffSkill>.from(p.skillsRemainingPlayerOne);
        _cachedOpponentSkills =
            Set<BlindBluffSkill>.from(p.skillsRemainingPlayerTwo);
      },
      idleBetweenRounds: (p) {
        _cachedPlayerSkills =
            Set<BlindBluffSkill>.from(p.skillsRemainingPlayerOne);
        _cachedOpponentSkills =
            Set<BlindBluffSkill>.from(p.skillsRemainingPlayerTwo);
      },
      orElse: () {},
    );
  }

  void _emitView() {
    final snap = _engine.snapshot;
    final phase = _phaseOf(snap);

    if (phase != _trackedPhase) {
      final prevPhase = _trackedPhase;
      _trackedPhase = phase;
      _timer?.cancel();
      if (phase == _SnapPhase.betting) {
        _lastSyncedBettingActor = null;
        if (prevPhase == _SnapPhase.skill) {
          _secondsRemaining = _kBettingTurnSeconds;
          _deferBettingSyncForFirstMoveBanner = true;
        }
      } else if (phase == _SnapPhase.skill) {
        _skillIntroPending = true;
        _skillReflectionSecondsRemaining = 0;
        _scheduleIntroUiFailsafe();
      } else if (phase == _SnapPhase.showdown || phase == _SnapPhase.complete) {
        _timer?.cancel();
      }
      if (phase == _SnapPhase.complete && prevPhase != _SnapPhase.complete) {
        _appendLog(_matchEndLogLine());
      }
    }

    emit(_mapSnapshot(snap));
    if (_deferBettingSyncForFirstMoveBanner) {
      _deferBettingSyncForFirstMoveBanner = false;
      unawaited(Future<void>.delayed(const Duration(seconds: 1), () {
        if (isClosed) {
          return;
        }
        final live = _engine.snapshot;
        if (_phaseOf(live) != _SnapPhase.betting) {
          return;
        }
        _syncBettingActorAndTimer(live);
      }));
    } else {
      _syncBettingActorAndTimer(snap);
    }
    _scheduleSkillRevealIfNeeded();

    final livePhase = _phaseOf(_engine.snapshot);
    if (!_skillIntroPending && livePhase == _SnapPhase.skill) {
      unawaited(Future.microtask(() {
        if (!isClosed) {
          _tryAutoSkipPlayerSkillsWhenSpent();
        }
      }));
    }
  }

  /// If the table intro never completes in the UI, unblock skill phase anyway.
  void _scheduleIntroUiFailsafe() {
    _introUiFailsafeTimer?.cancel();
    _introUiFailsafeTimer = Timer(const Duration(seconds: 6), () {
      _introUiFailsafeTimer = null;
      if (isClosed) {
        return;
      }
      if (_skillIntroPending) {
        notifySkillIntroComplete();
      }
    });
  }

  /// Starts the 30s human clock on your turn, or kicks the AI when it is seat two’s turn.
  void _syncBettingActorAndTimer(BlindBluffSnapshot snap) {
    final bet = snap.mapOrNull(bettingPhase: (p) => p);
    if (bet == null) {
      _lastSyncedBettingActor = null;
      // Skill phase has no betting snapshot; do not cancel the skill countdown
      // timer here — every [_emitView] would otherwise stop ticks after any
      // skill declaration or AI update.
      if (_phaseOf(snap) != _SnapPhase.skill) {
        _timer?.cancel();
      }
      return;
    }
    if (bet.betting.isClosed) {
      _lastSyncedBettingActor = null;
      _timer?.cancel();
      return;
    }
    final actor = bet.betting.actingPlayer;
    if (actor == _lastSyncedBettingActor) {
      return;
    }
    _lastSyncedBettingActor = actor;
    _timer?.cancel();
    if (actor == BlindBluffPlayerId.playerTwo) {
      unawaited(_kickAi());
    } else {
      _startTurnTimer(_kBettingTurnSeconds);
    }
  }

  void _scheduleSkillRevealIfNeeded() {
    final p = _engine.snapshot.mapOrNull(skillPhase: (x) => x);
    if (p == null || !p.awaitingSkillRevealAck || _skillRevealAnimScheduled) {
      return;
    }
    _skillRevealAnimScheduled = true;
    _timer?.cancel();
    unawaited(() async {
      await Future<void>.delayed(const Duration(milliseconds: 2200));
      if (!isClosed) {
        notifySkillRevealAnimationComplete();
      }
    }());
  }

  _SnapPhase _phaseOf(BlindBluffSnapshot snap) {
    return snap.map(
      idleBetweenRounds: (_) => _SnapPhase.idle,
      skillPhase: (_) => _SnapPhase.skill,
      bettingPhase: (_) => _SnapPhase.betting,
      roundResolving: (_) => _SnapPhase.showdown,
      matchComplete: (_) => _SnapPhase.complete,
    );
  }

  void _onTick() {
    final snap = _engine.snapshot;
    if (!_phaseOf(snap).isTimed) {
      _timer?.cancel();
      return;
    }
    if (_phaseOf(snap) == _SnapPhase.skill && _skillIntroPending) {
      _timer?.cancel();
      return;
    }
    final skillSnap = snap.mapOrNull(skillPhase: (p) => p);
    if (skillSnap != null && skillSnap.awaitingSkillRevealAck) {
      _timer?.cancel();
      return;
    }

    if (_phaseOf(snap) == _SnapPhase.skill &&
        _skillReflectionSecondsRemaining > 0) {
      _skillReflectionSecondsRemaining--;
      if (_skillReflectionSecondsRemaining <= 0) {
        _startTurnTimer(10);
        emit(_mapSnapshot(snap));
        // Rival skill is chosen only after you commit or at window end — same
        // declaration phase so both sides "think together".
        return;
      }
      emit(_mapSnapshot(snap));
      return;
    }

    if (_phaseOf(snap) == _SnapPhase.betting) {
      final bet = snap.mapOrNull(bettingPhase: (p) => p);
      if (bet != null &&
          !bet.betting.isClosed &&
          bet.betting.actingPlayer == BlindBluffPlayerId.playerTwo) {
        return;
      }
    }

    if (_secondsRemaining <= 1) {
      _timer?.cancel();
      _handleTimeout();
      return;
    }
    _secondsRemaining--;
    emit(_mapSnapshot(snap));
  }

  void _handleTimeout() {
    final skill = _engine.snapshot.mapOrNull(skillPhase: (p) => p);
    if (skill != null &&
        !skill.awaitingSkillRevealAck &&
        _skillReflectionSecondsRemaining <= 0) {
      if (!skill.playerOneLockedChoice) {
        declarePlayerSkill(null);
        return;
      }
      if (!skill.playerTwoLockedChoice) {
        unawaited(_kickAi());
        return;
      }
    }

    final bet = _engine.snapshot.mapOrNull(bettingPhase: (p) => p);
    if (bet != null &&
        !bet.betting.isClosed &&
        bet.betting.actingPlayer == BlindBluffPlayerId.playerOne) {
      unawaited(
        submitPlayerBetting(const BlindBluffBettingAction.timeoutFold()),
      );
    }
  }

  BlindBluffMatchState _mapSnapshot(BlindBluffSnapshot snap) {
    return snap.when(
      idleBetweenRounds: (
        _,
        __,
        ___,
        ____,
        _____,
        skillsRemainingPlayerOne,
        skillsRemainingPlayerTwo,
      ) {
        _cachedPlayerSkills =
            Set<BlindBluffSkill>.from(skillsRemainingPlayerOne);
        _cachedOpponentSkills =
            Set<BlindBluffSkill>.from(skillsRemainingPlayerTwo);
        return const BlindBluffMatchState.loading();
      },
      skillPhase: (
        roundNumber,
        playerOneChips,
        playerTwoChips,
        baseAnteFrozenForRound,
        potAfterAnte,
        visibleOpponentCardToPlayerOne,
        visibleOpponentCardToPlayerTwo,
        skillsRemainingPlayerOne,
        skillsRemainingPlayerTwo,
        playerOneLockedChoice,
        playerTwoLockedChoice,
        awaitingSkillRevealAck,
        declaredSkillPlayerOne,
        declaredSkillPlayerTwo,
      ) {
        _bootstrapInsuranceForRound(roundNumber);
        _cachedPlayerSkills =
            Set<BlindBluffSkill>.from(skillsRemainingPlayerOne);
        _cachedOpponentSkills =
            Set<BlindBluffSkill>.from(skillsRemainingPlayerTwo);
        final anteFromEngine = _engine.anteDoubledFromNotice;
        if (anteFromEngine != null) {
          _engine.clearAnteDoubledNotice();
          _stashedAnteDoubledFrom = anteFromEngine;
          _stashedAnteDoubledTo = baseAnteFrozenForRound;
          _stashedAnteDoubleRound = roundNumber;
        }
        final anteDoubledFrom = _stashedAnteDoubleRound == roundNumber
            ? _stashedAnteDoubledFrom
            : null;
        final anteDoubledTo = _stashedAnteDoubleRound == roundNumber
            ? _stashedAnteDoubledTo
            : null;
        return BlindBluffMatchState.staredownPhase(
          roundNumber: roundNumber,
          playerChips: playerOneChips,
          opponentChips: playerTwoChips,
          pot: potAfterAnte,
          baseAnteFrozenForRound: baseAnteFrozenForRound,
          anteDoubledFrom: anteDoubledFrom,
          anteDoubledTo: anteDoubledTo,
          opponentCard: visibleOpponentCardToPlayerOne,
          playerCard: visibleOpponentCardToPlayerTwo,
          playerSkillsRemaining:
              Set<BlindBluffSkill>.from(skillsRemainingPlayerOne),
          opponentSkillsRemaining:
              Set<BlindBluffSkill>.from(skillsRemainingPlayerTwo),
          playerLockedSkill: playerOneLockedChoice,
          opponentLockedSkill: playerTwoLockedChoice,
          awaitingIntroSequence: _skillIntroPending,
          skillReflectionSecondsRemaining: _skillReflectionSecondsRemaining,
          awaitingSkillRevealAnimation: awaitingSkillRevealAck,
          revealedPlayerSkill: declaredSkillPlayerOne,
          revealedOpponentSkill: declaredSkillPlayerTwo,
          secondsRemaining: _secondsRemaining,
          actionLog: List<String>.unmodifiable(_log),
        );
      },
      bettingPhase: (
        roundNumber,
        playerOneChips,
        playerTwoChips,
        pot,
        baseAnteFrozenForRound,
        visibleOpponentCardToPlayerOne,
        visibleOpponentCardToPlayerTwo,
        betting,
      ) {
        final raiseNotice = _opponentRaiseNoticeChips;
        _opponentRaiseNoticeChips = null;
        final checkNotice = _opponentCheckNotice;
        _opponentCheckNotice = false;
        return BlindBluffMatchState.bettingPhase(
          roundNumber: roundNumber,
          playerChips: playerOneChips,
          opponentChips: playerTwoChips,
          pot: pot,
          baseAnteFrozenForRound: baseAnteFrozenForRound,
          opponentCard: visibleOpponentCardToPlayerOne,
          playerCard: visibleOpponentCardToPlayerTwo,
          betting: betting,
          chipsToCallPlayer:
              _chipsToCall(betting, BlindBluffPlayerId.playerOne),
          playerHasPenaltyInsurance: _playerInsuranceRound,
          opponentHasPenaltyInsurance: _opponentInsuranceRound,
          secondsRemaining: _secondsRemaining,
          actionLog: List<String>.unmodifiable(_log),
          playerSkillsRemaining:
              Set<BlindBluffSkill>.from(_cachedPlayerSkills),
          opponentSkillsRemaining:
              Set<BlindBluffSkill>.from(_cachedOpponentSkills),
          opponentRaiseNoticeChips: raiseNotice,
          opponentCheckNotice: checkNotice,
        );
      },
      roundResolving:
          (roundNumber, resolution, playerOneChipsAfterPot, playerTwoChipsAfterPot) {
        _timer?.cancel();
        if (_engine.isMatchComplete) {
          _cachedTerminalRoundResolution = resolution;
          _cachedTerminalRoundNumber = roundNumber;
        }
        return BlindBluffMatchState.showdown(
          roundNumber: roundNumber,
          resolution: resolution,
          playerChips: playerOneChipsAfterPot,
          opponentChips: playerTwoChipsAfterPot,
          actionLog: List<String>.unmodifiable(_log),
          matchCompletePending: _engine.isMatchComplete,
        );
      },
      matchComplete:
          (
        winner,
        reason,
        playerOneChips,
        playerTwoChips,
        terminalRoundResolution,
        terminalRoundNumber,
      ) {
        _timer?.cancel();
        return BlindBluffMatchState.gameOver(
          winner: winner,
          reason: reason,
          playerChips: playerOneChips,
          opponentChips: playerTwoChips,
          terminalRoundResolution:
              terminalRoundResolution ?? _cachedTerminalRoundResolution,
          terminalRoundNumber:
              terminalRoundNumber ?? _cachedTerminalRoundNumber,
        );
      },
    );
  }

  int _chipsToCall(BlindBluffBettingPublicView betting, BlindBluffPlayerId seat) {
    final hi = max(betting.contributionPlayerOne, betting.contributionPlayerTwo);
    final mine = seat == BlindBluffPlayerId.playerOne
        ? betting.contributionPlayerOne
        : betting.contributionPlayerTwo;
    return hi - mine;
  }

  void _appendLog(String line) {
    _log.add(line);
    if (_log.length > 14) {
      _log.removeAt(0);
    }
  }

  void _logHumanBetting(BlindBluffBettingAction action, int deltaP1) {
    _appendLog(
      switch (action.kind) {
        BlindBluffBettingActionKind.check => 'You checked.',
        BlindBluffBettingActionKind.call => 'You called (+$deltaP1 chips).',
        BlindBluffBettingActionKind.raise => 'You raised (+$deltaP1 chips).',
        BlindBluffBettingActionKind.fold ||
        BlindBluffBettingActionKind.timeoutFold =>
          'You folded.',
      },
    );
  }

  Future<void> _kickAi() async {
    await _maybeAiSkill();
    await _maybeAiBetting();
  }

  Future<void> _maybeAiSkill() async {
    if (_aiBusy) {
      return;
    }
    final phase = _engine.snapshot.mapOrNull(skillPhase: (p) => p);
    if (phase == null ||
        phase.playerTwoLockedChoice ||
        phase.awaitingSkillRevealAck ||
        _skillIntroPending) {
      return;
    }

    _aiBusy = true;
    try {
      final choice = await _ai.decideSkill(
        phase.visibleOpponentCardToPlayerTwo,
        availableSkills: phase.skillsRemainingPlayerTwo,
        myChips: phase.playerTwoChips,
        roundBaseAnte: phase.baseAnteFrozenForRound,
        playerChips: phase.playerOneChips,
      );

      final applied = _engine.submitSkillDeclaration(
        seat: BlindBluffPlayerId.playerTwo,
        skill: choice,
      );
      if (!applied) {
        return;
      }

      if (choice == BlindBluffSkill.penaltyInsurance) {
        _opponentInsuranceRound = true;
      }

      _appendLog(
        choice == null
            ? 'Opponent skipped skills.'
            : switch (choice) {
                BlindBluffSkill.plusTwoModifier => 'Opponent used +2 Value.',
                BlindBluffSkill.doubleBlind => 'Opponent used Double Ante.',
                BlindBluffSkill.penaltyInsurance => 'Opponent used Immunity.',
              },
      );

      _refreshSkillCaches();
      _emitView();
      await _maybeAiBetting();
    } finally {
      _aiBusy = false;
    }
  }

  Future<void> _maybeAiBetting() async {
    if (_aiBusy) {
      return;
    }

    final table = _engine.snapshot.mapOrNull(bettingPhase: (p) => p);
    if (table == null) {
      return;
    }

    final street = table.betting;
    if (street.isClosed || street.actingPlayer != BlindBluffPlayerId.playerTwo) {
      return;
    }

    _aiBusy = true;
    try {
      final chipsToCallAi =
          _chipsToCall(street, BlindBluffPlayerId.playerTwo);

      final action = await _ai.decideAction(
        humanCard: table.visibleOpponentCardToPlayerTwo,
        currentCallAmount: chipsToCallAi,
        myChips: table.playerTwoChips,
        minRaise: street.minRaise,
        hasPenaltyInsuranceThisRound: _opponentInsuranceRound,
        playerChips: table.playerOneChips,
      );

      final p2Before = street.contributionPlayerTwo;

      final applied = _engine.submitBettingAction(
        seat: BlindBluffPlayerId.playerTwo,
        action: action,
      );
      if (!applied) {
        return;
      }

      final after = _engine.snapshot.mapOrNull(bettingPhase: (p) => p);
      final deltaP2 = after == null
          ? 0
          : after.betting.contributionPlayerTwo - p2Before;

      if (action.kind == BlindBluffBettingActionKind.raise &&
          deltaP2 > 0) {
        final owedBefore = chipsToCallAi;
        final bump = deltaP2 - owedBefore;
        _opponentRaiseNoticeChips =
            bump > 0 ? bump : deltaP2;
      } else if (action.kind == BlindBluffBettingActionKind.check) {
        _opponentCheckNotice = true;
      }

      _appendLog(_describeOpponentBetting(action, deltaP2));

      _emitView();
      await _maybeAiBetting();
    } finally {
      _aiBusy = false;
    }
  }

  String _describeOpponentBetting(BlindBluffBettingAction action, int deltaP2) {
    return switch (action.kind) {
      BlindBluffBettingActionKind.check => 'Opponent checked.',
      BlindBluffBettingActionKind.call => 'Opponent called (+$deltaP2 chips).',
      BlindBluffBettingActionKind.raise => 'Opponent raised (+$deltaP2 chips).',
      BlindBluffBettingActionKind.fold ||
      BlindBluffBettingActionKind.timeoutFold =>
        'Opponent folded.',
    };
  }
}
