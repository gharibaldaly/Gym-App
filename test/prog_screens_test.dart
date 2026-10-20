import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/ai/ai_service.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/core/theme/app_theme.dart';
import 'package:ironmind/features/progress/adherence_calendar.dart';
import 'package:ironmind/features/progress/progress_tab_screen.dart';
import 'package:ironmind/features/progress/prs_screen.dart';
import 'package:ironmind/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'prog_seed.dart';

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

/// Scrolls the first list until [finder] is built (no pumpAndSettle: spinners
/// would never settle while Drift queries need real async time).
Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 40 && finder.evaluate().isEmpty; i++) {
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -300));
    await _settle(tester);
  }
}

Future<AppDatabase> _seeded(WidgetTester tester) async {
  final db = memoryDb();
  await tester.runAsync(() => seedFortnight(db));
  return db;
}

Future<void> _dispose(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
  await tester.runAsync(db.close);
}

void main() {
  for (final lang in ['ar', 'en']) {
    testWidgets('progress tab renders every section with data ($lang)', (tester) async {
      final db = await _seeded(tester);
      await _pump(tester, db, const ProgressTabScreen(), lang: lang);
      await _settle(tester);
      final l = lookupAppLocalizations(Locale(lang));
      expect(find.text(l.progCalendarTitle), findsOneWidget);
      expect(find.text(l.progLinkPrs), findsOneWidget);

      // Show all history so the seeded October data is inside the period.
      await _scrollTo(tester, find.text(l.progPeriodAll));
      await tester.tap(find.text(l.progPeriodAll));
      await _settle(tester);

      expect(find.text(l.progExerciseTitle), findsOneWidget);
      expect(find.text(lang == 'ar' ? 'سكوات بالبار' : 'Barbell Squat'), findsWidgets);

      for (final title in [l.progVolumeTitle, l.progBodyTitle, l.progNutritionTitle, l.progSleepTitle]) {
        await _scrollTo(tester, find.text(title));
        expect(find.text(title), findsOneWidget);
      }
      expect(find.text(l.progNoSleepData), findsNothing);
      expect(tester.takeException(), isNull);
      await _dispose(tester, db);
    });
  }

  testWidgets('empty database shows friendly empty states', (tester) async {
    final db = memoryDb();
    await _pump(tester, db, const ProgressTabScreen(), lang: 'ar');
    await _settle(tester);
    final l = lookupAppLocalizations(const Locale('ar'));
    expect(find.text(l.progNoExerciseData), findsOneWidget);
    await _scrollTo(tester, find.text(l.progNoSleepData));
    expect(find.text(l.progNoSleepData), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _dispose(tester, db);
  });

  testWidgets('PRs page lists records per exercise', (tester) async {
    final db = await _seeded(tester);
    await _pump(tester, db, const PrsScreen(), lang: 'en');
    await _settle(tester);
    expect(find.text('Barbell Bench Press'), findsOneWidget);
    expect(find.text('Barbell Squat'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'squat');
    await _settle(tester);
    expect(find.text('Barbell Bench Press'), findsNothing);
    expect(tester.takeException(), isNull);
    await _dispose(tester, db);
  });

  testWidgets('day details sheet content', (tester) async {
    final db = await _seeded(tester);
    await _pump(tester, db, Scaffold(body: DayDetailsView(day: DateTime(2026, 10, 10))), lang: 'ar');
    await _settle(tester);
    expect(find.text('Push A'), findsOneWidget);
    expect(find.text('بنش برس بالبار'), findsOneWidget);
    expect(find.text('82.5×8 @9'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _dispose(tester, db);
  });
}
