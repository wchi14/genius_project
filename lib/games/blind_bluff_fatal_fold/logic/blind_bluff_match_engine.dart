import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/blind_card.dart';
import '../models/player_id.dart';
import 'blind_bluff_betting.dart';
import 'blind_bluff_deck.dart';
import 'blind_bluff_match_state.dart';
import 'blind_bluff_skills.dart';
import 'fatal_fold_rules.dart';
import 'showdown_comparator.dart';

/// Chip budgets at match start.
const int blindBluffStartingStack = 30;

/// Pure orchestrator for **Blind Bluff: Fatal Fold** match flow (no UI timers).
class BlindBluffMatchEngine {
  BlindBluffMatchEngine({Random? random})
      : _rng = random ?? Random(),
        _deck = BlindBluffDeck(random: random);

  final Random _rng;
  final BlindBluffDeck _deck;

  /// `null` until the first post-skill betting segment starts; then always the
  /// seat that should open **next** round (alternates from the opener used last).
  BlindBluffPlayerId? _nextRoundOpeningSeat;

  BlindBluffSkill? _declaredSkillPlayerOne;
  BlindBluffSkill? _declaredSkillPlayerTwo;
  bool _awaitingSkillReveal = false;

  final Set<BlindBluffSkill> _skillsPlayerOne =
      BlindBluffSkill.values.toSet();
  final Set<BlindBluffSkill> _skillsPlayerTwo =
      BlindBluffSkill.values.toSet();

  int _playerOneChips = blindBluffStartingStack;
  int _playerTwoChips = blindBluffStartingStack;

  int _baseAnte = 1;
  /// Previous ante before [beginRound] doubled it (null when no double this deal).
  int? _anteDoubledFromNotice;
  int _rolledPot = 0;
  int _pot = 0;

  /// Increments whenever [finishRound] completes successfully.
  int _completedRounds = 0;

  /// Active serial for the round currently being played (`1` on first begin).
  int _activeRoundNumber = 0;

  int _baseAnteFrozenForRound = 1;

  BlindCard? _playerOneCard;
  BlindCard? _playerTwoCard;

  bool _skillLockedPlayerOne = false;
  bool _skillLockedPlayerTwo = false;

  bool _playerOnePlusTwo = false;
  bool _playerTwoPlusTwo = false;
  bool _playerOneInsurance = false;
  bool _playerTwoInsurance = false;

  BlindBluffBettingRound? _betting;

  BlindBluffPlayerId? _matchWinner;
  String? _terminalReason;

  BlindBluffRoundResolution? _pendingResolution;

  /// Last ledger from [finishRound] when it also ended the match (for summary UI).
  BlindBluffRoundResolution? _terminalRoundResolutionForMatchComplete;
  int? _terminalRoundNumberForMatchComplete;

  bool get isMatchComplete => _matchWinner != null;

  /// Non-null only on the round right after the shoe recycled and ante doubled.
  int? get anteDoubledFromNotice => _anteDoubledFromNotice;

  void clearAnteDoubledNotice() => _anteDoubledFromNotice = null;

  /// Test-only: set stacks during an active round (e.g. before wagering actions).
  @visibleForTesting
  void debugSetStacksForTest({
    required int playerOne,
    required int playerTwo,
  }) {
    _playerOneChips = playerOne;
    _playerTwoChips = playerTwo;
  }

  /// Test-only: configure idle-between-rounds chip state before [beginRound].
  @visibleForTesting
  void debugIdleCarryoverForTest({
    required int playerOne,
    required int playerTwo,
    required int rolledPot,
    int completedRounds = 1,
    int? baseAnte,
  }) {
    _tearDownActiveRound();
    _matchWinner = null;
    _terminalReason = null;
    _playerOneChips = playerOne;
    _playerTwoChips = playerTwo;
    _rolledPot = rolledPot;
    _completedRounds = completedRounds;
    _pot = 0;
    if (baseAnte != null) {
      _baseAnte = baseAnte;
    }
  }

