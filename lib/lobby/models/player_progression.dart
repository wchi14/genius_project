/// Player meta-progression shown in the progression lobby HUD.
class PlayerProgression {
  const PlayerProgression({
    required this.level,
    required this.xp,
    required this.xpForNextLevel,
    required this.chips,
    required this.tokens,
    this.maxTokens = 10,
    this.nextTokenRegeneratesAt,
  });

  final int level;
  final int xp;
  final int xpForNextLevel;
  final int chips;
  final int tokens;
  final int maxTokens;

  /// When the next token will be granted; `null` when at [maxTokens].
  final DateTime? nextTokenRegeneratesAt;

  double get xpProgress {
    if (xpForNextLevel <= 0) {
      return 1;
    }
    return (xp / xpForNextLevel).clamp(0.0, 1.0);
  }

  bool get tokensFull => tokens >= maxTokens;

  /// Demo profile for lobby previews and local development.
  static PlayerProgression demo() {
    return PlayerProgression(
      level: 8,
      xp: 420,
      xpForNextLevel: 600,
      chips: 12450,
      tokens: 7,
      nextTokenRegeneratesAt: DateTime.now().add(const Duration(minutes: 24, seconds: 15)),
    );
  }
}
