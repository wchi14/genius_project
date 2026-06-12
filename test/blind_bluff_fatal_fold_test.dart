import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:genius_project/games/blind_bluff_fatal_fold/logic/blind_bluff_betting.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/logic/blind_bluff_match_engine.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/logic/blind_bluff_skills.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/logic/fatal_fold_rules.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/logic/showdown_comparator.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/models/blind_card.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/models/player_id.dart';

void main() {
  group('Fatal Fold predicates', () {
    test('joker fold always owes penalty without insurance', () {
      expect(
        owesFatalFoldPenalty(
          folderOwnCard: const BlindCard.joker(),
          opponentVisibleCard: const BlindCard.number(2),
          hadPenaltyInsurance: false,
        ),
        true,
      );
    });

    test('10 vs non-joker owes penalty', () {
      expect(
        owesFatalFoldPenalty(
          folderOwnCard: const BlindCard.number(10),
          opponentVisibleCard: const BlindCard.number(5),
          hadPenaltyInsurance: false,
        ),
        true,
      );
    });

    test('10 vs joker is safe', () {
      expect(
        owesFatalFoldPenalty(
          folderOwnCard: const BlindCard.number(10),
          opponentVisibleCard: const BlindCard.joker(),
          hadPenaltyInsurance: false,
        ),
        false,
      );
    });

    test('insurance suppresses penalty even with joker', () {
      expect(
        owesFatalFoldPenalty(
          folderOwnCard: const BlindCard.joker(),
          opponentVisibleCard: const BlindCard.number(3),
          hadPenaltyInsurance: true,
        ),
        false,
      );
    });
  });

  group('Showdown comparator', () {
    test('+2 beats stronger vanilla rank without beating joker', () {
      final outcome = compareShowdown(
        playerOneCard: const BlindCard.number(8),
        playerTwoCard: const BlindCard.number(9),
        playerOnePlusTwo: true,
        playerTwoPlusTwo: false,
      );
      expect(outcome, ShowdownOutcome.playerOneWins);

      final losesToJoker = compareShowdown(
        playerOneCard: const BlindCard.number(10),
        playerTwoCard: const BlindCard.joker(),
        playerOnePlusTwo: true,
        playerTwoPlusTwo: false,
      );
      expect(losesToJoker, ShowdownOutcome.playerTwoWins);
    });

    test('two jokers tie', () {
      expect(
        compareShowdown(
          playerOneCard: const BlindCard.joker(),
          playerTwoCard: const BlindCard.joker(),
          playerOnePlusTwo: false,
          playerTwoPlusTwo: false,
        ),
        ShowdownOutcome.tie,
      );
    });
  });

  group('Betting round', () {
    test('check/check resolves instantly', () {
      final round = BlindBluffBettingRound(
        firstToAct: BlindBluffPlayerId.playerOne,
        minRaise: 1,
      );

      var stacks = 20;

      bool pull(int amount) {
        if (stacks < amount) {
          return false;
        }
        stacks -= amount;
        return true;
      }

      expect(
        round.apply(
          seat: BlindBluffPlayerId.playerOne,
          action: const BlindBluffBettingAction.check(),
          pullFromStack: pull,
          seatStackBeforeAction: stacks,
          opponentStackBeforeAction: stacks,
        ),
        true,
      );
      expect(round.isClosed, false);

      expect(
        round.apply(
          seat: BlindBluffPlayerId.playerTwo,
          action: const BlindBluffBettingAction.check(),
          pullFromStack: pull,
          seatStackBeforeAction: stacks,
          opponentStackBeforeAction: stacks,
        ),
        true,
      );
      expect(round.isClosed, true);
    });

    test('all-in call commits full stack when owed is higher', () {
      final round = BlindBluffBettingRound(
        firstToAct: BlindBluffPlayerId.playerTwo,
        minRaise: 5,
      );

      var p2 = 20;
      var p1 = 7;
      var pot = 0;

      bool pullP2(int amount) {
        if (p2 < amount) {
          return false;
        }
        p2 -= amount;
        pot += amount;
        return true;
      }

      bool pullP1(int amount) {
        if (p1 < amount) {
          return false;
        }
        p1 -= amount;
        pot += amount;
        return true;
      }

      expect(
        round.apply(
          seat: BlindBluffPlayerId.playerTwo,
          action: const BlindBluffBettingAction.raise(raiseBy: 10),
          pullFromStack: pullP2,
          seatStackBeforeAction: p2,
          opponentStackBeforeAction: p1,
        ),
        true,
      );
      expect(round.contributionPlayerTwo, 10);
      expect(p2, 10);

      expect(
        round.apply(
          seat: BlindBluffPlayerId.playerOne,
          action: const BlindBluffBettingAction.call(),
          pullFromStack: pullP1,
          seatStackBeforeAction: p1,
          opponentStackBeforeAction: p2,
        ),
        true,
      );
      expect(round.contributionPlayerOne, 7);
      expect(p1, 0);
      expect(pot, 17);
      expect(round.isClosed, false);
    });

    test('engine accepts raise that forces one-chip opponent all-in', () {
      final engine = BlindBluffMatchEngine(random: Random(0));
      engine.beginRound();
      _passSkillsIntoBetting(engine);
      engine.debugSetStacksForTest(playerOne: 26, playerTwo: 1);

      expect(
        engine.submitBettingAction(
          seat: BlindBluffPlayerId.playerOne,
          action: const BlindBluffBettingAction.raise(raiseBy: 1),
        ),
        true,
      );
      final table = engine.snapshot.mapOrNull(bettingPhase: (p) => p)!;
      expect(table.betting.contributionPlayerOne, 1);
      expect(table.playerTwoChips, 1);
      expect(table.betting.actingPlayer, BlindBluffPlayerId.playerTwo);
    });

    test('short call refunds uncalled raise before showdown', () {
      final engine = BlindBluffMatchEngine(random: Random(0));
      engine.beginRound();
      _passSkillsIntoBetting(engine);

      var table = engine.snapshot.mapOrNull(bettingPhase: (p) => p)!;
      expect(table.betting.actingPlayer, BlindBluffPlayerId.playerOne);
      engine.debugSetStacksForTest(playerOne: 30, playerTwo: 8);

      table = engine.snapshot.mapOrNull(bettingPhase: (p) => p)!;
      final antes = table.pot;
      const raiser = BlindBluffPlayerId.playerOne;
      const caller = BlindBluffPlayerId.playerTwo;

      expect(
        engine.submitBettingAction(
          seat: raiser,
          action: const BlindBluffBettingAction.raise(raiseBy: 22),
        ),
        true,
      );
      table = engine.snapshot.mapOrNull(bettingPhase: (p) => p)!;
      final raiserChipsAfterRaise = raiser == BlindBluffPlayerId.playerOne
          ? table.playerOneChips
          : table.playerTwoChips;
      final raiserContribution = raiser == BlindBluffPlayerId.playerOne
          ? table.betting.contributionPlayerOne
          : table.betting.contributionPlayerTwo;
      expect(raiserChipsAfterRaise, 8);
      expect(raiserContribution, 22);
      expect(table.pot, antes + 22);

      expect(
        engine.submitBettingAction(
          seat: caller,
          action: const BlindBluffBettingAction.call(),
        ),
        true,
      );

      final resolving = engine.snapshot.mapOrNull(roundResolving: (p) => p)!;
      final callerChips = caller == BlindBluffPlayerId.playerOne
          ? resolving.playerOneChipsAfterPot
          : resolving.playerTwoChipsAfterPot;
      expect(callerChips, 0);

      const matchedPerSeat = 8;
      const matchedStreet = matchedPerSeat * 2;
      resolving.resolution.map(
        fold: (_) => fail('expected showdown'),
        showdown: (s) {
          expect(
            s.potAwardedToWinner,
            lessThan(antes + 22 + 8),
            reason: 'uncalled raise must not stay in the awarded pot',
          );
          expect(s.potAwardedToWinner, antes + matchedStreet);
          expect(s.matchedWagerPerSeat, matchedPerSeat);
        },
      );
    });

    test('sub-min open raise allowed when opponent has one chip left', () {
      final round = BlindBluffBettingRound(
        firstToAct: BlindBluffPlayerId.playerOne,
        minRaise: 4,
      );
      var p1 = 26;
      var p2 = 1;

      expect(
        round.apply(
          seat: BlindBluffPlayerId.playerOne,
          action: const BlindBluffBettingAction.raise(raiseBy: 1),
          pullFromStack: (amount) {
            if (p1 < amount) {
              return false;
            }
            p1 -= amount;
            return true;
          },
          seatStackBeforeAction: p1 + 1,
          opponentStackBeforeAction: p2,
        ),
        true,
      );
      expect(round.contributionPlayerOne, 1);
      expect(p1, 25);
    });

    test('short all-in raise allowed when shoving full stack', () {
      final round = BlindBluffBettingRound(
        firstToAct: BlindBluffPlayerId.playerOne,
        minRaise: 7,
      );
      var p1 = 5;
      var pot = 0;

      expect(
        round.apply(
          seat: BlindBluffPlayerId.playerOne,
          action: const BlindBluffBettingAction.raise(raiseBy: 5),
          pullFromStack: (a) {
            if (p1 < a) {
              return false;
            }
            p1 -= a;
            pot += a;
            return true;
          },
          seatStackBeforeAction: p1,
          opponentStackBeforeAction: 20,
        ),
        true,
      );
      expect(round.contributionPlayerOne, 5);
      expect(p1, 0);
      expect(pot, 5);
    });
  });

  group('Skill phase skip', () {
    test('skipSkillPhaseIfNoSkillsRemain opens betting when both spent all skills',
        () {
      final engine = BlindBluffMatchEngine(random: Random(1));
      _burnAllSkillsOverThreeRounds(engine);

      engine.beginRound();
      expect(
        engine.snapshot.maybeMap(
          skillPhase: (p) =>
              p.skillsRemainingPlayerOne.isEmpty &&
              p.skillsRemainingPlayerTwo.isEmpty,
          orElse: () => false,
        ),
        true,
      );

      expect(engine.skipSkillPhaseIfNoSkillsRemain(), true);
      expect(
        engine.snapshot.maybeMap(bettingPhase: (_) => true, orElse: () => false),
        true,
      );
      expect(engine.skipSkillPhaseIfNoSkillsRemain(), false);
    });
  });

  group('Match elimination', () {
    test('open shove waits for call then can end with showdown ledger', () {
      final engine = BlindBluffMatchEngine(random: Random(0));
      engine.beginRound();
      _passSkillsIntoBetting(engine);

      final table = engine.snapshot.mapOrNull(bettingPhase: (p) => p)!;
      expect(table.betting.actingPlayer, BlindBluffPlayerId.playerOne);

      final p1Stack = table.playerOneChips;
      expect(
        engine.submitBettingAction(
          seat: BlindBluffPlayerId.playerOne,
          action: BlindBluffBettingAction.raise(raiseBy: p1Stack),
        ),
        true,
      );
      expect(engine.isMatchComplete, false);
      expect(
        engine.snapshot.maybeMap(bettingPhase: (_) => true, orElse: () => false),
        true,
      );

      expect(
        engine.submitBettingAction(
          seat: BlindBluffPlayerId.playerTwo,
          action: const BlindBluffBettingAction.call(),
        ),
        true,
      );
      expect(
        engine.snapshot.maybeMap(
          roundResolving: (_) => true,
          orElse: () => false,
        ),
        true,
      );
      expect(engine.isMatchComplete, true);
    });

    test('rolled pot starts next round when stacks are below ante', () {
      final engine = BlindBluffMatchEngine(random: Random(0));
      engine.debugIdleCarryoverForTest(
        playerOne: 2,
        playerTwo: 3,
        rolledPot: 40,
        completedRounds: 1,
        baseAnte: 8,
      );

      engine.beginRound();

      expect(engine.isMatchComplete, false);
      final skill = engine.snapshot.mapOrNull(skillPhase: (p) => p)!;
      expect(skill.playerOneChips, 0);
      expect(skill.playerTwoChips, 0);
      expect(skill.potAfterAnte, 45);
    });

    test('bust only when broke with no rolled pot to contest', () {
      final engine = BlindBluffMatchEngine(random: Random(0));
      engine.debugIdleCarryoverForTest(
        playerOne: 0,
        playerTwo: 12,
        rolledPot: 0,
        completedRounds: 1,
        baseAnte: 8,
      );

      engine.beginRound();

      expect(engine.isMatchComplete, true);
      engine.snapshot.mapOrNull(
        matchComplete: (m) {
          expect(m.winner, BlindBluffPlayerId.playerTwo);
        },
      );
    });

    test('partial ante posts when stack is below full ante', () {
      final engine = BlindBluffMatchEngine(random: Random(0));
      engine.debugIdleCarryoverForTest(
        playerOne: 3,
        playerTwo: 5,
        rolledPot: 0,
        completedRounds: 1,
        baseAnte: 8,
      );

      engine.beginRound();

      expect(engine.isMatchComplete, false);
      final skill = engine.snapshot.mapOrNull(skillPhase: (p) => p)!;
      expect(skill.playerOneChips, 0);
      expect(skill.playerTwoChips, 0);
      expect(skill.potAfterAnte, 8);
    });

    test('match ends when a seat cannot afford the next ante', () {
      final engine = BlindBluffMatchEngine(random: Random(1));
      for (var i = 0; i < 80 && !engine.isMatchComplete; i++) {
        engine.beginRound();
        if (engine.isMatchComplete) {
          break;
        }
        _passSkillsIntoBetting(engine);
        if (engine.isMatchComplete) {
          break;
        }
        _checkCheckToResolution(engine);
        if (engine.snapshot.maybeMap(roundResolving: (_) => true, orElse: () => false)) {
          engine.finishRound();
        }
      }
      expect(engine.isMatchComplete, true);
      engine.snapshot.mapOrNull(
        matchComplete: (m) {
          expect(
            m.playerOneChips <= 0 || m.playerTwoChips <= 0,
            true,
          );
        },
      );
    });
  });

  group('Ante doubling', () {
    test('notice set when shoe recycles before deal', () {
      final engine = BlindBluffMatchEngine(random: Random(0));
      engine.beginRound();
      for (var r = 0; r < 16 && engine.anteDoubledFromNotice == null; r++) {
        _passSkillsIntoBetting(engine);
        _checkCheckToResolution(engine);
        if (engine.snapshot.maybeMap(roundResolving: (_) => true, orElse: () => false)) {
          engine.finishRound();
        }
        if (engine.isMatchComplete) {
          break;
        }
        engine.beginRound();
      }
      expect(engine.anteDoubledFromNotice, 1);
      final skill = engine.snapshot.mapOrNull(skillPhase: (p) => p)!;
      expect(skill.baseAnteFrozenForRound, 2);
    });
  });

  group('Match engine smoke', () {
    test('full pass-through round resolves', () {
      final engine = BlindBluffMatchEngine(random: Random(3));
      engine.beginRound();

      expect(
        engine.snapshot.maybeMap(skillPhase: (_) => true, orElse: () => false),
        true,
      );

      expect(
        engine.submitSkillDeclaration(
          seat: BlindBluffPlayerId.playerOne,
          skill: null,
        ),
        true,
      );
      expect(
        engine.submitSkillDeclaration(
          seat: BlindBluffPlayerId.playerTwo,
          skill: null,
        ),
        true,
      );

      expect(
        engine.snapshot.maybeMap(
          skillPhase: (p) => p.awaitingSkillRevealAck,
          orElse: () => false,
        ),
        true,
      );
      expect(engine.acknowledgeSkillReveal(), true);

      expect(
        engine.snapshot.maybeMap(bettingPhase: (_) => true, orElse: () => false),
        true,
      );

      final betting = engine.snapshot.maybeMap(
        bettingPhase: (phase) => phase.betting,
        orElse: () => null,
      )!;
      final first = betting.actingPlayer;

      expect(
        engine.submitBettingAction(
          seat: first,
          action: const BlindBluffBettingAction.check(),
        ),
        true,
      );

      expect(
        engine.submitBettingAction(
          seat: first.opponent,
          action: const BlindBluffBettingAction.check(),
        ),
        true,
      );

      expect(
        engine.snapshot.maybeMap(
          roundResolving: (_) => true,
          orElse: () => false,
        ),
        true,
      );

      engine.finishRound();

      expect(
        engine.snapshot.maybeMap(
          idleBetweenRounds: (_) => true,
          orElse: () => false,
        ),
        true,
      );
    });
  });
}

