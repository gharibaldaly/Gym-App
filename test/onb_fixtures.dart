import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:ironmind/core/providers.dart';

/// Shared profile fixtures for onboarding tests.
UserProfile blankProfile() => UserProfile(
      id: 1,
      language: 'en',
      measurementsJson: '{}',
      trainingDaysJson: '[]',
      focusMusclesJson: '[]',
      injuriesJson: '[]',
      mealTimesJson: '[]',
      supplementsJson: '[]',
      healthConnectEnabled: false,
      onboardingComplete: false,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

/// A profile that passes every step's validation.
UserProfile completeProfile() => blankProfile().copyWithCompanion(UserProfilesCompanion(
      sex: const Value('male'),
      age: const Value(28),
      heightCm: const Value(178),
      weightKg: const Value(82),
      bodyFatMethod: const Value('unknown'),
      goal: const Value('cut'),
      level: const Value('intermediate'),
      trainingExperience: const Value('1-3y'),
      daysPerWeek: const Value(4),
      trainingDaysJson: Value(jsonEncode([6, 7, 2, 3])),
      sessionMinutes: const Value(60),
      splitPreference: const Value('ppl'),
      location: const Value('full_gym'),
      jobType: const Value('desk'),
      sleepTime: const Value('23:30'),
      wakeTime: const Value('07:00'),
      trainingTimeOfDay: const Value('after_work'),
      trainingTime: const Value('18:00'),
      cardioType: const Value('walking'),
      cardioPerWeek: const Value(3),
      mealsPerDay: const Value(4),
      mealTimesJson: Value(jsonEncode(['08:00', '12:00', '16:00', '20:00'])),
      budgetLevel: const Value('medium'),
      waterGoalMl: const Value(3250),
    ));
