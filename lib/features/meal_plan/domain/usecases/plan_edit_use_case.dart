import '../../../../data/local/database.dart';
import '../../../../data/local/models/day_plan_with_meals.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../../data/local/models/week_plan_with_days.dart';
import '../../../onboarding/domain/models/meal_type.dart';
import '../../../settings/domain/repositories/user_profile_repository.dart';
import '../repositories/meal_plan_repository.dart';
import 'meal_plan_generator.dart';
import 'servings_calculator.dart';

/// Data returned by [PlanEditUseCase.getReplaceDialogData].
class PlanReplaceDialogData {
  const PlanReplaceDialogData({
    required this.candidates,
    required this.otherOccurrencesCount,
  });

  final List<Recipe> candidates;
  final int otherOccurrencesCount;
}

/// Encapsulates move-meal and replace-recipe operations shared between
/// [OnboardingCubit] and [PlanPreviewCubit].
class PlanEditUseCase {
  const PlanEditUseCase({
    required MealPlanRepository mealPlanRepository,
    required MealPlanGenerator mealPlanGenerator,
    required UserProfileRepository userProfileRepository,
  })  : _mealPlanRepository = mealPlanRepository,
        _mealPlanGenerator = mealPlanGenerator,
        _userProfileRepository = userProfileRepository;

  final MealPlanRepository _mealPlanRepository;
  final MealPlanGenerator _mealPlanGenerator;
  final UserProfileRepository _userProfileRepository;

  /// Returns the days the user can move [meal] to (non-free, not the source).
  List<DayPlanWithMeals> getMovableTargetDays(
    WeekPlanWithDays weekPlan,
    int sourceDayPlanId,
  ) {
    return weekPlan.days
        .where((d) => !d.dayPlan.isFreeDay && d.dayPlan.id != sourceDayPlanId)
        .toList()
      ..sort((a, b) => a.dayPlan.date.compareTo(b.dayPlan.date));
  }

  /// Swaps [mealId] with the corresponding meal on [targetDayPlanId],
  /// then returns the refreshed week plan.
  Future<WeekPlanWithDays?> moveMealToDay(
    int mealId,
    int targetDayPlanId,
  ) async {
    await _mealPlanRepository.swapMealsBetweenDays(mealId, targetDayPlanId);
    return _mealPlanRepository.getCurrentWeekPlan();
  }

  /// Fetches replacement candidates and counts other occurrences of the recipe.
  Future<PlanReplaceDialogData> getReplaceDialogData(
    MealWithRecipe meal,
    WeekPlanWithDays weekPlan,
  ) async {
    final profile = await _userProfileRepository.getProfile();
    if (profile == null) {
      return const PlanReplaceDialogData(
        candidates: [],
        otherOccurrencesCount: 0,
      );
    }

    final usedRecipeIds =
        weekPlan.days.expand((d) => d.meals).map((m) => m.recipe.id).toSet();

    final candidates = await _mealPlanGenerator.getCompatibleReplacements(
      meal.recipe.category,
      usedRecipeIds,
      profile,
    );

    final otherOccurrences = weekPlan.days
        .expand((d) => d.meals)
        .where((m) => m.meal.id != meal.meal.id && m.recipe.id == meal.recipe.id)
        .length;

    return PlanReplaceDialogData(
      candidates: candidates,
      otherOccurrencesCount: otherOccurrences,
    );
  }

  /// Replaces the recipe on [currentMeal] (and optionally all occurrences)
  /// with [newRecipe], then returns the refreshed week plan.
  Future<WeekPlanWithDays?> replaceRecipe(
    MealWithRecipe currentMeal,
    WeekPlanWithDays weekPlan,
    Recipe newRecipe, {
    required bool replaceAll,
  }) async {
    final profile = await _userProfileRepository.getProfile();
    if (profile == null) return null;

    final mealType = MealType.values.firstWhere(
      (m) => m.name.toUpperCase() == currentMeal.meal.mealType,
      orElse: () => MealType.lunch,
    );

    final mealsToUpdate = replaceAll
        ? weekPlan.days
            .expand((d) => d.meals)
            .where((m) => m.recipe.id == currentMeal.recipe.id)
            .map((m) => m.meal)
            .toList()
        : [currentMeal.meal];

    for (final meal in mealsToUpdate) {
      final type = MealType.values.firstWhere(
        (m) => m.name.toUpperCase() == meal.mealType,
        orElse: () => mealType,
      );
      final servings = ServingsCalculator.calculate(
        newRecipe,
        profile.dailyCalorieTarget,
        type,
      );
      await _mealPlanRepository.updateMeal(
        meal.copyWith(recipeId: newRecipe.id, servings: servings),
      );
    }

    return _mealPlanRepository.getCurrentWeekPlan();
  }
}
