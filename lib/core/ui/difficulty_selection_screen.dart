import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/ai_difficulty.dart';

class DifficultySelectionScreen extends StatelessWidget {
  const DifficultySelectionScreen({
    super.key,
    required this.gameId,
  });

  final String gameId;

  void _go(BuildContext context, AiDifficulty d) {
    context.go('/play/$gameId/${d.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select difficulty')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'AI difficulty',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => _go(context, AiDifficulty.easy),
              child: const Text('Easy'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () => _go(context, AiDifficulty.normal),
              child: const Text('Normal'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => _go(context, AiDifficulty.hard),
              child: const Text('Hard'),
            ),
          ],
        ),
      ),
    );
  }
}

