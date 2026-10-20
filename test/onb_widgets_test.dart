import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/core/theme/app_theme.dart';
import 'package:ironmind/data/repositories/profile_repository.dart';
import 'package:ironmind/features/onboarding/onboarding_flow.dart';
import 'package:ironmind/features/onboarding/onboarding_logic.dart';
import 'package:ironmind/features/onboarding/profile_edit_screen.dart';
import 'package:ironmind/features/onboarding/steps/step_registry.dart';
import 'package:ironmind/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onb_fixtures.dart';

Future<List<Override>> _overrides(AppDatabase db) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return [
    databaseProvider.overrideWithValue(db),
    sharedPrefsProvider.overrideWithValue(prefs),
    isOnlineProvider.overrideWithValue(true),
  ];
}

Widget _app(List<Override> overrides, Widget home, {String lang = 'en'}) => ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: Locale(lang),
        theme: AppTheme.dark(Locale(lang)),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: home,
      ),
    );

UserProfile _richProfile() => completeProfile().copyWithCompanion(UserProfilesCompanion(
      bodyFatMethod: const Value('shape'),
      bodyFatPct: const Value(20),
      measurementsJson: Value(encodeMeasurements({'waist': 86})),
      targetWeightKg: const Value(76),
      focusMusclesJson: Value(jsonEncode(['chest'])),
      injuriesJson: Value(jsonEncode(['knee', 'hypertension'])),
      jobHours: const Value('09:00-17:00'),
      likedFoods: const Value('eggs, mango'),
      budgetLevel: const Value(null),
      budgetEgp: const Value(6000),
      supplementsJson: Value(encodeSupplements([
        entryFromTemplate(supplementTemplate('whey')!, name: 'Whey', dose: '1 scoop'),
        const SupplementEntry(name: ''),
      ])),
    ));

void main() {
  for (final lang in ['en', 'ar']) {
    testWidgets('every step renders without layout errors ($lang)', (tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final overrides = await _overrides(db);
      for (final step in OnbStep.values) {
        var profile = _richProfile();
        await tester.pumpWidget(_app(
          overrides,
          StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: SingleChildScrollView(
                child: buildStepBody(
                  step,
                  profile: profile,
                  onChanged: (c) => setState(() => profile = profile.copyWithCompanion(c)),
                ),
              ),
            ),
          ),
          lang: lang,
        ));
        await tester.pump();
        expect(tester.takeException(), isNull, reason: step.name);
      }
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('days step: picking a count suggests matching weekdays', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final overrides = await _overrides(db);
    var profile = blankProfile();
    await tester.pumpWidget(_app(
      overrides,
      StatefulBuilder(
        builder: (context, setState) => Scaffold(
          body: SingleChildScrollView(
            child: buildStepBody(OnbStep.days,
                profile: profile, onChanged: (c) => setState(() => profile = profile.copyWithCompanion(c))),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('3'));
    await tester.pump();
    expect(profile.daysPerWeek, 3);
    expect(profile.trainingDays, suggestTrainingDays(3));
    expect(validateStep(OnbStep.days, profile), isNull);
    // Toggle one more day → mismatch.
    await tester.tap(find.text('Fri'));
    await tester.pump();
    expect(validateStep(OnbStep.days, profile), OnbIssue.daysMismatch);
  });

  testWidgets('onboarding flow: validation blocks Next and answers are saved', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final overrides = await _overrides(db);
    final en = lookupAppLocalizations(const Locale('en'));

    await tester.pumpWidget(_app(overrides, const OnboardingFlow()));
    await tester.pumpAndSettle();
    expect(find.text(en.onbLangTitle), findsOneWidget);
    expect(find.text(en.onbStepOf('1', '24')), findsOneWidget);

    await tester.tap(find.text(en.onbNext));
    await tester.pumpAndSettle();
    expect(find.text(en.onbBodyTitle), findsOneWidget);

    // Nothing filled → error.
    await tester.tap(find.text(en.onbNext));
    await tester.pumpAndSettle();
    expect(find.text(en.onbErrSex), findsOneWidget);

    await tester.tap(find.text(en.onbSexMale));
    await tester.enterText(find.widgetWithText(TextField, en.onbAge), '٢٨');
    await tester.enterText(find.widgetWithText(TextField, en.onbHeight), '178');
    await tester.enterText(find.widgetWithText(TextField, en.onbWeight), '82.5');
    await tester.pumpAndSettle();
    await tester.tap(find.text(en.onbNext));
    await tester.pumpAndSettle();
    expect(find.text(en.onbBodyFatTitle), findsOneWidget);

    // Back returns to the previous step with the values kept.
    await tester.tap(find.byTooltip(en.onbBack));
    await tester.pumpAndSettle();
    expect(find.text(en.onbBodyTitle), findsOneWidget);
    expect(find.text('82.5'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    final p = await ProfileRepository(db).get();
    expect(p!.sex, 'male');
    expect(p.age, 28);
    expect(p.weightKg, 82.5);
    expect(p.onboardingComplete, isFalse);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('profile editor lists answers and saves an edit', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final overrides = await _overrides(db);
    final repo = ProfileRepository(db);
    await repo.upsert(completeProfile().toCompanion(false));
    await repo.recomputeTargets();
    final en = lookupAppLocalizations(const Locale('en'));

    await tester.pumpWidget(_app(overrides, const ProfileEditScreen()));
    await tester.pumpAndSettle();
    expect(find.text(en.onbProfileTitle), findsOneWidget);
    await tester.scrollUntilVisible(find.text(en.onbSumLocation), 200);
    expect(find.text(en.onbSumLocation), findsOneWidget);
    await tester.tap(find.text(en.onbSumLocation));
    await tester.pumpAndSettle();
    await tester.tap(find.text(en.onbLocHome));
    await tester.pump();
    await tester.tap(find.text(en.save));
    await tester.pumpAndSettle();

    expect((await repo.get())!.location, 'home');
    // Location affects the workout plan → regeneration is offered.
    expect(find.text(en.onbRegenTitle), findsOneWidget);
    await tester.tap(find.text(en.onbRegenSkip));
    await tester.pumpAndSettle();
    expect(find.text(en.onbRegenTitle), findsNothing);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
