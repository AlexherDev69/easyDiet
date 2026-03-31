import '../../features/onboarding/domain/models/allergy.dart';
import '../../features/onboarding/domain/models/excluded_meat.dart';
import '../../features/onboarding/domain/models/meal_type.dart';

/// Shared parsing utilities for typed profile fields
/// (freeDays, enabledMealTypes, allergies, excludedMeats).
///
/// With Drift type converters the fields are already typed lists,
/// so these helpers only handle enum mapping.
class ProfileJsonParser {
  ProfileJsonParser._();

  static Set<MealType> parseMealTypes(List<String> names) {
    if (names.isEmpty) return MealType.values.toSet();
    final result = names
        .map((n) => MealType.values.where((m) => m.name == n).firstOrNull)
        .whereType<MealType>()
        .toSet();
    return result.isNotEmpty ? result : MealType.values.toSet();
  }

  static Set<Allergy> parseAllergies(List<String> names) {
    if (names.isEmpty) return {};
    return names
        .map((n) => Allergy.values.where((a) => a.name == n).firstOrNull)
        .whereType<Allergy>()
        .toSet();
  }

  static Set<ExcludedMeat> parseExcludedMeats(List<String> names) {
    if (names.isEmpty) return {};
    return names
        .map(
            (n) => ExcludedMeat.values.where((m) => m.name == n).firstOrNull)
        .whereType<ExcludedMeat>()
        .toSet();
  }
}
