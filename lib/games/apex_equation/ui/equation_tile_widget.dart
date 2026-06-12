import 'package:flutter/material.dart';

import 'package:genius_project/core/theme/app_theme.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/games/apex_equation/models/equation_tile.dart';

/// Displays one [EquationTile] on the pyramid or in a selection slot.
class EquationTileWidget extends StatelessWidget {
  const EquationTileWidget({
    super.key,
    required this.tile,
    required this.extent,
    this.isSelectedOnBoard = false,
    this.ignoreOperator = false,
    this.emphasizeOperator = false,
    this.onTap,
  });

  final EquationTile tile;
  final double extent;
  final bool isSelectedOnBoard;
  final bool ignoreOperator;

  /// Larger operator glyph on the pyramid (value scales down to fit same tile).
  final bool emphasizeOperator;
  final VoidCallback? onTap;

  static String operatorSymbol(OperatorType type) {
    return switch (type) {
      OperatorType.add => '+',
      OperatorType.subtract => '−',
      OperatorType.multiply => '×',
      OperatorType.divide => '÷',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = AdaptiveLayout.apexTileRadius(context);
    final innerPad = AdaptiveLayout.apexTileInnerPadding(extent);
    final borderWidth = AdaptiveLayout.apexTileBorderWidth(
      extent,
      selected: isSelectedOnBoard,
    );
    final opSize = AdaptiveLayout.apexTileOperatorFontSize(
      extent,
      emphasize: emphasizeOperator,
    );
    final valueSize = AdaptiveLayout.apexTileValueFontSize(
      extent,
      emphasize: emphasizeOperator,
    );
    final opStyle = TextStyle(
      fontSize: opSize,
      fontWeight: FontWeight.w800,
      height: 1,
      color: ignoreOperator
          ? theme.colorScheme.onSurface.withValues(alpha: 0.35)
          : AppTheme.neoGold,
      decoration: ignoreOperator ? TextDecoration.lineThrough : null,
      decorationThickness: extent * 0.04,
    );
    final valueStyle = TextStyle(
      fontSize: valueSize,
      fontWeight: FontWeight.w800,
      height: 1,
      color: theme.colorScheme.onSurface,
    );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: isSelectedOnBoard ? 0.42 : 1,
      child: Material(
        color: theme.colorScheme.surfaceContainerHigh,
        elevation: isSelectedOnBoard ? 0 : 2,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            width: extent,
            height: extent,
            padding: innerPad,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: isSelectedOnBoard
                    ? theme.colorScheme.primary.withValues(alpha: 0.55)
                    : theme.colorScheme.outline.withValues(alpha: 0.35),
                width: borderWidth,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(operatorSymbol(tile.operator), style: opStyle),
                  SizedBox(height: AdaptiveLayout.apexTileSymbolGap(extent)),
                  Text('${tile.value}', style: valueStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
