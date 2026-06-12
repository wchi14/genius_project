import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:genius_project/core/services/audio_haptic_service.dart';
import 'package:genius_project/core/theme/app_theme.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/core/ui/audio_settings_sheet.dart';
import 'package:genius_project/lobby/models/lobby_game_entry.dart';
import 'package:genius_project/lobby/models/player_progression.dart';

/// Horizontal progression lobby: unlockable game carousel + meta HUD.
///
/// Lifecycle:
/// - [initState] → [AudioHapticService.playLobbyBGM] (randomly picks a track).
/// - [dispose]   → [AudioHapticService.stopBGM]      (1-second fade out).
class ProgressionLobbyScreen extends StatefulWidget {
  ProgressionLobbyScreen({
    super.key,
    PlayerProgression? progression,
  }) : progression = progression ?? PlayerProgression.demo();

  final PlayerProgression progression;

  @override
  State<ProgressionLobbyScreen> createState() => _ProgressionLobbyScreenState();
}

class _ProgressionLobbyScreenState extends State<ProgressionLobbyScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(AudioHapticService.instance.playLobbyBGM());
  }

  @override
  void dispose() {
    unawaited(AudioHapticService.instance.stopBGM());
    super.dispose();
  }

  void _showTokenDialog() {
    unawaited(AudioHapticService.instance.triggerLightTap());
    showDialog<void>(
      context: context,
      builder: (_) => _TokenRegenerationDialog(progression: widget.progression),
    );
  }

  void _showAudioSettings() {
    unawaited(AudioHapticService.instance.triggerLightTap());
    AudioSettingsSheet.show(context);
  }

  void _openAbout() {
    unawaited(AudioHapticService.instance.triggerLightTap());
    context.push('/about');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pad = AdaptiveLayout.lobbyScreenPadding(context);
    final gap = AdaptiveLayout.lobbySectionGap(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Genius Project'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Audio Settings',
            onPressed: _showAudioSettings,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'About & Credits',
            onPressed: _openAbout,
          ),
          SizedBox(width: AdaptiveLayout.lobbyInlineGap(context) * 0.5),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.surface,
              Color.alphaBlend(
                scheme.primary.withValues(alpha: 0.14),
                scheme.surface,
              ),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: pad,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LobbyHud(
                  progression: widget.progression,
                  onTokenTap: _showTokenDialog,
                  onSettingsTap: _showAudioSettings,
                ),
                SizedBox(height: gap),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth =
                          AdaptiveLayout.lobbyGameCardWidth(context, constraints);
                      final cardGap = AdaptiveLayout.lobbyCardGap(context);
                      final listPad = AdaptiveLayout.lobbyListPadding(context);

                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: listPad,
                        itemCount: LobbyGameEntry.phaseOneSequence.length,
                        separatorBuilder: (_, __) => SizedBox(width: cardGap),
                        itemBuilder: (context, index) {
                          final entry = LobbyGameEntry.phaseOneSequence[index];
                          final unlocked =
                              entry.isUnlockedAt(widget.progression.level);
                          return SizedBox(
                            width: cardWidth,
                            child: _LobbyGameCard(
                              entry: entry,
                              unlocked: unlocked,
                              onEnter: unlocked
                                  ? () {
                                      unawaited(
                                        AudioHapticService.instance.triggerSuccessBuzz(),
                                      );
                                      unawaited(
                                        AudioHapticService.instance.playInGameBGM(
                                          gameId: entry.gameId,
                                        ),
                                      );
                                      context.push(entry.routePath);
                                    }
                                  : null,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LobbyHud extends StatelessWidget {
  const _LobbyHud({
    required this.progression,
    required this.onTokenTap,
    required this.onSettingsTap,
  });

  final PlayerProgression progression;
  final VoidCallback onTokenTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gap = AdaptiveLayout.lobbyInlineGap(context);
    final barHeight = AdaptiveLayout.lobbyXpBarHeight(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth <
            AdaptiveLayout.lobbyHudCompactBreakpoint(context);

        final levelChip = _HudStatChip(
          icon: Icons.military_tech_outlined,
          label: 'Lv. ${progression.level}',
          accent: AppTheme.neoGold,
        );
        final chipsChip = _HudStatChip(
          icon: Icons.paid_outlined,
          label: _formatChips(progression.chips),
          accent: scheme.secondary,
        );
        final tokenButton = _TokenHudButton(
          tokens: progression.tokens,
          maxTokens: progression.maxTokens,
          onTap: onTokenTap,
        );
        final settingsButton = _HudIconButton(
          icon: Icons.tune_rounded,
          tooltip: 'Audio settings',
          onTap: onSettingsTap,
        );

        final xpBar = Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'XP',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  SizedBox(width: gap * 0.5),
                  Text(
                    '${progression.xp} / ${progression.xpForNextLevel}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              SizedBox(height: gap * 0.35),
              ClipRRect(
                borderRadius: BorderRadius.circular(barHeight),
                child: LinearProgressIndicator(
                  value: progression.xpProgress,
                  minHeight: barHeight,
                  backgroundColor: scheme.surfaceContainerHighest,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  levelChip,
                  SizedBox(width: gap),
                  chipsChip,
                  const Spacer(),
                  tokenButton,
                  SizedBox(width: gap * 0.6),
                  settingsButton,
                ],
              ),
              SizedBox(height: gap),
              xpBar,
            ],
          );
        }

        return Row(
          children: [
            levelChip,
            SizedBox(width: gap),
            chipsChip,
            SizedBox(width: gap * 1.4),
            xpBar,
            SizedBox(width: gap * 1.4),
            tokenButton,
            SizedBox(width: gap * 0.6),
            settingsButton,
          ],
        );
      },
    );
  }

  String _formatChips(int chips) {
    if (chips >= 1000) {
      final k = chips / 1000;
      return k >= 10 ? '${k.round()}K' : '${k.toStringAsFixed(1)}K';
    }
    return chips.toString();
  }
}

