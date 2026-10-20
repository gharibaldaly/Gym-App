import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/data/repositories/profile_repository.dart';
import 'package:ironmind/features/onboarding/onboarding_data.dart';
import 'package:ironmind/features/onboarding/onboarding_logic.dart';

void main() {
  late AppDatabase db;
  late ProfileRepository repo;
  late OnboardingData data;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = ProfileRepository(db);
    data = OnboardingData(db);
  });
  tearDown(() => db.close());

  test('ensureProfile creates the row once with the UI language', () async {
    final p = await OnboardingData.ensureProfile(repo, 'en');
    expect(p.language, 'en');
    expect(p.onboardingComplete, isFalse);
    final again = await OnboardingData.ensureProfile(repo, 'ar');
    expect(again.language, 'en');
  });

  test('answersCompanion never overwrites targets or completion', () async {
    await OnboardingData.ensureProfile(repo, 'ar');
    await repo.upsert(const UserProfilesCompanion(
      calorieTarget: Value(2500),
      onboardingComplete: Value(true),
    ));
    final stale = (await repo.get())!.copyWith(calorieTarget: const Value(1000), onboardingComplete: false);
    await repo.upsert(answersCompanion(stale.copyWith(age: const Value(30))));
    final p = (await repo.get())!;
    expect(p.age, 30);
    expect(p.calorieTarget, 2500);
    expect(p.onboardingComplete, isTrue);
  });

  test('answersCompanion writes cleared (null) answers', () async {
    await OnboardingData.ensureProfile(repo, 'ar');
    await repo.upsert(const UserProfilesCompanion(targetWeightKg: Value(75)));
    final p = (await repo.get())!;
    await repo.upsert(answersCompanion(p.copyWith(targetWeightKg: const Value(null))));
    expect((await repo.get())!.targetWeightKg, isNull);
  });

  group('body metric', () {
    test('inserts today once and updates on later calls', () async {
      await OnboardingData.ensureProfile(repo, 'ar');
      await repo.upsert(UserProfilesCompanion(
        weightKg: const Value(82),
        bodyFatMethod: const Value('number'),
        bodyFatPct: const Value(18),
        measurementsJson: Value(encodeMeasurements({'waist': 86, 'arm': 38})),
      ));
      final now = DateTime(2026, 10, 20, 15, 30);
      await data.upsertTodayBodyMetric((await repo.get())!, now: now);
      await repo.upsert(const UserProfilesCompanion(weightKg: Value(81.5)));
      await data.upsertTodayBodyMetric((await repo.get())!, now: now.add(const Duration(hours: 2)));
      final rows = await db.select(db.bodyMetrics).get();
      expect(rows.length, 1);
      final r = rows.single;
      expect(r.date, DateTime(2026, 10, 20));
      expect(r.weightKg, 81.5);
      expect(r.bodyFatPct, 18);
      expect(r.waistCm, 86);
      expect(r.armCm, 38);
      expect(r.chestCm, isNull);
    });

    test('unknown body fat is not written; empty profile writes nothing', () async {
      await OnboardingData.ensureProfile(repo, 'ar');
      await data.upsertTodayBodyMetric((await repo.get())!);
      expect(await db.select(db.bodyMetrics).get(), isEmpty);
      await repo.upsert(const UserProfilesCompanion(
        weightKg: Value(70),
        bodyFatMethod: Value('unknown'),
        bodyFatPct: Value(25),
      ));
      await data.upsertTodayBodyMetric((await repo.get())!);
      final r = (await db.select(db.bodyMetrics).get()).single;
      expect(r.weightKg, 70);
      expect(r.bodyFatPct, isNull);
    });
  });

  group('supplements sync', () {
    test('inserts, updates by name, deactivates removed, ignores others', () async {
      // A supplement added elsewhere in the app must not be touched.
      await db.into(db.supplements).insert(SupplementsCompanion.insert(name: 'Iron'));
      final whey = entryFromTemplate(supplementTemplate('whey')!, name: 'Whey protein', dose: '1 scoop');
      const creatine = SupplementEntry(key: 'creatine', name: 'Creatine', dose: '5 g');
      await data.syncSupplements(const [], [whey, creatine]);

      var rows = await db.select(db.supplements).get();
      expect(rows.length, 3);
      final w = rows.firstWhere((r) => r.name == 'Whey protein');
      expect(w.proteinG, 24);
      expect(w.calories, 120);
      expect(w.dose, '1 scoop');
      expect(w.active, isTrue);

      // Edit whey dose (case-insensitive match), drop creatine.
      final whey2 = whey.copyWith(name: 'whey PROTEIN', dose: '2 scoops', proteinG: 48);
      await data.syncSupplements([whey, creatine], [whey2]);
      rows = await db.select(db.supplements).get();
      expect(rows.length, 3);
      final w2 = rows.firstWhere((r) => r.name.toLowerCase() == 'whey protein');
      expect(w2.dose, '2 scoops');
      expect(w2.proteinG, 48);
      expect(rows.firstWhere((r) => r.name == 'Creatine').active, isFalse);
      expect(rows.firstWhere((r) => r.name == 'Iron').active, isTrue);

      // Re-adding reactivates the same row.
      await data.syncSupplements([whey2], [whey2, creatine]);
      rows = await db.select(db.supplements).get();
      expect(rows.length, 3);
      expect(rows.firstWhere((r) => r.name == 'Creatine').active, isTrue);
    });

    test('blank names are skipped', () async {
      await data.syncSupplements(const [], const [SupplementEntry(name: '  ')]);
      expect(await db.select(db.supplements).get(), isEmpty);
    });
  });
}