  /// Latest public projection for presentation layers.
  BlindBluffSnapshot get snapshot {
    final pending = _pendingResolution;
    if (pending != null) {
      return BlindBluffSnapshot.roundResolving(
        roundNumber: _activeRoundNumber,
        resolution: pending,
        playerOneChipsAfterPot: _playerOneChips,
        playerTwoChipsAfterPot: _playerTwoChips,
      );
    }

    final winner = _matchWinner;
    if (winner != null) {
      return BlindBluffSnapshot.matchComplete(
        winner: winner,
        reason: _terminalReason ?? 'unknown',
        playerOneChips: _playerOneChips,
        playerTwoChips: _playerTwoChips,
        terminalRoundResolution: _terminalRoundResolutionForMatchComplete,
        terminalRoundNumber: _terminalRoundNumberForMatchComplete,
      );
    }

    if (_betting != null &&
        _playerOneCard != null &&
        _playerTwoCard != null) {
      final betting = _betting!;
      return BlindBluffSnapshot.bettingPhase(
        roundNumber: _activeRoundNumber,
        playerOneChips: _playerOneChips,
        playerTwoChips: _playerTwoChips,
        pot: _pot,
        baseAnteFrozenForRound: _baseAnteFrozenForRound,
        visibleOpponentCardToPlayerOne: _playerTwoCard!,
        visibleOpponentCardToPlayerTwo: _playerOneCard!,
        betting: BlindBluffBettingPublicView(
          contributionPlayerOne: betting.contributionPlayerOne,
          contributionPlayerTwo: betting.contributionPlayerTwo,
          actingPlayer: betting.actingPlayer,
          foldingPlayer: betting.foldingPlayer,
          isClosed: betting.isClosed,
          minRaise: betting.minRaise,
          firstToAct: betting.firstToAct,
        ),
      );
    }

    if (_playerOneCard != null && _playerTwoCard != null) {
      final bothLocked = _skillLockedPlayerOne && _skillLockedPlayerTwo;
      return BlindBluffSnapshot.skillPhase(
        roundNumber: _activeRoundNumber,
        playerOneChips: _playerOneChips,
        playerTwoChips: _playerTwoChips,
        baseAnteFrozenForRound: _baseAnteFrozenForRound,
        potAfterAnte: _pot,
        visibleOpponentCardToPlayerOne: _playerTwoCard!,
        visibleOpponentCardToPlayerTwo: _playerOneCard!,
        skillsRemainingPlayerOne: Set<BlindBluffSkill>.from(_skillsPlayerOne),
        skillsRemainingPlayerTwo: Set<BlindBluffSkill>.from(_skillsPlayerTwo),
        playerOneLockedChoice: _skillLockedPlayerOne,
        playerTwoLockedChoice: _skillLockedPlayerTwo,
        awaitingSkillRevealAck: bothLocked && _awaitingSkillReveal,
        declaredSkillPlayerOne: bothLocked ? _declaredSkillPlayerOne : null,
        declaredSkillPlayerTwo: bothLocked ? _declaredSkillPlayerTwo : null,
      );
    }

    return BlindBluffSnapshot.idleBetweenRounds(
      completedRounds: _completedRounds,
      playerOneChips: _playerOneChips,
      playerTwoChips: _playerTwoChips,
      baseAnte: _baseAnte,
      rolledPotCarryover: _rolledPot,
      skillsRemainingPlayerOne: Set<BlindBluffSkill>.from(_skillsPlayerOne),
      skillsRemainingPlayerTwo: Set<BlindBluffSkill>.from(_skillsPlayerTwo),
    );
  }

