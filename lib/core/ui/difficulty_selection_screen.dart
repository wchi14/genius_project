import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/ai_difficulty.dart';
import 'adaptive_layout.dart';
import 'hub_scaffold.dart';

class DifficultySelectionScreen extends StatelessWidget {
  const DifficultySelectionScreen({
    super.key,
    required this.gameId,
  });

  final String gameId;

  void _go(BuildContext context, AiDifficulty d) {
    // Push avoids resetting the hub stack (go() can hitch on slow emulators).
    context.push('/play/$gameId/${d.name}');
  }

  @override
  Widget build(BuildContext context) {
    return HubScaffold(
      title: 'Difficulty',
      subtitle: 'Choose the AI',
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = AdaptiveLayout.hubWideLayout(constraints.maxWidth, context);
          final gap = AdaptiveLayout.hubSectionGap(context);
          final pad = AdaptiveLayout.hubCardPadding(context);

          Widget card({
            required String title,
            required String subtitle,
            required VoidCallback onTap,
            required Widget button,
          }) {
            return Card(
              child: Padding(
                padding: pad,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(height: gap * 0.55),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.2,
                          ),
                    ),
                    SizedBox(height: gap),
                    button,
                  ],
                ),
              ),
            );
          }

          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              SizedBox(
                width: wide
                    ? (constraints.maxWidth - gap * 2) / 3
                    : double.infinity,
                child: card(
                  title: 'Easy',
                  subtitle: 'Learn the flow and experiment with skills.',
                  onTap: () => _go(context, AiDifficulty.easy),
                  button: FilledButton.tonal(
                    onPressed: () => _go(context, AiDifficulty.easy),
                    child: const Text(
                      'Play easy',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: wide
                    ? (constraints.maxWidth - gap * 2) / 3
                    : double.infinity,
                child: card(
                  title: 'Normal',
                  subtitle: 'Balanced risk/reward. The intended baseline.',
                  onTap: () => _go(context, AiDifficulty.normal),
                  button: FilledButton(
                    onPressed: () => _go(context, AiDifficulty.normal),
                    child: const Text(
                      'Play normal',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: wide
                    ? (constraints.maxWidth - gap * 2) / 3
                    : double.infinity,
                child: card(
                  title: 'Hard',
                  subtitle: 'Tighter play and higher pressure.',
                  onTap: () => _go(context, AiDifficulty.hard),
                  button: OutlinedButton(
                    onPressed: () => _go(context, AiDifficulty.hard),
                    child: const Text(
                      'Play hard',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

