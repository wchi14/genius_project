import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:genius_project/core/models/coordinate.dart';
import 'package:genius_project/games/matrix_poker_25/logic/combo.dart';
import 'package:genius_project/games/matrix_poker_25/logic/game_loop_manager.dart';
import 'package:genius_project/games/matrix_poker_25/logic/hand_rank.dart';
import 'package:genius_project/games/matrix_poker_25/logic/matrix_poker_cubit.dart';
import 'package:genius_project/games/matrix_poker_25/logic/matrix_poker_state.dart';
import 'package:genius_project/games/matrix_poker_25/logic/player_draft_manager.dart';

import 'matrix_poker_grid.dart';

/// Phase 3 blind duel: read-only board + scrollable combo list, commit, overlays.
class DuelView extends StatefulWidget {
  const DuelView({super.key});

  @override
  State<DuelView> createState() => _DuelViewState();
}

class _DuelViewState extends State<DuelView>
    with SingleTickerProviderStateMixin {
  int? _focusedComboIndex;
  Timer? _advanceTimer;
  int? _scheduledAutoAdvanceRound;

  late final AnimationController _revealController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  @override
  void dispose() {
    _advanceTimer?.cancel();
    _revealController.dispose();
    super.dispose();
  }

  void _cancelAutoAdvance() {
    _advanceTimer?.cancel();
    _advanceTimer = null;
    _scheduledAutoAdvanceRound = null;
  }

  void _scheduleAutoAdvance(BuildContext context, int roundNumber) {
    if (_scheduledAutoAdvanceRound == roundNumber) {
      return;
    }
    _scheduledAutoAdvanceRound = roundNumber;
    _advanceTimer?.cancel();
    _advanceTimer = Timer(const Duration(milliseconds: 2800), () {
      if (!mounted) {
        return;
      }
      final cubit = context.read<MatrixPokerCubit>();
      final stillResolved = cubit.state.maybeWhen(
        roundResolved: (_, __, ___, ____) => true,
        orElse: () => false,
      );
      if (!stillResolved) {
        return;
      }
      cubit.advanceAfterRoundResolved();
      _scheduledAutoAdvanceRound = null;
    });
  }

  void _onComboRowTap(BuildContext context, MatrixPokerCubit cubit, int index) {
    final isDuelTurn = cubit.state.maybeWhen(
      duelTurn: (_, __, ___, ____, _____) => true,
      orElse: () => false,
    );
    if (!isDuelTurn) {
      return;
    }
    if (cubit.isPlayerOneComboConsumed(index)) {
      return;
    }

    if (_focusedComboIndex != index) {
      setState(() => _focusedComboIndex = index);
      return;
    }

    context.read<MatrixPokerCubit>().commitCombo(index);
  }

  List<Coordinate>? _highlightCoords(MatrixPokerCubit cubit) {
    final i = _focusedComboIndex;
    if (i == null) {
      return null;
    }
    if (cubit.isPlayerOneComboConsumed(i)) {
      return null;
    }
    return cubit.playerOneDrafts.combos[i].coordinates;
  }

  Widget _duelScaffold(
    BuildContext context, {
    required MatrixPokerCubit cubit,
    required int headerRound,
    required int scoreP1,
    required int scoreP2,
    required bool waiting,
    required bool combosEnabled,
    required RoundResolution? resolved,
    required String? resultMessage,
    required int? remainingSeconds,
  }) {
    final grid = cubit.playerOneGrid;
    final combos = cubit.playerOneDrafts.combos;
    final highlights = waiting ? null : _highlightCoords(cubit);
    final isUrgent = (remainingSeconds ?? 999) <= 10;
    final timeLabel =
        remainingSeconds == null ? null : 'Time: $remainingSeconds seconds';

    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Duel — Round $headerRound / ${PlayerDraftManager.maxDrafts}',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Score (P1 - P2): $scoreP1 - $scoreP2',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (timeLabel != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      timeLabel,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isUrgent ? Colors.red : null,
                            fontWeight:
                                isUrgent ? FontWeight.w900 : FontWeight.w700,
                          ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 560;
                        final gridSection = AspectRatio(
                          aspectRatio: 1,
                          child: MatrixPokerGrid(
                            grid: grid,
                            highlightCoords: highlights,
                          ),
                        );
                        final listSection = _ComboList(
                          combos: combos,
                          cubit: cubit,
                          focusedIndex: _focusedComboIndex,
                          enabled: combosEnabled,
                          onTap: (i) => _onComboRowTap(context, cubit, i),
                        );

                        if (wide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 11, child: gridSection),
                              const SizedBox(width: 12),
                              Expanded(flex: 9, child: listSection),
                            ],
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              width: constraints.maxWidth,
                              child: gridSection,
                            ),
                            const SizedBox(height: 12),
                            Expanded(child: listSection),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (waiting)
            const Positioned.fill(
              child: _WaitingOverlay(),
            ),
          if (resolved != null && resultMessage != null)
            Positioned.fill(
              child: _RoundRevealOverlay(
                resolution: resolved,
                summaryLine: resultMessage,
                animation: _revealController,
                onContinue: () {
                  _cancelAutoAdvance();
                  context.read<MatrixPokerCubit>().advanceAfterRoundResolved();
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MatrixPokerCubit, MatrixPokerState>(
      listenWhen: (previous, current) => current.maybeWhen(
        waitingForOpponent: () => true,
        roundResolved: (_, __, ___, ____) => true,
        duelTurn: (_, __, ___, ____, _____) => true,
        gameOver: (_, __, ___) => true,
        orElse: () => false,
      ),
      listener: (context, state) {
        state.maybeWhen(
          waitingForOpponent: () {
            setState(() => _focusedComboIndex = null);
          },
          roundResolved: (_, __, ___, ____) {
            setState(() => _focusedComboIndex = null);
            _revealController.forward(from: 0);
            final res = context.read<MatrixPokerCubit>().latestRoundResolution;
            if (res != null) {
              _scheduleAutoAdvance(context, res.roundNumber);
            }
          },
          duelTurn: (_, __, ___, ____, _____) {
            _cancelAutoAdvance();
            _revealController.reset();
          },
          gameOver: (_, __, ___) {
            _cancelAutoAdvance();
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = context.read<MatrixPokerCubit>();

        return state.maybeWhen(
          duelTurn: (round, p1Score, p2Score, remainingSeconds, __) =>
              _duelScaffold(
            context,
            cubit: cubit,
            headerRound: round,
            scoreP1: p1Score,
            scoreP2: p2Score,
            waiting: false,
            combosEnabled: true,
            resolved: null,
            resultMessage: null,
            remainingSeconds: remainingSeconds,
          ),
          waitingForOpponent: () {
            final h = cubit.duelScoresHeader;
            return _duelScaffold(
              context,
              cubit: cubit,
              headerRound: h.round,
              scoreP1: h.p1Score,
              scoreP2: h.p2Score,
              waiting: true,
              combosEnabled: false,
              resolved: null,
              resultMessage: null,
              remainingSeconds: null,
            );
          },
          roundResolved: (_, __, message, ___) {
            final res = cubit.latestRoundResolution;
            if (res == null) {
              return const SizedBox.shrink();
            }
            return _duelScaffold(
              context,
              cubit: cubit,
              headerRound: res.roundNumber,
              scoreP1: res.scorePlayer1After,
              scoreP2: res.scorePlayer2After,
              waiting: false,
              combosEnabled: false,
              resolved: res,
              resultMessage: message,
              remainingSeconds: null,
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}

class _ComboList extends StatelessWidget {
  const _ComboList({
    required this.combos,
    required this.cubit,
    required this.focusedIndex,
    required this.enabled,
    required this.onTap,
  });

  final List<Combo> combos;
  final MatrixPokerCubit cubit;
  final int? focusedIndex;
  final bool enabled;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        itemCount: combos.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final used = cubit.isPlayerOneComboConsumed(index);
          final focused = focusedIndex == index;
          final c = combos[index];
          final line = '${_handRankLabel(c.rank)}: ${c.numbers.join(', ')}';

          return Material(
            color: used
                ? theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.55)
                : focused
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.55)
                    : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: used || !enabled ? null : () => onTap(index),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text(
                        '#${index + 1}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        line,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: used
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onSurface,
                          decoration: used ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WaitingOverlay extends StatelessWidget {
  const _WaitingOverlay();

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Waiting for Opponent...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundRevealOverlay extends StatelessWidget {
  const _RoundRevealOverlay({
    required this.resolution,
    required this.summaryLine,
    required this.animation,
    required this.onContinue,
  });

  final RoundResolution resolution;
  final String summaryLine;
  final AnimationController animation;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p1 = _comboSummary(resolution.player1Combo);
    final p2 = _comboSummary(resolution.player2Combo);
    final outcome = _winnerLine(resolution.winner);

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
        ),
        child: Center(
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Round ${resolution.roundNumber} result',
                        style: theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text('P1: $p1', style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 8),
                      Text('P2: $p2', style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 16),
                      Text(
                        outcome,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        summaryLine,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: onContinue,
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _comboSummary(Combo c) =>
    '${_handRankLabel(c.rank)} — ${c.numbers.join(', ')} (key ${c.primaryKeyValue})';

String _winnerLine(RoundWinner w) => switch (w) {
      RoundWinner.player1 => 'Player 1 wins the round',
      RoundWinner.player2 => 'Player 2 wins the round',
      RoundWinner.tie => 'Tie — no point this round',
    };

String _handRankLabel(HandRank rank) => switch (rank) {
      HandRank.fourOfAKind => 'Four of a Kind',
      HandRank.straightInOrder => '4 Straight (In Order)',
      HandRank.straightNotInOrder => '4 Straight (Not in Order)',
      HandRank.twoPair => 'Two Pair',
      HandRank.threeOfAKind => 'Three of a Kind',
      HandRank.onePair => 'One Pair',
      HandRank.highCard => 'High Card',
    };
