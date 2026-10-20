import 'package:flutter_riverpod/flutter_riverpod.dart';

class DayNutrition {
  final double calories, protein, carbs, fat;
  final double targetCalories, targetProtein, targetCarbs, targetFat;
  const DayNutrition({
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.targetCalories = 0,
    this.targetProtein = 0,
    this.targetCarbs = 0,
    this.targetFat = 0,
  });
  double get remainingCalories => targetCalories - calories;
}

/// Consumed (meals + supplements) vs targets for today.
final todayNutritionProvider = StreamProvider<DayNutrition>((ref) => Stream.value(const DayNutrition()));

/// Registers offline AI-queue handlers owned by nutrition (food photo analysis…).
void registerNutritionAiHandlers() {}
