import 'package:flutter/material.dart';

import '../../l10n/gen/app_localizations.dart';
import 'onboarding_logic.dart';

/// A selectable answer: stored [code] + localized label/subtitle + icon.
class OnbOption<T> {
  final T code;
  final String label;
  final String? subtitle;
  final IconData? icon;
  const OnbOption(this.code, this.label, {this.subtitle, this.icon});
}

String? labelOf<T>(List<OnbOption<T>> options, T? code) {
  if (code == null) return null;
  for (final o in options) {
    if (o.code == code) return o.label;
  }
  return code.toString();
}

// ---------------------------------------------------------------------------
// Step metadata
// ---------------------------------------------------------------------------

IconData stepIcon(OnbStep s) => switch (s) {
      OnbStep.language => Icons.translate,
      OnbStep.body => Icons.accessibility_new,
      OnbStep.bodyFat => Icons.water_drop_outlined,
      OnbStep.measurements => Icons.straighten,
      OnbStep.goal => Icons.flag_outlined,
      OnbStep.level => Icons.trending_up,
      OnbStep.days => Icons.calendar_month,
      OnbStep.sessionLength => Icons.timer_outlined,
      OnbStep.split => Icons.view_week_outlined,
      OnbStep.focus => Icons.center_focus_strong,
      OnbStep.location => Icons.location_on_outlined,
      OnbStep.injuries => Icons.healing_outlined,
      OnbStep.job => Icons.work_outline,
      OnbStep.sleep => Icons.bedtime_outlined,
      OnbStep.trainingTime => Icons.schedule,
      OnbStep.cardio => Icons.directions_run,
      OnbStep.meals => Icons.restaurant,
      OnbStep.foods => Icons.favorite_border,
      OnbStep.budget => Icons.payments_outlined,
      OnbStep.supplements => Icons.medication_outlined,
      OnbStep.water => Icons.local_drink_outlined,
      OnbStep.healthConnect => Icons.watch_outlined,
      OnbStep.apiKey => Icons.key_outlined,
      OnbStep.summary => Icons.fact_check_outlined,
    };

String stepTitle(AppLocalizations l, OnbStep s) => switch (s) {
      OnbStep.language => l.onbLangTitle,
      OnbStep.body => l.onbBodyTitle,
      OnbStep.bodyFat => l.onbBodyFatTitle,
      OnbStep.measurements => l.onbMeasTitle,
      OnbStep.goal => l.onbGoalTitle,
      OnbStep.level => l.onbLevelTitle,
      OnbStep.days => l.onbDaysTitle,
      OnbStep.sessionLength => l.onbSessionTitle,
      OnbStep.split => l.onbSplitTitle,
      OnbStep.focus => l.onbFocusTitle,
      OnbStep.location => l.onbLocationTitle,
      OnbStep.injuries => l.onbInjuriesTitle,
      OnbStep.job => l.onbJobTitle,
      OnbStep.sleep => l.onbSleepTitle,
      OnbStep.trainingTime => l.onbTrainTimeTitle,
      OnbStep.cardio => l.onbCardioTitle,
      OnbStep.meals => l.onbMealsTitle,
      OnbStep.foods => l.onbFoodsTitle,
      OnbStep.budget => l.onbBudgetTitle,
      OnbStep.supplements => l.onbSuppTitle,
      OnbStep.water => l.onbWaterTitle,
      OnbStep.healthConnect => l.onbHealthTitle,
      OnbStep.apiKey => l.onbKeyTitle,
      OnbStep.summary => l.onbSummaryTitle,
    };

