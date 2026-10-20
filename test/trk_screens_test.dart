import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/core/theme/app_theme.dart';
import 'package:ironmind/data/repositories/profile_repository.dart';
import 'package:ironmind/features/tracking/tracking_providers.dart';
import 'package:ironmind/features/tracking/tracking_screens.dart';
import 'package:ironmind/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime _today() {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

Future<void> _seed(AppDatabase db) async {
  final repo = TrackingRepository(db);
  final t = _today();
  await ProfileRepository(db).upsert(const UserProfilesCompanion(
    weightKg: Value(80),
    waterGoalMl: Value(3000),
    sleepTime: Value('23:30'),
    wakeTime: Value('07:00'),
    healthConnectEnabled: Value(true),
  ));
  await repo.addWater(250);
  await repo.addWater(1000, at: t.subtract(const Duration(hours: 5)));
  final s = await repo.saveSupplement(SupplementsCompanion.insert(name: 'Creatine', dose: const Value('5 g'), timing: const Value('morning')));
  await repo.saveSupplement(SupplementsCompanion.insert(name: 'Whey', proteinG: const Value(24), calories: const Value(120)));
  await repo.toggleSupplement(s);
  for (var i = 0; i < 20; i++) {
    final d = t.subtract(Duration(days: i));
    await repo.saveWeight(d, 82 - i * 0.1);
    await db.into(db.healthDaily).insert(HealthDailyCompanion.insert(
        date: d, hrv: Value(55.0 + i % 5), restingHr: Value(56.0 + i % 3), steps: Value(8000 + i)));
  }
  await db.into(db.sleepLogs).insert(SleepLogsCompanion.insert(
    date: t,
    durationMin: 452,
    deepMin: const Value(80),
    remMin: const Value(95),
    lightMin: const Value(250),
    awakeMin: const Value(27),
    start: Value(t.subtract(const Duration(minutes: 30))),
    end: Value(t.add(const Duration(hours: 7))),
    source: const Value('health_connect'),
  ));
  await repo.saveManualSleep(date: t.subtract(const Duration(days: 1)), durationMin: 400, quality: 3);
  await repo.saveMeasurements(t.subtract(const Duration(days: 10)), waist: 86, chest: 104, bodyFat: 19);
  await repo.saveMeasurements(t.subtract(const Duration(days: 3)), waist: 85, chest: 105, arm: 38);
  await repo.savePhoto(t, 'front', 'progress_photos/missing_front.jpg');
  await repo.savePhoto(t.subtract(const Duration(days: 30)), 'side', 'progress_photos/missing_side.jpg');
}

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  final screens = <String, Widget>{
    'water': const WaterScreen(),
    'supplements': const SupplementsScreen(),
    'sleep': const SleepLogScreen(),
    'weight': const BodyWeightScreen(),
    'measurements': const BodyMeasurementsScreen(),
    'photos': const ProgressPhotosScreen(),
    'compare': const ProgressPhotoCompareScreen(),
    'health': const HealthConnectSettingsScreen(),
  };

  for (final lang in ['ar', 'en']) {
    for (final e in screens.entries) {
      testWidgets('${e.key} renders ($lang)', (tester) async {
        await tester.runAsync(() => _seed(db));
        tester.view.physicalSize = const Size(1080, 2340);
        tester.view.devicePixelRatio = 2.75;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            sharedPrefsProvider.overrideWithValue(prefs),
            appDocsDirProvider.overrideWith((ref) async => Directory.systemTemp),
          ],
          child: MaterialApp(
            theme: AppTheme.dark(Locale(lang)),
            locale: Locale(lang),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: e.value,
          ),
        ));
        for (var i = 0; i < 6; i++) {
          await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
          await tester.pump(const Duration(milliseconds: 50));
        }
        expect(tester.takeException(), isNull);
        expect(find.byType(Scaffold), findsWidgets);
        await tester.pumpWidget(const SizedBox());
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
        await tester.pump(const Duration(seconds: 1));
      });
    }
  }

  testWidgets('weight quick log saves and updates the profile', (tester) async {
    await tester.runAsync(() => ProfileRepository(db).upsert(const UserProfilesCompanion(weightKg: Value(80))));
    late WidgetRef wref;
    await tester.pumpWidget(ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Consumer(builder: (context, ref, _) {
          wref = ref;
          return Scaffold(
            body: Center(
              child: TextButton(onPressed: () => showWeightQuickLog(context, ref), child: const Text('open')),
            ),
          );
        }),
      ),
    ));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
    await tester.pump();
    await tester.tap(find.text('open'));
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();
    final p = await tester.runAsync(() => ProfileRepository(db).get());
    expect(p!.weightKg, closeTo(80.1, 0.001));
    expect(wref, isNotNull);
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pump(const Duration(seconds: 5));
  });
}
