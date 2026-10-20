import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/calc/nutrition_calc.dart';
import 'package:ironmind/core/calc/plateau.dart';
import 'package:ironmind/core/calc/progression.dart';
import 'package:ironmind/core/calc/recovery.dart';
import 'package:ironmind/core/calc/stats.dart';
import 'package:ironmind/core/calc/strength_calc.dart';
import 'package:ironmind/core/calc/voice_parser.dart';

void main() {
  group('BMR / TDEE', () {
    test('Mifflin-St Jeor male', () {
      // 10*80 + 6.25*180 - 5*30 + 5 = 1780
      expect(NutritionCalc.bmr(male: true, weightKg: 80, heightCm: 180, age: 30), closeTo(1780, 0.01));
    });
    test('Mifflin-St Jeor female', () {
      // 10*60 + 6.25*165 - 5*25 - 161 = 1345.25
      expect(NutritionCalc.bmr(male: false, weightKg: 60, heightCm: 165, age: 25), closeTo(1345.25, 0.01));
    });
    test('Katch-McArdle when body fat is known', () {
      // LBM = 80 * 0.8 = 64 → 370 + 21.6*64 = 1752.4
      expect(NutritionCalc.bmr(male: true, weightKg: 80, heightCm: 180, age: 30, bodyFatPct: 20),
          closeTo(1752.4, 0.01));
    });
    test('activity factor grows with job and training days', () {
      expect(NutritionCalc.activityFactor(jobType: 'desk', trainingDays: 0), 1.2);
      expect(NutritionCalc.activityFactor(jobType: 'physical', trainingDays: 4),
          greaterThan(NutritionCalc.activityFactor(jobType: 'desk', trainingDays: 4)));
    });
    test('cut is below TDEE and bulk above', () {
      expect(NutritionCalc.calorieTarget(2500, 'cut'), lessThan(2500));
      expect(NutritionCalc.calorieTarget(2500, 'bulk'), greaterThan(2500));
      expect(NutritionCalc.calorieTarget(2500, 'fitness'), 2500);
    });
    test('macros add up to the calorie target (±1%)', () {
      final t = NutritionCalc.compute(
          male: true, weightKg: 80, heightCm: 180, age: 30, jobType: 'desk', trainingDays: 4, goal: 'cut');
      final kcal = t.proteinG * 4 + t.carbsG * 4 + t.fatG * 9;
      expect((kcal - t.calories).abs() / t.calories, lessThan(0.01));
      expect(t.proteinG, 176);
      expect(t.trainingDayCarbsG, greaterThan(t.restDayCarbsG));
      // weekly carbs preserved by carb cycling
      expect((t.trainingDayCarbsG * 4 + t.restDayCarbsG * 3 - t.carbsG * 7).abs(), lessThanOrEqualTo(4));
    });
    test('water goal', () {
      expect(NutritionCalc.waterGoalMl(80), 3250);
      expect(NutritionCalc.waterGoalMl(80, trainingDay: false), 2750);
    });
  });

  group('1RM & PR', () {
    test('Epley', () {
      expect(StrengthCalc.epley1Rm(100, 1), 100);
      expect(StrengthCalc.epley1Rm(100, 10), closeTo(133.33, 0.01));
      expect(StrengthCalc.epley1Rm(0, 10), 0);
    });
    test('no history → no PR', () {
      expect(PrDetector.detect(weightKg: 100, reps: 5, history: []), isEmpty);
    });
    test('weight PR', () {
      final pr = PrDetector.detect(weightKg: 102.5, reps: 3, history: const [HistSet(100, 5)]);
      expect(pr, contains(PrType.weight));
    });
    test('reps PR at same weight', () {
      final pr = PrDetector.detect(weightKg: 80, reps: 9, history: const [HistSet(80, 8), HistSet(90, 3)]);
      expect(pr, containsAll([PrType.reps]));
      expect(pr, isNot(contains(PrType.weight)));
    });
    test('e1RM PR', () {
      final pr = PrDetector.detect(weightKg: 90, reps: 8, history: const [HistSet(100, 3)]);
      // 90*(1+8/30)=114 > 100*(1.1)=110
      expect(pr, contains(PrType.e1rm));
    });
    test('equal performance is not a PR', () {
      expect(PrDetector.detect(weightKg: 80, reps: 8, history: const [HistSet(80, 8)]), isEmpty);
    });
  });

  group('Double progression', () {
    test('first time uses plan weight', () {
      final s = Progression.suggest(setIndex: 0, repMin: 8, repMax: 12, lastSession: [], planWeightKg: 40);
      expect(s.weightKg, 40);
      expect(s.reps, 8);
      expect(s.reason, ProgressionReason.firstTime);
    });
    test('all sets at top of range → add weight, back to repMin', () {
      final s = Progression.suggest(
        setIndex: 0,
        repMin: 8,
        repMax: 12,
        lastSession: const [LastSet(80, 12), LastSet(80, 12), LastSet(80, 12)],
        increment: 2.5,
      );
      expect(s.weightKg, 82.5);
      expect(s.reps, 8);
      expect(s.reason, ProgressionReason.increaseWeight);
    });
    test('not all at top → same weight, +1 rep', () {
      final s = Progression.suggest(
        setIndex: 1,
        repMin: 8,
        repMax: 12,
        lastSession: const [LastSet(80, 12), LastSet(80, 10), LastSet(80, 9)],
      );
      expect(s.weightKg, 80);
      expect(s.reps, 11);
      expect(s.reason, ProgressionReason.addReps);
    });
    test('RPE 10 at top of range → do not add weight', () {
      final s = Progression.suggest(
        setIndex: 0,
        repMin: 8,
        repMax: 12,
        lastSession: const [LastSet(80, 12, rpe: 10), LastSet(80, 12, rpe: 10)],
      );
      expect(s.weightKg, 80);
    });
    test('two sessions below range → reduce weight', () {
      final s = Progression.suggest(
        setIndex: 0,
        repMin: 8,
        repMax: 12,
        lastSession: const [LastSet(100, 6), LastSet(100, 5)],
        sessionBefore: const [LastSet(100, 6), LastSet(100, 6)],
        increment: 2.5,
      );
      expect(s.reason, ProgressionReason.reduceWeight);
      expect(s.weightKg, 95);
    });
    test('deload = 85%', () {
      final s = Progression.suggest(
          setIndex: 0, repMin: 8, repMax: 12, lastSession: const [LastSet(100, 10)], deload: true, increment: 2.5);
      expect(s.weightKg, 85);
    });
  });

  group('Plateau', () {
    final d = DateTime(2026, 1, 1);
    test('not enough sessions', () {
      expect(PlateauDetector.isPlateau([SessionBest(d, 100), SessionBest(d.add(const Duration(days: 3)), 100)]),
          isFalse);
    });
    test('3 sessions without beating previous best → plateau', () {
      final s = [
        SessionBest(d, 110),
        SessionBest(d.add(const Duration(days: 7)), 108),
        SessionBest(d.add(const Duration(days: 14)), 110),
        SessionBest(d.add(const Duration(days: 21)), 109),
      ];
      expect(PlateauDetector.isPlateau(s), isTrue);
    });
    test('improvement in window → no plateau', () {
      final s = [
        SessionBest(d, 100),
        SessionBest(d.add(const Duration(days: 7)), 100),
        SessionBest(d.add(const Duration(days: 14)), 104),
        SessionBest(d.add(const Duration(days: 21)), 101),
      ];
      expect(PlateauDetector.isPlateau(s), isFalse);
    });
  });

  group('Recovery score', () {
    test('no data → null', () {
      expect(RecoveryCalc.score(const RecoveryInput()), isNull);
    });
    test('great night + baseline HRV/RHR → high', () {
      final s = RecoveryCalc.score(const RecoveryInput(
          sleepMin: 480, hrv: 60, hrvBaseline: 50, restingHr: 52, restingHrBaseline: 55))!;
      expect(s, greaterThan(80));
      expect(RecoveryCalc.level(s), RecoveryLevel.high);
    });
    test('short sleep + low HRV + high RHR → low', () {
      final s = RecoveryCalc.score(const RecoveryInput(
          sleepMin: 240, hrv: 35, hrvBaseline: 50, restingHr: 62, restingHrBaseline: 55))!;
      expect(s, lessThan(40));
      expect(RecoveryCalc.level(s), RecoveryLevel.low);
    });
    test('sleep only', () {
      expect(RecoveryCalc.score(const RecoveryInput(sleepMin: 480)), 100);
      expect(RecoveryCalc.score(const RecoveryInput(sleepMin: 240)), 50);
    });
  });

  group('Stats', () {
    test('7-day moving average', () {
      final base = DateTime(2026, 1, 1);
      final pts = List.generate(10, (i) => DatedValue(base.add(Duration(days: i)), (80 + i).toDouble()));
      final ma = Stats.movingAverage(pts);
      expect(ma.first.value, 80);
      expect(ma[6].value, closeTo(83, 0.001)); // avg 80..86
      expect(ma[9].value, closeTo(86, 0.001)); // avg 83..89
    });
    test('cardio calories (MET)', () {
      final kcal = CardioCalc.calories(type: 'jump_rope', minutes: 10, weightKg: 70);
      expect(kcal, closeTo(11 * 3.5 * 70 / 200 * 10, 0.01));
      final walk = CardioCalc.calories(type: 'treadmill', minutes: 30, weightKg: 80, speedKmh: 5, inclinePct: 10);
      final flat = CardioCalc.calories(type: 'treadmill', minutes: 30, weightKg: 80, speedKmh: 5);
      expect(walk, greaterThan(flat));
    });
  });

  group('Voice parser', () {
    test('Arabic digits + units', () {
      expect(VoiceSetParser.parse('80 كيلو 10 عدات'), const ParsedSet(80, 10));
      expect(VoiceSetParser.parse('٨٠ كيلو ١٠ عدات'), const ParsedSet(80, 10));
      expect(VoiceSetParser.parse('82.5 كيلو 8 عدات'), const ParsedSet(82.5, 8));
      expect(VoiceSetParser.parse('٨٢٫٥ كجم ٨ تكرارات'), const ParsedSet(82.5, 8));
    });
    test('Egyptian number words', () {
      expect(VoiceSetParser.parse('تمانين كيلو عشر عدات'), const ParsedSet(80, 10));
      expect(VoiceSetParser.parse('خمسة وتمانين كيلو تمن عدات'), const ParsedSet(85, 8));
      expect(VoiceSetParser.parse('مية وعشرين كيلو خمس عدات'), const ParsedSet(120, 5));
      expect(VoiceSetParser.parse('اتنين وتمانين ونص كيلو ستة عدات'), const ParsedSet(82.5, 6));
      expect(VoiceSetParser.parse('80 ونص كيلو 6 عدات'), const ParsedSet(80.5, 6));
    });
    test('English', () {
      expect(VoiceSetParser.parse('80 kg 10 reps'), const ParsedSet(80, 10));
      expect(VoiceSetParser.parse('eighty kilos ten reps'), const ParsedSet(80, 10));
      expect(VoiceSetParser.parse('10 reps at 60 kg'), const ParsedSet(60, 10));
      expect(VoiceSetParser.parse('100 kg 5 reps rpe 8'), const ParsedSet(100, 5, rpe: 8));
    });
    test('pairs without units', () {
      expect(VoiceSetParser.parse('80 x 10'), const ParsedSet(80, 10));
      expect(VoiceSetParser.parse('80 في 10'), const ParsedSet(80, 10));
      expect(VoiceSetParser.parse('60 10'), const ParsedSet(60, 10));
      expect(VoiceSetParser.parse('12 reps at 20'), const ParsedSet(20, 12));
    });
    test('RPE in Arabic', () {
      expect(VoiceSetParser.parse('90 كيلو 6 عدات مجهود 9'), const ParsedSet(90, 6, rpe: 9));
    });
    test('bodyweight', () {
      expect(VoiceSetParser.parse('وزن الجسم 15 عدة'), const ParsedSet(0, 15));
    });
    test('unparseable → null', () {
      expect(VoiceSetParser.parse('الكتف بيوجعني'), isNull);
      expect(VoiceSetParser.parse('80 كيلو'), isNull);
    });
  });
}
