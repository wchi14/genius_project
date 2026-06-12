import 'package:flutter/material.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';

/// Shared turn timer chip (Blind Cup, Blind Count 40, etc.).
class TurnCountdownChip extends StatelessWidget {
  const TurnCountdownChip({
    super.key,
    required this.seconds,
    this.urgentThreshold = 5,
    this.showWhenInactive = false,
  });

  final int? seconds;
  final int urgentThreshold;

  /// When false, hides the chip if [seconds] is null.
  final bool showWhenInactive;

  @override
  Widget build(BuildContext context) {
    final s = seconds;
    if (s == null && !showWhenInactive) {
      return const SizedBox.shrink();
    }
    final scheme = Theme.of(context).colorScheme;
    final value = s ?? 0;
    final urgent = value <= urgentThreshold;
    return Chip(
      avatar: Icon(
        Icons.timer_outlined,
        size: AdaptiveLayout.bluffCupChipIconSize(context) * 0.45,
        color: urgent ? scheme.error : scheme.secondary,
      ),
      label: Text(
        '$value s',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: urgent ? scheme.error : scheme.onSurface,
            ),
      ),
      side: BorderSide(
        color: urgent ? scheme.error : scheme.outlineVariant,
      ),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.symmetric(
        horizontal: AdaptiveLayout.inlineGap(context) * 0.5,
      ),
    );
  }
}
