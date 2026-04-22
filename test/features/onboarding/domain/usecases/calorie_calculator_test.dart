import 'package:flutter_test/flutter_test.dart';
import 'package:easydiet/features/onboarding/domain/usecases/calorie_calculator.dart';
import 'package:easydiet/features/onboarding/domain/models/activity_level.dart';
import 'package:easydiet/features/onboarding/domain/models/loss_pace.dart';
import 'package:easydiet/features/onboarding/domain/models/sex.dart';
import 'package:easydiet/core/constants/app_constants.dart';

void main() {
  group('CalorieCalculator', () {
    const calculator = CalorieCalculator();

    // ── BMR ──────────────────────────────────────────────────────────────

    group('calculateBMR', () {
      test('should compute correct BMR for a male reference case', () {
        // 10*80 + 6.25*180 - 5*30 + 5 = 800 + 1125 - 150 + 5 = 1780
        final bmr = calculator.calculateBMR(
          weightKg: 80,
          heightCm: 180,
          age: 30,
          sex: Sex.male,
        );
        expect(bmr, closeTo(1780.0, 0.1));
      });

      test('should compute correct BMR for a female reference case', () {
        // 10*60 + 6.25*165 - 5*25 - 161 = 600 + 1031.25 - 125 - 161 = 1345.25
        final bmr = calculator.calculateBMR(
          weightKg: 60,
          heightCm: 165,
          age: 25,
          sex: Sex.female,
        );
        expect(bmr, closeTo(1345.25, 0.1));
      });

      test('should return lower BMR for female than male given same inputs', () {
        final maleBmr = calculator.calculateBMR(
          weightKg: 70,
          heightCm: 170,
          age: 35,
          sex: Sex.male,
        );
        final femaleBmr = calculator.calculateBMR(
          weightKg: 70,
          heightCm: 170,
          age: 35,
          sex: Sex.female,
        );
        // Male offset = +5, female = -161 → difference = 166
        expect(maleBmr - femaleBmr, closeTo(166.0, 0.01));
      });

      test('should produce lower BMR for an older person all else equal', () {
        final youngBmr = calculator.calculateBMR(
          weightKg: 75,
          heightCm: 175,
          age: 25,
          sex: Sex.male,
        );
        final olderBmr = calculator.calculateBMR(
          weightKg: 75,
          heightCm: 175,
          age: 50,
          sex: Sex.male,
        );
        expect(youngBmr, greaterThan(olderBmr));
      });
    });

    // ── TDEE ─────────────────────────────────────────────────────────────

    group('calculateTDEE', () {
      test('should multiply BMR by sedentary factor 1.2', () {
        final tdee = calculator.calculateTDEE(2000.0, ActivityLevel.sedentary);
        expect(tdee, closeTo(2400.0, 0.1));
      });

      test('should multiply BMR by lightlyActive factor 1.375', () {
        final tdee =
            calculator.calculateTDEE(2000.0, ActivityLevel.lightlyActive);
        expect(tdee, closeTo(2750.0, 0.1));
      });

      test('should multiply BMR by moderatelyActive factor 1.55', () {
        final tdee =
            calculator.calculateTDEE(2000.0, ActivityLevel.moderatelyActive);
        expect(tdee, closeTo(3100.0, 0.1));
      });

      test('should multiply BMR by active factor 1.725', () {
        final tdee = calculator.calculateTDEE(2000.0, ActivityLevel.active);
        expect(tdee, closeTo(3450.0, 0.1));
      });
    });

    // ── Daily target ──────────────────────────────────────────────────────

    group('calculateDailyTarget', () {
      test('should subtract gentle deficit (350 kcal) from TDEE', () {
        // Male, 80kg, 180cm, 30y, sedentary → BMR=1780, TDEE=2136, target=1786
        final target = calculator.calculateDailyTarget(
          weightKg: 80,
          heightCm: 180,
          age: 30,
          sex: Sex.male,
          activityLevel: ActivityLevel.sedentary,
          lossPace: LossPace.gentle,
        );
        final expectedBmr = calculator.calculateBMR(
          weightKg: 80,
          heightCm: 180,
          age: 30,
          sex: Sex.male,
        );
        final expectedTdee =
            calculator.calculateTDEE(expectedBmr, ActivityLevel.sedentary);
        final expectedTarget = (expectedTdee - LossPace.gentle.deficitKcal).round();
        expect(target, expectedTarget);
      });

      test('should subtract moderate deficit (500 kcal) from TDEE', () {
        final target = calculator.calculateDailyTarget(
          weightKg: 70,
          heightCm: 170,
          age: 35,
          sex: Sex.female,
          activityLevel: ActivityLevel.moderatelyActive,
          lossPace: LossPace.moderate,
        );
        final bmr = calculator.calculateBMR(
          weightKg: 70,
          heightCm: 170,
          age: 35,
          sex: Sex.female,
        );
        final tdee = calculator.calculateTDEE(bmr, ActivityLevel.moderatelyActive);
        final expectedTarget = (tdee - 500).round();
        expect(target, expectedTarget);
      });

      test('should subtract fast deficit (750 kcal) from TDEE', () {
        final target = calculator.calculateDailyTarget(
          weightKg: 90,
          heightCm: 185,
          age: 40,
          sex: Sex.male,
          activityLevel: ActivityLevel.active,
          lossPace: LossPace.fast,
        );
        final bmr = calculator.calculateBMR(
          weightKg: 90,
          heightCm: 185,
          age: 40,
          sex: Sex.male,
        );
        final tdee = calculator.calculateTDEE(bmr, ActivityLevel.active);
        final expectedTarget = (tdee - 750).round();
        expect(target, expectedTarget);
      });

      test(
          'should clamp to minimum 1500 kcal when deficit would drop male target below',
          () {
        // Small sedentary male with large deficit → must not go below 1500
        final target = calculator.calculateDailyTarget(
          weightKg: 55,
          heightCm: 160,
          age: 60,
          sex: Sex.male,
          activityLevel: ActivityLevel.sedentary,
          lossPace: LossPace.fast,
        );
        expect(target, greaterThanOrEqualTo(AppConstants.minCaloriesMale));
      });

      test(
          'should clamp to minimum 1200 kcal when deficit would drop female target below',
          () {
        final target = calculator.calculateDailyTarget(
          weightKg: 45,
          heightCm: 150,
          age: 65,
          sex: Sex.female,
          activityLevel: ActivityLevel.sedentary,
          lossPace: LossPace.fast,
        );
        expect(target, greaterThanOrEqualTo(AppConstants.minCaloriesFemale));
      });

      test('should not clamp when calculated target is above minimum', () {
        // Active male, large build → target should be well above 1500
        final target = calculator.calculateDailyTarget(
          weightKg: 100,
          heightCm: 190,
          age: 25,
          sex: Sex.male,
          activityLevel: ActivityLevel.active,
          lossPace: LossPace.gentle,
        );
        expect(target, greaterThan(AppConstants.minCaloriesMale + 100));
      });

      test('should produce lower target for female than male given same inputs',
          () {
        final shared = (
          weightKg: 70.0,
          heightCm: 170,
          age: 30,
          activityLevel: ActivityLevel.moderatelyActive,
          lossPace: LossPace.moderate,
        );
        final male = calculator.calculateDailyTarget(
          weightKg: shared.weightKg,
          heightCm: shared.heightCm,
          age: shared.age,
          sex: Sex.male,
          activityLevel: shared.activityLevel,
          lossPace: shared.lossPace,
        );
        final female = calculator.calculateDailyTarget(
          weightKg: shared.weightKg,
          heightCm: shared.heightCm,
          age: shared.age,
          sex: Sex.female,
          activityLevel: shared.activityLevel,
          lossPace: shared.lossPace,
        );
        expect(male, greaterThan(female));
      });
    });

    // ── Daily water ───────────────────────────────────────────────────────

    group('calculateDailyWater', () {
      test('should be 1 mL per kcal of TDEE rounded to nearest 100', () {
        // Male, 80kg, 180cm, 30y, sedentary → TDEE≈2136
        // waterMl = 2136 → round(2136/100)*100 = 2100
        final water = calculator.calculateDailyWater(
          weightKg: 80,
          heightCm: 180,
          age: 30,
          sex: Sex.male,
          activityLevel: ActivityLevel.sedentary,
        );
        // Result must be a multiple of 100
        expect(water % 100, equals(0));
      });

      test('should clamp to male minimum of 2500 mL for very sedentary case',
          () {
        final water = calculator.calculateDailyWater(
          weightKg: 50,
          heightCm: 155,
          age: 70,
          sex: Sex.male,
          activityLevel: ActivityLevel.sedentary,
        );
        expect(water, greaterThanOrEqualTo(AppConstants.minWaterMlMale));
        expect(water, lessThanOrEqualTo(AppConstants.maxWaterMlMale));
      });

      test('should clamp to female minimum of 2000 mL for very sedentary case',
          () {
        final water = calculator.calculateDailyWater(
          weightKg: 40,
          heightCm: 145,
          age: 75,
          sex: Sex.female,
          activityLevel: ActivityLevel.sedentary,
        );
        expect(water, greaterThanOrEqualTo(AppConstants.minWaterMlFemale));
        expect(water, lessThanOrEqualTo(AppConstants.maxWaterMlFemale));
      });

      test('should not exceed male maximum of 3300 mL for very active case',
          () {
        final water = calculator.calculateDailyWater(
          weightKg: 120,
          heightCm: 200,
          age: 20,
          sex: Sex.male,
          activityLevel: ActivityLevel.active,
        );
        expect(water, lessThanOrEqualTo(AppConstants.maxWaterMlMale));
      });

      test('should not exceed female maximum of 2800 mL for very active case',
          () {
        final water = calculator.calculateDailyWater(
          weightKg: 100,
          heightCm: 185,
          age: 20,
          sex: Sex.female,
          activityLevel: ActivityLevel.active,
        );
        expect(water, lessThanOrEqualTo(AppConstants.maxWaterMlFemale));
      });

      test('should return a higher water amount for an active person than a sedentary one',
          () {
        final sedentaryWater = calculator.calculateDailyWater(
          weightKg: 70,
          heightCm: 170,
          age: 30,
          sex: Sex.male,
          activityLevel: ActivityLevel.sedentary,
        );
        final activeWater = calculator.calculateDailyWater(
          weightKg: 70,
          heightCm: 170,
          age: 30,
          sex: Sex.male,
          activityLevel: ActivityLevel.active,
        );
        expect(activeWater, greaterThanOrEqualTo(sedentaryWater));
      });
    });
  });
}
