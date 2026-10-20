/// Local double-progression rules for per-set suggestions (works offline).
library;

enum ProgressionReason { firstTime, increaseWeight, addReps, repeat, reduceWeight, deload }

class SetSuggestion {
  final double weightKg;
  final int reps;
  final ProgressionReason reason;
  const SetSuggestion(this.weightKg, this.reps, this.reason);

  @override
  String toString() => 'SetSuggestion($weightKg x $reps, $reason)';
}

class LastSet {
  final double weightKg;
  final int reps;
  final double? rpe;
  const LastSet(this.weightKg, this.reps, {this.rpe});
}

class Progression {
  /// Weight increment by equipment (kg).
  static double incrementFor(String? equipment, {bool lowerBody = false}) {
    switch (equipment) {
      case 'barbell':
      case 'e-z curl bar':
        return lowerBody ? 5.0 : 2.5;
      case 'dumbbell':
      case 'kettlebells':
        return 2.0;
      case 'cable':
      case 'machine':
        return lowerBody ? 5.0 : 2.5;
      case 'body only':
        return 0;
      default:
        return 2.5;
    }
  }

  /// Suggests the target for working set [setIndex] (0-based).
  ///
  /// Double progression: when every working set last time hit [repMax] (and the
  /// effort wasn't maximal), add weight and drop back to [repMin]; otherwise keep the
  /// weight and add one rep (capped at [repMax]). Two sessions in a row below
  /// [repMin] → reduce weight ~5%.
  static SetSuggestion suggest({
    required int setIndex,
    required int repMin,
    required int repMax,
    required List<LastSet> lastSession,
    List<LastSet>? sessionBefore,
    double? planWeightKg,
    double increment = 2.5,
    bool deload = false,
  }) {
    if (lastSession.isEmpty) {
      return SetSuggestion(planWeightKg ?? 0, repMin, ProgressionReason.firstTime);
    }
    final ref = setIndex < lastSession.length ? lastSession[setIndex] : lastSession.last;

    if (deload) {
      final w = _round(ref.weightKg * 0.85, increment);
      return SetSuggestion(w, repMin, ProgressionReason.deload);
    }

    final allTop = lastSession.every((s) => s.reps >= repMax);
    final maxEffort = lastSession.any((s) => (s.rpe ?? 0) >= 9.5);
    if (allTop && !maxEffort && increment > 0) {
      final topWeight = lastSession.map((s) => s.weightKg).reduce((a, b) => a > b ? a : b);
      return SetSuggestion(topWeight + increment, repMin, ProgressionReason.increaseWeight);
    }
    if (allTop && increment == 0) {
      // Bodyweight: keep adding reps.
      return SetSuggestion(ref.weightKg, ref.reps + 1, ProgressionReason.addReps);
    }

    bool below(List<LastSet> s) => s.isNotEmpty && s.where((x) => x.reps < repMin).length > s.length / 2;
    if (below(lastSession) && sessionBefore != null && below(sessionBefore)) {
      final w = _round(ref.weightKg * 0.95, increment == 0 ? 0.5 : increment);
      return SetSuggestion(w, repMin, ProgressionReason.reduceWeight);
    }

    if (ref.reps < repMax) {
      final target = ref.reps < repMin ? repMin : ref.reps + 1;
      return SetSuggestion(ref.weightKg, target.clamp(repMin, repMax), ProgressionReason.addReps);
    }
    return SetSuggestion(ref.weightKg, repMax, ProgressionReason.repeat);
  }

  static double _round(double v, double step) {
    if (step <= 0) return v;
    final r = (v / step).round() * step;
    return double.parse(r.toStringAsFixed(2));
  }
}