class _HudStatChip extends StatelessWidget {
  const _HudStatChip({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final pad = AdaptiveLayout.lobbyHudChipPadding(context);
    final iconSize = AdaptiveLayout.lobbyHudIconSize(context);
    final gap = AdaptiveLayout.lobbyInlineGap(context);
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: pad,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AdaptiveLayout.lobbyHudChipRadius(context)),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: accent),
          SizedBox(width: gap * 0.6),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

class _HudIconButton extends StatelessWidget {
  const _HudIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pad = AdaptiveLayout.lobbyHudChipPadding(context);
    final iconSize = AdaptiveLayout.lobbyHudIconSize(context);
    final scheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: scheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdaptiveLayout.lobbyHudChipRadius(context)),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: pad,
            child: Icon(icon, size: iconSize, color: scheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

class _TokenHudButton extends StatelessWidget {
  const _TokenHudButton({
    required this.tokens,
    required this.maxTokens,
    required this.onTap,
  });

  final int tokens;
  final int maxTokens;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pad = AdaptiveLayout.lobbyHudChipPadding(context);
    final iconSize = AdaptiveLayout.lobbyHudIconSize(context);
    final gap = AdaptiveLayout.lobbyInlineGap(context);
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AdaptiveLayout.lobbyHudChipRadius(context)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: pad,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.generating_tokens, size: iconSize, color: scheme.primary),
              SizedBox(width: gap * 0.6),
              Text(
                '$tokens/$maxTokens',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TokenRegenerationDialog extends StatefulWidget {
  const _TokenRegenerationDialog({required this.progression});

  final PlayerProgression progression;

  @override
  State<_TokenRegenerationDialog> createState() => _TokenRegenerationDialogState();
}

class _TokenRegenerationDialogState extends State<_TokenRegenerationDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatRemaining(Duration remaining) {
    if (remaining.isNegative || remaining.inSeconds <= 0) {
      return '00:00';
    }
    final totalSeconds = remaining.inSeconds;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final pad = AdaptiveLayout.panelPadding(context);
    final progression = widget.progression;

    final bodyText = progression.tokensFull
        ? 'Tokens full (${progression.maxTokens}/${progression.maxTokens}).'
        : progression.nextTokenRegeneratesAt == null
            ? 'Next token timing unavailable.'
            : 'Next token in ${_formatRemaining(progression.nextTokenRegeneratesAt!.difference(DateTime.now()))}';

    return Dialog(
      child: Padding(
        padding: pad,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.generating_tokens,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: AdaptiveLayout.lobbyInlineGap(context)),
                Text('Tokens', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            SizedBox(height: AdaptiveLayout.lobbySectionGap(context) * 0.6),
            Text(
              '${progression.tokens}/${progression.maxTokens} available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: AdaptiveLayout.lobbyInlineGap(context) * 0.5),
            Text(
              bodyText,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            SizedBox(height: AdaptiveLayout.lobbySectionGap(context)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LobbyGameCard extends StatelessWidget {
  const _LobbyGameCard({
    required this.entry,
    required this.unlocked,
    required this.onEnter,
  });

  final LobbyGameEntry entry;
  final bool unlocked;
  final VoidCallback? onEnter;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pad = AdaptiveLayout.lobbyCardPadding(context);
    final iconExtent = AdaptiveLayout.lobbyGameCardIconExtent(context);
    final gap = AdaptiveLayout.lobbySectionGap(context);
    final radius = AdaptiveLayout.lobbyGameCardRadius(context);

    Widget cardBody = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: unlocked
              ? [
                  entry.accent.withValues(alpha: 0.55),
                  scheme.surfaceContainerHigh,
                ]
              : [
                  scheme.surfaceContainerHighest,
                  scheme.surfaceContainerHigh,
                ],
        ),
        border: Border.all(
          color: unlocked
              ? entry.accent.withValues(alpha: 0.65)
              : scheme.outlineVariant,
        ),
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: entry.accent.withValues(alpha: 0.28),
                  blurRadius: AdaptiveLayout.lobbyCardShadowBlur(context),
                  offset: Offset(0, AdaptiveLayout.lobbyCardShadowOffset(context)),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: pad,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: iconExtent,
              height: iconExtent,
              decoration: BoxDecoration(
                color: unlocked
                    ? entry.accent.withValues(alpha: 0.22)
                    : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(iconExtent * 0.22),
              ),
              child: Icon(
                entry.icon,
                size: iconExtent * 0.52,
                color: unlocked ? entry.accent : scheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: gap),
            Text(
              entry.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: unlocked ? scheme.onSurface : scheme.onSurfaceVariant,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: gap * 0.45),
            Text(
              entry.subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.25,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (unlocked)
              FilledButton(
                onPressed: onEnter,
                child: Text(entry.enterLabel),
              )
            else
              Text(
                'Unlocks at Lv. ${entry.unlockLevel}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
          ],
        ),
      ),
    );

    if (!unlocked) {
      cardBody = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child: cardBody,
      );
      cardBody = Stack(
        fit: StackFit.expand,
        children: [
          cardBody,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: Colors.black.withValues(alpha: 0.42),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: AdaptiveLayout.lobbyLockIconSize(context),
                  color: scheme.onSurface.withValues(alpha: 0.85),
                ),
                SizedBox(height: gap * 0.4),
                Text(
                  'Unlocks at Lv. ${entry.unlockLevel}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.9),
                      ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return cardBody;
  }
}
