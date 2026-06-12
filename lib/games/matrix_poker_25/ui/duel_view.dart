import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:genius_project/core/theme/app_theme.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';
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

class _DuelViewState extends State<DuelView> {
  int? _focusedComboIndex;
  Timer? _advanceTimer;
  int? _scheduledAutoAdvanceRound;
  int? _roundResultDialogShownForRound;

  @override
  void dispose() {
    _advanceTimer?.cancel();
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
      if (mounted &&
          _roundResultDialogShownForRound == roundNumber &&
          Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      if (!mounted) {
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

  void _presentRoundResultDialog(
    BuildContext context,
    RoundResolution resolution,
    String summaryLine,
  ) {
    if (_roundResultDialogShownForRound == resolution.roundNumber) {
      return;
    }
    _roundResultDialogShownForRound = resolution.roundNumber;
    final cubit = context.read<MatrixPokerCubit>();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return _RoundResultDialog(
          resolution: resolution,
          summaryLine: summaryLine,
          onContinue: () {
            Navigator.of(dialogCtx).pop();
            _cancelAutoAdvance();
            cubit.advanceAfterRoundResolved();
          },
        );
      },
    ).whenComplete(() {
      if (mounted) {
        setState(() => _roundResultDialogShownForRound = null);
      }
    });
  }

  Widget _duelScaffold(
    BuildContext context, {
    required MatrixPokerCubit cubit,
    required int headerRound,
    required int scoreP1,
    required int scoreP2,
    required bool waiting,
    required bool combosEnabled,
    required int? remainingSeconds,
  }) {
    final grid = cubit.playerOneGrid;
    final combos = cubit.playerOneDrafts.combos;
    final highlights = waiting ? null : _highlightCoords(cubit);
    final isUrgent = (remainingSeconds ?? 999) <= 10;
    final timeLabel =
        remainingSeconds == null ? null : 'Time: $remainingSeconds seconds';

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Padding(
            padding: AdaptiveLayout.screenPadding(context),
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
                    SizedBox(height: AdaptiveLayout.sectionGap(context) * 0.3),
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
                  SizedBox(height: AdaptiveLayout.sectionGap(context) * 0.55),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final wide = AdaptiveLayout.duelWideLayout(
                          constraints.maxWidth,
                          context,
                        );
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
                              SizedBox(
                                  width: AdaptiveLayout.inlineGap(context)),
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
                            SizedBox(
                                height: AdaptiveLayout.sectionGap(context)),
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
        ],
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
          roundResolved: (_, __, message, ___) {
            setState(() => _focusedComboIndex = null);
            final res = context.read<MatrixPokerCubit>().latestRoundResolution;
            if (res != null) {
              _scheduleAutoAdvance(context, res.roundNumber);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) {
                  return;
                }
                _presentRoundResultDialog(context, res, message);
              });
            }
          },
          duelTurn: (_, __, ___, ____, _____) {
            _cancelAutoAdvance();
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
              remainingSeconds: null,
            );
          },
          roundResolved: (p1Combo, p2Combo, msg, isGameOver) {
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

    final pad = AdaptiveLayout.inlineGap(context) * 1.1;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        padding: EdgeInsets.all(pad),
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
                padding: EdgeInsets.symmetric(
                  horizontal: AdaptiveLayout.sectionGap(context),
                  vertical: AdaptiveLayout.sectionGap(context) * 0.55,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: AdaptiveLayout.shortestSide(context) * 0.07,
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

class _RoundResultDialog extends StatelessWidget {
  const _RoundResultDialog({
    required this.resolution,
    required this.summaryLine,
    required this.onContinue,
  });

  final RoundResolution resolution;
  final String summaryLine;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final p1 = _comboSummary(resolution.player1Combo);
    final p2 = _comboSummary(resolution.player2Combo);
    final outcome = _winnerLine(resolution.winner);
    final bodyStyle = theme.textTheme.bodySmall?.copyWith(
      color: scheme.onSurface,
      height: 1.25,
    );
    final titleStyle = theme.textTheme.labelLarge?.copyWith(
      color: scheme.onSurfaceVariant,
      fontWeight: FontWeight.w600,
    );

    return Dialog(
      backgroundColor: scheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: AdaptiveLayout.dialogInsets(context),
      child: Padding(
        padding: AdaptiveLayout.panelPadding(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Round ${resolution.roundNumber} result',
              style: theme.textTheme.titleLarge?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AdaptiveLayout.sectionGap(context) * 0.75),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Player 1',
                        style: titleStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AdaptiveLayout.inlineGap(context)),
                      Text(
                        p1,
                        style: bodyStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AdaptiveLayout.inlineGap(context)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Player 2',
                        style: titleStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AdaptiveLayout.inlineGap(context)),
                      Text(
                        p2,
                        style: bodyStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AdaptiveLayout.sectionGap(context) * 0.65),
            Text(
              outcome,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppTheme.neoPurple,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AdaptiveLayout.inlineGap(context)),
            Text(
              summaryLine,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.3,
              ),
            ),
            SizedBox(height: AdaptiveLayout.sectionGap(context) * 0.85),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.neoGold,
                foregroundColor: AppTheme.neoBackground,
                padding: EdgeInsets.symmetric(
                  vertical: AdaptiveLayout.inlineGap(context),
                ),
              ),
              onPressed: onContinue,
              child: const Text('Continue'),
            ),
          ],
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
