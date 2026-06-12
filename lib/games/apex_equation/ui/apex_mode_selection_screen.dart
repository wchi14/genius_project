import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/core/ui/hub_scaffold.dart';

/// Hub step: pick Arena or Countdown before play.
class ApexModeSelectionScreen extends StatelessWidget {
  const ApexModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.hubSectionGap(context);
    final cardPad = AdaptiveLayout.hubCardPadding(context);
    return HubScaffold(
      title: 'Apex Equation',
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
                    'Clear 15 levels. One point per solve; five wrong tries auto-skip.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: gap),
                  FilledButton(
                    onPressed: () =>
                        context.push('/games/apex_equation/play/arena'),
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
                    '60 seconds on the clock. Correct solves add time by level band.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: gap),
                  FilledButton(
                    onPressed: () =>
                        context.push('/games/apex_equation/play/countdown'),
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