String stepSubtitle(AppLocalizations l, OnbStep s) => switch (s) {
      OnbStep.language => l.onbLangSubtitle,
      OnbStep.body => l.onbBodySubtitle,
      OnbStep.bodyFat => l.onbBodyFatSubtitle,
      OnbStep.measurements => l.onbMeasSubtitle,
      OnbStep.goal => l.onbGoalSubtitle,
      OnbStep.level => l.onbLevelSubtitle,
      OnbStep.days => l.onbDaysSubtitle,
      OnbStep.sessionLength => l.onbSessionSubtitle,
      OnbStep.split => l.onbSplitSubtitle,
      OnbStep.focus => l.onbFocusSubtitle,
      OnbStep.location => l.onbLocationSubtitle,
      OnbStep.injuries => l.onbInjuriesSubtitle,
      OnbStep.job => l.onbJobSubtitle,
      OnbStep.sleep => l.onbSleepSubtitle,
      OnbStep.trainingTime => l.onbTrainTimeSubtitle,
      OnbStep.cardio => l.onbCardioSubtitle,
      OnbStep.meals => l.onbMealsSubtitle,
      OnbStep.foods => l.onbFoodsSubtitle,
      OnbStep.budget => l.onbBudgetSubtitle,
      OnbStep.supplements => l.onbSuppSubtitle,
      OnbStep.water => l.onbWaterSubtitle,
      OnbStep.healthConnect => l.onbHealthSubtitle,
      OnbStep.apiKey => l.onbKeySubtitle,
      OnbStep.summary => l.onbSummarySubtitle,
    };

/// Short label used in summary rows.
String stepShortLabel(AppLocalizations l, OnbStep s) => switch (s) {
      OnbStep.language => l.onbSumLanguage,
      OnbStep.body => l.onbSumBody,
      OnbStep.bodyFat => l.onbSumBodyFat,
      OnbStep.measurements => l.onbSumMeasurements,
      OnbStep.goal => l.onbSumGoal,
      OnbStep.level => l.onbSumLevel,
      OnbStep.days => l.onbSumDays,
      OnbStep.sessionLength => l.onbSumSession,
      OnbStep.split => l.onbSumSplit,
      OnbStep.focus => l.onbSumFocus,
      OnbStep.location => l.onbSumLocation,
      OnbStep.injuries => l.onbSumInjuries,
      OnbStep.job => l.onbSumJob,
      OnbStep.sleep => l.onbSumSleep,
      OnbStep.trainingTime => l.onbSumTrainingTime,
      OnbStep.cardio => l.onbSumCardio,
      OnbStep.meals => l.onbSumMeals,
      OnbStep.foods => l.onbSumFoods,
      OnbStep.budget => l.onbSumBudget,
      OnbStep.supplements => l.onbSumSupplements,
      OnbStep.water => l.onbSumWater,
      OnbStep.healthConnect => l.onbSumHealth,
      OnbStep.apiKey => l.onbSumApiKey,
      OnbStep.summary => l.onbSummaryTitle,
    };

String sectionTitle(AppLocalizations l, OnbSection s) => switch (s) {
      OnbSection.basics => l.onbSectionBasics,
      OnbSection.goals => l.onbSectionGoals,
      OnbSection.training => l.onbSectionTraining,
      OnbSection.lifestyle => l.onbSectionLifestyle,
      OnbSection.nutrition => l.onbSectionNutrition,
      OnbSection.connections => l.onbSectionConnections,
    };

String issueText(AppLocalizations l, OnbIssue issue, {int? daysPerWeek}) => switch (issue) {
      OnbIssue.sexRequired => l.onbErrSex,
      OnbIssue.ageRange => l.onbErrAge,
      OnbIssue.heightRange => l.onbErrHeight,
      OnbIssue.weightRange => l.onbErrWeight,
      OnbIssue.bodyFatChoice => l.onbErrBodyFatChoice,
      OnbIssue.bodyFatRange => l.onbErrBodyFat,
      OnbIssue.measurementRange => l.onbErrMeasurement,
      OnbIssue.goalRequired => l.onbErrGoal,
      OnbIssue.targetWeightRange => l.onbErrTargetWeight,
      OnbIssue.goalWeeksRange => l.onbErrWeeks,
      OnbIssue.levelRequired => l.onbErrLevel,
      OnbIssue.daysCountRequired => l.onbErrDaysCount,
      OnbIssue.daysMismatch => l.onbErrDaysMismatch('${daysPerWeek ?? ''}'),
      OnbIssue.choiceRequired => l.onbErrChoose,
      OnbIssue.sleepRequired => l.onbErrSleep,
      OnbIssue.cardioPerWeekRequired => l.onbErrCardioPerWeek,
      OnbIssue.mealTimesMismatch => l.onbErrMealTimes,
      OnbIssue.budgetRange => l.onbErrBudget,
      OnbIssue.suppNameRequired => l.onbErrSuppName,
      OnbIssue.waterRange => l.onbErrWater,
    };

