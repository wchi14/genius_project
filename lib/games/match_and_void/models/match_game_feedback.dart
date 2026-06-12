/// Why a penalty was applied (wrong match vs wrong void).
enum MatchGameFeedbackKind {
  wrongMatch,
  wrongVoid,
}

/// One-shot UI payload for a penalty dialog.
class MatchGameFeedback {
  const MatchGameFeedback({
    required this.kind,
    required this.title,
    required this.body,
    required this.penaltySummary,
  });

  final MatchGameFeedbackKind kind;
  final String title;
  final String body;

  /// e.g. "−1 pt" or "−3s"
  final String penaltySummary;
}
