import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/ai_difficulty.dart';
import '../ui/difficulty_selection_screen.dart';
import '../ui/game_selection_screen.dart';
import '../ui/mode_selection_screen.dart';
import '../../games/matrix_poker_25/ui/matrix_poker_screen.dart';

AiDifficulty _parseDifficulty(String raw) {
  for (final d in AiDifficulty.values) {
    if (d.name == raw) return d;
  }
  return AiDifficulty.easy;
}

/// Global router for the Genius Project hub app.
final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const ModeSelectionScreen(),
    ),
    GoRoute(
      path: '/games',
      builder: (context, state) => const GameSelectionScreen(),
    ),
    GoRoute(
      path: '/games/:gameId/difficulty',
      builder: (context, state) {
        final gameId = state.pathParameters['gameId']!;
        return DifficultySelectionScreen(gameId: gameId);
      },
    ),
    GoRoute(
      path: '/play/:gameId/:difficulty',
      builder: (context, state) {
        final gameId = state.pathParameters['gameId']!;
        final raw = state.pathParameters['difficulty']!;
        final difficulty = _parseDifficulty(raw);

        switch (gameId) {
          case 'matrix_poker_25':
            return MatrixPokerScreen(aiDifficulty: difficulty);
          default:
            return _UnknownGameScreen(gameId: gameId);
        }
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('Navigation error'),
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No route match for: ${state.uri}\n\n${state.error}',
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ),
);

class _UnknownGameScreen extends StatelessWidget {
  const _UnknownGameScreen({required this.gameId});

  final String gameId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unknown game')),
      body: Center(
        child: Text('No game registered for gameId: $gameId'),
      ),
    );
  }
}

