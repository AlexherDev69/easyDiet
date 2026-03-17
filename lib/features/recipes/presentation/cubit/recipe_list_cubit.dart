import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

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

  StreamSubscription<dynamic>? _recipesSubscription;
  StreamSubscription<dynamic>? _planSubscription;

  // ── Public actions ──────────────────────────────────────────────────

  void selectTab(int tab) {
    emit(state.copyWith(selectedTab: tab, clearCategory: true));
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
    _recipesSubscription = _recipeRepository.watchAllRecipes().listen((recipes) {
      // watchAllRecipes returns List<Recipe>, but we need RecipeWithDetails
      // Load full details asynchronously
      _loadAllRecipesWithDetails();
    });

    _planSubscription =
        _mealPlanRepository.watchCurrentWeekPlan().listen((plan) {
      if (plan != null) {
        final ids = plan.days
            .expand((day) => day.meals.map((m) => m.recipe.id))
            .toSet();
        emit(state.copyWith(weekRecipeIds: ids));
      }
    });
  }

  Future<void> _loadAllRecipesWithDetails() async {
    final recipes = await _recipeRepository.getAllRecipesWithDetails();
    emit(state.copyWith(allRecipes: recipes, isLoading: false));
  }

  @override
  Future<void> close() {
    _recipesSubscription?.cancel();
    _planSubscription?.cancel();
    return super.close();
  }
}
