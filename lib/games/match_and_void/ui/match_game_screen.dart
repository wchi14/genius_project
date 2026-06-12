import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:genius_project/core/theme/app_theme.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/games/match_and_void/logic/match_game_cubit.dart';
import 'package:genius_project/games/match_and_void/logic/match_game_state.dart';
import 'package:genius_project/games/match_and_void/models/match_card.dart';
import 'package:genius_project/games/match_and_void/models/match_game_feedback.dart';
import 'package:genius_project/games/match_and_void/models/match_game_mode.dart';
import 'package:genius_project/games/match_and_void/ui/match_card_widget.dart';

/// Landscape play surface for Match & Void (Arena or Countdown).
class MatchGameScreen extends StatelessWidget {
  const MatchGameScreen({
    super.key,
    required this.mode,
    this.cubit,
  });

  final MatchGameMode mode;
  final MatchGameCubit? cubit;

  @override
  Widget build(BuildContext context) {
    const body = _MatchGameBody();

    if (cubit != null) {
      return BlocProvider<MatchGameCubit>.value(
        value: cubit!,
        child: body,
      );
    }
    return BlocProvider<MatchGameCubit>(
      create: (_) => MatchGameCubit(mode: mode),
      child: body,
    );
  }
}

class _MatchGameBody extends StatelessWidget {
  const _MatchGameBody();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MatchGameCubit, MatchGameState>(
          listenWhen: (prev, next) => !prev.isGameOver && next.isGameOver,
          listener: (context, state) {
            _showGameOverSheet(context, state);
          },
        ),
        BlocListener<MatchGameCubit, MatchGameState>(
          listenWhen: (prev, next) =>
              next.pendingFeedback != null &&
              prev.pendingFeedback != next.pendingFeedback,
          listener: (context, state) {
            _showPenaltyDialog(context, state.pendingFeedback!);
          },
        ),
        BlocListener<MatchGameCubit, MatchGameState>(
          listenWhen: (prev, next) =>
              !prev.voidStreakAdvanceNotice && next.voidStreakAdvanceNotice,
          listener: (context, state) {
            _showVoidStreakDialog(context, state);
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppTheme.neoBackground,
        body: SafeArea(
          child: Padding(
            padding: AdaptiveLayout.matchVoidPlayInsets(context),
            child: BlocBuilder<MatchGameCubit, MatchGameState>(
              builder: (context, state) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _ActionPanel(state: state),
                        ),
                        SizedBox(
                          width: AdaptiveLayout.matchVoidPanelGap(context),
                        ),
                        Expanded(
                          flex: 2,
                          child: _HistoryPanel(state: state),
                        ),
                      ],
                    ),
                    _MatchHud(state: state),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showPenaltyDialog(
    BuildContext context,
    MatchGameFeedback feedback,
  ) {
    final cubit = context.read<MatchGameCubit>();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        final pad = AdaptiveLayout.panelPadding(dialogCtx);
        final gap = AdaptiveLayout.sectionGap(dialogCtx);
        final bodyStyle = Theme.of(dialogCtx).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neoTextPrimary,
              height: 1.35,
            );
        final penaltyStyle =
            Theme.of(dialogCtx).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFFF5252),
                  fontWeight: FontWeight.w800,
                );