  /// Starts a fresh round from [BlindBluffSnapshot.idleBetweenRounds].
  ///
  /// Throws if the match already ended or if a round is in-flight.
  void beginRound() {
    if (_matchWinner != null) {
      throw StateError('Match already complete.');
    }
    if (_pendingResolution != null) {
      throw StateError('Finish the pending round before starting another.');
    }
    if (_playerOneCard != null || _playerTwoCard != null) {
      throw StateError('A round is already active.');
    }

    _terminalRoundResolutionForMatchComplete = null;
    _terminalRoundNumberForMatchComplete = null;

    _activeRoundNumber = _completedRounds + 1;
    _skillLockedPlayerOne = false;
    _skillLockedPlayerTwo = false;
    _declaredSkillPlayerOne = null;
    _declaredSkillPlayerTwo = null;
    _awaitingSkillReveal = false;
    _playerOnePlusTwo = false;
    _playerTwoPlusTwo = false;
    _playerOneInsurance = false;
    _playerTwoInsurance = false;
    _betting = null;

    _anteDoubledFromNotice = null;
    if (_deck.needsReshuffleBeforeDeal) {
      _anteDoubledFromNotice = _baseAnte;
      _deck.reshuffleDiscardIntoDraw();
      _baseAnte *= 2;
    }

    final dealt = _deck.drawTwo();
    _playerOneCard = dealt.first;
    _playerTwoCard = dealt.second;

    _baseAnteFrozenForRound = _baseAnte;

    if (!_canContestNextRoundAfterAnte()) {
      if (_playerOneChips == 0 && _playerTwoChips > 0) {
        _awardMatchDueToBankruptcy(cannotPay: BlindBluffPlayerId.playerOne);
      } else if (_playerTwoChips == 0 && _playerOneChips > 0) {
        _awardMatchDueToBankruptcy(cannotPay: BlindBluffPlayerId.playerTwo);
      } else {
        _matchWinner = BlindBluffPlayerId.playerTwo;
        _terminalReason = 'Both seats busted — opponent wins on tie-break.';
        _tearDownActiveRound();
      }
      return;
    }

    final p1Posted = min(_playerOneChips, _baseAnteFrozenForRound);
    final p2Posted = min(_playerTwoChips, _baseAnteFrozenForRound);
    _playerOneChips -= p1Posted;
    _playerTwoChips -= p2Posted;
    _pot = _rolledPot + p1Posted + p2Posted;
    _rolledPot = 0;
    _syncEliminationAfterChipChange();
  }

  /// Declare a skill (or `null` for pass). Each seat locks exactly once.
  bool submitSkillDeclaration({
    required BlindBluffPlayerId seat,
    required BlindBluffSkill? skill,
  }) {
    if (_matchWinner != null || _pendingResolution != null) {
      return false;
    }
    if (_playerOneCard == null || _playerTwoCard == null) {
      return false;
    }
    if (_betting != null) {
      return false;
    }

    final locked =
        seat == BlindBluffPlayerId.playerOne ? _skillLockedPlayerOne : _skillLockedPlayerTwo;
    if (locked) {
      return false;
    }

    if (skill != null) {
      final available =
          seat == BlindBluffPlayerId.playerOne ? _skillsPlayerOne : _skillsPlayerTwo;
      if (!available.contains(skill)) {
        return false;
      }
      switch (skill) {
        case BlindBluffSkill.plusTwoModifier:
          if (seat == BlindBluffPlayerId.playerOne) {
            _playerOnePlusTwo = true;
          } else {
            _playerTwoPlusTwo = true;
          }
          available.remove(skill);
          break;
        case BlindBluffSkill.penaltyInsurance:
          if (seat == BlindBluffPlayerId.playerOne) {
            _playerOneInsurance = true;
          } else {
            _playerTwoInsurance = true;
          }
          available.remove(skill);
          break;
        case BlindBluffSkill.doubleBlind:
          if (_playerOneChips < _baseAnteFrozenForRound ||
              _playerTwoChips < _baseAnteFrozenForRound) {
            return false;
          }
          _playerOneChips -= _baseAnteFrozenForRound;
          _playerTwoChips -= _baseAnteFrozenForRound;
          _pot += 2 * _baseAnteFrozenForRound;
          available.remove(skill);
          break;
      }
    }

    if (seat == BlindBluffPlayerId.playerOne) {
      _skillLockedPlayerOne = true;
      _declaredSkillPlayerOne = skill;
    } else {
      _skillLockedPlayerTwo = true;
      _declaredSkillPlayerTwo = skill;
    }

    if (_skillLockedPlayerOne && _skillLockedPlayerTwo) {
      _awaitingSkillReveal = true;
    }
    _syncEliminationAfterChipChange();
    return true;
  }

