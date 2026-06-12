import 'package:flutter/material.dart';

/// One unlockable game tile in the progression lobby carousel.
class LobbyGameEntry {
  const LobbyGameEntry({
    required this.gameId,
    required this.title,
    required this.subtitle,
    required this.unlockLevel,
    required this.routePath,
    required this.icon,
    required this.accent,
    required this.enterLabel,
  });

  final String gameId;
  final String title;
  final String subtitle;
  final int unlockLevel;
  final String routePath;
  final IconData icon;
  final Color accent;
  final String enterLabel;

  bool isUnlockedAt(int playerLevel) => playerLevel >= unlockLevel;

  /// Canonical unlock sequence for Phase 1 (July).
  static const List<LobbyGameEntry> phaseOneSequence = [
    LobbyGameEntry(
      gameId: 'bluff_cup',
      title: "Bluff Cup: Liar's Dice",
      subtitle: 'Bid, catch, reveal — with a blind die.',
      unlockLevel: 1,
      routePath: '/games/bluff_cup/play',
      icon: Icons.casino_outlined,
      accent: Color(0xFF7C3AED),
      enterLabel: 'Enter Match',
    ),
    LobbyGameEntry(
      gameId: 'apex_equation',
      title: 'Apex Equation',
      subtitle: 'Pick three tiles. Hit the target. BODMAS applies.',
      unlockLevel: 3,
      routePath: '/games/apex_equation/mode',
      icon: Icons.calculate_outlined,
      accent: Color(0xFF06B6D4),
      enterLabel: 'Enter Match',
    ),
    LobbyGameEntry(
      gameId: 'match_and_void',
      title: 'Match & Void',
      subtitle: 'Find SET triplets or declare the board empty.',
      unlockLevel: 6,
      routePath: '/games/match_and_void/mode',
      icon: Icons.category_outlined,
      accent: Color(0xFF10B981),
      enterLabel: 'Enter Match',
    ),
    LobbyGameEntry(
      gameId: 'matrix_poker_25',
      title: 'Matrix Poker 25',
      subtitle: 'Draft a 5×5 hand. Score lines. Duel the AI.',
      unlockLevel: 10,
      routePath: '/games/matrix_poker_25/difficulty',
      icon: Icons.grid_4x4,
      accent: Color(0xFFF59E0B),
      enterLabel: 'Enter Match',
    ),
    LobbyGameEntry(
      gameId: 'blind_count_40',
      title: 'Blind Count 40',
      subtitle: 'Memory duel — count hidden blocks, combo guesses, skills.',
      unlockLevel: 15,
      routePath: '/games/blind_count_40/play',
      icon: Icons.grid_view_rounded,
      accent: Color(0xFFEC4899),
      enterLabel: 'Enter Match',
    ),
    LobbyGameEntry(
      gameId: 'blind_bluff_fatal_fold',
      title: 'Blind Bluff: Fatal Fold',
      subtitle: 'Read the card. Pick a skill. Bet, call, or fold.',
      unlockLevel: 20,
      routePath: '/games/blind_bluff_fatal_fold/play',
      icon: Icons.visibility,
      accent: Color(0xFFEF4444),
      enterLabel: 'Enter Match',
    ),
    LobbyGameEntry(
      gameId: 'sniper_poker',
      title: 'Sniper Poker',
      subtitle: 'Flop, river, sniper calls — shotgun hedges the pot.',
      unlockLevel: 25,
      routePath: '/games/sniper_poker/play',
      icon: Icons.gps_fixed,
      accent: Color(0xFF6366F1),
      enterLabel: 'Enter Match',
    ),
  ];
}
