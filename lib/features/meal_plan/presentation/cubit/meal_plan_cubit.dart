import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../../../data/local/database.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../../data/local/models/week_plan_with_days.dart';
import '../../../onboarding/domain/models/meal_type.dart';
import '../../../recipes/domain/repositories/recipe_repository.dart';
import '../../../settings/domain/repositories/user_profile_repository.dart';
import '../../domain/repositories/meal_plan_repository.dart';
import '../../domain/usecases/meal_plan_generator.dart';
import 'meal_plan_state.dart';

/// Manages the weekly meal plan screen — port of MealPlanViewModel.kt.
class MealPlanCubit extends Cubit<MealPlanState> {
  MealPlanCubit({
    required MealPlanRepository mealPlanRepository,
    required UserProfileRepository userProfileRepository,
    required RecipeRepository recipeRepository,
    required MealPlanGenerator mealPlanGenerator,
  })  : _mealPlanRepository = mealPlanRepository,
        _userProfileRepository = userProfileRepository,
        _recipeRepository = recipeRepository,
        _mealPlanGenerator = mealPlanGenerator,
        super(const MealPlanState()) {
    _loadWeekPlan();
  }

  final MealPlanRepository _mealPlanRepository;
  final UserProfileRepository _userProfileRepository;
  final RecipeRepository _recipeRepository;
  final MealPlanGenerator _mealPlanGenerator;

  StreamSubscription<WeekPlanWithDays?>? _planSubscription;

  // ── Public actions ──────────────────────────────────────────────────

  void selectDay(int index) {
    emit(state.copyWith(selectedDayIndex: index));
  }

  Future<void> regenerateWeekPlan() async {
    emit(state.copyWith(isRegenerating: true));
    final profile = await _userProfileRepository.getProfile();
    if (profile == null) return;
    await _mealPlanRepository.deleteWeekPlans();
    await _mealPlanGenerator.generateWeekPlan(profile);
    emit(state.copyWith(isRegenerating: false));
  }

  Future<void> toggleMealConsumed(int mealId, bool currentlyConsumed) async {
    await _mealPlanRepository.toggleMealConsumed(mealId, !currentlyConsumed);
  }

  Future<void> shiftByOneDay() async {
    await _mealPlanRepository.shiftProgramByOneDay();
  }

  // ── Swap dialog ───────────────────────────────────────────────────

  Future<void> openSwapDialog(Meal meal) async {
    final profile = await _userProfileRepository.getProfile();
    if (profile == null) return;
    final weekPlan = state.weekPlan;
    if (weekPlan == null) return;

    final mealType = _parseMealType(meal.mealType);
    if (mealType == null) return;

    final alternatives = await _mealPlanGenerator.getAlternativeRecipes(
      meal.recipeId,
      mealType,
      profile,
    );

    final todayMillis = AppDateUtils.todayMillis();
    final otherOccurrences = weekPlan.days
        .where((d) => d.dayPlan.date >= todayMillis)
        .expand((d) => d.meals)
        .where((m) => m.meal.id != meal.id && m.meal.recipeId == meal.recipeId)
        .length;

    emit(state.copyWith(
      swapDialogMeal: meal,
      swapAlternatives: alternatives,
      swapOtherOccurrencesCount: otherOccurrences,
    ));
  }

  void closeSwapDialog() {
    emit(state.copyWith(clearSwapDialog: true));
  }

  Future<void> swapMeal(Recipe newRecipe, {required bool replaceAll}) async {
    final meal = state.swapDialogMeal;
    final weekPlan = state.weekPlan;
    if (meal == null || weekPlan == null) return;

    final profile = await _userProfileRepository.getProfile();
    if (profile == null) return;

    final todayMillis = AppDateUtils.todayMillis();

    final mealsToUpdate = replaceAll
        ? weekPlan.days
            .where((d) => d.dayPlan.date >= todayMillis)
            .expand((d) => d.meals)
            .where((m) => m.meal.recipeId == meal.recipeId)
            .map((m) => m.meal)
            .toList()
        : [meal];

    for (final m in mealsToUpdate) {
      final mealType = _parseMealType(m.mealType);
      if (mealType == null) continue;
      final servings = _mealPlanGenerator.calculateServings(
        newRecipe,
        profile.dailyCalorieTarget,
        mealType,
      );
      await _mealPlanRepository.updateMeal(
        m.copyWith(recipeId: newRecipe.id, servings: servings),
      );
    }
    closeSwapDialog();
  }

  // ── Move dialog ───────────────────────────────────────────────────

  void openMoveDialog(MealWithRecipe meal, int sourceDayPlanId) {
    final weekPlan = state.weekPlan;
    if (weekPlan == null) return;

    final targetDays = weekPlan.days
        .where((d) => !d.dayPlan.isFreeDay && d.dayPlan.id != sourceDayPlanId)
        .toList()
      ..sort((a, b) => a.dayPlan.date.compareTo(b.dayPlan.date));

    emit(state.copyWith(
      showMoveDialog: true,
      movingMeal: meal,
      movingSourceDayPlanId: sourceDayPlanId,
      moveTargetDays: targetDays,
    ));
  }

  void closeMoveDialog() {
    emit(state.copyWith(clearMoveDialog: true));
  }

  Future<void> moveMealToDay(int targetDayPlanId) async {
    final meal = state.movingMeal;
    if (meal == null) return;
    await _mealPlanRepository.swapMealsBetweenDays(
      meal.meal.id,
      targetDayPlanId,
    );
    closeMoveDialog();
  }

  // ── Export JSON ───────────────────────────────────────────────────

