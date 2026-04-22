import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/local/database.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../meal_plan/domain/repositories/meal_plan_repository.dart';
import '../../../meal_plan/domain/usecases/meal_plan_generator.dart';
import '../../../meal_plan/domain/usecases/plan_edit_use_case.dart';
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
    required PlanEditUseCase planEditUseCase,
  })  : _mealPlanRepository = mealPlanRepository,
        _mealPlanGenerator = mealPlanGenerator,
        _userProfileRepository = userProfileRepository,
        _shoppingListGenerator = shoppingListGenerator,
        _planEditUseCase = planEditUseCase,
        super(const PlanPreviewState()) {
    _generateNewPlan();
  }

  final MealPlanRepository _mealPlanRepository;
  final MealPlanGenerator _mealPlanGenerator;
  final UserProfileRepository _userProfileRepository;
  final ShoppingListGenerator _shoppingListGenerator;
  final PlanEditUseCase _planEditUseCase;

  /// Minimum time the generation loading animation stays visible, to let
  /// the progress bar run to completion even when generation is fast.
  static const _minGenerationAnimationDuration = Duration(milliseconds: 6500);

  Future<void> _generateNewPlan() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    final minDelay = Future<void>.delayed(_minGenerationAnimationDuration);
    try {
      final profile = await _userProfileRepository.getProfile();
      if (profile == null) {
        await minDelay;
        emit(state.copyWith(isLoading: false));
        return;
      }

      // week_plans.week_start_date has a UNIQUE constraint, so we must drop
      // the existing plan before generating a new one.
      await _mealPlanRepository.deleteWeekPlans();
      await _mealPlanGenerator.generateWeekPlan(profile);

      final weekPlan = await _mealPlanRepository.getCurrentWeekPlan();
      await minDelay;
      emit(state.copyWith(isLoading: false, weekPlan: weekPlan));
    } catch (e) {
      debugPrint('Error in _generateNewPlan: $e');
      await minDelay;
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> confirmPlan() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
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
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // ── Move meal between days ──────────────────────────────────────

  void openMoveMealDialog(MealWithRecipe meal, int sourceDayPlanId) {
    final weekPlan = state.weekPlan;
    if (weekPlan == null) return;
    emit(state.copyWith(
      showMoveDialog: true,
      movingMeal: meal,
      movingSourceDayPlanId: sourceDayPlanId,
      moveTargetDays: _planEditUseCase.getMovableTargetDays(weekPlan, sourceDayPlanId),
    ));
  }

  void dismissMoveDialog() {
    emit(state.copyWith(
      showMoveDialog: false,
      moveTargetDays: const [],
    ));
  }

  Future<void> moveMealToDay(int targetDayPlanId) async {
    emit(state.copyWith(clearErrorMessage: true));
    try {
      final meal = state.movingMeal;
      if (meal == null) return;
      final updatedPlan =
          await _planEditUseCase.moveMealToDay(meal.meal.id, targetDayPlanId);
      emit(state.copyWith(
        weekPlan: updatedPlan,
        showMoveDialog: false,
        moveTargetDays: const [],
      ));
    } catch (e) {
      debugPrint('Error in moveMealToDay: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // ── Replace recipe ──────────────────────────────────────────────

  Future<void> openReplaceDialog(MealWithRecipe meal) async {
    emit(state.copyWith(clearErrorMessage: true));
    try {
      final weekPlan = state.weekPlan;
      if (weekPlan == null) return;
      final data = await _planEditUseCase.getReplaceDialogData(meal, weekPlan);
      emit(state.copyWith(
        showReplaceDialog: true,
        replacingMeal: meal,
        replacementCandidates: data.candidates,
        otherOccurrencesCount: data.otherOccurrencesCount,
      ));
    } catch (e) {
      debugPrint('Error in openReplaceDialog: $e');
      emit(state.copyWith(errorMessage: e.toString()));
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
    emit(state.copyWith(clearErrorMessage: true));
    try {
      final currentMeal = state.replacingMeal;
      final weekPlan = state.weekPlan;
      if (currentMeal == null || weekPlan == null) return;
      final updatedPlan = await _planEditUseCase.replaceRecipe(
        currentMeal,
        weekPlan,
        newRecipe,
        replaceAll: replaceAll,
      );
      emit(state.copyWith(
        weekPlan: updatedPlan,
        showReplaceDialog: false,
        replacementCandidates: const [],
        otherOccurrencesCount: 0,
      ));
    } catch (e) {
      debugPrint('Error in replaceRecipe: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
