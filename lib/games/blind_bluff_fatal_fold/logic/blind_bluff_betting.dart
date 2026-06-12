import '../models/player_id.dart';

/// Betting choices during the post-skill wagering segment.
enum BlindBluffBettingActionKind {
  check,
  call,
  raise,
  fold,

  /// Mirrors the design rule that a missed timer resolves as a fold.
  timeoutFold,
}

/// Typed betting command issued by a seat.
class BlindBluffBettingAction {
  const BlindBluffBettingAction._({
    required this.kind,
    this.raiseBy,
  });

  const BlindBluffBettingAction.check()
      : this._(kind: BlindBluffBettingActionKind.check);

  const BlindBluffBettingAction.call()
      : this._(kind: BlindBluffBettingActionKind.call);

  const BlindBluffBettingAction.fold()
      : this._(kind: BlindBluffBettingActionKind.fold);

  const BlindBluffBettingAction.timeoutFold()
      : this._(kind: BlindBluffBettingActionKind.timeoutFold);

  /// Raise **by** this incremental amount beyond the call — must be ≥ [minRaise]
  /// unless the raise is all‑in or commits the opponent’s remaining stack (HU).
  const BlindBluffBettingAction.raise({required int raiseBy})
      : this._(
          kind: BlindBluffBettingActionKind.raise,
          raiseBy: raiseBy,
        );

  final BlindBluffBettingActionKind kind;

  /// Additional chips beyond matching the current wager (raises only).
  final int? raiseBy;
}

/// Mutable finite-state machine for a single heads-up betting segment.
///
/// Chips are **not** stored here — the caller moves stacks/pot using the
/// amounts reported via [lastContributionDelta].
class BlindBluffBettingRound {
  BlindBluffBettingRound({
    required this.firstToAct,
    required this.minRaise,
  }) : actingPlayer = firstToAct;

  /// Who opens the action after antes/skills resolve.
  final BlindBluffPlayerId firstToAct;

  /// Minimum incremental bump for raises (engine defaults to current base ante).
  final int minRaise;

  /// Amount each seat has contributed **during this betting segment**.
  int contributionPlayerOne = 0;
  int contributionPlayerTwo = 0;

  BlindBluffPlayerId actingPlayer;

  BlindBluffPlayerId? foldingPlayer;

  bool _closed = false;

  /// Tracks check/check completion around at the zero-street.
  bool _checkedAroundAtZero = false;

  /// Last chips added to the pot by the acting player when an action succeeds.
  int lastContributionDelta = 0;

  bool get isClosed => _closed;

  int _betFor(BlindBluffPlayerId seat) =>
      seat == BlindBluffPlayerId.playerOne
          ? contributionPlayerOne
          : contributionPlayerTwo;

  int get currentFacingBet {
    return contributionPlayerOne > contributionPlayerTwo
        ? contributionPlayerOne
        : contributionPlayerTwo;
  }

  /// Chips required for [seat] to reach [currentFacingBet].
  int chipsToCall(BlindBluffPlayerId seat) =>
      currentFacingBet - _betFor(seat);

  /// Applies [action] for [seat]. [seatStackBeforeAction] is that seat’s stack
  /// **before** this action (outside the pot); used for all‑in call / all‑in raise.
  /// [opponentStackBeforeAction] is used to allow sub‑[minRaise] bumps that still
  /// put a short opponent all‑in.
  ///
  /// Returns `false` when illegal or out-of-turn (state untouched).
  bool apply({
    required BlindBluffPlayerId seat,
    required BlindBluffBettingAction action,
    required bool Function(int amount) pullFromStack,
    required int seatStackBeforeAction,
    required int opponentStackBeforeAction,
  }) {
    if (_closed || foldingPlayer != null) {
      return false;
    }
    if (seat != actingPlayer) {
      return false;
    }

    lastContributionDelta = 0;

    final isTimedOutFold =
        action.kind == BlindBluffBettingActionKind.timeoutFold;
    final isVoluntaryFold = action.kind == BlindBluffBettingActionKind.fold;
    if (isVoluntaryFold || isTimedOutFold) {
      foldingPlayer = seat;
      _closed = true;
      return true;
    }

    switch (action.kind) {
      case BlindBluffBettingActionKind.fold:
      case BlindBluffBettingActionKind.timeoutFold:
        throw StateError('Fold paths must be handled before switching.');

      case BlindBluffBettingActionKind.check:
        if (contributionPlayerOne != contributionPlayerTwo ||
            contributionPlayerOne != 0) {
          return false;
        }
        if (_checkedAroundAtZero) {
          _closed = true;
          return true;
        }
        _checkedAroundAtZero = true;
        actingPlayer = actingPlayer.opponent;
        return true;

      case BlindBluffBettingActionKind.call:
        final owed = chipsToCall(seat);
        if (owed <= 0) {
          return false;
        }
        final actual = owed <= seatStackBeforeAction
            ? owed
            : seatStackBeforeAction;
        if (actual <= 0) {
          return false;
        }
        if (!pullFromStack(actual)) {
          return false;
        }
        _addContribution(seat, actual);
        _advanceTurnAfterCall();
        return true;

      case BlindBluffBettingActionKind.raise:
        final owed = chipsToCall(seat);
        final bumpRequested = action.raiseBy;
        if (bumpRequested == null || bumpRequested < 1) {
          return false;
        }
        final wanted = owed + bumpRequested;
        if (wanted > seatStackBeforeAction) {
          return false;
        }
        final bumpEff = bumpRequested;
        final total = wanted;
        final isAllIn = total == seatStackBeforeAction;
        final newContribution = _betFor(seat) + total;
        final oppOwed = newContribution - _betFor(seat.opponent);
        final forcesOpponentAllIn = opponentStackBeforeAction > 0 &&
            oppOwed >= opponentStackBeforeAction;
        if (!isAllIn && bumpEff < minRaise && !forcesOpponentAllIn) {
          return false;
        }
        if (!pullFromStack(total)) {
          return false;
        }
        _checkedAroundAtZero = false;
        _addContribution(seat, total);
        actingPlayer = seat.opponent;
        return true;
    }
  }

  void _addContribution(BlindBluffPlayerId seat, int amount) {
    if (seat == BlindBluffPlayerId.playerOne) {
      contributionPlayerOne += amount;
    } else {
      contributionPlayerTwo += amount;
    }
    lastContributionDelta = amount;
  }

  void _advanceTurnAfterCall() {
    if (contributionPlayerOne == contributionPlayerTwo) {
      _closed = true;
      return;
    }
    actingPlayer = actingPlayer.opponent;
  }

  /// Marks the round complete without a fold (used when stacks disallow further play).
  void forceCloseWithoutFold() {
    _closed = true;
  }

  /// After an uncalled excess refund, keep ledger contributions at the matched level.
  void clampContributionsToMatchedLevel() {
    final matched = contributionPlayerOne < contributionPlayerTwo
        ? contributionPlayerOne
        : contributionPlayerTwo;
    contributionPlayerOne = matched;
    contributionPlayerTwo = matched;
  }
}
