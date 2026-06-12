import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/core/models/coordinate.dart';
import 'package:genius_project/games/matrix_poker_25/logic/combo.dart';
import 'package:genius_project/games/matrix_poker_25/logic/hand_rank.dart';
import 'package:genius_project/games/matrix_poker_25/logic/matrix_poker_cubit.dart';
import 'package:genius_project/games/matrix_poker_25/logic/player_draft_manager.dart';
import 'package:genius_project/games/matrix_poker_25/models/matrix_grid_model.dart';

import 'matrix_poker_error_dialog.dart';

/// Phase 2 UI: grid with A–E / 1–5 headers, live draft list, undo, sorted confirm.
/// The app locks to landscape at startup; this view still handles rare portrait
/// layouts (e.g. split-screen) with a rotate hint.
class DraftingView extends StatefulWidget {
  const DraftingView({
    super.key,
    required this.grid,
    required this.initialDraftedCombos,
    required this.remainingSeconds,
  });

  final MatrixGridModel grid;

  /// Seeds local copy from [MatrixPokerState.drafting] `draftedCombos` when the screen opens.
  final List<Combo> initialDraftedCombos;

  final int remainingSeconds;

  @override
  State<DraftingView> createState() => _DraftingViewState();
}

class _DraftingViewState extends State<DraftingView> {
  final List<Coordinate> _selectedCells = [];
  late List<Combo> _draftedCombos;

  /// Highlighted draft row for delete affordance (`0..n-1`).
  int? _selectedDraftListIndex;

  @override
  void initState() {
    super.initState();
    _draftedCombos = List.of(widget.initialDraftedCombos);
  }

