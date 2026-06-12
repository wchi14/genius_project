import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:genius_project/core/models/ai_difficulty.dart';
import 'package:genius_project/games/matrix_poker_25/logic/matrix_poker_cubit.dart';
import 'package:genius_project/games/matrix_poker_25/logic/matrix_poker_state.dart';
import 'package:genius_project/games/matrix_poker_25/logic/player_draft_manager.dart';
import 'package:genius_project/games/matrix_poker_25/models/matrix_grid_model.dart';
import 'package:genius_project/games/matrix_poker_25/ai/easy_ai.dart';
import 'package:genius_project/games/matrix_poker_25/ai/normal_ai.dart';
import 'package:genius_project/games/matrix_poker_25/ai/hard_ai.dart';
import 'package:genius_project/games/matrix_poker_25/ai/matrix_poker_ai_agent.dart';

import 'package:genius_project/core/theme/app_theme.dart';
import 'board_filling_view.dart';
import 'drafting_view.dart';
import 'duel_view.dart';

/// Hub entry that wires [MatrixPokerCubit] for Matrix Poker 25 (Phase 2 shell).
class MatrixPokerScreen extends StatelessWidget {
  const MatrixPokerScreen({
    super.key,
    this.aiDifficulty = AiDifficulty.easy,
    this.cubit,
  });

  final AiDifficulty aiDifficulty;

  /// Optional pre-built cubit (tests / parent injection). If null, a fresh cubit is created.
  final MatrixPokerCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final body = _MatrixPokerScaffoldBody(
      autoStartDrafting: cubit == null,
    );

    if (cubit != null) {
      return BlocProvider<MatrixPokerCubit>.value(
        value: cubit!,
        child: body,
      );
    }

    return BlocProvider<MatrixPokerCubit>(
      create: (_) => MatrixPokerCubit(
        playerOneDrafts: PlayerDraftManager(),
        playerTwoDrafts: PlayerDraftManager(),
        playerOneGrid: MatrixGridModel(),
        opponentAgent: _agentForDifficulty(aiDifficulty),
      ),
      child: body,
    );
  }
}

MatrixPokerAiAgent _agentForDifficulty(AiDifficulty d) => switch (d) {
      AiDifficulty.easy => EasyAiAgent(),
      AiDifficulty.normal => NormalAiAgent(),
      AiDifficulty.hard => HardAiAgent(),
    };

class _MatrixPokerScaffoldBody extends StatefulWidget {
  const _MatrixPokerScaffoldBody({required this.autoStartDrafting});

  final bool autoStartDrafting;

  @override
  State<_MatrixPokerScaffoldBody> createState() =>
      _MatrixPokerScaffoldBodyState();
}

class _MatrixPokerScaffoldBodyState extends State<_MatrixPokerScaffoldBody> {
  /// Keeps [DuelView] state alive across duel / waiting / resolved emissions.
  final GlobalKey _duelViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.autoStartDrafting) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        context.read<MatrixPokerCubit>().startDrafting();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrix Poker 25'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.neoBackground,
              AppTheme.neoBackground.withValues(alpha: 0.92),
              const Color(0xFF0D1018),
            ],
          ),
        ),
        child: BlocBuilder<MatrixPokerCubit, MatrixPokerState>(
          builder: (context, state) {
            return state.when(
            initial: () => Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            boardFilling:
                (grid, fillRound, dealerValue, remainingSeconds, totalRounds) =>
                    BoardFillingView(
              grid: grid,
              fillRound: fillRound,
              dealerValue: dealerValue,
              remainingSeconds: remainingSeconds,
              totalRounds: totalRounds,
            ),
            drafting: (grid, draftedCombos, remainingSeconds) => DraftingView(
              grid: grid,
              initialDraftedCombos: draftedCombos,
              remainingSeconds: remainingSeconds,
            ),
            waitingForOpponent: () => DuelView(key: _duelViewKey),
            duelTurn: (_, __, ___, ____, _____) => DuelView(key: _duelViewKey),
            roundResolved: (_, __, ___, ____) => DuelView(key: _duelViewKey),
            gameOver: (finalP1Score, finalP2Score, winner) => Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.grid_on,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Match complete',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.neoTextPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Final score: $finalP1Score – $finalP2Score',
                      style: const TextStyle(
                        color: AppTheme.neoTextMuted,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      winner,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.neoPurple,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          },
        ),
      ),
    );
  }
}
