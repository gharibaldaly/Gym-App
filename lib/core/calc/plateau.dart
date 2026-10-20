/// Rule-based plateau detection (no AI). The AI is only asked to explain it.
library;

class SessionBest {
  final DateTime date;

  /// Best estimated 1RM among working sets of that session.
  final double bestE1rm;
  const SessionBest(this.date, this.bestE1rm);
}

class PlateauDetector {
  /// True when each of the last [window] sessions failed to beat the best e1RM
  /// achieved before them (by more than [tolerance], e.g. 0.005 = 0.5%).
  /// Needs at least window + 1 sessions.
  static bool isPlateau(List<SessionBest> sessions, {int window = 3, double tolerance = 0.005}) {
    if (sessions.length < window + 1) return false;
    final sorted = [...sessions]..sort((a, b) => a.date.compareTo(b.date));
    final before = sorted.sublist(0, sorted.length - window);
    final recent = sorted.sublist(sorted.length - window);
    final bestBefore = before.map((s) => s.bestE1rm).reduce((a, b) => a > b ? a : b);
    if (bestBefore <= 0) return false;
    return recent.every((s) => s.bestE1rm <= bestBefore * (1 + tolerance));
  }
}
