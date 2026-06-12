import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:genius_project/core/theme/app_theme.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/games/apex_equation/logic/apex_game_cubit.dart';
import 'package:genius_project/games/apex_equation/logic/apex_game_state.dart';
import 'package:genius_project/games/apex_equation/models/apex_game_mode.dart';
import 'package:genius_project/games/apex_equation/models/equation_tile.dart';
import 'package:genius_project/games/apex_equation/ui/equation_tile_widget.dart';

/// Landscape play surface for Apex Equation (Arena or Countdown).
class ApexGameScreen extends StatelessWidget {
  const ApexGameScreen({
    super.key,
    required this.mode,
    this.cubit,
  });

  final ApexGameMode mode;
  final ApexGameCubit? cubit;

  static const List<List<int>> pyramidRows = [
    [0],
    [1, 2],
    [3, 4, 5],
    [6, 7, 8, 9],
  ];

  @override
  Widget build(BuildContext context) {
    const body = _ApexGameBody();

    if (cubit != null) {
      return BlocProvider<ApexGameCubit>.value(
        value: cubit!,
        child: body,
      );
    }
    return BlocProvider<ApexGameCubit>(
      create: (_) => ApexGameCubit(mode: mode),
      child: body,
    );
  }
}

class _ApexGameBody extends StatelessWidget {
  const _ApexGameBody();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApexGameCubit, ApexGameState>(
      listenWhen: (prev, next) => !prev.isGameOver && next.isGameOver,
      listener: (context, state) => _showGameOverSheet(context, state),
      child: Scaffold(
        backgroundColor: AppTheme.neoBackground,
        body: SafeArea(
          child: Padding(
            padding: AdaptiveLayout.apexPlayInsets(context),
            child: BlocBuilder<ApexGameCubit, ApexGameState>(
              builder: (context, state) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _PyramidBoard(state: state),
                    ),
                    SizedBox(width: AdaptiveLayout.apexPanelGap(context)),
                    Expanded(
                      flex: 4,
                      child: _RightPanel(state: state),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showGameOverSheet(BuildContext context, ApexGameState state) {
    final modeLabel =
        state.mode == ApexGameMode.arena ? 'Arena complete' : "Time's up";
    final timeLine = state.mode == ApexGameMode.countdown
        ? ''
        : '\nTime: ${state.remainingSeconds}s';

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      builder: (ctx) {
        return Padding(
          padding: AdaptiveLayout.panelPadding(ctx),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(modeLabel, style: Theme.of(ctx).textTheme.titleLarge),
              SizedBox(height: AdaptiveLayout.sectionGap(ctx)),
              Text(
                'Score: ${state.currentScore}$timeLine',
                style: Theme.of(ctx).textTheme.bodyLarge,
              ),
              SizedBox(height: AdaptiveLayout.sectionGap(ctx)),
              FilledButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (context.mounted) {
                    context.pop();
                  }
                },
                child: const Text('Back'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PyramidBoard extends StatelessWidget {
  const _PyramidBoard({required this.state});

  final ApexGameState state;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final rowGap = AdaptiveLayout.apexPyramidRowGap(context);
        final tileGap = AdaptiveLayout.apexTileGap(context);
        final tileExtent = AdaptiveLayout.apexPyramidTileExtent(
          regionWidth: constraints.maxWidth,
          regionHeight: constraints.maxHeight,
          tileGap: tileGap,
          rowGap: rowGap,
        );

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var r = 0; r < ApexGameScreen.pyramidRows.length; r++) ...[
                if (r > 0) SizedBox(height: rowGap),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var c = 0;
                        c < ApexGameScreen.pyramidRows[r].length;
                        c++) ...[
                      if (c > 0) SizedBox(width: tileGap),
                      _PyramidTile(
                        state: state,
                        index: ApexGameScreen.pyramidRows[r][c],
                        extent: tileExtent,
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _PyramidTile extends StatelessWidget {
  const _PyramidTile({
    required this.state,
    required this.index,
    required this.extent,
  });

  final ApexGameState state;
  final int index;
  final double extent;

  @override
  Widget build(BuildContext context) {
    if (index >= state.availableTiles.length) {
      return SizedBox(width: extent, height: extent);
    }

    final tile = state.availableTiles[index];
    final isSelected =
        state.selectedTiles.any((selected) => selected.id == tile.id);
    final cubit = context.read<ApexGameCubit>();

    return EquationTileWidget(
      tile: tile,
      extent: extent,
      isSelectedOnBoard: isSelected,
      emphasizeOperator: true,
      onTap: state.isGameOver
          ? null
          : () {
              if (isSelected) {
                cubit.deselectTile(tile);
              } else {
                cubit.selectTile(tile);
              }
            },
    );
  }
}

class _RightPanel extends StatelessWidget {
  const _RightPanel({required this.state});

  final ApexGameState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ApexGameCubit>();
    final slotExtent = AdaptiveLayout.apexSelectionSlotExtent(context);
    final targetExtent = AdaptiveLayout.apexTargetBoxExtent(context);
    final gap = AdaptiveLayout.sectionGap(context);

    return Padding(
      padding: AdaptiveLayout.apexRightPanelPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ApexHud(state: state),
          SizedBox(height: gap),
          Expanded(
            child: Center(
              child: _TargetBox(
                target: state.targetNumber,
                extent: targetExtent,
              ),
            ),
          ),
          SizedBox(height: gap),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) SizedBox(width: AdaptiveLayout.apexTileGap(context)),
              _SelectionSlot(
                index: i,
                tile: i < state.selectedTiles.length
                    ? state.selectedTiles[i]
                    : null,
                extent: slotExtent,
                onClear: state.isGameOver || i >= state.selectedTiles.length
                    ? null
                    : () => cubit.deselectTile(state.selectedTiles[i]),
              ),
            ],
          ],
        ),
          SizedBox(height: gap),
          SizedBox(
            height: AdaptiveLayout.apexConfirmButtonHeight(context),
            width: slotExtent * 3 + AdaptiveLayout.apexTileGap(context) * 2,
            child: FilledButton(
              onPressed: state.isGameOver || state.selectedTiles.length != 3
                  ? null
                  : cubit.submitAnswer,
              child: const Text('CONFIRM'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApexHud extends StatelessWidget {
  const _ApexHud({required this.state});

  final ApexGameState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gap = AdaptiveLayout.inlineGap(context);
    final isCountdown = state.mode == ApexGameMode.countdown;
    const levelCap = ApexGameCubit.arenaLevelCount;
    final levelLabel = state.mode == ApexGameMode.arena
        ? '${state.currentLevel.clamp(1, levelCap)} / $levelCap'
        : '${state.currentLevel}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          isCountdown ? 'Countdown' : 'Arena',
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppTheme.neoGold,
          ),
        ),
        SizedBox(height: gap * 0.5),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: gap,
          runSpacing: gap * 0.5,
          children: [
            _HudChip(label: 'Score', value: '${state.currentScore}'),
            _HudChip(label: 'Level', value: levelLabel),
            _HudChip(
              label: isCountdown ? 'Time' : 'Elapsed',
              value: isCountdown
                  ? '${state.remainingSeconds}s'
                  : '${state.remainingSeconds}s',
            ),
          ],
        ),
        if (state.currentWrongTries > 0) ...[
          SizedBox(height: gap),
          Text(
            'Wrong tries: ${state.currentWrongTries}/${ApexGameCubit.maxWrongTriesBeforeAutoSkip}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: const Color(0xFFFF5252),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _HudChip extends StatelessWidget {
  const _HudChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = AdaptiveLayout.apexTileRadius(context);
    final pad = AdaptiveLayout.apexHudChipPadding(context);
    final borderWidth = AdaptiveLayout.apexHudChipBorderWidth(context);

    return Container(
      padding: pad,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.55),
          width: borderWidth,
        ),
        color: theme.colorScheme.surfaceContainerHigh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(value, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _TargetBox extends StatelessWidget {
  const _TargetBox({required this.target, required this.extent});

  final int target;
  final double extent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = AdaptiveLayout.apexTileRadius(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'TARGET',
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppTheme.neoGold,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: AdaptiveLayout.inlineGap(context)),
        Container(
          width: extent,
          height: extent,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: AppTheme.neoGold.withValues(alpha: 0.85),
              width: 2.5,
            ),
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          child: Text(
            '$target',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppTheme.neoGold,
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectionSlot extends StatelessWidget {
  const _SelectionSlot({
    required this.index,
    required this.tile,
    required this.extent,
    this.onClear,
  });

  final int index;
  final EquationTile? tile;
  final double extent;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = AdaptiveLayout.apexTileRadius(context);

    if (tile == null) {
      return Container(
        width: extent,
        height: extent,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.4),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '${index + 1}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return EquationTileWidget(
      tile: tile!,
      extent: extent,
      ignoreOperator: index == 0,
      onTap: onClear,
    );
  }
}
