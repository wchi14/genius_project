import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:genius_project/core/theme/app_theme.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/core/models/coordinate.dart';
import 'package:genius_project/games/matrix_poker_25/models/matrix_grid_model.dart';

/// Read-only 5×5 grid with optional circular highlights on [highlightCoords].
class MatrixPokerGrid extends StatelessWidget {
  const MatrixPokerGrid({
    super.key,
    required this.grid,
    this.highlightCoords,
  });

  final MatrixGridModel grid;

  /// When non-null, those cells get a circular ring (combo preview in duel).
  final List<Coordinate>? highlightCoords;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final highlightSet = highlightCoords == null
        ? const <Coordinate>{}
        : highlightCoords!.toSet();

    return LayoutBuilder(
      builder: (context, constraints) {
        final g = AdaptiveLayout.matrixCellGutter(
          math.min(constraints.maxWidth, constraints.maxHeight),
        );
        return Column(
          children: [
            for (var y = 0; y < 5; y++)
              Expanded(
                child: Row(
                  children: [
                    for (var x = 0; x < 5; x++)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(g),
                          child: _GridCell(
                            value: grid.getNumberAt(Coordinate(x, y)),
                            highlight: highlightSet.contains(Coordinate(x, y)),
                            theme: theme,
                            scheme: scheme,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({
    required this.value,
    required this.highlight,
    required this.theme,
    required this.scheme,
  });

  final int value;
  final bool highlight;
  final ThemeData theme;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final u = math.min(constraints.maxWidth, constraints.maxHeight);
        final r = math.max(u * 0.08, 1.0);
        final shadowAlpha = highlight ? 0.42 : 0.22;
        final lift = u * (highlight ? 0.06 : 0.04);
        final ringBlur = highlight ? u * 0.12 : 0.0;
        final ringSpread = highlight ? u * 0.008 : 0.0;
        final ringW = math.max(u * 0.035, 1.0);

        return DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: shadowAlpha),
                blurRadius: lift,
                offset: Offset(0, lift * 0.35),
              ),
              BoxShadow(
                color: AppTheme.neoPurple
                    .withValues(alpha: highlight ? 0.2 : 0.0),
                blurRadius: ringBlur,
                spreadRadius: ringSpread,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(r),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    '$value',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (highlight)
                  IgnorePointer(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.neoPurple,
                            width: ringW,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
