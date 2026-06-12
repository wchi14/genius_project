import 'package:flutter_test/flutter_test.dart';
import 'dart:math';
import 'package:fake_async/fake_async.dart';
import 'package:genius_project/games/blind_count_40/logic/blind_count_cubit.dart';
import 'package:genius_project/games/blind_count_40/logic/blind_count_state.dart';
import 'package:genius_project/games/blind_count_40/models/game_player.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai_config.dart';

void main() {
  group('Blind Count skills', () {
    test('each skill is one-off per match', () {
      fakeAsync((async) {
        final cubit = BlindCountCubit(firstPlayer: BlindPlayerId.p1);
        try {
          cubit.useSumRevealSkill();
          expect(cubit.state.p1UsedSkills, [BlindCountSkillId.sum]);
          expect(cubit.canUseP1Skill(BlindCountSkillId.sum), isFalse);

          // Skill peek should clear after 3 seconds.
          async.elapse(const Duration(seconds: 4));

          cubit.giveBlockToOpponent();
          expect(cubit.state.currentTurn, BlindPlayerId.p2);
          expect(cubit.state.hasUsedSkillThisTurn, isFalse);
          expect(cubit.canUseP1Skill(BlindCountSkillId.sum), isFalse);
        } finally {
          cubit.close();
        }
      });
    });

    test('at most one skill per turn', () {
      fakeAsync((async) {
        final cubit = BlindCountCubit(firstPlayer: BlindPlayerId.p1);
        try {
          cubit.useSumRevealSkill();
          expect(cubit.state.hasUsedSkillThisTurn, isTrue);
          expect(cubit.canUseP1Skill(BlindCountSkillId.radar), isFalse);
          expect(cubit.canUseP1Skill(BlindCountSkillId.bloat), isFalse);

          cubit.useRadarSkill();
          expect(cubit.state.p1UsedSkills, [BlindCountSkillId.sum]);
        } finally {
          cubit.close();
        }
      });
    });

    test('opponent cannot chain multiple skills in one turn', () {
      fakeAsync((async) {
        // Make skills eligible by avoiding forced-guess (Rule 2) during this test.
        final cubit = BlindCountCubit(
          firstPlayer: BlindPlayerId.p2,
          opponentAiConfig: const BlindCountOpponentAiConfig(
            highConfidenceGuessThreshold: 999,
            skillAttemptChance: 1.0,
          ),
        );
        try {
          var activated = false;
          for (var seed = 0; seed < 50; seed++) {
            if (cubit.tryOpponentSkill(random: Random(seed))) {
              activated = true;
              break;
            }
          }
          expect(activated, isTrue);
          expect(cubit.state.p2UsedSkills.length, 1);
          expect(cubit.state.hasUsedSkillThisTurn, isTrue);
          expect(cubit.tryOpponentSkill(random: Random(0)), isFalse);
        } finally {
          cubit.close();
        }
      });
    });
  });
}
