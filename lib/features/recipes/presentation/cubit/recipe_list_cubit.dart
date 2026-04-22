import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/local/database.dart';
import '../../../../data/local/models/week_plan_with_days.dart';
import '../../../meal_plan/domain/repositories/meal_plan_repository.dart';
import '../../domain/repositories/recipe_repository.dart';
import 'recipe_list_state.dart';

/// Manages recipe list — port of RecipeListViewModel.kt.
class RecipeListCubit extends Cubit<RecipeListState> {
  RecipeListCubit({
    required RecipeRepository recipeRepository,
    required MealPlanRepository mealPlanRepository,
  })  : _recipeRepository = recipeRepository,
        _mealPlanRepository = mealPlanRepository,
        super(const RecipeListState()) {
    _loadRecipes();
  }

  final RecipeRepository _recipeRepository;
  final MealPlanRepository _mealPlanRepository;

  StreamSubscription<List<Recipe>>? _recipesSubscription;
  StreamSubscription<WeekPlanWithDays?>? _planSubscription;

  // ── Public actions ──────────────────────────────────────────────────

  void selectTab(int tab) {
    // On ne reset PAS la catégorie : l'utilisateur veut conserver son
    // filtre (Petit-dej / Dejeuner / …) en basculant entre "Cette
    // semaine" et "Toutes les recettes".
    emit(state.copyWith(selectedTab: tab));
  }

  void selectCategory(String? category) {
    if (category == null) {
      emit(state.copyWith(clearCategory: true));
    } else {
      emit(state.copyWith(selectedCategory: category));
    }
  }

  // ── Private ───────────────────────────────────────────────────────

  void _loadRecipes() {
    _recipesSubscription = _recipeRepository.watchAllRecipes().listen(
      (_) => _loadAllRecipesWithDetails(),
      onError: (Object e) {
        debugPrint('Error in watchAllRecipes: $e');
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      },
    );

    _planSubscription =
        _mealPlanRepository.watchCurrentWeekPlan().listen(
      (plan) {
        if (plan != null) {
          final ids = plan.days
              .expand((day) => day.meals.map((m) => m.recipe.id))
              .toSet();
          emit(state.copyWith(weekRecipeIds: ids));
        }
      },
      onError: (Object e) {
        debugPrint('Error in watchCurrentWeekPlan: $e');
      },
    );
  }

  Future<void> _loadAllRecipesWithDetails() async {
    try {
      final recipes = await _recipeRepository.getAllRecipesWithDetails();
      emit(state.copyWith(allRecipes: recipes, isLoading: false));
    } catch (e) {
      debugPrint('Error in _loadAllRecipesWithDetails: $e');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _recipesSubscription?.cancel();
    _planSubscription?.cancel();
    return super.close();
  }
}
