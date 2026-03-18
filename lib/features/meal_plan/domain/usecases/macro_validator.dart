import '../../../../data/local/database.dart';
import '../../../onboarding/domain/models/meal_type.dart';

/// Result of macro validation for a generated plan.
class MacroValidation {
  const MacroValidation({required this.isValid, this.recipeToBlacklist});

  final bool isValid;
  final int? recipeToBlacklist;
}

/// Validates macronutrient balance of a generated meal plan.
class MacroValidator {
  // ── Constants ──────────────────────────────────────────────────────
  static const defaultMaxFatPercent = 35.0;
  static const _relaxedMaxFatPercent = 38.0;
  static const _fatRelaxationThreshold = 35.0;
  static const _minProteinPercent = 20.0;
  static const minProteinGroups = 3;

  /// Compute the effective fat limit based on available recipes.
  double computeEffectiveFatLimit(List<Recipe> filteredRecipes) {
    final lunchDinner = filteredRecipes
        .where((r) => r.category == 'LUNCH' || r.category == 'DINNER')
        .toList();
    if (lunchDinner.isEmpty) return defaultMaxFatPercent;

    final fatPercents = lunchDinner.map((r) {
      if (r.caloriesPerServing > 0) {
        return r.fatGrams * 9.0 / r.caloriesPerServing * 100.0;
      }
      return 0.0;
    }).toList()
      ..sort();

    final median = fatPercents[fatPercents.length ~/ 2];
    return median > _fatRelaxationThreshold
        ? _relaxedMaxFatPercent
        : defaultMaxFatPercent;
  }

  /// Validate the macro balance of a plan.
  MacroValidation validate({
    required Map<String, List<Recipe>> plan,
    required int dailyCalorieTarget,
    required Map<int, Set<String>> ingredientSets,
    required double maxFatPercent,
    required double Function(Recipe, int, MealType) calculateServings,
  }) {
    var totalFatCal = 0.0;
    var totalProteinCal = 0.0;
    var totalCal = 0.0;
    int? fattiestRecipeId;
    var fattiestFatPercent = 0.0;
    int? lowestProteinRecipeId;
    var lowestProteinPercent = 100.0;

    for (final entry in plan.entries) {
      for (final recipe in entry.value) {
        final type = MealType.values.firstWhere(
          (m) => m.name.toUpperCase() == entry.key,
          orElse: () => MealType.breakfast,
        );
        final servings = calculateServings(recipe, dailyCalorieTarget, type);
        final cal = recipe.caloriesPerServing * servings;
        final fatCal = recipe.fatGrams * servings * 9.0;
        final protCal = recipe.proteinGrams * servings * 4.0;
        totalCal += cal;
        totalFatCal += fatCal;
        totalProteinCal += protCal;

        final recipeFatPct = cal > 0 ? fatCal / cal * 100.0 : 0.0;
        if (recipeFatPct > fattiestFatPercent) {
          fattiestFatPercent = recipeFatPct;
          fattiestRecipeId = recipe.id;
        }

        final recipeProtPct = cal > 0 ? protCal / cal * 100.0 : 0.0;
        if (recipeProtPct < lowestProteinPercent) {
          lowestProteinPercent = recipeProtPct;
          lowestProteinRecipeId = recipe.id;
        }
      }
    }

    final avgFatPercent = totalCal > 0 ? totalFatCal / totalCal * 100.0 : 0.0;
    final avgProtPercent =
        totalCal > 0 ? totalProteinCal / totalCal * 100.0 : 0.0;

    final proteinGroupsUsed = <String>{};
    for (final recipes in plan.values) {
      for (final recipe in recipes) {
        final ings = ingredientSets[recipe.id];
        if (ings == null) continue;
        for (final ing in ings) {
          final group = ProteinGroupResolver.resolveGroup(ing);
          if (group != null && proteinGroups.contains(group)) {
            proteinGroupsUsed.add(group);
          }
        }
      }
    }

    if (avgFatPercent > maxFatPercent) {
      return MacroValidation(
        isValid: false,
        recipeToBlacklist: fattiestRecipeId,
      );
    }
    if (avgProtPercent < _minProteinPercent) {
      return MacroValidation(
        isValid: false,
        recipeToBlacklist: lowestProteinRecipeId,
      );
    }
    if (proteinGroupsUsed.length < minProteinGroups) {
      return MacroValidation(
        isValid: false,
        recipeToBlacklist: lowestProteinRecipeId,
      );
    }
    return const MacroValidation(isValid: true);
  }

  /// Compute fat penalty for a recipe during scoring.
  int computeFatPenalty(double fatGrams, int caloriesPerServing) {
    if (caloriesPerServing <= 0) return 0;
    final fatPercent = fatGrams * 9.0 / caloriesPerServing * 100.0;
    if (fatPercent > 50) return 4;
    if (fatPercent > 40) return 3;
    if (fatPercent > 30) return 1;
    return 0;
  }

  /// Protein groups used for diversity tracking.
  static const proteinGroups = {
    'egg', 'poultry', 'salmon', 'tuna', 'whitefish', 'oily_fish',
    'red_meat', 'pork', 'shellfish', 'plant_protein', 'legume',
  };
}

/// Resolves ingredient names to protein diversity groups.
class ProteinGroupResolver {
  static const _ingredientToGroup = {
    'oeuf': 'egg', "blanc d'oeuf": 'egg', "jaune d'oeuf": 'egg',
    'poulet': 'poultry', 'blanc de poulet': 'poultry',
    'cuisse de poulet': 'poultry', 'haut de cuisse de poulet': 'poultry',
    'filet de poulet': 'poultry', 'escalope de poulet': 'poultry',
    'dinde': 'poultry', 'escalope de dinde': 'poultry',
    'saumon': 'salmon', 'filet de saumon': 'salmon',
    'pave de saumon': 'salmon',
    'thon': 'tuna',
    'cabillaud': 'whitefish', 'dos de cabillaud': 'whitefish',
    'sardine': 'oily_fish', 'maquereau': 'oily_fish',
    'filet de maquereau': 'oily_fish',
    'boeuf': 'red_meat', 'steak hache': 'red_meat',
    'viande hachee': 'red_meat', 'veau': 'red_meat',
    'epaule de veau': 'red_meat', 'agneau': 'red_meat',
    'souris d agneau': 'red_meat',
    'porc': 'pork', 'filet mignon': 'pork',
    'crevette': 'shellfish', 'moule': 'shellfish',
    'tofu': 'plant_protein', 'tempeh': 'plant_protein',
    'seitan': 'plant_protein',
    'lentille': 'legume', 'pois chiche': 'legume',
    'haricot rouge': 'legume', 'haricot noir': 'legume',
    'haricot blanc': 'legume',
    'avocat': 'avocado',
  };

  /// Resolve an ingredient key to its diversity group.
  static String? resolveGroup(String normalizedKey) {
    final exact = _ingredientToGroup[normalizedKey];
    if (exact != null) return exact;
    for (final entry in _ingredientToGroup.entries) {
      if (normalizedKey.startsWith(entry.key)) return entry.value;
    }
    return null;
  }
}
