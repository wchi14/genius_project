import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'adaptive_layout.dart';
import 'hub_scaffold.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.hubSectionGap(context);
    final cardPad = AdaptiveLayout.hubCardPadding(context);
    return HubScaffold(
      title: 'Genius Project',
      subtitle: 'Choose a mode',
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
                    'Single player',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: gap * 0.55),
                  Text(
                    'Pick a game and an AI difficulty.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: gap),
                  FilledButton(
                    onPressed: () => context.push('/games'),
                    child: const Text('Browse games'),
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
                    'Online',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: gap * 0.55),
                  Text(
                    'Multiplayer mode is planned for a later phase.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: gap),
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming Phase 4')),
                      );
                    },
                    child: const Text('Coming soon'),
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
