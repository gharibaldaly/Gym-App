/// 1RM estimation, volume and PR detection.
library;

class StrengthCalc {
  /// Epley: 1RM = w × (1 + reps/30). 1 rep → the weight itself.
  static double epley1Rm(double weightKg, int reps) {
    if (reps <= 0 || weightKg <= 0) return 0;
    if (reps == 1) return weightKg;
    return weightKg * (1 + reps / 30.0);
  }

  static double volume(Iterable<({double weight, int reps})> sets) =>
      sets.fold(0.0, (s, e) => s + e.weight * e.reps);

  static double roundTo(double v, double step) => (v / step).round() * step;
}

/// A previously logged set used for PR comparison.
class HistSet {
  final double weightKg;
  final int reps;
  const HistSet(this.weightKg, this.reps);
}

enum PrType { weight, reps, e1rm }

class PrDetector {
  /// Returns which PRs a new set breaks compared with all previous (non-warmup) sets
  /// for the same exercise. No history → no PR (first time isn't a record).
  static Set<PrType> detect({
    required double weightKg,
    required int reps,
    required List<HistSet> history,
  }) {
    if (history.isEmpty || reps <= 0) return {};
    final result = <PrType>{};
    final maxWeight = history.map((h) => h.weightKg).reduce((a, b) => a > b ? a : b);
    if (weightKg > maxWeight) result.add(PrType.weight);

    final sameWeight = history.where((h) => (h.weightKg - weightKg).abs() < 0.01);
    if (sameWeight.isNotEmpty) {
      final maxReps = sameWeight.map((h) => h.reps).reduce((a, b) => a > b ? a : b);
      if (reps > maxReps) result.add(PrType.reps);
    }

    final best = history.map((h) => StrengthCalc.epley1Rm(h.weightKg, h.reps)).reduce((a, b) => a > b ? a : b);
    if (StrengthCalc.epley1Rm(weightKg, reps) > best + 0.01) result.add(PrType.e1rm);
    return result;
  }
}
