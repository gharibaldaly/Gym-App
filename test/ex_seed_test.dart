import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/data/repositories/exercise_repository.dart';
import 'package:ironmind/features/exercises/exercise_seed.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('parseArabicContent', () {
    test('parses valid entries and skips invalid ones', () {
      final m = parseArabicContent(jsonEncode({
        'Barbell_Curl': {
          'nameAr': ' كيرل بار ',
          'instructionsAr': ['امسك البار', '', 5],
          'mistakesEn': ['Swinging'],
          'mistakesAr': ['المرجحة'],
        },
        'Bad': 'not an object',
        'NoName': {'instructionsAr': ['خطوة']},
      }));
      expect(m.keys, containsAll(['Barbell_Curl', 'NoName']));
      expect(m.containsKey('Bad'), isFalse);
      expect(m['Barbell_Curl']!.nameAr, 'كيرل بار');
      expect(m['Barbell_Curl']!.instructionsAr, ['امسك البار']);
      expect(m['NoName']!.nameAr, isNull);
    });

    test('non-object root yields empty map', () {
      expect(parseArabicContent('[1,2,3]'), isEmpty);
    });
  });

  group('deriveMovementPattern', () {
    test('category wins for stretch / cardio / olympic', () {
      expect(deriveMovementPattern(category: 'stretching', force: 'pull', primary: ['chest']), 'stretch');
      expect(deriveMovementPattern(category: 'cardio', primary: ['quadriceps']), 'cardio');
      expect(deriveMovementPattern(category: 'olympic weightlifting', primary: ['shoulders']), 'olympic');
    });
    test('lower body → legs, abs → core', () {
      expect(deriveMovementPattern(category: 'strength', force: 'push', primary: ['quadriceps']), 'legs');
      expect(deriveMovementPattern(category: 'plyometrics', force: 'push', primary: ['hamstrings']), 'legs');
      expect(deriveMovementPattern(category: 'strength', force: 'pull', primary: ['abdominals']), 'core');
    });
    test('force / muscle based push & pull', () {
      expect(deriveMovementPattern(category: 'strength', force: 'push', primary: ['chest']), 'push');
      expect(deriveMovementPattern(category: 'strength', force: 'pull', primary: ['lats']), 'pull');
      expect(deriveMovementPattern(category: 'strength', force: null, primary: ['triceps']), 'push');
      expect(deriveMovementPattern(category: 'strength', force: null, primary: ['biceps']), 'pull');
      expect(deriveMovementPattern(category: 'powerlifting', force: 'pull', primary: ['lower back']), 'pull');
      expect(deriveMovementPattern(category: 'strength', force: 'static', primary: ['lower back']), 'core');
    });
  });

  group('autoArabicName', () {
    test('translates known words and moves equipment to the end', () {
      expect(autoArabicName('Barbell Curl'), 'كيرل بالبار');
      expect(autoArabicName('Incline Dumbbell Press'), 'إنكلاين بريس بالدمبل');
      expect(autoArabicName('Barbell Bench Press - Medium Grip'), isNull); // "medium" unknown
      expect(autoArabicName('Quad Stretch'), 'إطالة أمامية');
    });
    test('returns null for unknown words', () {
      expect(autoArabicName('Zercher Squat'), isNull);
    });
  });

  group('buildSeedCompanions', () {
    final raw = [
      {
        'id': 'A',
        'name': 'Barbell Curl',
        'force': 'pull',
        'level': 'beginner',
        'mechanic': 'isolation',
        'equipment': 'barbell',
        'primaryMuscles': ['biceps'],
        'secondaryMuscles': ['forearms', 'biceps'],
        'instructions': ['Stand up.', 'Curl.'],
        'category': 'strength',
        'images': ['A/0.jpg', 'A/1.jpg'],
      },
      {
        'id': 'B',
        'name': 'Zercher Squat',
        'force': 'push',
        'equipment': null,
        'mechanic': 'compound',
        'primaryMuscles': ['quadriceps'],
        'secondaryMuscles': [],
        'instructions': [],
        'category': 'strength',
        'images': [],
      },
      {
        'id': 'C',
        'name': 'Neck Stretch Thing',
        'equipment': null,
        'primaryMuscles': ['neck'],
        'secondaryMuscles': [],
        'category': 'stretching',
        'images': [],
      },
      {'name': 'no id'},
    ];
    final ar = {
      'A': const ArabicExerciseContent(
        nameAr: 'كيرل بالبار',
        instructionsAr: ['اقف', 'اطوي'],
        mistakesEn: ['Swinging'],
        mistakesAr: ['المرجحة'],
      ),
    };

    test('merges Arabic content and derives fields', () {
      final rows = buildSeedCompanions(raw, ar);
      expect(rows.length, 3);
      final a = rows.first;
      expect(a.nameAr.value, 'كيرل بالبار');
      expect(jsonDecode(a.secondaryMusclesJson.value), ['forearms']); // primary removed
      expect(jsonDecode(a.instructionsArJson.value), ['اقف', 'اطوي']);
      expect(jsonDecode(a.mistakesEnJson.value), ['Swinging']);
      expect(a.movementPattern.value, 'pull');
      expect(a.isFavorite.present, isFalse, reason: 'favorites must survive re-seed');
      expect(a.isCustom.present, isFalse);
    });

    test('falls back to English name and fills missing equipment', () {
      final rows = buildSeedCompanions(raw, const {});
      final b = rows[1];
      expect(b.nameAr.value, 'Zercher Squat');
      expect(b.equipment.value, 'other');
      expect(b.movementPattern.value, 'legs');
      expect(rows[2].equipment.value, 'body only');
      expect(rows[2].movementPattern.value, 'stretch');
      expect(rows.first.nameAr.value, 'كيرل بالبار'); // glossary fallback
    });
  });

  group('seedExercisesIfNeeded', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('seeds the bundled library quickly and keeps favorites & custom on re-seed', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = ExerciseRepository(db);

      final sw = Stopwatch()..start();
      await seedExercisesIfNeeded(db, prefs);
      sw.stop();
      expect(await repo.count(), greaterThanOrEqualTo(870));
      expect(prefs.getInt(SettingsKeys.seedVersion), kExerciseSeedVersion);
      // Generous bound for CI; on device the batch takes a few hundred ms.
      expect(sw.elapsedMilliseconds, lessThan(5000));

      final all = await repo.all();
      expect(all.every((e) => e.nameAr.isNotEmpty), isTrue);
      expect(all.where((e) => e.movementPattern == null), isEmpty);

      final id = all.first.id;
      await repo.setFavorite(id, true);
      await repo.insertCustom(ExercisesCompanion.insert(id: 'custom_1', nameEn: 'My Move', nameAr: 'حركتي'));

      // Same version → no work; version change → re-seed.
      await seedExercisesIfNeeded(db, prefs);
      await prefs.setInt(SettingsKeys.seedVersion, -1);
      await seedExercisesIfNeeded(db, prefs);

      expect((await repo.byId(id))!.isFavorite, isTrue);
      final custom = await repo.byId('custom_1');
      expect(custom, isNotNull);
      expect(custom!.isCustom, isTrue);
    });

    test('applySeed upsert does not overwrite favorites', () async {
      await applySeed(db, [
        const ExercisesCompanion(id: Value('X'), nameEn: Value('Old'), nameAr: Value('قديم')),
      ]);
      await ExerciseRepository(db).setFavorite('X', true);
      await applySeed(db, [
        const ExercisesCompanion(id: Value('X'), nameEn: Value('New'), nameAr: Value('جديد')),
      ]);
      final x = await ExerciseRepository(db).byId('X');
      expect(x!.nameEn, 'New');
      expect(x.isFavorite, isTrue);
    });
  });

  group('repository search', () {
    late AppDatabase db;
    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      await applySeed(db, [
        const ExercisesCompanion(
          id: Value('db_bench'),
          nameEn: Value('Dumbbell Bench Press'),
          nameAr: Value('بنش بريس بالدمبل'),
          primaryMusclesJson: Value('["chest"]'),
          equipment: Value('dumbbell'),
        ),
        const ExercisesCompanion(
          id: Value('stretch'),
          nameEn: Value('Chest Stretch'),
          nameAr: Value('إطالة الصدر'),
          primaryMusclesJson: Value('["chest"]'),
          equipment: Value('body only'),
        ),
      ]);
    });
    tearDown(() => db.close());

    test('multi-word, abbreviation and Arabic spelling variants', () async {
      final repo = ExerciseRepository(db);
      expect((await repo.watchSearch(query: 'db bench').first).map((e) => e.id), ['db_bench']);
      expect((await repo.watchSearch(query: 'press bench').first).map((e) => e.id), ['db_bench']);
      expect((await repo.watchSearch(query: 'اطالة').first).map((e) => e.id), ['stretch']);
      expect((await repo.watchSearch(muscle: 'chest', equipment: 'dumbbell').first).length, 1);
    });
  });
}
