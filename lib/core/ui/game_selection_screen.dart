import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a game')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Available games',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => context.push('/games/matrix_poker_25/difficulty'),
              child: const Text('Matrix Poker 25'),
            ),
          ],
        ),
      ),
    );
  }
}

