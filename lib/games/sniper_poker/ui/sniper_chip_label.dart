import 'package:flutter/material.dart';
import 'package:genius_project/core/theme/app_theme.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';

/// Gold chip icon + amount (Fatal Fold style).
class SniperChipLabel extends StatelessWidget {
  const SniperChipLabel({
    required this.amount,
    this.compact = false,
    this.iconColor = AppTheme.neoGold,
    super.key,
  });

  final int amount;
  final bool compact;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final baseFs =
        Theme.of(context).textTheme.labelLarge?.fontSize ?? 14;
    final iconSize = baseFs * (compact ? 0.95 : 1.15);
    final gap = AdaptiveLayout.inlineGap(context) * (compact ? 0.25 : 0.35);
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          height: 1,
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.toll_rounded, size: iconSize, color: iconColor),
        SizedBox(width: gap),
        Text('$amount', style: textStyle),
      ],
    );
  }
}
