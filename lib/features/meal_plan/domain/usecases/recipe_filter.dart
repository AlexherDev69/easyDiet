import 'dart:convert';

import '../../../../data/local/database.dart';
import '../../../onboarding/domain/models/diet_type.dart';
import '../../../onboarding/domain/models/excluded_meat.dart';

/// Pure filtering and parsing logic for recipes.
/// Stateless — all methods are static.
class RecipeFilter {
  RecipeFilter._();

  static List<Recipe> filterByDietType(
    List<Recipe> recipes,
    DietType userDietType,
  ) {
    return switch (userDietType) {
      DietType.omnivore => recipes,
      DietType.vegetarian => recipes
          .where((r) => r.dietType == 'VEGETARIAN' || r.dietType == 'VEGAN')
          .toList(),
      DietType.vegan => recipes.where((r) => r.dietType == 'VEGAN').toList(),
    };
  }

  static List<Recipe> filterByAllergies(
    List<Recipe> recipes,
    Set<String> userAllergies,
  ) {
    if (userAllergies.isEmpty) return recipes;
    return recipes.where((recipe) {
      try {
        final allergens =
            (json.decode(recipe.allergens) as List?)?.cast<String>() ??
                <String>[];
        return allergens.every((a) => !userAllergies.contains(a));
      } catch (_) {
        return true;
      }
    }).toList();
  }

  static List<Recipe> filterByExcludedMeats(
    List<Recipe> recipes,
    Set<String> excludedMeats,
  ) {
    if (excludedMeats.isEmpty) return recipes;
    return recipes.where((recipe) {
      try {
        final meats =
            (json.decode(recipe.meatTypes) as List?)?.cast<String>() ??
                <String>[];
        return meats.every((m) => !excludedMeats.contains(m));
      } catch (_) {
        return true;
      }
    }).toList();
  }

  static Set<String> parseAllergies(
    String allergiesJson,
    String customAllergies,
  ) {
    List<String> standard;
    try {
      standard =
          (json.decode(allergiesJson) as List?)?.cast<String>() ?? <String>[];
    } catch (_) {
      standard = <String>[];
    }
    final custom = customAllergies.trim().isNotEmpty
        ? customAllergies.split(',').map((s) => s.trim().toUpperCase()).toList()
        : <String>[];
    return {...standard, ...custom};
  }

  static Set<String> parseExcludedMeats(String excludedMeatsJson) {
    try {
      final names = (json.decode(excludedMeatsJson) as List).cast<String>();
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

  /// Convenience: run the full filtering pipeline in one call.
  static List<Recipe> applyAll(
    List<Recipe> recipes, {
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
}
