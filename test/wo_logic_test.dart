import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/calc/progression.dart';
import 'package:ironmind/features/workout/live_workout_screen.dart' show buildLiveEntries;
import 'package:ironmind/features/workout/workout_logic.dart';
import 'package:ironmind/features/workout/workout_suggestions.dart';
import 'package:ironmind/core/providers.dart';

typedef S = ({double weight, int reps, String setType});

void main() {
  group('session status', () {
    test('completed when every planned exercise has all working sets', () {
      expect(
        computeSessionStatus([(planned: 3, done: 3), (planned: 4, done: 5)], anythingLogged: true),
        SessionStatus.completed,
      );
    });
    test('partial when any planned exercise is short', () {
      expect(
        computeSessionStatus([(planned: 3, done: 3), (planned: 4, done: 2)], anythingLogged: true),
        SessionStatus.partial,
      );
    });
    test('free workout: completed if anything logged', () {
      expect(computeSessionStatus(const [], anythingLogged: true), SessionStatus.completed);
      expect(computeSessionStatus(const [], anythingLogged: false), SessionStatus.partial);
    });
  });

  group('volume', () {
    test('excludes warm-up sets', () {
      final sets = <S>[
        (weight: 40, reps: 10, setType: SetType.warmup),
        (weight: 80, reps: 10, setType: SetType.normal),
        (weight: 80, reps: 8, setType: SetType.failure),
        (weight: 60, reps: 12, setType: SetType.drop),
      ];
      expect(sessionVolume(sets), 80 * 10 + 80 * 8 + 60 * 12);
    });
    test('best e1RM ignores warm-ups', () {
      final sets = <S>[
        (weight: 200, reps: 1, setType: SetType.warmup),
        (weight: 100, reps: 5, setType: SetType.normal),
      ];
      expect(bestE1rm(sets), closeTo(100 * (1 + 5 / 30), 1e-9));
    });
  });

  group('missed dates', () {
    test('only past training weekdays without a session, from the day after activation', () {
      // Mon 2026-10-05 activation; training Mon(1)/Wed(3)/Sat(6); now Mon 2026-10-19.
      final out = missedDates(
        activatedAt: DateTime(2026, 10, 5, 18),
        now: DateTime(2026, 10, 19, 9),
        trainingWeekdays: {1, 3, 6},
        sessionDays: {DateTime(2026, 10, 7), DateTime(2026, 10, 12)},
      );
      expect(out, [DateTime(2026, 10, 10), DateTime(2026, 10, 14), DateTime(2026, 10, 17)]);
    });
    test('never more than maxDays back and never today', () {
      final out = missedDates(
        activatedAt: DateTime(2025, 1, 1),
        now: DateTime(2026, 10, 20, 12),
        trainingWeekdays: {1, 2, 3, 4, 5, 6, 7},
        sessionDays: const {},
        maxDays: 10,
      );
      expect(out.length, 10);
      expect(out.first, DateTime(2026, 10, 10));
      expect(out.last, DateTime(2026, 10, 19));
    });
  });

  group('recovery adjust', () {
    test('parses coach JSON and applies to weight and sets', () {
      final r = RecoveryAdjust.parse('{"weightFactor":0.9,"setsDelta":-1}')!;
      expect(r.applySets(4), 3);
      expect(r.applySets(1), 1);
      final s = r.apply(const SetSuggestion(100, 8, ProgressionReason.addReps), 2.5);
      expect(s.weightKg, 90);
      expect(s.reps, 8);
    });
    test('invalid JSON → null', () {
      expect(RecoveryAdjust.parse('oops'), isNull);
      expect(RecoveryAdjust.parse(null), isNull);
    });
    test('key format', () {
      expect(recoveryAdjustKey(DateTime(2026, 3, 5)), 'recovery_adjust_2026-03-05');
    });
  });

  group('deload helpers', () {
    test('active window is 7 days', () {
      final start = DateTime(2026, 10, 10);
      expect(deloadActiveOn(start, DateTime(2026, 10, 10, 8)), isTrue);
      expect(deloadActiveOn(start, DateTime(2026, 10, 16, 23)), isTrue);
      expect(deloadActiveOn(start, DateTime(2026, 10, 17)), isFalse);
      expect(deloadActiveOn(null, DateTime(2026, 10, 17)), isFalse);
    });
    test('e1RM trend ratio detects a drop', () {
      final now = DateTime(2026, 10, 20);
      List<({DateTime date, double e1rm})> l(double prev, double recent) => [
            (date: now.subtract(const Duration(days: 20)), e1rm: prev),
            (date: now.subtract(const Duration(days: 3)), e1rm: recent),
          ];
      final dropping = {'a': l(100, 94), 'b': l(80, 76), 'c': l(60, 58)};
      final ratio = e1rmTrendRatio(dropping, now: now)!;
      expect(ratio, lessThan(0.97));
      expect(performanceDropped(ratio), isTrue);
      final ok = {'a': l(100, 101), 'b': l(80, 80), 'c': l(60, 61)};
      expect(performanceDropped(e1rmTrendRatio(ok, now: now)), isFalse);
      expect(e1rmTrendRatio({'a': l(100, 90)}, now: now), isNull); // too few exercises
    });
  });

  group('suggestions', () {
    test('double progression adds weight after hitting the top of the range', () {
      final s = buildSetSuggestions(
        sets: 3,
        repMin: 8,
        repMax: 12,
        lastSession: const [LastSet(80, 12), LastSet(80, 12), LastSet(80, 12)],
        increment: 2.5,
      );
      expect(s.map((e) => e.weightKg), [82.5, 82.5, 82.5]);
      expect(s.first.reps, 8);
    });
    test('deload uses 85% (plan weight when no history)', () {
      final s = buildSetSuggestions(
        sets: 1,
        repMin: 8,
        repMax: 12,
        lastSession: const [],
        planWeightKg: 100,
        increment: 2.5,
        deload: true,
      );
      expect(s.single.weightKg, 85);
    });
    test('recovery factor applies on top', () {
      final s = buildSetSuggestions(
        sets: 1,
        repMin: 8,
        repMax: 12,
        lastSession: const [LastSet(100, 10)],
        increment: 2.5,
        recovery: const RecoveryAdjust(weightFactor: 0.9, setsDelta: -1),
      );
      expect(s.single.weightKg, 90);
    });
  });

  group('live entries', () {
    PlanExercise pe(int id, String ex) => PlanExercise(
          id: id,
          planDayId: 1,
          exerciseId: ex,
          orderIndex: id,
          sets: 3,
          repMin: 8,
          repMax: 12,
          restSeconds: 90,
        );
    test('applies today swaps, extras and logged exercises without duplicates', () {
      final e = buildLiveEntries(
        plan: [pe(1, 'A'), pe(2, 'B')],
        swaps: {'2': 'C'},
        extras: ['D', 'A'],
        loggedExerciseIds: ['B', 'D'],
      );
      expect(e.map((x) => x.exerciseId), ['A', 'C', 'D', 'B']);
      expect(e[1].substituted, isTrue);
      expect(e[1].pe?.id, 2);
      expect(e[2].pe, isNull);
    });
  });
}