  /// When both seats have no skills left, auto-pass and open betting (no reveal).
  bool skipSkillPhaseIfNoSkillsRemain() {
    if (_matchWinner != null ||
        _pendingResolution != null ||
        _betting != null ||
        _playerOneCard == null ||
        _playerTwoCard == null) {
      return false;
    }
    if (_skillsPlayerOne.isNotEmpty || _skillsPlayerTwo.isNotEmpty) {
      return false;
    }

    _skillLockedPlayerOne = true;
    _skillLockedPlayerTwo = true;
    _declaredSkillPlayerOne = null;
    _declaredSkillPlayerTwo = null;
    _awaitingSkillReveal = false;
    _startBettingSegment();
    return true;
  }

  /// Continues into the betting segment after the UI has finished the skill
  /// reveal animation.
  bool acknowledgeSkillReveal() {
    if (!_awaitingSkillReveal || _betting != null) {
      return false;
    }
    if (!_skillLockedPlayerOne || !_skillLockedPlayerTwo) {
      return false;
    }
    _awaitingSkillReveal = false;
    _startBettingSegment();
    return true;
  }

  /// Applies a wagering decision for whichever seat actually holds the turn.
  bool submitBettingAction({
    required BlindBluffPlayerId seat,
    required BlindBluffBettingAction action,
  }) {
    final betting = _betting;
    if (_matchWinner != null ||
        _pendingResolution != null ||
        betting == null) {
      return false;
    }

    final applied = betting.apply(
      seat: seat,
      action: action,
      pullFromStack: (amount) => _pullChipsToPot(seat, amount),
      seatStackBeforeAction: seat == BlindBluffPlayerId.playerOne
          ? _playerOneChips
          : _playerTwoChips,
      opponentStackBeforeAction: seat == BlindBluffPlayerId.playerOne
          ? _playerTwoChips
          : _playerOneChips,
    );

    if (!applied) {
      return false;
    }

    _syncUncalledWagersBeforePotAward(closeStreetWhenRefunded: true);

    if (betting.isClosed) {
      final folder = betting.foldingPlayer;
      if (folder != null) {
        _resolveFold(folder);
      } else {
        _resolveShowdown();
      }
      return true;
    }

    // All‑in with stack at 0 but street still open (e.g. opponent must still call).
    if (_syncEliminationAfterChipChange()) {
      return true;
    }

    return true;
  }

