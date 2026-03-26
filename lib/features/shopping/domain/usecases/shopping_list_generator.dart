import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/utils/ingredient_normalizer.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../../../data/local/database.dart';
import '../../../../data/local/models/week_plan_with_days.dart';
import '../../../recipes/domain/repositories/recipe_repository.dart';
import '../repositories/shopping_repository.dart';

/// Generates a shopping list from a week plan.
/// Port of ShoppingListGenerator.kt.
class ShoppingListGenerator {
  ShoppingListGenerator(this._recipeRepository, this._shoppingRepository);

  final RecipeRepository _recipeRepository;
  final ShoppingRepository _shoppingRepository;

  Future<void> generateShoppingList(
    WeekPlanWithDays weekPlan, {
    int shoppingTripsPerWeek = 1,
  }) async {
    await _shoppingRepository.deleteGeneratedItems(weekPlan.weekPlan.id);

    final dietDays = weekPlan.days
        .where((d) => !d.dayPlan.isFreeDay)
        .toList()
      ..sort((a, b) => a.dayPlan.date.compareTo(b.dayPlan.date));

    final tripDayMap = _buildTripDayMap(
      dietDays.map((d) => d.dayPlan.dayOfWeek).toList(),
      shoppingTripsPerWeek,
    );

    // One aggregation map per trip
    final tripMaps = <int, Map<String, _AggregatedIngredient>>{};

    for (final day in dietDays) {
      final tripNumber = tripDayMap[day.dayPlan.dayOfWeek] ?? 1;

      for (final mealWithRecipe in day.meals) {
        final recipe = await _recipeRepository.getRecipeWithDetails(
          mealWithRecipe.recipe.id,
        );
        if (recipe == null) continue;
        final servingsMultiplier =
            mealWithRecipe.meal.servings / recipe.recipe.servings;

        for (final ingredient in recipe.ingredients) {
          final (normalizedKey, displayName) =
              _normalizeIngredient(ingredient.name);
          if (_excludedIngredients.contains(normalizedKey)) continue;

          final (normalizedQty, normalizedUnit) = _normalizeUnit(
            ingredient.quantity * servingsMultiplier,
            ingredient.unit,
            normalizedKey,
          );

          final key = '$normalizedKey|$normalizedUnit';
          final source = _IngredientSource(
            recipeName: mealWithRecipe.recipe.name,
            dayOfWeek: day.dayPlan.dayOfWeek,
            quantity: normalizedQty,
            unit: normalizedUnit,
          );

          final normalizedSection =
              _normalizeSectionName(ingredient.supermarketSection);
          final ingredientMap =
              tripMaps.putIfAbsent(tripNumber, () => {});
          final existing = ingredientMap[key];
          if (existing != null) {
            existing.quantity += normalizedQty;
            existing.sources.add(source);
          } else {
            ingredientMap[key] = _AggregatedIngredient(
              displayName: displayName,
              quantity: normalizedQty,
              unit: normalizedUnit,
              section: normalizedSection,
              sources: [source],
            );
          }
        }
      }
    }

    final shoppingItems = <ShoppingItemsCompanion>[];
    for (final entry in tripMaps.entries) {
      final tripNumber = entry.key;
      for (final agg in entry.value.values) {
        final (displayQty, displayUnit) =
            _toDisplayUnit(agg.quantity, agg.unit);
        shoppingItems.add(ShoppingItemsCompanion.insert(
          weekPlanId: weekPlan.weekPlan.id,
          name: agg.displayName,
          quantity: QuantityFormatter.roundForCooking(displayQty),
          unit: displayUnit,
          supermarketSection: agg.section,
          isChecked: const Value(false),
          isManuallyAdded: const Value(false),
          sourceDetails: Value(json.encode(
            agg.sources.map((s) => s.toJson()).toList(),
          )),
          tripNumber: Value(tripNumber),
        ));
      }
    }

    await _shoppingRepository.insertItems(shoppingItems);
  }

  Map<int, int> _buildTripDayMap(List<int> dietDayNumbers, int tripsPerWeek) {
    if (tripsPerWeek <= 1 || dietDayNumbers.isEmpty) {
      return {for (final d in dietDayNumbers) d: 1};
    }
    final effectiveTrips = tripsPerWeek.clamp(1, dietDayNumbers.length);
    final sorted = List.of(dietDayNumbers)..sort();
    final map = <int, int>{};
    for (var i = 0; i < sorted.length; i++) {
      // Distribute days equitably: day i goes to trip (i * effectiveTrips ~/ sorted.length) + 1
      map[sorted[i]] = (i * effectiveTrips ~/ sorted.length) + 1;
    }
    return map;
  }

