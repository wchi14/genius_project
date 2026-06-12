import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'adaptive_layout.dart';
import 'hub_scaffold.dart';

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HubScaffold(
      title: 'Games',
      subtitle: 'Pick something to play',
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = AdaptiveLayout.hubWideLayout(constraints.maxWidth, context);
          final gap = AdaptiveLayout.hubSectionGap(context);
          final tileWidth = wide
              ? (constraints.maxWidth - gap) / 2
              : constraints.maxWidth;

          final tiles = <Widget>[
            _GameTile(
              title: 'Matrix Poker 25',
              subtitle: 'Draft a 5×5 hand. Score lines. Duel the AI.',
              icon: Icons.grid_4x4,
              cta: 'Choose difficulty',
              onTap: () => context.push('/games/matrix_poker_25/difficulty'),
            ),
            _GameTile(
              title: 'Blind Bluff: Fatal Fold',
              subtitle: 'Read the card. Pick a skill. Bet, call, or fold.',
              icon: Icons.visibility,
              cta: 'Play now',
              onTap: () => context.push('/games/blind_bluff_fatal_fold/play'),
            ),
            _GameTile(
              title: 'Blind Count 40',
              subtitle: 'Memory duel — count hidden blocks, combo guesses, skills.',
              icon: Icons.grid_view_rounded,
              cta: 'Play now',
              onTap: () => context.push('/games/blind_count_40/play'),
            ),
            _GameTile(
              title: "Blind Cup: Liar's dice",
              subtitle: 'Bid, catch, reveal — with a blind die.',
              icon: Icons.casino_outlined,
              cta: 'Play now',
              onTap: () => context.push('/games/bluff_cup/play'),
            ),
            _GameTile(
              title: 'Match & Void',
              subtitle: 'Find SET triplets or declare the board empty.',
              icon: Icons.category_outlined,
              cta: 'Choose mode',
              onTap: () => context.push('/games/match_and_void/mode'),
            ),
            _GameTile(
              title: 'Apex Equation',
              subtitle: 'Pick three tiles. Hit the target. BODMAS applies.',
              icon: Icons.calculate_outlined,
              cta: 'Choose mode',
              onTap: () => context.push('/games/apex_equation/mode'),
            ),
            _GameTile(
              title: 'Sniper Poker',
              subtitle: 'Flop, river, sniper calls — shotgun hedges the pot.',
              icon: Icons.gps_fixed,
              cta: 'Play now',
              onTap: () => context.push('/games/sniper_poker/play'),
            ),
          ];

          if (wide) {
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final tile in tiles)
                  SizedBox(width: tileWidth, child: tile),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < tiles.length; i++) ...[
                if (i > 0) SizedBox(height: gap),
                tiles[i],
              ],
            ],
          );
        },
      ),
    );
  }
}

class _GameTile extends StatelessWidget {
  const _GameTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cta,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String cta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pad = AdaptiveLayout.hubCardPadding(context);
    final iconExtent = AdaptiveLayout.hubIconExtent(context);
    final iconRadius = AdaptiveLayout.hubIconRadius(context);
    final inlineGap = AdaptiveLayout.hubInlineGap(context);
    final sectionGap = AdaptiveLayout.hubSectionGap(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: pad,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: iconExtent,
                    height: iconExtent,
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(iconRadius),
                    ),
                    child: Icon(icon, color: scheme.primary),
                  ),
                  SizedBox(width: inlineGap),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: sectionGap * 0.7),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.2,
                    ),
              ),
              SizedBox(height: sectionGap),
              FilledButton.tonal(
                onPressed: onTap,
                child: Text(
                  cta,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

