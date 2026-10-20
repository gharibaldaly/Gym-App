/// Small statistics helpers (moving average, cardio calories).
library;

class DatedValue {
  final DateTime date;
  final double value;
  const DatedValue(this.date, this.value);
}

class Stats {
  /// Trailing moving average over [days] calendar days (inclusive) for each point.
  static List<DatedValue> movingAverage(List<DatedValue> points, {int days = 7}) {
    final sorted = [...points]..sort((a, b) => a.date.compareTo(b.date));
    final out = <DatedValue>[];
    for (final p in sorted) {
      final from = p.date.subtract(Duration(days: days - 1));
      final window = sorted.where((q) => !q.date.isBefore(_day(from)) && !q.date.isAfter(p.date));
      final avg = window.fold(0.0, (s, q) => s + q.value) / window.length;
      out.add(DatedValue(p.date, avg));
    }
    return out;
  }

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  static double? mean(Iterable<double> v) => v.isEmpty ? null : v.reduce((a, b) => a + b) / v.length;
}

/// MET-based calorie estimate: kcal = MET × 3.5 × kg / 200 × minutes.
class CardioCalc {
  static double met(String type, {double? speedKmh, double? inclinePct, int? level}) {
    switch (type) {
      case 'treadmill':
      case 'run':
      case 'walk':
        final s = speedKmh ?? (type == 'run' ? 9 : 5);
        // ACSM walking/running equations → VO2 (ml/kg/min) → MET.
        final mPerMin = s * 1000 / 60;
        final grade = (inclinePct ?? 0) / 100;
        final vo2 = s < 7.5
            ? 3.5 + 0.1 * mPerMin + 1.8 * mPerMin * grade
            : 3.5 + 0.2 * mPerMin + 0.9 * mPerMin * grade;
        return vo2 / 3.5;
      case 'bike':
        return 4.0 + (level ?? 5) * 0.5;
      case 'elliptical':
        return 4.5 + (level ?? 5) * 0.3;
      case 'rowing':
        return 5.0 + (level ?? 5) * 0.4;
      case 'stairs':
        return 7.0 + (level ?? 5) * 0.4;
      case 'jump_rope':
        return 11.0;
      case 'swim':
        return 7.0;
      default:
        return 5.0;
    }
  }

  static double calories({
    required String type,
    required double minutes,
    required double weightKg,
    double? speedKmh,
    double? inclinePct,
    int? level,
  }) {
    final m = met(type, speedKmh: speedKmh, inclinePct: inclinePct, level: level);
    return m * 3.5 * weightKg / 200 * minutes;
  }
}
