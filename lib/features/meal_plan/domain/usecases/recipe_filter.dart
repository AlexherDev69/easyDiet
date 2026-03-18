import 'dart:convert';

import '../../../../data/local/database.dart';
import '../../../onboarding/domain/models/diet_type.dart';
import '../../../onboarding/domain/models/excluded_meat.dart';

/// Filters recipes based on allergies, diet type, and excluded meats.
class RecipeFilter {
  /// Filter by diet type compatibility.
  List<Recipe> filterByDietType(List<Recipe> recipes, DietType userDietType) {
    return switch (userDietType) {
      DietType.omnivore => recipes,
      DietType.vegetarian => recipes
          .where((r) =>
              r.dietType == 'VEGETARIAN' || r.dietType == 'VEGAN')
          .toList(),
      DietType.vegan => recipes.where((r) => r.dietType == 'VEGAN').toList(),
    };
  }

  /// Filter out recipes containing user allergens.
  List<Recipe> filterByAllergies(
    List<Recipe> recipes,
    Set<String> userAllergies,
  ) {
    if (userAllergies.isEmpty) return recipes;
    return recipes.where((recipe) {
      try {
        final allergens =
            (json.decode(recipe.allergens) as List?)?.cast<String>() ??
                <String>[];
        return allergens.none((a) => userAllergies.contains(a));
      } catch (_) {
        return true;
      }
    }).toList();
  }

  /// Filter out recipes containing excluded meat types.
  List<Recipe> filterByExcludedMeats(
    List<Recipe> recipes,
    Set<String> excludedMeats,
  ) {
    if (excludedMeats.isEmpty) return recipes;
    return recipes.where((recipe) {
      try {
        final meats =
            (json.decode(recipe.meatTypes) as List?)?.cast<String>() ??
                <String>[];
        return meats.none((m) => excludedMeats.contains(m));
      } catch (_) {
        return true;
      }
    }).toList();
  }

  /// Apply all filters in pipeline order.
  List<Recipe> applyAll({
    required List<Recipe> recipes,
    required Set<String> allergies,
    required DietType dietType,
    required Set<String> excludedMeats,
  }) {
    return filterByExcludedMeats(
      filterByDietType(
        filterByAllergies(recipes, allergies),
        dietType,
      ),
      excludedMeats,
    );
  }

  // ── Parsing helpers ────────────────────────────────────────────────

  /// Parse allergen strings from profile JSON fields.
  Set<String> parseAllergies(String allergiesJson, String customAllergies) {
    final standard =
        (json.decode(allergiesJson) as List?)?.cast<String>() ?? <String>[];
    final custom = customAllergies.trim().isNotEmpty
        ? customAllergies
            .split(',')
            .map((s) => s.trim().toUpperCase())
            .toList()
        : <String>[];
    return {...standard, ...custom};
  }

  /// Parse excluded meats from profile JSON, expanding groups.
  Set<String> parseExcludedMeats(String excludedMeatsJson) {
    try {
      final names =
          (json.decode(excludedMeatsJson) as List).cast<String>();
      final expanded = <String>{};
      for (final name in names) {
        if (name == ExcludedMeat.allMeat.name.toUpperCase() ||
            name == 'ALL_MEAT') {
          expanded.addAll(['PORK', 'BEEF', 'POULTRY', 'VEAL', 'LAMB']);
        } else if (name == ExcludedMeat.allFish.name.toUpperCase() ||
            name == 'ALL_FISH') {
          expanded.addAll(['FISH', 'SHELLFISH']);
        } else {
          expanded.add(name);
        }
      }
      return expanded;
    } catch (_) {
      return {};
    }
  }
}

/// Extension to mirror Kotlin's `none` on Iterable.
extension IterableNone<T> on Iterable<T> {
  bool none(bool Function(T) test) => !any(test);
}
