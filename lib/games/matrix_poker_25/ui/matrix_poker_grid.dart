import 'package:flutter/material.dart';

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

    // IMPORTANT: avoid GridView here. Even with NeverScrollablePhysics, a GridView
    // can end up clipped in tight layouts (showing only a few rows) because it's
    // still a scroll viewport. This Expanded Row/Column layout always paints all
    // 25 cells and scales to whatever space the parent gives it.
    return Column(
      children: [
        for (var y = 0; y < 5; y++)
          Expanded(
            child: Row(
              children: [
                for (var x = 0; x < 5; x++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(3),
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
    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              '$value',
              style: theme.textTheme.titleMedium?.copyWith(
                color: scheme.onSurface,
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
                      color: scheme.tertiary,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