  Future<String> exportWeekPlanJson() async {
    final weekPlan = state.weekPlan;
    if (weekPlan == null) return '';

    final sorted = state.sortedDays;
    final daysJson = <Map<String, dynamic>>[];

    for (final day in sorted) {
      daysJson.add(await _buildDayPlanJson(day));
    }

    // Week totals
    var totalCal = 0;
    var totalProt = 0.0;
    var totalCarbs = 0.0;
    var totalFat = 0.0;
    var dietDays = 0;

    for (final day in sorted) {
      if (day.dayPlan.isFreeDay) continue;
      dietDays++;
      for (final m in day.meals) {
        totalCal += (m.recipe.caloriesPerServing * m.meal.servings).round();
        totalProt += m.recipe.proteinGrams * m.meal.servings;
        totalCarbs += m.recipe.carbsGrams * m.meal.servings;
        totalFat += m.recipe.fatGrams * m.meal.servings;
      }
    }

    final root = <String, dynamic>{
      'weekPlan': daysJson,
      'weekTotals': {
        'dietDays': dietDays,
        'totalCalories': totalCal,
        if (dietDays > 0) 'avgCaloriesPerDay': totalCal ~/ dietDays,
        'totalProteinGrams': totalProt.toStringAsFixed(1),
        'totalCarbsGrams': totalCarbs.toStringAsFixed(1),
        'totalFatGrams': totalFat.toStringAsFixed(1),
      },
    };

    return const JsonEncoder.withIndent('  ').convert(root);
  }

  // ── Private ───────────────────────────────────────────────────────

  void _loadWeekPlan() {
    _planSubscription =
        _mealPlanRepository.watchCurrentWeekPlan().listen((plan) {
      emit(state.copyWith(weekPlan: plan, isLoading: false));
    });
  }

  Future<Map<String, dynamic>> _buildDayPlanJson(
    dynamic dayPlanWithMeals,
  ) async {
    final dayPlan = dayPlanWithMeals.dayPlan;
    final meals = dayPlanWithMeals.meals as List<MealWithRecipe>;
    final date = AppDateUtils.fromEpochMillis(dayPlan.date);

    const mealOrder = ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK'];
    final sorted = List.of(meals)
      ..sort(
        (a, b) => mealOrder
            .indexOf(a.meal.mealType)
            .compareTo(mealOrder.indexOf(b.meal.mealType)),
      );

    final mealsJson = <Map<String, dynamic>>[];
    for (final mealWithRecipe in sorted) {
      final mealTypeFr = _frenchMealType(mealWithRecipe.meal.mealType);
      final recipe = mealWithRecipe.recipe;
      final servings = mealWithRecipe.meal.servings;

      final recipeJson = <String, dynamic>{
        'name': recipe.name,
        'caloriesPerServing': recipe.caloriesPerServing,
        'totalCalories': (recipe.caloriesPerServing * servings).round(),
        'proteinGrams':
            (recipe.proteinGrams * servings).toStringAsFixed(1),
        'carbsGrams': (recipe.carbsGrams * servings).toStringAsFixed(1),
        'fatGrams': (recipe.fatGrams * servings).toStringAsFixed(1),
        'prepTimeMinutes': recipe.prepTimeMinutes,
        'cookTimeMinutes': recipe.cookTimeMinutes,
      };

      // Load ingredients for this recipe
      final details =
          await _recipeRepository.getRecipeWithDetails(recipe.id);
      if (details != null) {
        final multiplier = servings / recipe.servings;
        recipeJson['ingredients'] = details.ingredients.map((ing) {
          return {
            'name': ing.name,
            'quantity':
                QuantityFormatter.format(ing.quantity * multiplier),
            'unit': ing.unit,
          };
        }).toList();
        recipeJson['steps'] = (List.of(details.steps)
              ..sort(
                  (a, b) => a.stepNumber.compareTo(b.stepNumber)))
            .map((s) => s.instruction)
            .toList();
      }

      mealsJson.add({
        'type': mealTypeFr,
        'servings': QuantityFormatter.format(servings),
        'recipe': recipeJson,
      });
    }

    final totalCal =
        sorted.fold<int>(0, (s, m) => s + (m.recipe.caloriesPerServing * m.meal.servings).round());
    final totalP =
        sorted.fold<double>(0, (s, m) => s + m.recipe.proteinGrams * m.meal.servings);
    final totalC =
        sorted.fold<double>(0, (s, m) => s + m.recipe.carbsGrams * m.meal.servings);
    final totalF =
        sorted.fold<double>(0, (s, m) => s + m.recipe.fatGrams * m.meal.servings);

    return {
      'date': date.toIso8601String().split('T').first,
      'dayOfWeek': AppDateUtils.getDayOfWeekFrench(date.weekday),
      'isFreeDay': dayPlan.isFreeDay,
      'meals': mealsJson,
      'totals': {
        'calories': totalCal,
        'proteinGrams': totalP.toStringAsFixed(1),
        'carbsGrams': totalC.toStringAsFixed(1),
        'fatGrams': totalF.toStringAsFixed(1),
      },
    };
  }

  String _frenchMealType(String raw) {
    switch (raw) {
      case 'BREAKFAST':
        return 'Petit-dejeuner';
      case 'LUNCH':
        return 'Dejeuner';
      case 'DINNER':
        return 'Diner';
      case 'SNACK':
        return 'Collation';
      default:
        return raw;
    }
  }

  MealType? _parseMealType(String raw) {
    try {
      return MealType.values.firstWhere(
        (t) => t.name.toUpperCase() == raw,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> close() {
    _planSubscription?.cancel();
    return super.close();
  }
}
