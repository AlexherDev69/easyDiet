import 'dart:math';

import '../../../../core/constants/app_constants.dart';
import '../models/activity_level.dart';
import '../models/loss_pace.dart';
import '../models/sex.dart';

/// Mifflin-St Jeor calorie calculator with TDEE and water intake.
class CalorieCalculator {
  const CalorieCalculator();

  /// Basal Metabolic Rate (Mifflin-St Jeor).
  double calculateBMR({
    required double weightKg,
    required int heightCm,
    required int age,
    required Sex sex,
  }) {
    final base = 10.0 * weightKg + 6.25 * heightCm - 5.0 * age;
    return switch (sex) {
      Sex.male => base + 5.0,
      Sex.female => base - 161.0,
    };
  }

  /// Total Daily Energy Expenditure.
  double calculateTDEE(double bmr, ActivityLevel activityLevel) {
    return bmr * activityLevel.factor;
  }

  /// Daily calorie target with deficit, clamped to sex-specific minimums.
  int calculateDailyTarget({
    required double weightKg,
    required int heightCm,
    required int age,
    required Sex sex,
    required ActivityLevel activityLevel,
    required LossPace lossPace,
  }) {
    final bmr = calculateBMR(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      sex: sex,
    );
    final tdee = calculateTDEE(bmr, activityLevel);
    final target = tdee - lossPace.deficitKcal;

    final minimum = switch (sex) {
      Sex.male => AppConstants.minCaloriesMale,
      Sex.female => AppConstants.minCaloriesFemale,
    };

    return max(target.round(), minimum);
  }

  /// Daily water intake in mL (EFSA/IOM approach: 1 mL per kcal TDEE).
  int calculateDailyWater({
    required double weightKg,
    required int heightCm,
    required int age,
    required Sex sex,
    required ActivityLevel activityLevel,
  }) {
    final bmr = calculateBMR(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      sex: sex,
    );
    final tdee = calculateTDEE(bmr, activityLevel);
    final waterMl = tdee * AppConstants.waterMlPerKcal;

    final rounded = (waterMl / 100.0).round() * 100;

    final (minWater, maxWater) = switch (sex) {
      Sex.male => (AppConstants.minWaterMlMale, AppConstants.maxWaterMlMale),
      Sex.female => (
        AppConstants.minWaterMlFemale,
        AppConstants.maxWaterMlFemale,
      ),
    };

    return rounded.clamp(minWater, maxWater);
  }
}
