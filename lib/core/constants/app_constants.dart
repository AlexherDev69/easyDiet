class AppConstants {
  AppConstants._();

  static const int minCaloriesMale = 1500;
  static const int minCaloriesFemale = 1200;
  static const double kcalPerKgFat = 7700.0;
  static const double calorieTolerancePercent = 0.10;
  static const int daysInWeek = 7;
  static const double waterMlPerKcal = 1.0;
  static const int minWaterMlMale = 2500;
  static const int maxWaterMlMale = 3300;
  static const int minWaterMlFemale = 2000;
  static const int maxWaterMlFemale = 2800;

  // Calorie share per meal slot (must sum to 1.0)
  static const double calorieShareBreakfast = 0.25;
  static const double calorieShareLunch = 0.35;
  static const double calorieShareDinner = 0.30;
  static const double calorieShareSnack = 0.10;

  // Servings limits
  static const double maxServingsMeal = 3.0;
  static const double maxServingsSnack = 2.0;
}