        return AlertDialog(
          backgroundColor: AppTheme.neoBackground,
          insetPadding: AdaptiveLayout.dialogInsets(dialogCtx),
          title: Text(
            feedback.title,
            textAlign: TextAlign.center,
            style: Theme.of(dialogCtx).textTheme.titleMedium?.copyWith(
                  color: AppTheme.neoGold,
                  fontWeight: FontWeight.w700,
                ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(feedback.body, textAlign: TextAlign.center, style: bodyStyle),
              SizedBox(height: gap),
              Text(
                feedback.penaltySummary,
                textAlign: TextAlign.center,
                style: penaltyStyle,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                cubit.clearPendingFeedback();
              },
              child: const Text('OK'),
            ),
          ],
          contentPadding: pad,
          actionsPadding: pad,
        );
      },
    ).then((_) {
      if (context.mounted) {
        cubit.clearPendingFeedback();
      }
    });
  }

  void _showVoidStreakDialog(BuildContext context, MatchGameState state) {
    final cubit = context.read<MatchGameCubit>();
    final arenaPenalty = state.mode == MatchGameMode.arena
        ? ' A further ${MatchGameCubit.arenaVoidStreakBoardPenalty} pt penalty applies.'
        : '';
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        final pad = AdaptiveLayout.panelPadding(dialogCtx);
        return AlertDialog(
          backgroundColor: AppTheme.neoBackground,
          insetPadding: AdaptiveLayout.dialogInsets(dialogCtx),
          title: Text(
            'Five wrong voids',
            style: Theme.of(dialogCtx).textTheme.titleMedium?.copyWith(
                  color: AppTheme.neoGold,
                  fontWeight: FontWeight.w700,
                ),
          ),
          content: Text(
            'You declared Void five times in a row without clearing the board. '
            'Moving to the next board.$arenaPenalty',
            style: Theme.of(dialogCtx).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.neoTextPrimary,
                  height: 1.35,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                cubit.acknowledgeVoidStreakAdvance();
              },
              child: const Text('Continue'),
            ),
          ],
          contentPadding: pad,
          actionsPadding: pad,
        );
      },
    );
  }

  void _showGameOverSheet(BuildContext context, MatchGameState state) {
    final modeLabel =
        state.mode == MatchGameMode.arena ? 'Arena complete' : "Time's up";
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        final pad = AdaptiveLayout.panelPadding(dialogCtx);
        return AlertDialog(
          title: Text(modeLabel),
          content: Text('Final score: ${state.currentScore}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                if (context.mounted) {
                  context.pop();
                }
              },
              child: const Text('Back'),
            ),
          ],
          contentPadding: pad,
          actionsPadding: pad,
        );
      },
    );
  }
}

class _MatchHud extends StatelessWidget {
  const _MatchHud({required this.state});

  final MatchGameState state;

  @override
  Widget build(BuildContext context) {
    final hudHeight = AdaptiveLayout.matchVoidHudHeight(context);
    final gap = AdaptiveLayout.inlineGap(context);
    final label = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppTheme.neoTextPrimary,
          fontWeight: FontWeight.w700,
        );
    final value = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppTheme.neoGold,
          fontWeight: FontWeight.w800,
        );

    final modeName =
        state.mode == MatchGameMode.arena ? 'Arena' : 'Countdown';
    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        color: const Color(0xFF1A2234),
        elevation: 4,
        borderRadius: BorderRadius.circular(
          AdaptiveLayout.matchVoidCardRadius(context),
        ),
        child: SizedBox(
          height: hudHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: gap * 1.2),
            child: Row(
              children: [
                _HudChip(label: 'Mode', value: modeName, labelStyle: label, valueStyle: value),
                if (state.mode == MatchGameMode.countdown) ...[
                  SizedBox(width: gap),
                  _HudChip(
                    label: 'Time',
                    value: '${state.remainingSeconds}s',
                    labelStyle: label,
                    valueStyle: value,
                  ),
                ],
                if (state.mode == MatchGameMode.arena) ...[
                  SizedBox(width: gap),
                  _HudChip(
                    label: 'Board',
                    value:
                        '${state.currentBoardIndex.clamp(1, MatchGameCubit.arenaBoardCount)}/${MatchGameCubit.arenaBoardCount}',
                    labelStyle: label,
                    valueStyle: value,
                  ),
                ],
                const Spacer(),
                _HudChip(
                  label: 'Score',
                  value: '${state.currentScore}',
                  labelStyle: label,
                  valueStyle: value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HudChip extends StatelessWidget {
  const _HudChip({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.inlineGap(context) * 0.35;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: labelStyle),
        SizedBox(width: gap),
        Text(value, style: valueStyle),
      ],
    );
  }
}

class _ActionPanel extends StatelessWidget {
  const _ActionPanel({required this.state});

  final MatchGameState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MatchGameCubit>();
    final gap = AdaptiveLayout.matchVoidPanelGap(context);
    final enabled = !state.isGameOver;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: AdaptiveLayout.matchVoidHudHeight(context) + gap),
        Expanded(
          flex: 8,
          child: _BoardGrid(
            board: state.currentBoard,
            selectedIndices: state.selectedIndices,
            enabled: enabled,
            onTap: cubit.toggleCardSelection,
          ),
        ),
        SizedBox(height: gap),
        Expanded(
          flex: 2,
          child: _ActionButtons(
            state: state,
            enabled: enabled,
            onConfirm: cubit.submitMatch,
            onVoid: cubit.declareVoid,
          ),
        ),
      ],
    );
  }
}

class _BoardGrid extends StatelessWidget {
  const _BoardGrid({
    required this.board,
    required this.selectedIndices,
    required this.enabled,
    required this.onTap,
  });