// ---------------------------------------------------------------------------
// Option lists
// ---------------------------------------------------------------------------

List<OnbOption<String>> sexOptions(AppLocalizations l) => [
      OnbOption('male', l.onbSexMale, icon: Icons.male),
      OnbOption('female', l.onbSexFemale, icon: Icons.female),
    ];

List<OnbOption<String>> bodyFatMethodOptions(AppLocalizations l) => [
      OnbOption('number', l.onbBfNumber, subtitle: l.onbBfNumberSub, icon: Icons.percent),
      OnbOption('shape', l.onbBfShape, subtitle: l.onbBfShapeSub, icon: Icons.accessibility),
      OnbOption('unknown', l.onbBfUnknown, subtitle: l.onbBfUnknownSub, icon: Icons.help_outline),
    ];

List<OnbOption<BodyShape>> bodyShapeOptions(AppLocalizations l) => [
      OnbOption(BodyShape.lean, l.onbShapeLean, subtitle: l.onbShapeLeanSub),
      OnbOption(BodyShape.athletic, l.onbShapeAthletic, subtitle: l.onbShapeAthleticSub),
      OnbOption(BodyShape.average, l.onbShapeAverage, subtitle: l.onbShapeAverageSub),
      OnbOption(BodyShape.soft, l.onbShapeSoft, subtitle: l.onbShapeSoftSub),
      OnbOption(BodyShape.heavy, l.onbShapeHeavy, subtitle: l.onbShapeHeavySub),
    ];

String measurementLabel(AppLocalizations l, String key) => switch (key) {
      'waist' => l.onbMeasWaist,
      'chest' => l.onbMeasChest,
      'arm' => l.onbMeasArm,
      'thigh' => l.onbMeasThigh,
      'neck' => l.onbMeasNeck,
      'hips' => l.onbMeasHips,
      _ => key,
    };

List<OnbOption<String>> goalOptions(AppLocalizations l) => [
      OnbOption('bulk', l.onbGoalBulk, subtitle: l.onbGoalBulkSub, icon: Icons.fitness_center),
      OnbOption('cut', l.onbGoalCut, subtitle: l.onbGoalCutSub, icon: Icons.local_fire_department_outlined),
      OnbOption('recomp', l.onbGoalRecomp, subtitle: l.onbGoalRecompSub, icon: Icons.autorenew),
      OnbOption('strength', l.onbGoalStrength, subtitle: l.onbGoalStrengthSub, icon: Icons.bolt),
      OnbOption('fitness', l.onbGoalFitness, subtitle: l.onbGoalFitnessSub, icon: Icons.favorite_outline),
    ];

List<OnbOption<String>> levelOptions(AppLocalizations l) => [
      OnbOption('beginner', l.onbLevelBeginner, subtitle: l.onbLevelBeginnerSub, icon: Icons.signal_cellular_alt_1_bar),
      OnbOption('intermediate', l.onbLevelIntermediate,
          subtitle: l.onbLevelIntermediateSub, icon: Icons.signal_cellular_alt_2_bar),
      OnbOption('advanced', l.onbLevelAdvanced, subtitle: l.onbLevelAdvancedSub, icon: Icons.signal_cellular_alt),
    ];

List<OnbOption<String>> experienceOptions(AppLocalizations l) => [
      OnbOption('none', l.onbExpNone),
      OnbOption('<6m', l.onbExpLt6m),
      OnbOption('6-12m', l.onbExp6to12m),
      OnbOption('1-3y', l.onbExp1to3y),
      OnbOption('3y+', l.onbExp3yPlus),
    ];

const sessionMinuteOptions = [30, 45, 60, 75, 90];

