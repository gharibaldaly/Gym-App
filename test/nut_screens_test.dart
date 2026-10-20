import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/ai/ai_service.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/core/theme/app_theme.dart';
import 'package:ironmind/features/nutrition/egyptian_foods.dart';
import 'package:ironmind/features/nutrition/logging/food_review_screen.dart';
import 'package:ironmind/features/nutrition/logging/my_foods_screen.dart';
import 'package:ironmind/features/nutrition/nutrition_logic.dart';
import 'package:ironmind/features/nutrition/nutrition_providers.dart';
import 'package:ironmind/features/nutrition/nutrition_tab_screen.dart';
import 'package:ironmind/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AppDatabase> _db({bool withPlan = true}) async {
  final db = AppDatabase(NativeDatabase.memory());
  await db.into(db.userProfiles).insert(UserProfilesCompanion.insert(
        id: const Value(1),
        trainingDaysJson: Value('[${DateTime.now().weekday}]'),
        mealsPerDay: const Value(3),
        calorieTarget: const Value(2400),
        proteinG: const Value(160),
        carbsG: const Value(270),
        fatG: const Value(75),
        trainingDayCarbsG: const Value(300),
        restDayCarbsG: const Value(250),
        onboardingComplete: const Value(true),
      ));
  if (withPlan) {
    final tr = MacroTargets.forDay(calorieTarget: 2400, proteinG: 160, carbsG: 270, fatG: 75, dayCarbsG: 300);
    final rest = MacroTargets.forDay(calorieTarget: 2400, proteinG: 160, carbsG: 270, fatG: 75, dayCarbsG: 250);
    await NutritionRepository(db).savePlan(buildTemplatePlan(training: tr, rest: rest, mealsPerDay: 3));
  }
  return db;
}

Future<void> _pump(WidgetTester tester, AppDatabase db, Widget home, {String lang = 'en'}) async {
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

Future<void> _end(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await _settle(tester);
}

void main() {
  testWidgets('today view: planned meals, one-tap "ate as planned" updates totals', (tester) async {
    final db = await _db();
    addTearDown(db.close);
    await _pump(tester, db, const NutritionTabScreen());
    await _settle(tester);
    expect(find.text('Training day'), findsWidgets);
    expect(find.text('Breakfast'), findsOneWidget);
    expect(find.text('Lunch'), findsOneWidget);
    expect(find.text('Dinner'), findsOneWidget);

    await tester.tap(find.text('Breakfast'));
    await _settle(tester);
    await tester.tap(find.text('Ate it as planned'));
    await _settle(tester);
    final logs = await db.select(db.mealLogs).get();
    expect(logs.single.source, 'plan');
    expect(logs.single.mealIndex, 0);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    await _end(tester);
  });

  testWidgets('pending AI logs are shown clearly', (tester) async {
    final db = await _db();
    addTearDown(db.close);
    await NutritionRepository(db)
        .addLog(day: DateTime.now(), name: 'كشري وبيض', items: const [], source: 'ai_text', status: 'pending_ai');
    await _pump(tester, db, const NutritionTabScreen(), lang: 'ar');
    await _settle(tester);
    expect(find.text('وجبة مستنية تحليل الـ AI'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('مستني تحليل الـ AI'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.text('مستني تحليل الـ AI'), findsOneWidget);
    await _end(tester);
  });

  testWidgets('plan tab toggles day type; shopping tab aggregates', (tester) async {
    final db = await _db();
    addTearDown(db.close);
    await _pump(tester, db, const NutritionTabScreen());
    await _settle(tester);
    await tester.tap(find.text('Meal plan'));
    await _settle(tester);
    expect(find.text('Basic meal plan'), findsOneWidget);
    expect(find.text('Swap meal'), findsWidgets);
    await tester.tap(find.text('Rest day'));
    await _settle(tester);
    expect(find.text('Rest day'), findsWidgets);

    await tester.tap(find.text('Shopping'));
    await _settle(tester);
    expect(find.text('Weekly shopping list'), findsOneWidget);
    expect(find.textContaining('eggs'), findsWidgets);
    await tester.tap(find.byType(CheckboxListTile).first);
    await _settle(tester);
    expect(tester.widget<CheckboxListTile>(find.byType(CheckboxListTile).first).value, isTrue);
    await _end(tester);
  });

  testWidgets('no plan: offline basic plan can be created', (tester) async {
    final db = await _db(withPlan: false);
    addTearDown(db.close);
    await _pump(tester, db, const NutritionTabScreen());
    await _settle(tester);
    await tester.tap(find.text('Meal plan'));
    await _settle(tester);
    await tester.tap(find.text('Use a basic offline plan'));
    await _settle(tester);
    expect(await NutritionRepository(db).activePlan(), isNotNull);
    await _end(tester);
  });

  testWidgets('review screen scales macros with grams and saves to my foods', (tester) async {
    final db = await _db(withPlan: false);
    addTearDown(db.close);
    await _pump(
      tester,
      db,
      FoodReviewScreen(
        items: [FoodEntry.fromFood(food('rice'), 200)],
        name: 'Rice plate',
        source: 'ai_text',
        confidence: 0.8,
      ),
    );
    await _settle(tester);
    expect(find.text('260 kcal'), findsWidgets);
    await tester.tap(find.byIcon(Icons.add).last);
    await _settle(tester);
    expect(find.text('210 g'), findsOneWidget);
    await tester.tap(find.text('Save meal'));
    await _settle(tester);
    final log = (await db.select(db.mealLogs).get()).single;
    expect(log.calories, closeTo(273, 0.5));
    expect(log.source, 'ai_text');
    final mine = (await db.select(db.foodItems).get()).single;
    expect(mine.name, 'Rice plate');
    expect(mine.useCount, 1);
    await _end(tester);
  });

  testWidgets('my foods: one tap logs without AI', (tester) async {
    final db = await _db(withPlan: false);
    addTearDown(db.close);
    await NutritionRepository(db).saveMyFood('Foul sandwich', [FoodEntry.fromFood(food('foul'), 150)]);
    await _pump(tester, db, const MyFoodsScreen());
    await _settle(tester);
    await tester.tap(find.text('Foul sandwich'));
    await _settle(tester);
    final log = (await db.select(db.mealLogs).get()).single;
    expect(log.source, 'saved');
    expect(log.calories, closeTo(165, 0.5));
    await _end(tester);
  });
}
