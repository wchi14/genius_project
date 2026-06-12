import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:genius_project/core/services/audio_haptic_service.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';

/// Modal bottom sheet exposing BGM and SFX volume sliders.
///
/// Sliders update [AudioHapticService.bgmVolume] and [AudioHapticService.sfxVolume]
/// in real-time via [ValueListenableBuilder] — no separate state needed.
///
/// Usage:
/// ```dart
/// AudioSettingsSheet.show(context);
/// ```
class AudioSettingsSheet extends StatelessWidget {
  const AudioSettingsSheet({super.key});

  /// Opens the sheet as a modal bottom sheet.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AudioSettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pad = AdaptiveLayout.panelPadding(context);
    final gap = AdaptiveLayout.sectionGap(context);
    final inlineGap = AdaptiveLayout.inlineGap(context);
    final radius = AdaptiveLayout.lobbyGameCardRadius(context);

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius * 1.2)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: pad,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---- drag handle ----
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: EdgeInsets.only(bottom: gap),
                  decoration: BoxDecoration(
                    color: scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ---- header ----
              Row(
                children: [
                  Icon(Icons.tune_rounded, color: scheme.primary),
                  SizedBox(width: inlineGap),
                  Text('Audio Settings', style: textTheme.titleMedium),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ],
              ),

              SizedBox(height: gap),

              // ---- BGM volume ----
              _VolumeSliderRow(
                icon: Icons.music_note_rounded,
                label: 'Music',
                notifier: AudioHapticService.instance.bgmVolume,
                activeColor: scheme.primary,
              ),

              SizedBox(height: gap * 0.65),

              // ---- SFX volume ----
              _VolumeSliderRow(
                icon: Icons.volume_up_rounded,
                label: 'Sound FX',
                notifier: AudioHapticService.instance.sfxVolume,
                activeColor: scheme.secondary,
              ),

              SizedBox(height: gap * 0.5),

              // ---- mute + credits row ----
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      final svc = AudioHapticService.instance;
                      final mute = svc.bgmVolume.value > 0;
                      svc.bgmVolume.value = mute ? 0.0 : 0.70;
                      svc.sfxVolume.value = mute ? 0.0 : 1.00;
                    },
                    icon: ValueListenableBuilder<double>(
                      valueListenable: AudioHapticService.instance.bgmVolume,
                      builder: (_, vol, __) => Icon(
                        vol > 0 ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                        size: 16,
                      ),
                    ),
                    label: const Text('Mute all'),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.push('/about');
                    },
                    icon: const Icon(Icons.info_outline_rounded, size: 16),
                    label: const Text('Credits'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _VolumeSliderRow extends StatelessWidget {
  const _VolumeSliderRow({
    required this.icon,
    required this.label,
    required this.notifier,
    required this.activeColor,
  });

  final IconData icon;
  final String label;
  final ValueNotifier<double> notifier;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final inlineGap = AdaptiveLayout.inlineGap(context);
    final iconSize = AdaptiveLayout.lobbyHudIconSize(context);

    return ValueListenableBuilder<double>(
      valueListenable: notifier,
      builder: (context, value, _) {
        return Row(
          children: [
            // icon badge
            Container(
              padding: EdgeInsets.all(inlineGap * 0.55),
              decoration: BoxDecoration(
                color: activeColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: iconSize * 0.85, color: activeColor),
            ),
            SizedBox(width: inlineGap),

            // label — fixed width so sliders align
            SizedBox(
              width: 72,
              child: Text(
                label,
                style: textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // slider
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: activeColor,
                  thumbColor: activeColor,
                  inactiveTrackColor: scheme.outlineVariant,
                  overlayColor: activeColor.withValues(alpha: 0.18),
                  trackHeight: 3,
                ),
                child: Slider(
                  value: value,
                  onChanged: (v) => notifier.value = v,
                ),
              ),
            ),

            // percentage chip
            SizedBox(
              width: 42,
              child: Text(
                '${(value * 100).round()}%',
                textAlign: TextAlign.end,
                style: textTheme.labelMedium?.copyWith(
                  color: value > 0 ? activeColor : scheme.onSurfaceVariant,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