void _burnAllSkillsOverThreeRounds(BlindBluffMatchEngine engine) {
  const uses = <BlindBluffSkill>[
    BlindBluffSkill.plusTwoModifier,
    BlindBluffSkill.penaltyInsurance,
    BlindBluffSkill.doubleBlind,
  ];
  for (final skill in uses) {
    if (engine.isMatchComplete) {
      return;
    }
    engine.beginRound();
    if (engine.isMatchComplete) {
      return;
    }
    expect(
      engine.submitSkillDeclaration(
        seat: BlindBluffPlayerId.playerOne,
        skill: skill,
      ),
      true,
    );
    expect(
      engine.submitSkillDeclaration(
        seat: BlindBluffPlayerId.playerTwo,
        skill: skill,
      ),
      true,
    );
    expect(engine.acknowledgeSkillReveal(), true);
    _checkCheckToResolution(engine);
    if (engine.snapshot.maybeMap(roundResolving: (_) => true, orElse: () => false)) {
      engine.finishRound();
    }
  }
}

void _passSkillsIntoBetting(BlindBluffMatchEngine engine) {
  expect(
    engine.submitSkillDeclaration(
      seat: BlindBluffPlayerId.playerOne,
      skill: null,
    ),
    true,
  );
  expect(
    engine.submitSkillDeclaration(
      seat: BlindBluffPlayerId.playerTwo,
      skill: null,
    ),
    true,
  );
  expect(engine.acknowledgeSkillReveal(), true);
  expect(
    engine.snapshot.maybeMap(bettingPhase: (_) => true, orElse: () => false),
    true,
  );
}

void _checkCheckToResolution(BlindBluffMatchEngine engine) {
  final betting = engine.snapshot.mapOrNull(bettingPhase: (p) => p.betting)!;
  final first = betting.actingPlayer;
  expect(
    engine.submitBettingAction(
      seat: first,
      action: const BlindBluffBettingAction.check(),
    ),
    true,
  );
  if (engine.isMatchComplete) {
    return;
  }
  expect(
    engine.submitBettingAction(
      seat: first.opponent,
      action: const BlindBluffBettingAction.check(),
    ),
    true,
  );
}