  @override
  void didUpdateWidget(DraftingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(
        widget.initialDraftedCombos, oldWidget.initialDraftedCombos)) {
      _draftedCombos = List.of(widget.initialDraftedCombos);
    }
  }

  bool _isSelected(Coordinate c) => _selectedCells.any((e) => e == c);

  void _addCell(Coordinate coord) {
    setState(() {
      if (_selectedCells.length >= 4) return;
      if (_selectedCells.any((c) => c == coord)) return;
      _selectedCells.add(coord);
    });
  }

  List<Coordinate>? get _highlightedDraftCoords {
    final i = _selectedDraftListIndex;
    if (i == null) return null;
    if (i < 0 || i >= _draftedCombos.length) return null;
    return _draftedCombos[i].coordinates;
  }

  void _toggleCell(Coordinate coord) {
    setState(() {
      final i = _selectedCells.indexWhere((c) => c == coord);
      if (i >= 0) {
        _selectedCells.removeAt(i);
        return;
      }
      if (_selectedCells.length >= 4) {
        return;
      }
      _selectedCells.add(coord);
    });
  }

  Future<void> _showError(String message, {String title = 'Heads up'}) async {
    if (!mounted) {
      return;
    }
    await showMatrixPokerErrorDialog(context, message: message, title: title);
  }

  Future<void> _onAddCombo() async {
    if (_selectedCells.length != 4) {
      await _showError(
        'Select exactly four cells on the grid before adding a combo.',
        title: 'Incomplete selection',
      );
      return;
    }

    final cubit = context.read<MatrixPokerCubit>();
    final coords = List<Coordinate>.of(_selectedCells);
    final ok = cubit.playerOneDrafts.tryDraftCombo(widget.grid, coords);

    if (!ok) {
      await _showError(
        'That line is not a valid four-cell straight, or you already saved this shape. '
        'Try a different line.',
        title: 'Invalid combo',
      );
      setState(_selectedCells.clear);
      return;
    }

    setState(() {
      _selectedCells.clear();
      _selectedDraftListIndex = null;
      _draftedCombos = List.of(cubit.playerOneDrafts.combos);
    });
  }

  void _onDraftRowTap(int index) {
    setState(() {
      _selectedDraftListIndex = _selectedDraftListIndex == index ? null : index;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedCells.clear();
      // keep draft row selection (user might be removing/editing)
    });
  }

  void _removeDraftAt(int index) {
    final cubit = context.read<MatrixPokerCubit>();
    cubit.playerOneDrafts.removeDraftAt(index);
    setState(() {
      _selectedDraftListIndex = null;
      _draftedCombos = List.of(cubit.playerOneDrafts.combos);
    });
  }

  /// Strongest first: lower [HandRank.index], then higher [Combo.primaryKeyValue].
  static void _sortDraftsStrongestFirst(List<Combo> list) {
    list.sort((a, b) {
      final byRank = a.rank.index.compareTo(b.rank.index);
      if (byRank != 0) {
        return byRank;
      }
      return b.primaryKeyValue.compareTo(a.primaryKeyValue);
    });
  }

  Future<void> _onConfirm() async {
    if (_draftedCombos.length != PlayerDraftManager.maxDrafts) {
      return;
    }
    final sorted = List<Combo>.of(_draftedCombos);
    _sortDraftsStrongestFirst(sorted);
    await context.read<MatrixPokerCubit>().submitDrafts(sorted);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final timeLeft = _formatMmSs(widget.remainingSeconds);
    final isUrgent = widget.remainingSeconds <= 10;
    final timerStyle = theme.textTheme.titleSmall?.copyWith(
      color: isUrgent ? Colors.red : scheme.onSurfaceVariant,
      fontWeight: isUrgent ? FontWeight.w800 : FontWeight.w600,
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation != Orientation.landscape) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Please rotate your device to landscape to draft combos.',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Drafted: ${_draftedCombos.length} / ${PlayerDraftManager.maxDrafts}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Time Left: $timeLeft',
                        style: timerStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _LabeledGrid(
                          grid: widget.grid,
                          isSelected: _isSelected,
                          highlightedCoords: _highlightedDraftCoords,
                          onCellTap: _toggleCell,
                          onCellDragAdd: _addCell,
                          scheme: scheme,
                          theme: theme,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonal(
                              style: FilledButton.styleFrom(
                                foregroundColor: scheme.onSurface,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              onPressed: _onAddCombo,
                              child: const Text('Add Combo'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: scheme.onSurface,
                                side: BorderSide(color: scheme.outline),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              onPressed: _selectedCells.isEmpty
                                  ? null
                                  : _clearSelection,
                              child: const Text('Clear Selection'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                foregroundColor: scheme.onPrimary,
                                backgroundColor: scheme.primary,
                                disabledForegroundColor:
                                    scheme.onSurface.withValues(alpha: 0.45),
                                disabledBackgroundColor:
                                    scheme.surfaceContainerHighest,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              onPressed: _draftedCombos.length ==
                                      PlayerDraftManager.maxDrafts
                                  ? _onConfirm
                                  : null,
                              child: const Text('Confirm 12 Combos'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _DraftListPanel(
                    combos: _draftedCombos,
                    selectedIndex: _selectedDraftListIndex,
                    onRowTap: _onDraftRowTap,
                    onRemove: _removeDraftAt,
                    theme: theme,
                    scheme: scheme,
                  ),
                ),
              ],
            ),
        );
      },
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

/// Cell [0,0] → A1 … [4,4] → E5.
String chessLabel(Coordinate c) =>
    '${String.fromCharCode('A'.codeUnitAt(0) + c.x)}${c.y + 1}';

String _handRankLabel(HandRank rank) => switch (rank) {
      HandRank.fourOfAKind => 'Four of a Kind',
      HandRank.straightInOrder => '4 Straight (In Order)',
      HandRank.straightNotInOrder => '4 Straight (Not in Order)',
      HandRank.twoPair => 'Two Pair',
      HandRank.threeOfAKind => 'Three of a Kind',
      HandRank.onePair => 'One Pair',
      HandRank.highCard => 'High Card',
    };

class _LabeledGrid extends StatefulWidget {
  const _LabeledGrid({
    required this.grid,
    required this.isSelected,
    required this.highlightedCoords,
    required this.onCellTap,
    required this.onCellDragAdd,
    required this.scheme,
    required this.theme,
  });

  final MatrixGridModel grid;
  final bool Function(Coordinate c) isSelected;
  final List<Coordinate>? highlightedCoords;
  final void Function(Coordinate coord) onCellTap;
  final void Function(Coordinate coord) onCellDragAdd;
  final ColorScheme scheme;
  final ThemeData theme;

  @override
  State<_LabeledGrid> createState() => _LabeledGridState();
}

class _LabeledGridState extends State<_LabeledGrid> {
  int? _activePointer;
  Coordinate? _lastDragCell;
  Offset? _pointerDownLocal;
  bool _isDragging = false;

  void _endDrag() {
    _activePointer = null;
    _lastDragCell = null;
    _pointerDownLocal = null;
    _isDragging = false;
  }

  @override
  Widget build(BuildContext context) {
    final highlightSet = widget.highlightedCoords == null
        ? const <Coordinate>{}
        : widget.highlightedCoords!.toSet();

    return LayoutBuilder(
      builder: (context, constraints) {
        final extent = AdaptiveLayout.gridLabelExtent(
          math.min(constraints.maxWidth, constraints.maxHeight),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                SizedBox(
                  width: extent,
                  height: extent,
                  child: const SizedBox.shrink(),
                ),
                for (var x = 0; x < 5; x++)
                  Expanded(
                    child: Center(
                      child: Text(
                        String.fromCharCode('A'.codeUnitAt(0) + x),
                        style: widget.theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: widget.scheme.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: extent,
                    child: Column(
                      children: [
                        for (var y = 0; y < 5; y++)
                          Expanded(
                            child: Center(
                              child: Text(
                                '${y + 1}',
                                style: widget.theme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: widget.scheme.primary,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, gridConstraints) {
                        final cellG = AdaptiveLayout.matrixCellGutter(
                          math.min(
                            gridConstraints.maxWidth,
                            gridConstraints.maxHeight,
                          ),
                        );
                        void hitTest(Offset local) {
                          final w = gridConstraints.maxWidth;
                          final h = gridConstraints.maxHeight;
                          if (w <= 0 || h <= 0) return;
                          final x = (local.dx / (w / 5)).floor();
                          final y = (local.dy / (h / 5)).floor();
                          if (x < 0 || x > 4 || y < 0 || y > 4) return;
                          final cell = Coordinate(x, y);
                          if (_lastDragCell == cell) return;
                          _lastDragCell = cell;
                          widget.onCellDragAdd(cell);
                        }

                        // Use raw pointer listening so taps still go to InkWell.
                        return Listener(
                          behavior: HitTestBehavior.translucent,
                          onPointerDown: (e) {
                            // Do NOT add on down; this prevents a tap from "adding" and then
                            // immediately toggling off via InkWell.onTap.
                            _activePointer = e.pointer;
                            _lastDragCell = null;
                            _pointerDownLocal = e.localPosition;
                            _isDragging = false;
                          },
                          onPointerMove: (e) {
                            if (_activePointer != e.pointer) return;
                            final down = _pointerDownLocal;
                            if (down == null) return;
                            final delta = (e.localPosition - down);
                            // Only treat as a swipe after a small movement threshold.
                            // This prevents "tap jitter" on desktop from selecting via swipe
                            // and then immediately toggling off via InkWell.
                            if (!_isDragging && delta.distance < 6) {
                              return;
                            }
                            _isDragging = true;
                            hitTest(e.localPosition);
                          },
                          onPointerUp: (_) => _endDrag(),
                          onPointerCancel: (_) => _endDrag(),
                          child: Column(
                            children: [
                              for (var y = 0; y < 5; y++)
                                Expanded(
                                  child: Row(
                                    children: [
                                      for (var x = 0; x < 5; x++)
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(cellG),
                                            child: _GridCell(
                                              coord: Coordinate(x, y),
                                              value: widget.grid.getNumberAt(
                                                Coordinate(x, y),
                                              ),
                                              selected: widget.isSelected(
                                                Coordinate(x, y),
                                              ),
                                              highlighted: highlightSet
                                                  .contains(Coordinate(x, y)),
                                              onTap: () => widget.onCellTap(
                                                Coordinate(x, y),
                                              ),
                                              scheme: widget.scheme,
                                              theme: widget.theme,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
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
    required this.coord,
    required this.value,
    required this.selected,
    required this.highlighted,
    required this.onTap,
    required this.scheme,
    required this.theme,
  });

  final Coordinate coord;
  final int value;
  final bool selected;
  final bool highlighted;
  final VoidCallback onTap;
  final ColorScheme scheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final u = math.min(constraints.maxWidth, constraints.maxHeight);
        final r = math.max(u * 0.12, 2.0);
        return Material(
          color: selected
              ? scheme.primaryContainer
              : highlighted
                  ? scheme.tertiaryContainer.withValues(alpha: 0.55)
                  : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(r),
          child: InkWell(
            borderRadius: BorderRadius.circular(r),
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            onTap: onTap,
            child: Center(
              child: Text(
                '$value',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: selected
                      ? scheme.onPrimaryContainer
                      : scheme.onSurface,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DraftListPanel extends StatelessWidget {
  const _DraftListPanel({
    required this.combos,
    required this.selectedIndex,
    required this.onRowTap,
    required this.onRemove,
    required this.theme,
    required this.scheme,
  });

  final List<Combo> combos;
  final int? selectedIndex;
  final void Function(int index) onRowTap;
  final void Function(int index) onRemove;
  final ThemeData theme;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Your drafts',
          style: theme.textTheme.titleMedium?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'Tap a row to remove it. Confirm sorts strongest → weakest.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              border: Border.all(color: scheme.outline.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: combos.isEmpty
                ? Center(
                    child: Text(
                      'No drafts yet.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: combos.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final c = combos[index];
                      final coords = c.coordinates.map(chessLabel).join(', ');
                      final line = '${_handRankLabel(c.rank)} — $coords';
                      final selected = selectedIndex == index;

                      return Material(
                        color: selected
                            ? scheme.secondaryContainer
                                .withValues(alpha: 0.65)
                            : scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => onRowTap(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 26,
                                  child: Text(
                                    '${index + 1}.',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    line,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: scheme.onSurface,
                                      height: 1.25,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                      foregroundColor: scheme.primary,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    onPressed: () => onRemove(index),
                                    icon: const Icon(Icons.delete_outline,
                                        size: 20),
                                    label: const Text('Remove'),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
