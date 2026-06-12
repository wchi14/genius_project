import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../lobby/ui/progression_lobby_screen.dart';
import '../models/ai_difficulty.dart';
import '../ui/about_credits_screen.dart';
import '../ui/difficulty_selection_screen.dart';
import '../ui/game_selection_screen.dart';
import '../ui/mode_selection_screen.dart';
import 'lazy_game_screens.dart';

AiDifficulty _parseDifficulty(String raw) {
  for (final d in AiDifficulty.values) {
    if (d.name == raw) return d;
  }
  return AiDifficulty.easy;
}

/// Hub router. Game play screens load via deferred imports in [lazy_game_screens.dart].
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const ModeSelectionScreen(),
      ),
      GoRoute(
        path: '/lobby',
        builder: (context, state) => ProgressionLobbyScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutCreditsScreen(),
      ),
      GoRoute(
        path: '/games',
        builder: (context, state) => const GameSelectionScreen(),
        routes: <RouteBase>[
          // Specific paths before :gameId catch-all.
          GoRoute(
            path: 'blind_bluff_fatal_fold/play',
            builder: (context, state) => const LazyBlindBluffScreen(),
          ),
          GoRoute(
            path: 'blind_count_40/play',
            builder: (context, state) => const LazyBlindCountScreen(),
          ),
          GoRoute(
            path: 'bluff_cup/play',
            builder: (context, state) => const LazyBluffCupScreen(),
          ),
          GoRoute(
            path: 'sniper_poker/play',
            builder: (context, state) => const LazySniperPokerScreen(),
          ),
          GoRoute(
            path: 'match_and_void/mode',
            builder: (context, state) => const LazyMatchModeSelectionScreen(),
          ),
          GoRoute(
            path: 'match_and_void/play/:mode',
            builder: (context, state) {
              final raw = state.pathParameters['mode']!;
              return LazyMatchGameScreen(modeName: raw);
            },
          ),
          GoRoute(
            path: 'apex_equation/mode',
            builder: (context, state) => const LazyApexModeSelectionScreen(),
          ),
          GoRoute(
            path: 'apex_equation/play/:mode',
            builder: (context, state) {
              final raw = state.pathParameters['mode']!;
              return LazyApexGameScreen(modeName: raw);
            },
          ),
          GoRoute(
            path: ':gameId/difficulty',
            builder: (context, state) {
              final gameId = state.pathParameters['gameId']!;
              return DifficultySelectionScreen(gameId: gameId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/play/:gameId/:difficulty',
        builder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          final raw = state.pathParameters['difficulty']!;
          final difficulty = _parseDifficulty(raw);

          switch (gameId) {
            case 'matrix_poker_25':
              return LazyMatrixPokerScreen(aiDifficulty: difficulty);
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
}

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