  final List<MatchCard> board;
  final List<int> selectedIndices;
  final bool enabled;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.matchVoidPanelGap(context) * 0.65;
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = math.min(constraints.maxWidth, constraints.maxHeight);
        final cell = (side - gap * 2) / 3;
        final gridSide = cell * 3 + gap * 2;
        return Center(
          child: SizedBox(
            width: gridSide,
            height: gridSide,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: gap,
                mainAxisSpacing: gap,
                childAspectRatio: 1,
              ),
              itemCount: board.length,
              itemBuilder: (context, index) {
                return MatchCardWidget(
                  card: board[index],
                  isSelected: selectedIndices.contains(index),
                  onTap: enabled ? () => onTap(index) : null,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.state,
    required this.enabled,
    required this.onConfirm,
    required this.onVoid,
  });

  final MatchGameState state;
  final bool enabled;
  final VoidCallback onConfirm;
  final VoidCallback onVoid;

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.matchVoidPanelGap(context) * 0.5;
    final penaltyColor =
        AdaptiveLayout.matchVoidVoidPenaltyColor(state.voidPenaltyLevel);
    final canConfirm = enabled && state.selectedIndices.length == 3;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: FilledButton(
            onPressed: canConfirm ? onConfirm : null,
            child: Text(
              'Confirm Match',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          child: FilledButton.tonal(
            style: FilledButton.styleFrom(
              foregroundColor: penaltyColor,
              side: BorderSide(color: penaltyColor, width: gap * 0.12),
            ),
            onPressed: enabled ? onVoid : null,
            child: _VoidButtonLabel(
              state: state,
              penaltyColor: penaltyColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _VoidButtonLabel extends StatelessWidget {
  const _VoidButtonLabel({
    required this.state,
    required this.penaltyColor,
  });

  final MatchGameState state;
  final Color penaltyColor;

  @override
  Widget build(BuildContext context) {
    final titleSize = AdaptiveLayout.matchVoidVoidButtonTitleSize(context);
    final subtitleSize =
        AdaptiveLayout.matchVoidVoidButtonSubtitleSize(context);
    final titleStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: penaltyColor,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
          fontSize: titleSize,
          height: 1.1,
        );
    final subtitleStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: penaltyColor,
          fontWeight: FontWeight.w700,
          fontSize: subtitleSize,
          height: 1.1,
        );

    final cubit = context.read<MatchGameCubit>();
    final nextPenalty = state.mode == MatchGameMode.arena
        ? cubit.arenaNextVoidPenaltyIfWrong()
        : MatchGameCubit.countdownVoidPenaltySeconds;
    final penaltyLine = state.mode == MatchGameMode.arena
        ? '(−$nextPenalty pt if wrong)'
        : '(−${nextPenalty}s if wrong)';

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AdaptiveLayout.inlineGap(context) * 0.35,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('VOID', textAlign: TextAlign.center, style: titleStyle),
            SizedBox(height: AdaptiveLayout.inlineGap(context) * 0.15),
            Text(
              penaltyLine,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: subtitleStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel({required this.state});

  final MatchGameState state;

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.matchVoidPanelGap(context);
    final radius = AdaptiveLayout.matchVoidCardRadius(context);
    final scheme = Theme.of(context).colorScheme;
    final title = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        );
    final empty = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppTheme.neoTextMuted,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: AdaptiveLayout.matchVoidHudHeight(context) + gap),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Padding(
              padding: EdgeInsets.all(gap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Matches Found: ${state.historyLog.length}',
                    style: title,
                  ),
                  SizedBox(height: gap * 0.75),
                  Expanded(
                    child: state.historyLog.isEmpty
                        ? Center(
                            child: Text(
                              'Found triplets appear here.',
                              style: empty,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.separated(
                            itemCount: state.historyLog.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: gap * 0.65),
                            itemBuilder: (context, index) {
                              return _HistoryTripletRow(
                                triplet: state.historyLog[index],
                                index: index + 1,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryTripletRow extends StatelessWidget {
  const _HistoryTripletRow({
    required this.triplet,
    required this.index,
  });

  final List<MatchCard> triplet;
  final int index;

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.inlineGap(context);
    final extent = AdaptiveLayout.matchVoidHistoryCardExtent(context);
    final label = Theme.of(context).textTheme.labelMedium;

    return Row(
      children: [
        SizedBox(
          width: extent * 0.55,
          child: Text('#$index', style: label),
        ),
        for (var i = 0; i < triplet.length; i++) ...[
          if (i > 0) SizedBox(width: gap * 0.45),
          SizedBox(
            width: extent,
            height: extent,
            child: MatchCardWidget(
              card: triplet[i],
              compact: true,
            ),
          ),
        ],
      ],
    );
  }
}
