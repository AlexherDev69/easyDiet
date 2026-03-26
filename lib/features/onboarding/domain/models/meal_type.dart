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
  /// Balanced split: breakfast 25%, lunch 35%, dinner 30%, snack 10%.
  double get calorieShare {
    switch (this) {
      case MealType.breakfast:
        return 0.25;
      case MealType.lunch:
        return 0.35;
      case MealType.dinner:
        return 0.30;
      case MealType.snack:
        return 0.10;
    }
  }
}
