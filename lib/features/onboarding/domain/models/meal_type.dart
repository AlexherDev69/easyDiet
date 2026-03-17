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
}
