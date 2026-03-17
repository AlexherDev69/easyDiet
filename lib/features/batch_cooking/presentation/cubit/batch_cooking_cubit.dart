import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/ingredient_normalizer.dart';
import '../../../../data/local/daos/day_plan_dao.dart';
import '../../../../data/local/models/recipe_with_details.dart';
import '../../../recipes/domain/repositories/recipe_repository.dart';
import '../../domain/models/batch_cooking_models.dart';
import 'batch_cooking_state.dart';

/// Manages batch cooking overview — port of BatchCookingViewModel.kt.
class BatchCookingCubit extends Cubit<BatchCookingState> {
  BatchCookingCubit({
    required DayPlanDao dayPlanDao,
    required RecipeRepository recipeRepository,
  })  : _dayPlanDao = dayPlanDao,
        _recipeRepository = recipeRepository,
        super(const BatchCookingState());

  final DayPlanDao _dayPlanDao;
  final RecipeRepository _recipeRepository;

  Future<void> loadBatchCooking(int dayPlanId) async {
    final dayPlan = await _dayPlanDao.getDayPlanWithMealsById(dayPlanId);
    if (dayPlan == null) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    final recipes = <BatchCookingRecipeInfo>[];
    final allRecipeDetails = <(BatchCookingRecipeInfo, RecipeWithDetails)>[];

    for (final mealWithRecipe in dayPlan.meals) {
      final details = await _recipeRepository
          .getRecipeWithDetails(mealWithRecipe.recipe.id);
      if (details == null) continue;

      final info = BatchCookingRecipeInfo(
        recipeId: mealWithRecipe.recipe.id,
        recipeName: mealWithRecipe.recipe.name,
        servings: mealWithRecipe.meal.servings,
        baseServings: mealWithRecipe.recipe.servings,
        prepTimeMinutes: mealWithRecipe.recipe.prepTimeMinutes,
        cookTimeMinutes: mealWithRecipe.recipe.cookTimeMinutes,
        totalTimeMinutes:
            mealWithRecipe.recipe.prepTimeMinutes +
            mealWithRecipe.recipe.cookTimeMinutes,
        ingredients: details.ingredients,
        mealType: mealWithRecipe.meal.mealType,
      );
      recipes.add(info);
      allRecipeDetails.add((info, details));
    }

    final mergedIngredients = _mergeIngredients(allRecipeDetails);
    final commonIngredients =
        mergedIngredients.where((i) => i.fromRecipes.length > 1).toList();

    emit(state.copyWith(
      sessionNumber: dayPlan.dayPlan.batchCookingSession ?? 1,
      recipes: recipes,
      commonIngredients: commonIngredients,
      allIngredients: mergedIngredients,
      totalPrepTime: recipes.isEmpty
          ? 0
          : recipes.map((r) => r.prepTimeMinutes).reduce(max),
      totalCookTime: recipes.fold<int>(0, (sum, r) => sum + r.cookTimeMinutes),
      isLoading: false,
    ));
  }

  List<MergedIngredient> _mergeIngredients(
    List<(BatchCookingRecipeInfo, RecipeWithDetails)> recipePairs,
  ) {
    final ingredientMap = <String, _MergedIngredientBuilder>{};

    for (final (info, details) in recipePairs) {
      final multiplier = info.servingsMultiplier;

      for (final ingredient in details.ingredients) {
        final normalizedName = _normalizeName(ingredient.name);
        final (normalizedQty, normalizedUnit) =
            _normalizeUnit(ingredient.quantity * multiplier, ingredient.unit);
        final key = '$normalizedName|$normalizedUnit';

        final existing = ingredientMap[key];
        if (existing != null) {
          existing.quantity += normalizedQty;
          if (!existing.fromRecipes.contains(info.recipeName)) {
            existing.fromRecipes.add(info.recipeName);
          }
        } else {
          ingredientMap[key] = _MergedIngredientBuilder(
            name: ingredient.name,
            quantity: normalizedQty,
            unit: normalizedUnit,
            section: ingredient.supermarketSection,
            fromRecipes: [info.recipeName],
          );
        }
      }
    }

    final result = ingredientMap.values
        .map((b) => MergedIngredient(
              name: b.name,
              quantity: (b.quantity * 10).ceil() / 10,
              unit: b.unit,
              section: b.section,
              fromRecipes: b.fromRecipes,
            ))
        .toList();

    // Sort: most shared first, then by section, then by name
    result.sort((a, b) {
      final cmp = b.fromRecipes.length.compareTo(a.fromRecipes.length);
      if (cmp != 0) return cmp;
      final cmpSection = a.section.compareTo(b.section);
      if (cmpSection != 0) return cmpSection;
      return a.name.compareTo(b.name);
    });

    return result;
  }

  String _normalizeName(String name) {
    var n = name.toLowerCase().trim();
    // Remove trailing 's' for simple plural handling
    if (n.length > 3 &&
        n.endsWith('s') &&
        !n.endsWith('ss') &&
        !n.endsWith('us') &&
        !n.endsWith('is')) {
      n = n.substring(0, n.length - 1);
    }
    return IngredientNormalizer.removeAccents(n);
  }

  (double, String) _normalizeUnit(double quantity, String unit) {
    final lower = unit.toLowerCase().trim();
    if (lower == 'c. a soupe') {
      return (quantity * 3, 'c. a cafe');
    }
    return (quantity, unit);
  }
}

class _MergedIngredientBuilder {
  _MergedIngredientBuilder({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.section,
    required this.fromRecipes,
  });

  final String name;
  double quantity;
  final String unit;
  final String section;
  final List<String> fromRecipes;
}
