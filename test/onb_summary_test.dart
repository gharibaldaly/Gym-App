import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/features/onboarding/onboarding_logic.dart';
import 'package:ironmind/features/onboarding/onboarding_summary.dart';
import 'package:ironmind/l10n/gen/app_localizations.dart';

import 'onb_fixtures.dart';

void main() {
  final en = lookupAppLocalizations(const Locale('en'));
  final ar = lookupAppLocalizations(const Locale('ar'));

  test('every step except summary appears once, grouped in section order', () {
    final sections = buildProfileSummary(completeProfile(), en);
    final steps = [for (final s in sections) ...s.items.map((i) => i.step)];
    expect(steps.toSet().length, steps.length);
    expect(steps.length, OnbStep.values.length - 1);
    expect(sections.map((s) => s.section).toList(), OnbSection.values);
    for (final s in sections) {
      for (final i in s.items) {
        expect(i.step.section, s.section);
      }
    }
  });

  test('exclude removes steps and empty sections', () {
    final sections =
        buildProfileSummary(completeProfile(), en, exclude: {OnbStep.healthConnect, OnbStep.apiKey});
    expect(sections.any((s) => s.section == OnbSection.connections), isFalse);
  });

  test('complete profile has no invalid rows; blank profile flags required ones', () {
    final ok = buildProfileSummary(completeProfile(), en).expand((s) => s.items);
    expect(ok.where((i) => i.invalid), isEmpty);
    final blank = buildProfileSummary(blankProfile(), en).expand((s) => s.items);
    final invalid = blank.where((i) => i.invalid).map((i) => i.step).toSet();
    expect(invalid, containsAll([OnbStep.body, OnbStep.goal, OnbStep.days, OnbStep.budget]));
    expect(invalid.contains(OnbStep.focus), isFalse);
  });

  test('English values', () {
    final p = completeProfile().copyWithCompanion(UserProfilesCompanion(
      targetWeightKg: const Value(76),
      goalWeeks: const Value(12),
      focusMusclesJson: Value(jsonEncode(['chest', 'glutes'])),
      likedFoods: const Value('eggs, chicken, mango'),
      allergies: const Value('lactose'),
      supplementsJson: Value(encodeSupplements([const SupplementEntry(name: 'Creatine', dose: '5 g')])),
    ));
    String v(OnbStep s) => summaryValue(s, p, en);
    expect(v(OnbStep.body), 'Male · 28 y · 178 cm · 82 kg');
    expect(v(OnbStep.goal), 'Cut · → 76 kg · 12 weeks');
    expect(v(OnbStep.days), contains('Sat'));
    expect(v(OnbStep.days).indexOf('Sat'), lessThan(v(OnbStep.days).indexOf('Tue')));
    expect(v(OnbStep.focus), 'Chest، Glutes');
    expect(v(OnbStep.foods), 'Likes: Eggs، Chicken، mango\nAllergies: Lactose');
    expect(v(OnbStep.supplements), 'Creatine (5 g)');
    expect(v(OnbStep.measurements), en.onbNone);
    expect(v(OnbStep.sleep), startsWith('23:30 → 07:00'));
    expect(v(OnbStep.water), '3250 ml');
    expect(summaryValue(OnbStep.apiKey, p, en, hasApiKey: true), en.onbKeySet);
    expect(summaryValue(OnbStep.apiKey, p, en), en.onbKeyNotSet);
  });

  test('body fat value per method', () {
    final p = completeProfile();
    expect(
        summaryValue(OnbStep.bodyFat,
            p.copyWithCompanion(const UserProfilesCompanion(bodyFatMethod: Value('number'), bodyFatPct: Value(17.5))), en),
        '17.5%');
    expect(
        summaryValue(OnbStep.bodyFat,
            p.copyWithCompanion(const UserProfilesCompanion(bodyFatMethod: Value('shape'), bodyFatPct: Value(20))), en),
        en.onbBodyFatShapeValue('20'));
    expect(summaryValue(OnbStep.bodyFat, p, en), en.onbBfUnknown);
  });

  test('Arabic values use Arabic labels', () {
    final p = completeProfile();
    expect(summaryValue(OnbStep.goal, p, ar), ar.onbGoalCut);
    expect(summaryValue(OnbStep.location, p, ar), ar.onbLocFullGym);
    expect(summaryValue(OnbStep.days, p, ar), contains(ar.weekdaySat));
    expect(summaryValue(OnbStep.budget, p, ar), ar.onbBudgetMedium);
  });

  test('custom budget shows the amount', () {
    final p = completeProfile()
        .copyWithCompanion(const UserProfilesCompanion(budgetLevel: Value(null), budgetEgp: Value(6000)));
    expect(summaryValue(OnbStep.budget, p, en), '6000 EGP');
  });
}
