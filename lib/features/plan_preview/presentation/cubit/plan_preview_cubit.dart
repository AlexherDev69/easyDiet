import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/local/database.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../meal_plan/domain/repositories/meal_plan_repository.dart';
import '../../../meal_plan/domain/usecases/meal_plan_generator.dart';
import '../../../onboarding/domain/models/meal_type.dart';
import '../../../settings/domain/repositories/user_profile_repository.dart';
import '../../../shopping/domain/usecases/shopping_list_generator.dart';
import 'plan_preview_state.dart';

/// Manages the standalone plan preview — port of PlanPreviewViewModel.kt.
class PlanPreviewCubit extends Cubit<PlanPreviewState> {
  PlanPreviewCubit({
    required MealPlanRepository mealPlanRepository,
    required MealPlanGenerator mealPlanGenerator,
    required UserProfileRepository userProfileRepository,
    required ShoppingListGenerator shoppingListGenerator,
  })  : _mealPlanRepository = mealPlanRepository,
        _mealPlanGenerator = mealPlanGenerator,
        _userProfileRepository = userProfileRepository,
        _shoppingListGenerator = shoppingListGenerator,
        super(const PlanPreviewState()) {
    _generateNewPlan();
  }

  final MealPlanRepository _mealPlanRepository;
  final MealPlanGenerator _mealPlanGenerator;
  final UserProfileRepository _userProfileRepository;
  final ShoppingListGenerator _shoppingListGenerator;

  Future<void> _generateNewPlan() async {
    try {
      emit(state.copyWith(isLoading: true));
      final profile = await _userProfileRepository.getProfile();
      if (profile == null) return;

      await _mealPlanRepository.deleteWeekPlans();
      await _mealPlanGenerator.generateWeekPlan(profile);

      final weekPlan = await _mealPlanRepository.getCurrentWeekPlan();
      emit(state.copyWith(isLoading: false, weekPlan: weekPlan));
    } catch (e) {
      debugPrint('Error in _generateNewPlan: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> confirmPlan() async {
    try {
      emit(state.copyWith(isLoading: true));
      final profile = await _userProfileRepository.getProfile();
      final weekPlan = await _mealPlanRepository.getCurrentWeekPlan();
      if (weekPlan != null) {
        await _shoppingListGenerator.generateShoppingList(
          weekPlan,
          shoppingTripsPerWeek: profile?.shoppingTripsPerWeek ?? 1,
        );
      }
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      debugPrint('Error in confirmPlan: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  // ── Move meal between days ──────────────────────────────────────

  void openMoveMealDialog(MealWithRecipe meal, int sourceDayPlanId) {
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

  void dismissMoveDialog() {
    emit(state.copyWith(
      showMoveDialog: false,
      moveTargetDays: const [],
    ));
  }

  Future<void> moveMealToDay(int targetDayPlanId) async {
    try {
      final meal = state.movingMeal;
      if (meal == null) return;

      await _mealPlanRepository.swapMealsBetweenDays(
          meal.meal.id, targetDayPlanId);
      final updatedPlan = await _mealPlanRepository.getCurrentWeekPlan();
      emit(state.copyWith(
        weekPlan: updatedPlan,
        showMoveDialog: false,
        moveTargetDays: const [],
      ));
    } catch (e) {
      debugPrint('Error in moveMealToDay: $e');
    }
  }

  // ── Replace recipe ──────────────────────────────────────────────

  Future<void> openReplaceDialog(MealWithRecipe meal) async {
    try {
      final profile = await _userProfileRepository.getProfile();
      if (profile == null) return;
      final weekPlan = state.weekPlan;
      if (weekPlan == null) return;

      final usedRecipeIds = weekPlan.days
          .expand((d) => d.meals)
          .map((m) => m.recipe.id)
          .toSet();

      final candidates = await _mealPlanGenerator.getCompatibleReplacements(
        meal.recipe.category,
        usedRecipeIds,
        profile,
      );

      final otherOccurrences = weekPlan.days
          .expand((d) => d.meals)
          .where((m) => m.meal.id != meal.meal.id && m.recipe.id == meal.recipe.id)
          .length;

      emit(state.copyWith(
        showReplaceDialog: true,
        replacingMeal: meal,
        replacementCandidates: candidates,
        otherOccurrencesCount: otherOccurrences,
      ));
    } catch (e) {
      debugPrint('Error in openReplaceDialog: $e');
    }
  }

  void dismissReplaceDialog() {
    emit(state.copyWith(
      showReplaceDialog: false,
      replacementCandidates: const [],
      otherOccurrencesCount: 0,
    ));
  }

  Future<void> replaceRecipe(Recipe newRecipe, bool replaceAll) async {
    try {
      final currentMeal = state.replacingMeal;
      final weekPlan = state.weekPlan;
      if (currentMeal == null || weekPlan == null) return;

      final profile = await _userProfileRepository.getProfile();
      if (profile == null) return;

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
        final servings = _mealPlanGenerator.calculateServings(
          newRecipe,
          profile.dailyCalorieTarget,
          type,
        );
        await _mealPlanRepository.updateMeal(
          Meal(
            id: meal.id,
            dayPlanId: meal.dayPlanId,
            mealType: meal.mealType,
            recipeId: newRecipe.id,
            servings: servings,
            isConsumed: meal.isConsumed,
          ),
        );
      }

      final updatedPlan = await _mealPlanRepository.getCurrentWeekPlan();
      emit(state.copyWith(
        weekPlan: updatedPlan,
        showReplaceDialog: false,
        replacementCandidates: const [],
        otherOccurrencesCount: 0,
      ));
    } catch (e) {
      debugPrint('Error in replaceRecipe: $e');
    }
  }
}
