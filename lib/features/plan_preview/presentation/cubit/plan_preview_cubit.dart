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

  /// ID of the existing plan before we generate a new preview.
  int? _previousWeekPlanId;

  Future<void> _generateNewPlan() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      final profile = await _userProfileRepository.getProfile();
      if (profile == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      // Save the existing plan ID so we can clean up later.
      final existingPlan = await _mealPlanRepository.getCurrentWeekPlan();
      _previousWeekPlanId = existingPlan?.weekPlan.id;

      // Generate the new plan without deleting the old one first.
      // Old plans will be cleaned up on confirmPlan() or on close().
      await _mealPlanGenerator.generateWeekPlan(profile);

      final weekPlan = await _mealPlanRepository.getCurrentWeekPlan();
      emit(state.copyWith(isLoading: false, weekPlan: weekPlan));
    } catch (e) {
      debugPrint('Error in _generateNewPlan: $e');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  bool _confirmed = false;

  Future<void> confirmPlan() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      // Delete old plans now that the user has confirmed the preview.
      if (_previousWeekPlanId != null) {
        await _mealPlanRepository.deleteWeekPlanById(_previousWeekPlanId!);
      }
      _confirmed = true;

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

  @override
  Future<void> close() async {
    // If the user navigated away without confirming, delete the preview plan
    // and keep the original intact.
    if (!_confirmed && state.weekPlan != null) {
      try {
        await _mealPlanRepository.deleteWeekPlanById(
          state.weekPlan!.weekPlan.id,
        );
      } catch (_) {
        // Best-effort cleanup.
      }
    }
    return super.close();
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
