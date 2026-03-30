import '../../../../core/constants/app_constants.dart';

enum MealType {
  breakfast('Petit-dejeuner'),
  lunch('Dejeuner'),
  dinner('Diner'),
  snack('Collation');

  const MealType(this.displayName);
  final String displayName;

  /// Maps to the category name used in recipes.json
  String get categoryKey {
    switch (this) {
      case MealType.breakfast:
        return 'BREAKFAST';
      case MealType.lunch:
        return 'LUNCH';
      case MealType.dinner:
        return 'DINNER';
      case MealType.snack:
        return 'SNACK';
    }
  }

  /// Fraction of daily calorie target allocated to this meal slot.
  double get calorieShare {
    switch (this) {
      case MealType.breakfast:
        return AppConstants.calorieShareBreakfast;
      case MealType.lunch:
        return AppConstants.calorieShareLunch;
      case MealType.dinner:
        return AppConstants.calorieShareDinner;
      case MealType.snack:
        return AppConstants.calorieShareSnack;
    }
  }
}
