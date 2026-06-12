import 'dart:async';

import 'package:flutter/material.dart';

import 'package:genius_project/core/models/ai_difficulty.dart';
import 'package:genius_project/core/theme/app_theme.dart';
import 'package:genius_project/games/apex_equation/models/apex_game_mode.dart';
import 'package:genius_project/games/apex_equation/ui/apex_game_screen.dart'
    deferred as apex_equation;
import 'package:genius_project/games/apex_equation/ui/apex_mode_selection_screen.dart'
    deferred as apex_equation_hub;
import 'package:genius_project/games/blind_bluff_fatal_fold/ui/blind_bluff_screen.dart'
    deferred as blind_bluff;
import 'package:genius_project/games/blind_count_40/ui/blind_count_screen.dart'
    deferred as blind_count;
import 'package:genius_project/games/bluff_cup/ui/bluff_cup_screen.dart'
    deferred as bluff_cup;
import 'package:genius_project/games/matrix_poker_25/ui/matrix_poker_screen.dart'
    deferred as matrix_poker;
import 'package:genius_project/games/match_and_void/models/match_game_mode.dart';
import 'package:genius_project/games/match_and_void/ui/match_game_screen.dart'
    deferred as match_void;
import 'package:genius_project/games/match_and_void/ui/match_mode_selection_screen.dart'
    deferred as match_void_hub;
import 'package:genius_project/games/sniper_poker/ui/sniper_poker_screen.dart'
    deferred as sniper_poker;

/// Minimal shell shown while a deferred game library loads.
class _DeferredGameLoading extends StatelessWidget {
  const _DeferredGameLoading({this.label = 'Loading game…'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neoBackground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

/// Loads [BluffCupScreen] (Blind Cup: Liar's dice) on demand.
class LazyBluffCupScreen extends StatefulWidget {
  const LazyBluffCupScreen({super.key});

  @override
  State<LazyBluffCupScreen> createState() => _LazyBluffCupScreenState();
}

class _LazyBluffCupScreenState extends State<LazyBluffCupScreen> {
  late final Future<void> _load = bluff_cup.loadLibrary();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _load,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _DeferredGameLoading(
            label: "Loading Blind Cup: Liar's dice…",
          );
        }
        return bluff_cup.BluffCupScreen();
      },
    );
  }
}

/// Loads [BlindCountScreen] on demand.
class LazyBlindCountScreen extends StatefulWidget {
  const LazyBlindCountScreen({super.key});

  @override
  State<LazyBlindCountScreen> createState() => _LazyBlindCountScreenState();
}

class _LazyBlindCountScreenState extends State<LazyBlindCountScreen> {
  late final Future<void> _load = blind_count.loadLibrary();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _load,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _DeferredGameLoading(label: 'Loading Blind Count 40…');
        }
        return blind_count.BlindCountScreen();
      },
    );
  }
}

/// Loads [BlindBluffScreen] on demand so hub navigation stays light.
class LazyBlindBluffScreen extends StatefulWidget {
  const LazyBlindBluffScreen({super.key});

  @override
  State<LazyBlindBluffScreen> createState() => _LazyBlindBluffScreenState();
}

class _LazyBlindBluffScreenState extends State<LazyBlindBluffScreen> {
  late final Future<void> _load = blind_bluff.loadLibrary();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _load,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _DeferredGameLoading(label: 'Loading Blind Bluff…');
        }
        return blind_bluff.BlindBluffScreen();
      },
    );
  }
}

/// Loads [MatrixPokerScreen] on demand.
class LazyMatrixPokerScreen extends StatefulWidget {
  const LazyMatrixPokerScreen({required this.aiDifficulty, super.key});

  final AiDifficulty aiDifficulty;

  @override
  State<LazyMatrixPokerScreen> createState() => _LazyMatrixPokerScreenState();
}

class _LazyMatrixPokerScreenState extends State<LazyMatrixPokerScreen> {
  late final Future<void> _load = matrix_poker.loadLibrary();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _load,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _DeferredGameLoading(label: 'Loading Matrix Poker…');
        }
        return matrix_poker.MatrixPokerScreen(
          aiDifficulty: widget.aiDifficulty,
        );
      },
    );
  }
}

/// Loads Match & Void mode picker on demand.
class LazyMatchModeSelectionScreen extends StatefulWidget {
  const LazyMatchModeSelectionScreen({super.key});

  @override
  State<LazyMatchModeSelectionScreen> createState() =>
      _LazyMatchModeSelectionScreenState();
}

class _LazyMatchModeSelectionScreenState
    extends State<LazyMatchModeSelectionScreen> {
  late final Future<void> _load = match_void_hub.loadLibrary();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _load,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _DeferredGameLoading(label: 'Loading Match & Void…');
        }
        return match_void_hub.MatchModeSelectionScreen();
      },
    );
  }
}

/// Loads [MatchGameScreen] on demand. [modeName] is `arena` or `countdown`.
class LazyMatchGameScreen extends StatefulWidget {
  const LazyMatchGameScreen({required this.modeName, super.key});

  final String modeName;

  @override
  State<LazyMatchGameScreen> createState() => _LazyMatchGameScreenState();
}

class _LazyMatchGameScreenState extends State<LazyMatchGameScreen> {
  late final Future<void> _load = match_void.loadLibrary();

  MatchGameMode get _mode => widget.modeName == 'countdown'
      ? MatchGameMode.countdown
      : MatchGameMode.arena;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _load,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _DeferredGameLoading(label: 'Loading Match & Void…');
        }
        return match_void.MatchGameScreen(mode: _mode);
      },
    );
  }
}

/// Loads Apex Equation mode picker on demand.
class LazyApexModeSelectionScreen extends StatefulWidget {
  const LazyApexModeSelectionScreen({super.key});

  @override
  State<LazyApexModeSelectionScreen> createState() =>
      _LazyApexModeSelectionScreenState();
}

class _LazyApexModeSelectionScreenState extends State<LazyApexModeSelectionScreen> {
  late final Future<void> _load = apex_equation_hub.loadLibrary();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _load,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _DeferredGameLoading(label: 'Loading Apex Equation…');
        }
        return apex_equation_hub.ApexModeSelectionScreen();
      },
    );
  }
}

/// Loads [ApexGameScreen] on demand. [modeName] is `arena` or `countdown`.
class LazyApexGameScreen extends StatefulWidget {
  const LazyApexGameScreen({required this.modeName, super.key});

  final String modeName;

  @override
  State<LazyApexGameScreen> createState() => _LazyApexGameScreenState();
}

class _LazyApexGameScreenState extends State<LazyApexGameScreen> {
  late final Future<void> _load = apex_equation.loadLibrary();

  ApexGameMode get _mode => widget.modeName == 'countdown'
      ? ApexGameMode.countdown
      : ApexGameMode.arena;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _load,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _DeferredGameLoading(label: 'Loading Apex Equation…');
        }
        return apex_equation.ApexGameScreen(mode: _mode);
      },
    );
  }
}

/// Loads [SniperPokerScreen] on demand.
class LazySniperPokerScreen extends StatefulWidget {
  const LazySniperPokerScreen({super.key});

  @override
  State<LazySniperPokerScreen> createState() => _LazySniperPokerScreenState();
}

class _LazySniperPokerScreenState extends State<LazySniperPokerScreen> {
  late final Future<void> _load = sniper_poker.loadLibrary();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _load,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _DeferredGameLoading(label: 'Loading Sniper Poker…');
        }
        return sniper_poker.SniperPokerScreen();
      },
    );
  }
}
