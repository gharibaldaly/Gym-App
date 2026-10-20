/// Daily recovery score (0-100) from sleep + HRV + resting HR vs the user's baseline.
library;

class RecoveryInput {
  final int? sleepMin;
  final int? sleepQuality; // 1-5 (manual)
  final double? hrv;
  final double? hrvBaseline;
  final double? restingHr;
  final double? restingHrBaseline;
  final int sleepNeedMin;
  const RecoveryInput({
    this.sleepMin,
    this.sleepQuality,
    this.hrv,
    this.hrvBaseline,
    this.restingHr,
    this.restingHrBaseline,
    this.sleepNeedMin = 480,
  });
}

enum RecoveryLevel { low, moderate, high }

class RecoveryCalc {
  static double _clamp(double v) => v.clamp(0.0, 100.0);

  /// Returns null when there is no data at all.
  static int? score(RecoveryInput i) {
    final parts = <(double score, double weight)>[];

    if (i.sleepMin != null) {
      var s = _clamp(i.sleepMin! / i.sleepNeedMin * 100);
      if (i.sleepQuality != null) {
        final q = (i.sleepQuality!.clamp(1, 5) - 1) / 4 * 100;
        s = s * 0.7 + q * 0.3;
      }
      parts.add((s, 0.4));
    } else if (i.sleepQuality != null) {
      parts.add(((i.sleepQuality!.clamp(1, 5) - 1) / 4 * 100, 0.3));
    }

    if (i.hrv != null && i.hrvBaseline != null && i.hrvBaseline! > 0) {
      final ratio = i.hrv! / i.hrvBaseline!;
      parts.add((_clamp(50 + (ratio - 1) * 250), 0.35));
    }

    if (i.restingHr != null && i.restingHrBaseline != null && i.restingHrBaseline! > 0) {
      final diff = i.restingHrBaseline! - i.restingHr!;
      parts.add((_clamp(50 + diff * 10), 0.25));
    }

    if (parts.isEmpty) return null;
    final totalW = parts.fold(0.0, (s, p) => s + p.$2);
    final v = parts.fold(0.0, (s, p) => s + p.$1 * p.$2) / totalW;
    return v.round().clamp(0, 100);
  }

  static RecoveryLevel level(int score) {
    if (score < 40) return RecoveryLevel.low;
    if (score < 65) return RecoveryLevel.moderate;
    return RecoveryLevel.high;
  }
}
