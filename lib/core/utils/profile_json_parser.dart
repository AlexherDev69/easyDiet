import 'dart:convert';

import '../../features/onboarding/domain/models/allergy.dart';
import '../../features/onboarding/domain/models/excluded_meat.dart';
import '../../features/onboarding/domain/models/meal_type.dart';

/// Shared parsing utilities for JSON-encoded profile fields
/// (freeDays, enabledMealTypes, allergies, excludedMeats).
class ProfileJsonParser {
  ProfileJsonParser._();

  static Set<int> parseIntSet(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return {};
    try {
      final decoded = json.decode(jsonStr);
      if (decoded is List) return decoded.cast<int>().toSet();
    } catch (_) {}
    return {};
  }

  static Set<MealType> parseMealTypes(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return MealType.values.toSet();
    try {
      final decoded = json.decode(jsonStr);
      if (decoded is List) {
        return decoded
            .cast<String>()
            .map((n) => MealType.values.where((m) => m.name == n).firstOrNull)
            .whereType<MealType>()
            .toSet();
      }
    } catch (_) {}
    return MealType.values.toSet();
  }

  static Set<Allergy> parseAllergies(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return {};
    try {
      final names = (json.decode(jsonStr) as List).cast<String>();
      return names
          .map((n) => Allergy.values.where((a) => a.name == n).firstOrNull)
          .whereType<Allergy>()
          .toSet();
    } catch (_) {
      return {};
    }
  }

  static Set<ExcludedMeat> parseExcludedMeats(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return {};
    try {
      final names = (json.decode(jsonStr) as List).cast<String>();
      return names
          .map((n) =>
              ExcludedMeat.values.where((m) => m.name == n).firstOrNull)
          .whereType<ExcludedMeat>()
          .toSet();
    } catch (_) {
      return {};
    }
  }
}