List<OnbOption<String>> splitOptions(AppLocalizations l) => [
      OnbOption('muscle_group', l.onbSplitMuscleGroup, subtitle: l.onbSplitMuscleGroupSub, icon: Icons.grid_view),
      OnbOption('bro', l.onbSplitBro, subtitle: l.onbSplitBroSub, icon: Icons.looks_one_outlined),
      OnbOption('full_body', l.onbSplitFullBody, subtitle: l.onbSplitFullBodySub, icon: Icons.accessibility_new),
      OnbOption('ppl', l.onbSplitPpl, subtitle: l.onbSplitPplSub, icon: Icons.swap_vert),
      OnbOption('upper_lower', l.onbSplitUpperLower, subtitle: l.onbSplitUpperLowerSub, icon: Icons.unfold_more),
      OnbOption('ai', l.onbSplitAi, subtitle: l.onbSplitAiSub, icon: Icons.auto_awesome),
    ];

List<OnbOption<String>> muscleOptions(AppLocalizations l) => [
      OnbOption('chest', l.onbMuscleChest),
      OnbOption('back', l.onbMuscleBack),
      OnbOption('shoulders', l.onbMuscleShoulders),
      OnbOption('biceps', l.onbMuscleBiceps),
      OnbOption('triceps', l.onbMuscleTriceps),
      OnbOption('forearms', l.onbMuscleForearms),
      OnbOption('abdominals', l.onbMuscleAbs),
      OnbOption('quadriceps', l.onbMuscleQuads),
      OnbOption('hamstrings', l.onbMuscleHamstrings),
      OnbOption('glutes', l.onbMuscleGlutes),
      OnbOption('calves', l.onbMuscleCalves),
      OnbOption('traps', l.onbMuscleTraps),
    ];

List<OnbOption<String>> locationOptions(AppLocalizations l) => [
      OnbOption('full_gym', l.onbLocFullGym, subtitle: l.onbLocFullGymSub, icon: Icons.fitness_center),
      OnbOption('limited_gym', l.onbLocLimitedGym, subtitle: l.onbLocLimitedGymSub, icon: Icons.sports_gymnastics),
      OnbOption('home', l.onbLocHome, subtitle: l.onbLocHomeSub, icon: Icons.home_outlined),
    ];

List<OnbOption<String>> jointInjuryOptions(AppLocalizations l) => [
      OnbOption('shoulder', l.onbInjShoulder),
      OnbOption('knee', l.onbInjKnee),
      OnbOption('lower_back', l.onbInjLowerBack),
      OnbOption('elbow', l.onbInjElbow),
      OnbOption('wrist', l.onbInjWrist),
      OnbOption('neck', l.onbInjNeck),
      OnbOption('hip', l.onbInjHip),
      OnbOption('ankle', l.onbInjAnkle),
    ];

List<OnbOption<String>> healthConditionOptions(AppLocalizations l) => [
      OnbOption('hypertension', l.onbInjHypertension),
      OnbOption('diabetes', l.onbInjDiabetes),
      OnbOption('heart', l.onbInjHeart),
      OnbOption('asthma', l.onbInjAsthma),
      OnbOption('hernia', l.onbInjHernia),
    ];

List<OnbOption<String>> jobOptions(AppLocalizations l) => [
      OnbOption('desk', l.onbJobDesk, subtitle: l.onbJobDeskSub, icon: Icons.computer),
      OnbOption('mobile', l.onbJobMobile, subtitle: l.onbJobMobileSub, icon: Icons.directions_walk),
      OnbOption('physical', l.onbJobPhysical, subtitle: l.onbJobPhysicalSub, icon: Icons.construction),
      OnbOption('none', l.onbJobNone, subtitle: l.onbJobNoneSub, icon: Icons.school_outlined),
    ];

List<OnbOption<String>> trainingTimeOptions(AppLocalizations l) => [
      OnbOption('morning', l.onbTimeMorning, icon: Icons.wb_sunny_outlined),
      OnbOption('after_work', l.onbTimeAfterWork, icon: Icons.wb_twilight),
      OnbOption('night', l.onbTimeNight, icon: Icons.nightlight_outlined),
    ];

