import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/ai/ai_service.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/core/theme/app_theme.dart';
import 'package:ironmind/features/exercises/add_exercise_screen.dart';
import 'package:ironmind/features/exercises/exercise_detail_screen.dart';
import 'package:ironmind/features/exercises/exercise_library_screen.dart';
import 'package:ironmind/l10n/gen/app_localizations.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AppDatabase> _db() async {
  final db = AppDatabase(NativeDatabase.memory());
  await db.into(db.exercises).insert(ExercisesCompanion.insert(
        id: 'custom_press',
        nameEn: 'Chest Press Machine',
        nameAr: 'تشيست بريس ماكينة',
        primaryMusclesJson: const Value('["chest"]'),
        secondaryMusclesJson: const Value('["triceps","shoulders"]'),
        equipment: const Value('machine'),
        movementPattern: const Value('push'),
        mechanic: const Value('compound'),
        instructionsEnJson: const Value('["Sit down.","Push the handles."]'),
        instructionsArJson: const Value('["اقعد.","ادفع المساكات."]'),
        mistakesArJson: const Value('["متقفلش الكوع جامد"]'),
        isCustom: const Value(true),
      ));
  await db.into(db.exercises).insert(ExercisesCompanion.insert(
        id: 'custom_row',
        nameEn: 'Machine Row',
        nameAr: 'رو ماكينة',
        primaryMusclesJson: const Value('["middle back"]'),
        equipment: const Value('machine'),
        isCustom: const Value(true),
      ));
  for (var i = 0; i < 3; i++) {
    final sid = await db.into(db.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(date: DateTime(2026, 9, 1 + i * 3), status: const Value('completed')),
        );
    for (var s = 0; s < 3; s++) {
      await db.into(db.setLogs).insert(SetLogsCompanion.insert(
            sessionId: sid,
            exerciseId: 'custom_press',
            setIndex: s,
            weightKg: 60 + i * 5.0,
            reps: 10 - s,
          ));
    }
  }
  return db;
}

Future<void> _pump(WidgetTester tester, AppDatabase db, Widget home, {String lang = 'ar'}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.75;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      sharedPrefsProvider.overrideWithValue(prefs),
      hasApiKeyProvider.overrideWithValue(false),
      isOnlineProvider.overrideWithValue(false),
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
      home: home,
    ),
  ));
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  testWidgets('library lists, filters and toggles favorites', (tester) async {
    final db = await _db();
    addTearDown(db.close);
    await _pump(tester, db, const ExerciseLibraryScreen());
    await _settle(tester);
    expect(find.text('تشيست بريس ماكينة'), findsOneWidget);
    expect(find.text('رو ماكينة'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'press');
    await tester.pump(const Duration(milliseconds: 300));
    await _settle(tester);
    expect(find.text('رو ماكينة'), findsNothing);
    expect(find.text('تشيست بريس ماكينة'), findsOneWidget);

    // The filter chip also shows a star; the exercise's favorite button is the last one.
    await tester.tap(find.byIcon(Symbols.star_rounded).last);
    await _settle(tester);
    final ex = await (db.select(db.exercises)..where((t) => t.id.equals('custom_press'))).getSingle();
    expect(ex.isFavorite, isTrue);
    await tester.pumpWidget(const SizedBox());
    await _settle(tester);
  });

  testWidgets('detail shows steps, body map and history', (tester) async {
    final db = await _db();
    addTearDown(db.close);
    await _pump(tester, db, const ExerciseDetailScreen(exerciseId: 'custom_press'), lang: 'en');
    await _settle(tester);
    expect(find.text('Chest Press Machine'), findsWidgets);
    expect(find.text('Push the handles.'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Personal records'), 300, scrollable: find.byType(Scrollable).first);
    await _settle(tester);
    expect(find.text('Last time'), findsOneWidget);
    expect(find.text('70 kg'), findsWidgets); // heaviest
    await tester.pumpWidget(const SizedBox());
    await _settle(tester);
  });

  testWidgets('add screen without AI goes to the manual form', (tester) async {
    final db = await _db();
    addTearDown(db.close);
    await _pump(tester, db, const AddExerciseScreen(), lang: 'en');
    await _settle(tester);
    await tester.scrollUntilVisible(find.text('Fill in manually'), 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Fill in manually'));
    await _settle(tester);
    expect(find.text('Name (English)'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextField, 'Name (English)'), 'Landmine Press');
    await tester.tap(find.text('Save').first);
    await _settle(tester);
    expect(find.text('Add a name and at least one primary muscle.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await _settle(tester);
  });
}
