import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/core/ui/hub_scaffold.dart';

/// Hub step: pick Arena or Countdown before play.
class MatchModeSelectionScreen extends StatelessWidget {
  const MatchModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.hubSectionGap(context);
    final cardPad = AdaptiveLayout.hubCardPadding(context);
    return HubScaffold(
      title: 'Match & Void',
      subtitle: 'Choose a ruleset',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: cardPad,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Arena',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: gap * 0.5),
                  Text(
                    'Clear 10 boards. Score matches and voids; bad voids escalate penalties.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: gap),
                  FilledButton(
                    onPressed: () =>
                        context.push('/games/match_and_void/play/arena'),
                    child: const Text('Play Arena'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: gap),
          Card(
            child: Padding(
              padding: cardPad,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Countdown',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: gap * 0.5),
                  Text(
                    '90 seconds on the clock. Boards 1–5: +15s per match, +30s per void. '
                    'Boards 6–10: +10s / +25s. Board 11+: +10s / +20s. '
                    'Wrong picks cost 3s; wrong voids cost 5s.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: gap),
                  FilledButton(
                    onPressed: () =>
                        context.push('/games/match_and_void/play/countdown'),
                    child: const Text('Play Countdown'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
