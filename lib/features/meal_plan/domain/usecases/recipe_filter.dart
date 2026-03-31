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
      final allergens = recipe.allergens;
      // Also check meatTypes for SHELLFISH to cover recipes that only tag
      // shellfish as a meat type but not as an allergen (NUT-19 fix).
      if (userAllergies.contains('SHELLFISH')) {
        if (recipe.meatTypes.contains('SHELLFISH')) return false;
      }
      return allergens.every((a) => !userAllergies.contains(a));
    }).toList();
  }

  static List<Recipe> filterByExcludedMeats(
    List<Recipe> recipes,
    Set<String> excludedMeats,
  ) {
    if (excludedMeats.isEmpty) return recipes;
    return recipes.where((recipe) {
      return recipe.meatTypes.every((m) => !excludedMeats.contains(m));
    }).toList();
  }

  static Set<String> parseAllergies(
    List<String> allergies,
    String customAllergies,
  ) {
    final custom = customAllergies.trim().isNotEmpty
        ? customAllergies.split(',').map((s) => s.trim().toUpperCase()).toList()
        : <String>[];
    return {...allergies, ...custom};
  }

  static Set<String> parseExcludedMeats(List<String> excludedMeats) {
    final expanded = <String>{};
    for (final name in excludedMeats) {
      if (name == ExcludedMeat.allMeat.name.toUpperCase() ||
          name == 'ALL_MEAT') {
        expanded.addAll([
          'PORK', 'BEEF', 'POULTRY', 'VEAL', 'LAMB', 'FISH', 'SHELLFISH',
        ]);
      } else if (name == ExcludedMeat.allFish.name.toUpperCase() ||
          name == 'ALL_FISH') {
        expanded.addAll(['FISH', 'SHELLFISH']);
      } else {
        expanded.add(name);
      }
    }
    return expanded;
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