  (String, String) _normalizeIngredient(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return ('', '');

    var withoutArticle = trimmed.replaceFirst(_articlePattern, '').trim();
    if (withoutArticle.isEmpty) withoutArticle = trimmed;

    // Capitalize first letter.
    final capitalized =
        withoutArticle[0].toUpperCase() + withoutArticle.substring(1);

    final key = IngredientNormalizer.normalizeKey(name);
    final displayName = IngredientNormalizer.canonicalDisplayName(key) ??
        capitalized.replaceAll(_parentheticalPattern, '').trim();

    return (key, displayName);
  }

  bool _isDryIngredient(String ingredientKey) {
    return _dryIngredientPatterns.any((p) => ingredientKey.contains(p));
  }

  (double, String) _normalizeUnit(
    double quantity,
    String unit,
    String ingredientKey,
  ) {
    final unitLower = unit.toLowerCase().trim();
    final isDry = _isDryIngredient(ingredientKey);

    final (double baseQty, String baseUnit) = switch (unitLower) {
      'kg' => (quantity * 1000, 'g'),
      'l' => (quantity * 1000, 'ml'),
      'cl' => (quantity * 10, 'ml'),
      'c. a soupe' => isDry
          ? (quantity * _dryTbspGrams, 'g')
          : (quantity * 15, 'ml'),
      'c. a cafe' => isDry
          ? (quantity * _dryTspGrams, 'g')
          : (quantity * 5, 'ml'),
      'gousse' || 'gousses' => (quantity, 'gousses'),
      'piece' || 'pieces' => (quantity, 'unite'),
      'branche' || 'branches' => (quantity, 'branches'),
      'bouquet' || 'bouquets' => (quantity, 'bouquet'),
      'tranche' || 'tranches' => (quantity, 'tranche'),
      'pincee' => (quantity, 'pincee'),
      _ => (quantity, unit),
    };

    // Normalize "unite" to specific unit for known ingredients
    final override = _ingredientUnitOverride[ingredientKey];
    if (override != null && baseUnit == override.$1) {
      return (baseQty, override.$2);
    }

    return (baseQty, baseUnit);
  }

  String _normalizeSectionName(String section) {
    final aliased = _sectionAliases[section] ?? section;
    // Convert to lowercase to match SupermarketSection enum names.
    return aliased.toLowerCase();
  }

  (double, String) _toDisplayUnit(double quantity, String unit) {
    return switch (unit) {
      'g' when quantity >= 1000 => (quantity / 1000, 'kg'),
      'ml' when quantity >= 1000 => (quantity / 1000, 'l'),
      _ => (quantity, unit),
    };
  }

  // ── Constants ────────────────────────────────────────────────────────

  static final _articlePattern = RegExp(
    r"^(du |de la |de l['\u2019]|des |d['\u2019]|le |la |les |l['\u2019])",
    caseSensitive: false,
  );
  static final _parentheticalPattern = RegExp(r'\s*\(.*?\)');

  static const _excludedIngredients = {
    'eau', 'water', 'eau froide', 'eau chaude',
    'eau bouillante', 'eau tiede', 'eau glacee',
    'sel', 'poivre', 'sel et poivre',
  };

  static const _ingredientUnitOverride = {
    'ail': ('unite', 'gousses'),
    'sauce tomate': ('ml', 'g'),
  };

  static const _sectionAliases = {
    'CONDIMENTS': 'spices',
    'MEAT_FISH': 'meat',
    'SEAFOOD': 'meat',
  };

  static const _dryTspGrams = 3.0;
  static const _dryTbspGrams = 10.0;

  static const _dryIngredientPatterns = [
    'cumin', 'curcuma', 'paprika', 'cannelle', 'curry',
    'muscade', 'piment', 'gingembre moulu', 'thym sec',
    'oregano', 'origan', 'herbes de provence',
    'romarin', 'coriandre moulue', 'poivre',
    'sel', 'fleur de sel', 'bicarbonate', 'levure',
    'farine', 'sucre', 'cacao', 'maizena',
    'poudre', 'moulu', 'moulue', 'seche', 'sechee',
  ];
}

class _AggregatedIngredient {
  _AggregatedIngredient({
    required this.displayName,
    required this.quantity,
    required this.unit,
    required this.section,
    required this.sources,
  });

  final String displayName;
  double quantity;
  final String unit;
  final String section;
  final List<_IngredientSource> sources;
}

class _IngredientSource {
  const _IngredientSource({
    required this.recipeName,
    required this.dayOfWeek,
    required this.quantity,
    required this.unit,
  });

  final String recipeName;
  final int dayOfWeek;
  final double quantity;
  final String unit;

  Map<String, dynamic> toJson() => {
        'recipeName': recipeName,
        'dayOfWeek': dayOfWeek,
        'quantity': quantity,
        'unit': unit,
      };
}
