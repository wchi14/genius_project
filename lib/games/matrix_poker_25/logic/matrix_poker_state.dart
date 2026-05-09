import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/matrix_grid_model.dart';
import 'combo.dart';

part 'matrix_poker_state.freezed.dart';

/// Matrix Poker 25 Cubit state — union built with **freezed**.
///
/// UI should prefer exhaustive [`when`]/[`maybeWhen`] switching (see
/// [MatrixPokerScreen] `BlocBuilder`).
@freezed
class MatrixPokerState with _$MatrixPokerState {
  /// Session boot / idle before Phase 1 begins.
  const factory MatrixPokerState.initial() = _Initial;

  /// Phase 1: dealer reveals a shared draw each turn; P1 picks an empty cell.
  ///
  /// *(Included alongside the Task 2.1b unions so the existing loop keeps working.)*
  const factory MatrixPokerState.boardFilling({
    required MatrixGridModel grid,
    required int fillRound,
    required int dealerValue,
    required int remainingSeconds,
    @Default(25) int totalRounds,
  }) = _BoardFilling;

  /// Phase 2: user is picking twelve line combos on [grid].
  const factory MatrixPokerState.drafting({
    required MatrixGridModel grid,
    required List<Combo> draftedCombos,
    required int remainingSeconds,
  }) = _Drafting;

  /// Loading gap after P1 commits (mock opponent latency).
  const factory MatrixPokerState.waitingForOpponent() = _WaitingForOpponent;

  /// Phase 3 — active blind duel turn for P1.
  const factory MatrixPokerState.duelTurn({
    required int round,
    required int p1Score,
    required int p2Score,
    required int remainingSeconds,

    /// Snapshot of P1’s twelve combos for UI / AI parity (slot **index** is still
    /// implied by list position `0..11`; consumed slots remain visible via Cubit).
    required List<Combo> p1RemainingCombos,
  }) = _DuelTurn;

  /// Both commits resolved — show reveal overlay before advancing.
  const factory MatrixPokerState.roundResolved({
    required Combo p1Revealed,
    required Combo p2Revealed,
    required String resultMessage,
    required bool isGameOver,
  }) = _RoundResolved;

  /// Duel finished — overall outcome banner.
  const factory MatrixPokerState.gameOver({
    required int finalP1Score,
    required int finalP2Score,
    required String winner,
  }) = _GameOver;
}