  /// Cleans up table state after the UI consumes [BlindBluffSnapshot.roundResolving].
  void finishRound() {
    final resolution = _pendingResolution;
    if (resolution == null) {
      throw StateError('No resolution awaiting acknowledgement.');
    }
    final finishedRoundSerial = _activeRoundNumber;

    final p1 = _playerOneCard;
    final p2 = _playerTwoCard;
    if (p1 == null || p2 == null) {
      throw StateError('Missing hole cards during finishRound.');
    }

    _deck.discardPlayedCards(p1, p2);
    _playerOneCard = null;
    _playerTwoCard = null;
    _betting = null;
    _pendingResolution = null;

    _completedRounds++;

    _syncEliminationAfterChipChange();

    if (_matchWinner != null) {
      _terminalRoundResolutionForMatchComplete = resolution;
      _terminalRoundNumberForMatchComplete = finishedRoundSerial;
    }
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  void _startBettingSegment() {
    final opener = _nextRoundOpeningSeat ??
        (_rng.nextBool()
            ? BlindBluffPlayerId.playerOne
            : BlindBluffPlayerId.playerTwo);
    _nextRoundOpeningSeat = opener.opponent;
    _betting = BlindBluffBettingRound(
      firstToAct: opener,
      minRaise: _baseAnteFrozenForRound,
    );
  }

  bool _pullChipsToPot(BlindBluffPlayerId seat, int amount) {
    if (amount <= 0) {
      return false;
    }
    if (seat == BlindBluffPlayerId.playerOne) {
      if (_playerOneChips < amount) {
        return false;
      }
      _playerOneChips -= amount;
    } else {
      if (_playerTwoChips < amount) {
        return false;
      }
      _playerTwoChips -= amount;
    }
    _pot += amount;
    return true;
  }

  /// Returns matched chips per seat on the current street (`0` if no betting).
  int _matchedWagerPerSeatOnStreet() {
    final betting = _betting;
    if (betting == null) {
      return 0;
    }
    return min(
      betting.contributionPlayerOne,
      betting.contributionPlayerTwo,
    );
  }

  /// Heads‑up: when the shorter stack is all‑in, return uncalled chips to the
  /// bettor and clamp street contributions to the matched amount.
  ///
  /// Also runs at showdown as a safety net if the street was still open.
  void _syncUncalledWagersBeforePotAward({bool closeStreetWhenRefunded = false}) {
    final betting = _betting;
    if (betting == null) {
      return;
    }
    final c1 = betting.contributionPlayerOne;
    final c2 = betting.contributionPlayerTwo;
    if (c1 == c2) {
      return;
    }

    final loSeat = c1 < c2
        ? BlindBluffPlayerId.playerOne
        : BlindBluffPlayerId.playerTwo;
    final loStack =
        loSeat == BlindBluffPlayerId.playerOne ? _playerOneChips : _playerTwoChips;
    if (loStack != 0) {
      return;
    }

    final refundTo = loSeat.opponent;
    final excess = (c1 - c2).abs();
    if (excess <= 0) {
      return;
    }
    final refund = min(excess, _pot);
    if (refund <= 0) {
      return;
    }
    _pot -= refund;
    if (refundTo == BlindBluffPlayerId.playerOne) {
      _playerOneChips += refund;
    } else {
      _playerTwoChips += refund;
    }
    betting.clampContributionsToMatchedLevel();
    if (closeStreetWhenRefunded && !betting.isClosed) {
      betting.forceCloseWithoutFold();
    }
  }

  void _resolveFold(BlindBluffPlayerId folder) {
    final winner = folder.opponent;
    final awarded = _pot;
    _pot = 0;

    if (winner == BlindBluffPlayerId.playerOne) {
      _playerOneChips += awarded;
    } else {
      _playerTwoChips += awarded;
    }

    final folderCard = _cardForSeat(folder);
    final opponentCard = _cardForSeat(folder.opponent);

    final insured = folder == BlindBluffPlayerId.playerOne
        ? _playerOneInsurance
        : _playerTwoInsurance;

    final owesPenalty = owesFatalFoldPenalty(
      folderOwnCard: folderCard,
      opponentVisibleCard: opponentCard,
      hadPenaltyInsurance: insured,
    );

    var penaltyPaid = 0;
    if (owesPenalty) {
      final folderStack = folder == BlindBluffPlayerId.playerOne
          ? _playerOneChips
          : _playerTwoChips;
      penaltyPaid = min(fatalFoldPenaltyChips, folderStack);
      if (penaltyPaid > 0) {
        _transferChips(from: folder, to: winner, amount: penaltyPaid);
      }
    }

    _pendingResolution = BlindBluffRoundResolution.fold(
      potWinner: winner,
      foldingPlayer: folder,
      foldingPlayersCard: folderCard,
      opponentsVisibleCard: opponentCard,
      potAwarded: awarded,
      fatalFoldPenaltyApplied: owesPenalty,
      fatalFoldPenaltyPaid: penaltyPaid,
    );
    _syncEliminationAfterChipChange();
  }

  void _resolveShowdown() {
    _syncUncalledWagersBeforePotAward(closeStreetWhenRefunded: true);

    final p1Card = _playerOneCard!;
    final p2Card = _playerTwoCard!;
    final matchedWagerPerSeat = _matchedWagerPerSeatOnStreet();
    final outcome = compareShowdown(
      playerOneCard: p1Card,
      playerTwoCard: p2Card,
      playerOnePlusTwo: _playerOnePlusTwo,
      playerTwoPlusTwo: _playerTwoPlusTwo,
    );

    final previousPot = _pot;
    switch (outcome) {
      case ShowdownOutcome.tie:
        _rolledPot += previousPot;
        _pot = 0;
        _pendingResolution = BlindBluffRoundResolution.showdown(
          outcome: outcome,
          playerOneCard: p1Card,
          playerTwoCard: p2Card,
          playerOneUsedPlusTwo: _playerOnePlusTwo,
          playerTwoUsedPlusTwo: _playerTwoPlusTwo,
          potAwardedToWinner: 0,
          matchedWagerPerSeat: matchedWagerPerSeat,
          rolledPotNextRound: _rolledPot,
        );
        break;
      case ShowdownOutcome.playerOneWins:
        _playerOneChips += previousPot;
        _pot = 0;
        _pendingResolution = BlindBluffRoundResolution.showdown(
          outcome: outcome,
          playerOneCard: p1Card,
          playerTwoCard: p2Card,
          playerOneUsedPlusTwo: _playerOnePlusTwo,
          playerTwoUsedPlusTwo: _playerTwoPlusTwo,
          potAwardedToWinner: previousPot,
          matchedWagerPerSeat: matchedWagerPerSeat,
          rolledPotNextRound: _rolledPot,
        );
        break;
      case ShowdownOutcome.playerTwoWins:
        _playerTwoChips += previousPot;
        _pot = 0;
        _pendingResolution = BlindBluffRoundResolution.showdown(
          outcome: outcome,
          playerOneCard: p1Card,
          playerTwoCard: p2Card,
          playerOneUsedPlusTwo: _playerOnePlusTwo,
          playerTwoUsedPlusTwo: _playerTwoPlusTwo,
          potAwardedToWinner: previousPot,
          matchedWagerPerSeat: matchedWagerPerSeat,
          rolledPotNextRound: _rolledPot,
        );
        break;
    }
    _syncEliminationAfterChipChange();
  }

  BlindCard _cardForSeat(BlindBluffPlayerId seat) {
    return seat == BlindBluffPlayerId.playerOne ? _playerOneCard! : _playerTwoCard!;
  }

  void _transferChips({
    required BlindBluffPlayerId from,
    required BlindBluffPlayerId to,
    required int amount,
  }) {
    if (amount == 0) {
      return;
    }
    if (from == BlindBluffPlayerId.playerOne) {
      _playerOneChips -= amount;
      _playerTwoChips += amount;
    } else {
      _playerTwoChips -= amount;
      _playerOneChips += amount;
    }
  }

  /// Chips still contestable on the table (center pot or carryover), not in stacks.
  bool _hasContestablePot() => _pot > 0 || _rolledPot > 0;

  /// Whether the next hand can start when a seat cannot post the full ante.
  bool _canContestNextRoundAfterAnte() {
    if (_hasContestablePot()) {
      return true;
    }
    if (_playerOneChips > 0 && _playerTwoChips > 0) {
      return true;
    }
    return false;
  }

  void _awardMatchDueToBankruptcy({
    required BlindBluffPlayerId cannotPay,
  }) {
    _matchWinner = cannotPay.opponent;
    _terminalReason = 'Could not pay the ante.';
    _tearDownActiveRound();
  }

  /// Returns `true` when the match just ended because a seat hit zero chips.
  bool _syncEliminationAfterChipChange() {
    if (_matchWinner != null) {
      return true;
    }

    // All‑in with stack at 0: opponent may still call/fold — do not end the
    // match until this betting street is closed.
    final street = _betting;
    if (street != null && !street.isClosed) {
      return false;
    }

    _maybeDeclareWinnerByElimination();
    if (_matchWinner == null) {
      return false;
    }
    if (_pendingResolution == null) {
      _tearDownActiveRound();
    }
    return true;
  }

  void _tearDownActiveRound() {
    final p1 = _playerOneCard;
    final p2 = _playerTwoCard;
    if (p1 != null && p2 != null) {
      _deck.discardPlayedCards(p1, p2);
    }
    _playerOneCard = null;
    _playerTwoCard = null;
    _betting = null;
    _pendingResolution = null;
    _awaitingSkillReveal = false;
  }

  void _maybeDeclareWinnerByElimination() {
    if (_playerOneChips <= 0 && _playerTwoChips <= 0) {
      if (_hasContestablePot()) {
        return;
      }
      _matchWinner = BlindBluffPlayerId.playerTwo;
      _terminalReason = 'Both seats busted — opponent wins on tie-break.';
      return;
    }
    if (_playerOneChips <= 0) {
      if (_hasContestablePot()) {
        return;
      }
      _matchWinner = BlindBluffPlayerId.playerTwo;
      _terminalReason = 'Player ran out of chips.';
    } else if (_playerTwoChips <= 0) {
      if (_hasContestablePot()) {
        return;
      }
      _matchWinner = BlindBluffPlayerId.playerOne;
      _terminalReason = 'Opponent ran out of chips.';
    }
  }
}
