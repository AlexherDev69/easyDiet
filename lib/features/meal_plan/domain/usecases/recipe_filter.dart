import '../../../../data/local/database.dart';
import '../../../onboarding/domain/models/allergy.dart';
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

  /// Maps stored allergy entries (enum `.name` like `gluten`, `treeNuts`) to
  /// the canonical JSON keys (`GLUTEN`, `TREE_NUTS`) used in recipe data.
  /// Unknown entries (legacy uppercase or custom-allergy passthrough) are
  /// kept as-is after uppercasing.
  static Set<String> parseAllergies(
    List<String> allergies,
    String customAllergies,
  ) {
    final mapped = allergies.map((n) {
      final match = Allergy.values.where((a) => a.name == n).firstOrNull;
      return match?.jsonKey ?? n.toUpperCase();
    });
    final custom = customAllergies.trim().isNotEmpty
        ? customAllergies.split(',').map((s) => s.trim().toUpperCase())
        : const <String>[];
    return {...mapped, ...custom};
  }

  /// Maps stored excluded-meat entries (enum `.name` like `pork`, `allMeat`)
  /// to the canonical JSON keys used in recipe `meatTypes`. Aggregate values
  /// (`allMeat`, `allFish`) expand to multiple keys via `ExcludedMeat.jsonKeys`.
  static Set<String> parseExcludedMeats(List<String> excludedMeats) {
    final expanded = <String>{};
    for (final name in excludedMeats) {
      final match = ExcludedMeat.values.where((m) => m.name == name).firstOrNull;
      if (match != null) {
        expanded.addAll(match.jsonKeys);
      } else {
        // Legacy data: accept already-uppercase keys and the historical
        // `ALL_MEAT` / `ALL_FISH` aliases.
        switch (name) {
          case 'ALL_MEAT':
            expanded.addAll(ExcludedMeat.allMeat.jsonKeys);
          case 'ALL_FISH':
            expanded.addAll(ExcludedMeat.allFish.jsonKeys);
          default:
            expanded.add(name);
        }
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
