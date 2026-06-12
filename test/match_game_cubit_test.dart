import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/match_and_void/logic/board_generator.dart';
import 'package:genius_project/games/match_and_void/logic/match_game_cubit.dart';
import 'package:genius_project/games/match_and_void/logic/match_validator.dart';
import 'package:genius_project/games/match_and_void/models/match_card.dart';
import 'package:genius_project/games/match_and_void/models/match_game_feedback.dart';
import 'package:genius_project/games/match_and_void/models/match_game_mode.dart';

void main() {
  group('MatchGameCubit', () {
    test('arena starts on board 1 with score 0', () {
      final cubit = MatchGameCubit(mode: MatchGameMode.arena, random: Random(1));
      addTearDown(cubit.close);

      expect(cubit.state.mode, MatchGameMode.arena);
      expect(cubit.state.currentBoardIndex, 1);
      expect(cubit.state.currentScore, 0);
      expect(cubit.state.remainingSeconds, 0);
      expect(cubit.state.isGameOver, isFalse);
      expect(cubit.state.currentBoard, hasLength(9));
    });

    test('countdown starts with 90 seconds', () {
      final cubit =
          MatchGameCubit(mode: MatchGameMode.countdown, random: Random(1));
      addTearDown(cubit.close);

      expect(cubit.state.remainingSeconds, 90);
    });

    test('toggleCardSelection caps at three indices', () {
      final cubit = MatchGameCubit(mode: MatchGameMode.arena, random: Random(1));
      addTearDown(cubit.close);

      cubit.toggleCardSelection(0);
      cubit.toggleCardSelection(1);
      cubit.toggleCardSelection(2);
      cubit.toggleCardSelection(3);
      expect(cubit.state.selectedIndices, [0, 1, 2]);

      cubit.toggleCardSelection(1);
      expect(cubit.state.selectedIndices, [0, 2]);
    });

    test('valid submit adds history and scores in arena', () {
      final board = [
        MatchCard.fromId(0),
        MatchCard.fromId(1),
        MatchCard.fromId(2),
        ...List<MatchCard>.generate(6, (i) => MatchCard.fromId(i + 10)),
      ];
      expect(
        MatchValidator.isValidMatch(board[0], board[1], board[2]),
        isTrue,
      );

      final cubit = MatchGameCubit(
        mode: MatchGameMode.arena,
        random: Random(1),
        initialBoard: board,
      );
      addTearDown(cubit.close);

      cubit.toggleCardSelection(0);
      cubit.toggleCardSelection(1);
      cubit.toggleCardSelection(2);
      cubit.submitMatch();

      expect(cubit.state.currentScore, 1);
      expect(cubit.state.historyLog, hasLength(1));
      expect(cubit.state.selectedIndices, isEmpty);
      expect(cubit.state.voidPenaltyLevel, 0);
    });

    test('invalid submit penalizes arena score', () {
      final cubit = MatchGameCubit(mode: MatchGameMode.arena, random: Random(1));
      addTearDown(cubit.close);

      cubit.toggleCardSelection(0);
      cubit.toggleCardSelection(1);
      cubit.toggleCardSelection(3);
      cubit.submitMatch();

      expect(cubit.state.currentScore, -1);
      expect(cubit.state.historyLog, isEmpty);
    });

    test('declareVoid succeeds when board has no valid triplets', () {
      final board = _firstVoidableBoard();
      final cubit = MatchGameCubit(
        mode: MatchGameMode.arena,
        random: Random(99),
        initialBoard: board,
      );
      addTearDown(cubit.close);

      expect(MatchValidator.findAllValidMatches(board), isEmpty);

      cubit.declareVoid();
      expect(cubit.state.currentScore, 3);
      expect(cubit.state.currentBoardIndex, 2);
      expect(cubit.state.historyLog, isEmpty);
    });

    test('declareVoid failure escalates arena void penalty', () {
      final board = [
        MatchCard.fromId(0),
        MatchCard.fromId(1),
        MatchCard.fromId(2),
        ...List<MatchCard>.generate(6, (i) => MatchCard.fromId(i + 10)),
      ];
      final cubit = MatchGameCubit(
        mode: MatchGameMode.arena,
        random: Random(1),
        initialBoard: board,
      );
      addTearDown(cubit.close);

      cubit.declareVoid();
      expect(cubit.state.currentScore, -1);
      expect(cubit.state.voidPenaltyLevel, 1);
    });

    test('countdown valid submit adds time', () {
      final board = [
        MatchCard.fromId(0),
        MatchCard.fromId(1),
        MatchCard.fromId(2),
        ...List<MatchCard>.generate(6, (i) => MatchCard.fromId(i + 10)),
      ];
      final cubit = MatchGameCubit(
        mode: MatchGameMode.countdown,
        random: Random(1),
        initialBoard: board,
      );
      addTearDown(cubit.close);

      expect(cubit.state.remainingSeconds, 90);

      cubit.toggleCardSelection(0);
      cubit.toggleCardSelection(1);
      cubit.toggleCardSelection(2);
      cubit.submitMatch();

      expect(cubit.state.currentScore, 1);
      expect(cubit.state.remainingSeconds, 105);
    });

    test('countdown match bonus tiers by board index', () {
      expect(MatchGameCubit.countdownMatchBonusForBoard(1), 15);
      expect(MatchGameCubit.countdownMatchBonusForBoard(5), 15);
      expect(MatchGameCubit.countdownMatchBonusForBoard(6), 10);
      expect(MatchGameCubit.countdownMatchBonusForBoard(10), 10);
      expect(MatchGameCubit.countdownMatchBonusForBoard(11), 10);
    });

    test('countdown void bonus tiers by board index', () {
      expect(MatchGameCubit.countdownVoidBonusForBoard(1), 30);
      expect(MatchGameCubit.countdownVoidBonusForBoard(5), 30);
      expect(MatchGameCubit.countdownVoidBonusForBoard(6), 25);
      expect(MatchGameCubit.countdownVoidBonusForBoard(10), 25);
      expect(MatchGameCubit.countdownVoidBonusForBoard(11), 20);
    });

    test('countdown wrong match costs 3 seconds and shows toast', () {
      final cubit =
          MatchGameCubit(mode: MatchGameMode.countdown, random: Random(1));
      addTearDown(cubit.close);

      cubit.toggleCardSelection(0);
      cubit.toggleCardSelection(1);
      cubit.toggleCardSelection(3);
      cubit.submitMatch();

      expect(cubit.state.remainingSeconds, 87);
      expect(cubit.state.pendingFeedback?.kind, MatchGameFeedbackKind.wrongMatch);
    });

    test('arena next void penalty shows 3 before fifth wrong void', () {
      final board = [
        MatchCard.fromId(0),
        MatchCard.fromId(1),
        MatchCard.fromId(2),
        ...List<MatchCard>.generate(6, (i) => MatchCard.fromId(i + 10)),
      ];
      final cubit = MatchGameCubit(
        mode: MatchGameMode.arena,
        random: Random(1),
        initialBoard: board,
      );
      addTearDown(cubit.close);

      for (var i = 0; i < 4; i++) {
        cubit.declareVoid();
      }
      expect(cubit.arenaNextVoidPenaltyIfWrong(), 3);
    });

    test('arena completing board 10 ends at 10/10 not 11', () {
      final board = _firstVoidableBoard();
      final cubit = MatchGameCubit(
        mode: MatchGameMode.arena,
        random: Random(99),
        initialBoard: board,
      );
      addTearDown(cubit.close);
      cubit.emit(cubit.state.copyWith(currentBoardIndex: 10));

      cubit.declareVoid();

      expect(cubit.state.isGameOver, isTrue);
      expect(cubit.state.currentBoardIndex, 10);
    });

    test('five wrong voids in a row advances board and arena streak costs 3 pts', () {
      final board = [
        MatchCard.fromId(0),
        MatchCard.fromId(1),
        MatchCard.fromId(2),
        ...List<MatchCard>.generate(6, (i) => MatchCard.fromId(i + 10)),
      ];
      final cubit = MatchGameCubit(
        mode: MatchGameMode.arena,
        random: Random(1),
        initialBoard: board,
      );
      addTearDown(cubit.close);

      for (var i = 0; i < 5; i++) {
        cubit.declareVoid();
      }

      expect(cubit.state.currentBoardIndex, 2);
      expect(cubit.state.voidStreakAdvanceNotice, isTrue);
      expect(cubit.state.voidPenaltyLevel, 0);
      // −1, −1, −2, −2 on voids 1–4, then −3 on 5th (forced board advance).
      expect(cubit.state.currentScore, -9);
    });
  });
}

List<MatchCard> _firstVoidableBoard() {
  final rng = Random(0);
  for (var attempt = 0; attempt < 200000; attempt++) {
    final ids = List<int>.generate(27, (i) => i)..shuffle(rng);
    final board = ids.take(9).map(MatchCard.fromId).toList();
    if (MatchValidator.findAllValidMatches(board).isEmpty) {
      return board;
    }
  }
  throw StateError('Could not find a voidable 9-card board');
}
