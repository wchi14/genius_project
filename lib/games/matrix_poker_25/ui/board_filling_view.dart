import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:genius_project/core/models/coordinate.dart';
import 'package:genius_project/games/matrix_poker_25/logic/matrix_poker_cubit.dart';
import 'package:genius_project/games/matrix_poker_25/models/matrix_grid_model.dart';

import 'matrix_poker_error_dialog.dart';

/// Phase 1 UI (landscape): sidebar with dealer draw; **non-scrolling** 5×5 grid
/// that expands to use remaining space.
class BoardFillingView extends StatelessWidget {
  const BoardFillingView({
    super.key,
    required this.grid,
    required this.fillRound,
    required this.dealerValue,
    required this.remainingSeconds,
    this.totalRounds = 25,
  });

  final MatrixGridModel grid;
  final int fillRound;
  final int dealerValue;
  final int remainingSeconds;
  final int totalRounds;

  Future<void> _showOccupiedCellWarning(BuildContext context) async {
    await showMatrixPokerErrorDialog(
      context,
      title: 'Cell already filled',
      message:
          'That square already has a number. Tap an empty cell (shown with a dot) '
          'to place $dealerValue.',
    );
  }

  Future<void> _onEmptyCellTap(BuildContext context, Coordinate coord) async {
    final ok =
        await context.read<MatrixPokerCubit>().tryPlaceDealerNumber(coord);
    if (!ok && context.mounted) {
      await showMatrixPokerErrorDialog(
        context,
        title: "Can't place here",
        message:
            'This cell cannot take the current draw. Choose a different empty square.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final timeLeft = _formatMmSs(remainingSeconds);
    final isUrgent = remainingSeconds <= 10;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Phase 1',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fill your board',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Round $fillRound / $totalRounds',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Time Left: $timeLeft',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isUrgent ? Colors.red : scheme.onSurfaceVariant,
                      fontWeight: isUrgent ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Dealer',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$dealerValue',
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You and your opponent both place this number on your own boards.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: scheme.outlineVariant),
                  color: scheme.surfaceContainerLow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        for (var y = 0; y < 5; y++)
                          Expanded(
                            child: Row(
                              children: [
                                for (var x = 0; x < 5; x++)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: _Phase1Cell(
                                        value:
                                            grid.getNumberAt(Coordinate(x, y)),
                                        theme: theme,
                                        scheme: scheme,
                                        onEmptyTap: () => _onEmptyCellTap(
                                            context, Coordinate(x, y)),
                                        onOccupiedTap: () =>
                                            _showOccupiedCellWarning(context),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatMmSs(int seconds) {
  final m = seconds ~/ 60;
  final s = seconds % 60;
  final mm = m.toString().padLeft(2, '0');
  final ss = s.toString().padLeft(2, '0');
  return '$mm:$ss';
}

class _Phase1Cell extends StatelessWidget {
  const _Phase1Cell({
    required this.value,
    required this.theme,
    required this.scheme,
    required this.onEmptyTap,
    required this.onOccupiedTap,
  });

  final int value;
  final ThemeData theme;
  final ColorScheme scheme;
  final VoidCallback onEmptyTap;
  final VoidCallback onOccupiedTap;

  @override
  Widget build(BuildContext context) {
    final empty = value == 0;

    final label = Center(
      child: Text(
        empty ? '·' : '$value',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: empty ? FontWeight.w400 : FontWeight.w600,
          color: empty ? scheme.onSurfaceVariant : scheme.onSurface,
        ),
      ),
    );

    if (empty) {
      return Material(
        color: scheme.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          onTap: onEmptyTap,
          child: label,
        ),
      );
    }

    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        onTap: onOccupiedTap,
        child: label,
      ),
    );
  }
}