List<OnbOption<String>> cardioOptions(AppLocalizations l) => [
      OnbOption('none', l.onbCardioNone, icon: Icons.block),
      OnbOption('walking', l.onbCardioWalking, icon: Icons.directions_walk),
      OnbOption('running', l.onbCardioRunning, icon: Icons.directions_run),
      OnbOption('cycling', l.onbCardioCycling, icon: Icons.directions_bike),
      OnbOption('elliptical', l.onbCardioElliptical, icon: Icons.elevator_outlined),
      OnbOption('swimming', l.onbCardioSwimming, icon: Icons.pool),
      OnbOption('hiit', l.onbCardioHiit, icon: Icons.flash_on),
      OnbOption('stairs', l.onbCardioStairs, icon: Icons.stairs_outlined),
      OnbOption('jump_rope', l.onbCardioJumpRope, icon: Icons.cable),
      OnbOption('football', l.onbCardioFootball, icon: Icons.sports_soccer),
    ];

String foodLabel(AppLocalizations l, String code) => switch (code) {
      'ful medames' => l.onbFoodFul,
      'eggs' => l.onbFoodEggs,
      'chicken' => l.onbFoodChicken,
      'tuna' => l.onbFoodTuna,
      'rice' => l.onbFoodRice,
      'baladi bread' => l.onbFoodBaladiBread,
      'yogurt' => l.onbFoodYogurt,
      'cottage cheese' => l.onbFoodCottageCheese,
      'white cheese' => l.onbFoodWhiteCheese,
      'koshari' => l.onbFoodKoshari,
      'minced beef' => l.onbFoodMincedBeef,
      'fish' => l.onbFoodFish,
      'lentils' => l.onbFoodLentils,
      'taameya' => l.onbFoodTaameya,
      'oats' => l.onbFoodOats,
      'pasta' => l.onbFoodPasta,
      'potatoes' => l.onbFoodPotatoes,
      'sweet potato' => l.onbFoodSweetPotato,
      'milk' => l.onbFoodMilk,
      'peanut butter' => l.onbFoodPeanutButter,
      'bananas' => l.onbFoodBananas,
      'dates' => l.onbFoodDates,
      'liver' => l.onbFoodLiver,
      'molokhia' => l.onbFoodMolokhia,
      _ => code,
    };

String allergyLabel(AppLocalizations l, String code) => switch (code) {
      'lactose' => l.onbAllergyLactose,
      'gluten' => l.onbAllergyGluten,
      'nuts' => l.onbAllergyNuts,
      'peanuts' => l.onbAllergyPeanuts,
      'eggs' => l.onbAllergyEggs,
      'seafood' => l.onbAllergySeafood,
      _ => code,
    };

List<OnbOption<String>> budgetOptions(AppLocalizations l) => [
      OnbOption('low', l.onbBudgetLow, subtitle: l.onbBudgetLowSub, icon: Icons.savings_outlined),
      OnbOption('medium', l.onbBudgetMedium, subtitle: l.onbBudgetMediumSub, icon: Icons.account_balance_wallet_outlined),
      OnbOption('open', l.onbBudgetOpen, subtitle: l.onbBudgetOpenSub, icon: Icons.all_inclusive),
      OnbOption('custom', l.onbBudgetCustom, subtitle: l.onbBudgetCustomSub, icon: Icons.edit_outlined),
    ];

String supplementName(AppLocalizations l, String key) => switch (key) {
      'whey' => l.onbSuppWhey,
      'creatine' => l.onbSuppCreatine,
      'mass_gainer' => l.onbSuppMassGainer,
      'casein' => l.onbSuppCasein,
      'multivitamin' => l.onbSuppMultivitamin,
      'omega3' => l.onbSuppOmega3,
      'vitamin_d' => l.onbSuppVitaminD,
      'zma' => l.onbSuppZma,
      'bcaa' => l.onbSuppBcaa,
      'pre_workout' => l.onbSuppPreWorkout,
      'caffeine' => l.onbSuppCaffeine,
      _ => key,
    };

String supplementDefaultDose(AppLocalizations l, SupplementTemplate t) => switch (t.doseKind) {
      'scoop' => l.onbDoseScoop,
      'scoop_plain' => l.onbDoseScoopPlain,
      'gainer' => l.onbDoseGainer,
      'grams5' => l.onbDoseGrams('5'),
      'tablet' => l.onbDoseTablet,
      'capsule' => l.onbDoseCapsule,
      'mg200' => l.onbDoseMg('200'),
      _ => l.onbDoseServing,
    };
