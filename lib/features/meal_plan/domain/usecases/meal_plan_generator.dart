import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/ingredient_normalizer.dart';
import '../../../../data/local/database.dart';
import '../../../../data/local/models/recipe_with_details.dart';
import '../../../onboarding/domain/models/diet_type.dart';
import '../../../onboarding/domain/models/excluded_meat.dart';
import '../../../onboarding/domain/models/meal_type.dart';
import '../../../recipes/domain/repositories/recipe_repository.dart';
import '../repositories/meal_plan_repository.dart';

/// Generates a weekly meal plan from recipes based on user profile.
/// Port of MealPlanGenerator.kt (~914 lines).
class MealPlanGenerator {
  MealPlanGenerator(this._mealPlanRepository, this._recipeRepository);

  final MealPlanRepository _mealPlanRepository;
  final RecipeRepository _recipeRepository;

  Future<void> generateWeekPlan(UserProfile profile) async {
    var allRecipes = await _recipeRepository.getAllRecipes();
    var retries = 0;
    while (allRecipes.isEmpty && retries < 10) {
      await Future<void>.delayed(const Duration(seconds: 1));
      allRecipes = await _recipeRepository.getAllRecipes();
      retries++;
    }
    if (allRecipes.isEmpty) return;

    final userAllergies =
        _parseAllergies(profile.allergies, profile.customAllergies);
    final userDietType = DietType.values.firstWhere(
      (d) => d.name == profile.dietType,
      orElse: () => DietType.omnivore,
    );
    final userExcludedMeats = _parseExcludedMeats(profile.excludedMeats);
    final filteredRecipes = _filterByExcludedMeats(
      _filterByDietType(
        _filterByAllergies(allRecipes, userAllergies),
        userDietType,
      ),
      userExcludedMeats,
    );
    final enabledMeals = _parseEnabledMealTypes(profile.enabledMealTypes);

    final Map<String, List<Recipe>> selected;
    if (profile.economicMode) {
      selected = await _selectRecipesEconomic(
        filteredRecipes,
        enabledMeals,
        profile,
      );
    } else {
      selected = await _selectRecipesRandom(
        filteredRecipes,
        enabledMeals,
        profile,
      );
    }

    final breakfasts = selected['BREAKFAST'] ?? [];
    final lunches = selected['LUNCH'] ?? [];
    final dinners = selected['DINNER'] ?? [];
    final snacks = selected['SNACK'] ?? [];

    final dietStart =
        DateTime.fromMillisecondsSinceEpoch(profile.dietStartDate);
    final today = AppDateUtils.today();
    final planStart =
        dietStart.isAfter(today) || dietStart == today ? dietStart : today;

    final weekPlanId = await _mealPlanRepository.createWeekPlan(
      WeekPlansCompanion.insert(
        weekStartDate: AppDateUtils.toEpochMillis(planStart),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    final dietStartIndex =
        DateTime.fromMillisecondsSinceEpoch(profile.dietStartDate).weekday - 1;

    final freeDayIndices = _parseFreeDays(
      profile.freeDays,
      profile.dietDaysPerWeek,
      dietStartIndex,
    );

    final planDayWeekdayIndices = List.generate(7, (offset) {
      return planStart.add(Duration(days: offset)).weekday - 1;
    });

    final dietDayIndices = <int>{};
    for (var i = 0; i < planDayWeekdayIndices.length; i++) {
      if (!freeDayIndices.contains(planDayWeekdayIndices[i])) {
        dietDayIndices.add(i);
      }
    }
    final dietDays = dietDayIndices.length;

    final batchSessions =
        max(profile.batchCookingSessionsPerWeek, 0);
    final batchDayIndices = batchSessions > 0
        ? _computeBatchDayIndices(
            batchSessions,
            dietStartIndex,
            dietDays,
            profile.batchCookingBeforeDiet,
          )
        : <int>[];

    final breakfastSchedule =
        _groupRecipesByBatch(breakfasts, dietDays, batchSessions);
    final lunchSchedule =
        _groupRecipesByBatch(lunches, dietDays, batchSessions);
    final dinnerSchedule =
        _groupRecipesByBatch(dinners, dietDays, batchSessions);
    final snackSchedule =
        _groupRecipesByBatch(snacks, dietDays, batchSessions);

    var dietDayIdx = 0;

    for (var dayOffset = 0; dayOffset < 7; dayOffset++) {
      final date = planStart.add(Duration(days: dayOffset));
      final weekdayIndex = planDayWeekdayIndices[dayOffset];
      final isFreeDay = freeDayIndices.contains(weekdayIndex);
      final batchIdx = batchDayIndices.indexOf(weekdayIndex);
      final int? batchSession = batchIdx >= 0 ? batchIdx + 1 : null;

      final dayPlanId = await _mealPlanRepository.createDayPlan(
        DayPlansCompanion.insert(
          weekPlanId: weekPlanId,
          date: AppDateUtils.toEpochMillis(date),
          dayOfWeek: date.weekday,
          isFreeDay: Value(isFreeDay),
          batchCookingSession: Value(batchSession),
        ),
      );

      if (!isFreeDay) {
        final meals = <MealsCompanion>[];

        final breakfast =
            dietDayIdx < breakfastSchedule.length
                ? breakfastSchedule[dietDayIdx]
                : null;
        if (breakfast != null) {
          meals.add(MealsCompanion.insert(
            dayPlanId: dayPlanId,
            mealType: MealType.breakfast.name.toUpperCase(),
            recipeId: breakfast.id,
            servings: Value(calculateServings(
              breakfast,
              profile.dailyCalorieTarget,
              MealType.breakfast,
            )),
          ));
        }

        final lunch =
            dietDayIdx < lunchSchedule.length
                ? lunchSchedule[dietDayIdx]
                : null;
        if (lunch != null) {
          meals.add(MealsCompanion.insert(
            dayPlanId: dayPlanId,
            mealType: MealType.lunch.name.toUpperCase(),
            recipeId: lunch.id,
            servings: Value(calculateServings(
              lunch,
              profile.dailyCalorieTarget,
              MealType.lunch,
            )),
          ));
        }

        final dinner =
            dietDayIdx < dinnerSchedule.length
                ? dinnerSchedule[dietDayIdx]
                : null;
        if (dinner != null) {
          meals.add(MealsCompanion.insert(
            dayPlanId: dayPlanId,
            mealType: MealType.dinner.name.toUpperCase(),
            recipeId: dinner.id,
            servings: Value(calculateServings(
              dinner,
              profile.dailyCalorieTarget,
              MealType.dinner,
            )),
          ));
        }

        final snack =
            dietDayIdx < snackSchedule.length
                ? snackSchedule[dietDayIdx]
                : null;
        if (snack != null) {
          meals.add(MealsCompanion.insert(
            dayPlanId: dayPlanId,
            mealType: MealType.snack.name.toUpperCase(),
            recipeId: snack.id,
            servings: Value(calculateServings(
              snack,
              profile.dailyCalorieTarget,
              MealType.snack,
            )),
          ));
        }

        await _mealPlanRepository.createMeals(meals);
        dietDayIdx++;
      }
    }
  }

  /// Returns alternative recipes for swapping a meal.
  Future<List<Recipe>> getAlternativeRecipes(
    int currentRecipeId,
    MealType mealType,
    UserProfile profile,
  ) async {
    final category = mealType.name.toUpperCase();
    final recipes = await _recipeRepository.getRecipesByCategory(category);
    final userAllergies =
        _parseAllergies(profile.allergies, profile.customAllergies);
    final userDietType = DietType.values.firstWhere(
      (d) => d.name == profile.dietType,
      orElse: () => DietType.omnivore,
    );
    final userExcludedMeats = _parseExcludedMeats(profile.excludedMeats);
    return _filterByExcludedMeats(
      _filterByDietType(
        _filterByAllergies(recipes, userAllergies),
        userDietType,
      ),
      userExcludedMeats,
    ).where((r) => r.id != currentRecipeId).toList();
  }

  /// Returns compatible replacements for a given category.
  Future<List<Recipe>> getCompatibleReplacements(
    String category,
    Set<int> excludeRecipeIds,
    UserProfile profile,
  ) async {
    final allRecipes = await _recipeRepository.getAllRecipes();
    final userAllergies =
        _parseAllergies(profile.allergies, profile.customAllergies);
    final userDietType = DietType.values.firstWhere(
      (d) => d.name == profile.dietType,
      orElse: () => DietType.omnivore,
    );
    final userExcludedMeats = _parseExcludedMeats(profile.excludedMeats);

    return _filterByExcludedMeats(
      _filterByDietType(
        _filterByAllergies(allRecipes, userAllergies),
        userDietType,
      ),
      userExcludedMeats,
    )
        .where((r) => r.category == category && !excludeRecipeIds.contains(r.id))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  // ── Serving calculation ──────────────────────────────────────────────

  double calculateServings(
    Recipe recipe,
    int dailyTarget,
    MealType mealType,
  ) {
    final mealCalorieShare = switch (mealType) {
      MealType.breakfast => 0.25,
      MealType.lunch => 0.35,
      MealType.dinner => 0.30,
      MealType.snack => 0.10,
    };
    final maxServings = switch (mealType) {
      MealType.breakfast => 1.5,
      MealType.lunch => 2.0,
      MealType.dinner => 2.0,
      MealType.snack => 1.5,
    };
    final targetCalories = dailyTarget * mealCalorieShare;
    final servings = targetCalories / recipe.caloriesPerServing;
    return ((servings * 4).round() / 4.0).clamp(0.5, maxServings);
  }

  // ── Parsing helpers ──────────────────────────────────────────────────

  Set<MealType> _parseEnabledMealTypes(String jsonStr) {
    try {
      final names = (json.decode(jsonStr) as List).cast<String>();
      return names
          .map((n) => MealType.values.firstWhere(
                (m) => m.name == n || m.name.toUpperCase() == n,
                orElse: () => MealType.breakfast,
              ))
          .toSet();
    } catch (_) {
      return MealType.values.toSet();
    }
  }

  Set<int> _parseFreeDays(
    String freeDaysJson,
    int dietDaysPerWeek,
    int dietStartIndex,
  ) {
    try {
      final days = (json.decode(freeDaysJson) as List).cast<int>();
      if (days.isNotEmpty) return days.toSet();
      return _computeFreeDaysFallback(dietDaysPerWeek, dietStartIndex);
    } catch (_) {
      return _computeFreeDaysFallback(dietDaysPerWeek, dietStartIndex);
    }
  }

  Set<int> _computeFreeDaysFallback(int dietDaysPerWeek, int dietStartIndex) {
    final dietDayIndices =
        List.generate(dietDaysPerWeek, (i) => (dietStartIndex + i) % 7).toSet();
    return List.generate(7, (i) => i)
        .where((i) => !dietDayIndices.contains(i))
        .toSet();
  }

  Set<String> _parseAllergies(String allergiesJson, String customAllergies) {
    final standard =
        (json.decode(allergiesJson) as List?)?.cast<String>() ?? <String>[];
    final custom = customAllergies.trim().isNotEmpty
        ? customAllergies.split(',').map((s) => s.trim().toUpperCase()).toList()
        : <String>[];
    return {...standard, ...custom};
  }

  Set<String> _parseExcludedMeats(String excludedMeatsJson) {
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

  // ── Filtering pipeline ───────────────────────────────────────────────

  List<Recipe> _filterByDietType(List<Recipe> recipes, DietType userDietType) {
    return switch (userDietType) {
      DietType.omnivore => recipes,
      DietType.vegetarian => recipes
          .where((r) =>
              r.dietType == 'VEGETARIAN' || r.dietType == 'VEGAN')
          .toList(),
      DietType.vegan => recipes.where((r) => r.dietType == 'VEGAN').toList(),
    };
  }

  List<Recipe> _filterByAllergies(
    List<Recipe> recipes,
    Set<String> userAllergies,
  ) {
    if (userAllergies.isEmpty) return recipes;
    return recipes.where((recipe) {
      final allergens =
          (json.decode(recipe.allergens) as List?)?.cast<String>() ??
              <String>[];
      return allergens.none((a) => userAllergies.contains(a));
    }).toList();
  }

  List<Recipe> _filterByExcludedMeats(
    List<Recipe> recipes,
    Set<String> excludedMeats,
  ) {
    if (excludedMeats.isEmpty) return recipes;
    final expanded = _expandExclusions(excludedMeats);
    return recipes.where((recipe) {
      final meats =
          (json.decode(recipe.meatTypes) as List?)?.cast<String>() ??
              <String>[];
      return meats.none((m) => expanded.contains(m));
    }).toList();
  }

  Set<String> _expandExclusions(Set<String> excludedMeats) {
    final expanded = {...excludedMeats};
    if (expanded.contains('ALL_MEAT')) {
      expanded.addAll(['PORK', 'BEEF', 'LAMB', 'POULTRY', 'VEAL']);
    }
    if (expanded.contains('ALL_FISH')) {
      expanded.addAll(['FISH', 'SHELLFISH']);
    }
    if (expanded.contains('SHELLFISH_MEAT')) {
      expanded.add('SHELLFISH');
    }
    return expanded;
  }

  // ── Batch cooking helpers ────────────────────────────────────────────

  List<int> _computeBatchDayIndices(
    int sessions,
    int dietStartIndex,
    int dietDays,
    bool batchBeforeDiet,
  ) {
    if (sessions == 0) return [];
    final firstBatch =
        batchBeforeDiet ? (dietStartIndex - 1 + 7) % 7 : dietStartIndex;
    if (sessions == 1) return [firstBatch];
    if (sessions == 2) {
      final secondBatch = (dietStartIndex + dietDays ~/ 2) % 7;
      return [firstBatch, secondBatch];
    }
    return [firstBatch];
  }

  List<Recipe> _groupRecipesByBatch(
    List<Recipe> recipes,
    int dietDayCount,
    int batchSessions,
  ) {
    if (recipes.isEmpty || dietDayCount == 0) return [];
    final sessions = batchSessions.clamp(0, 2);
    if (sessions <= 1) return _fillDaysWithRecipes(recipes, dietDayCount);

    final firstSegDays = (dietDayCount + 1) ~/ 2;
    final secondSegDays = dietDayCount - firstSegDays;

    final mid = (recipes.length + 1) ~/ 2;
    final firstRecipes = recipes.sublist(0, mid);
    final secondRecipes =
        mid < recipes.length ? recipes.sublist(mid) : [recipes.last];

    return _fillDaysWithRecipes(firstRecipes, firstSegDays) +
        _fillDaysWithRecipes(secondRecipes, secondSegDays);
  }

  List<Recipe> _fillDaysWithRecipes(List<Recipe> recipes, int days) {
    if (recipes.isEmpty || days == 0) return [];
    return List.generate(days, (i) => recipes[i % recipes.length]);
  }

  // ── Random mode ──────────────────────────────────────────────────────

  Future<Map<String, List<Recipe>>> _selectRecipesRandom(
    List<Recipe> filteredRecipes,
    Set<MealType> enabledMeals,
    UserProfile profile,
  ) async {
    final filteredIds = filteredRecipes.map((r) => r.id).toSet();
    final allWithDetails = (await _recipeRepository.getAllRecipesWithDetails())
        .where((rwd) => filteredIds.contains(rwd.recipe.id))
        .toList();

    final ingredientSets = {
      for (final rwd in allWithDetails)
        rwd.recipe.id: rwd.ingredients
            .map((i) => IngredientNormalizer.normalizeKey(i.name))
            .where((k) => !_scoringExcludedIngredients.contains(k))
            .toSet(),
    };

    final distinctCounts = {
      'BREAKFAST': profile.distinctBreakfasts,
      'LUNCH': profile.distinctLunches,
      'DINNER': profile.distinctDinners,
      'SNACK': profile.distinctSnacks,
    };

    final effectiveFatLimit = _computeEffectiveFatLimit(filteredRecipes);
    final blacklistedIds = <int>{};

    for (var attempt = 0; attempt <= _maxValidationRetries; attempt++) {
      final result = <String, List<Recipe>>{};
      for (final mealType in ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK']) {
        final mt = MealType.values.firstWhere(
          (m) => m.name.toUpperCase() == mealType,
        );
        if (!enabledMeals.contains(mt)) continue;
        final needed = distinctCounts[mealType] ?? 0;
        final pool = filteredRecipes
            .where((r) =>
                r.category == mealType && !blacklistedIds.contains(r.id))
            .toList()
          ..shuffle();
        result[mealType] = pool.take(needed).toList();
      }

      final validation = _validateMacros(
        result,
        profile.dailyCalorieTarget,
        ingredientSets,
        effectiveFatLimit,
      );
      if (validation.isValid || attempt == _maxValidationRetries) {
        return result;
      }

      if (validation.recipeToBlacklist != null) {
        blacklistedIds.add(validation.recipeToBlacklist!);
      } else {
        return result;
      }
    }

    // Safety fallback
    final result = <String, List<Recipe>>{};
    for (final mealType in ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK']) {
      final mt = MealType.values.firstWhere(
        (m) => m.name.toUpperCase() == mealType,
      );
      if (!enabledMeals.contains(mt)) continue;
      final needed = distinctCounts[mealType] ?? 0;
      final pool = filteredRecipes
          .where((r) => r.category == mealType)
          .toList()
        ..shuffle();
      result[mealType] = pool.take(needed).toList();
    }
    return result;
  }

  // ── Economic mode ────────────────────────────────────────────────────

  Future<Map<String, List<Recipe>>> _selectRecipesEconomic(
    List<Recipe> filteredRecipes,
    Set<MealType> enabledMeals,
    UserProfile profile,
  ) async {
    final filteredIds = filteredRecipes.map((r) => r.id).toSet();
    final allWithDetails = (await _recipeRepository.getAllRecipesWithDetails())
        .where((rwd) => filteredIds.contains(rwd.recipe.id))
        .toList();

    final ingredientSets = {
      for (final rwd in allWithDetails)
        rwd.recipe.id: rwd.ingredients
            .map((i) => IngredientNormalizer.normalizeKey(i.name))
            .where((k) => !_scoringExcludedIngredients.contains(k))
            .toSet(),
    };

    final ingredientFrequency = <String, int>{};
    for (final ingSet in ingredientSets.values) {
      for (final ing in ingSet) {
        ingredientFrequency[ing] = (ingredientFrequency[ing] ?? 0) + 1;
      }
    }

    final distinctCounts = {
      'BREAKFAST': profile.distinctBreakfasts,
      'LUNCH': profile.distinctLunches,
      'DINNER': profile.distinctDinners,
      'SNACK': profile.distinctSnacks,
    };

    final candidatesByType = <String, List<RecipeWithDetails>>{};
    for (final rwd in allWithDetails) {
      final mt = MealType.values.firstWhere(
        (m) => m.name.toUpperCase() == rwd.recipe.category,
        orElse: () => MealType.breakfast,
      );
      if (!enabledMeals.contains(mt)) continue;
      candidatesByType.putIfAbsent(rwd.recipe.category, () => []).add(rwd);
    }
    final sortedTypes = candidatesByType.entries.toList()
      ..sort((a, b) => a.value.length.compareTo(b.value.length));

    final effectiveFatLimit = _computeEffectiveFatLimit(filteredRecipes);
    final blacklistedIds = <int>{};

    for (var attempt = 0; attempt <= _maxValidationRetries; attempt++) {
      final overlapWeight = attempt <= 2
          ? 1.0
          : attempt <= 5
              ? 0.5
              : 0.0;

      final result = _runGreedySelection(
        sortedTypes,
        distinctCounts,
        ingredientSets,
        ingredientFrequency,
        blacklistedIds,
        overlapWeight,
      );

      final validation = _validateMacros(
        result,
        profile.dailyCalorieTarget,
        ingredientSets,
        effectiveFatLimit,
      );
      if (validation.isValid || attempt == _maxValidationRetries) {
        return result;
      }

      if (validation.recipeToBlacklist != null) {
        blacklistedIds.add(validation.recipeToBlacklist!);
      } else {
        return result;
      }
    }

    return _runGreedySelection(
      sortedTypes,
      distinctCounts,
      ingredientSets,
      ingredientFrequency,
      blacklistedIds,
      0.0,
    );
  }

  Map<String, List<Recipe>> _runGreedySelection(
    List<MapEntry<String, List<RecipeWithDetails>>> sortedTypes,
    Map<String, int> distinctCounts,
    Map<int, Set<String>> ingredientSets,
    Map<String, int> ingredientFrequency,
    Set<int> blacklistedIds,
    double overlapWeight,
  ) {
    final globalSelected = <String>{};
    final selectedIds = <int>{};
    final groupUsageCount = <String, int>{};
    final result = <String, List<Recipe>>{};

    for (final entry in sortedTypes) {
      final mealType = entry.key;
      final candidates = entry.value;
      final needed = distinctCounts[mealType] ?? 0;
      final selected = <Recipe>[];

      for (var i = 0; i < needed; i++) {
        final available = candidates
            .where((rwd) =>
                !selectedIds.contains(rwd.recipe.id) &&
                !blacklistedIds.contains(rwd.recipe.id))
            .where((rwd) =>
                _isWithinGroupCaps(ingredientSets[rwd.recipe.id], groupUsageCount))
            .toList();

        if (available.isEmpty) {
          final fallback = candidates
              .where((rwd) =>
                  !selectedIds.contains(rwd.recipe.id) &&
                  !blacklistedIds.contains(rwd.recipe.id))
              .toList();
          if (fallback.isEmpty) break;
          final pick = (fallback..shuffle()).first;
          selected.add(pick.recipe);
          selectedIds.add(pick.recipe.id);
          _trackSelectedRecipe(
            ingredientSets[pick.recipe.id],
            globalSelected,
            groupUsageCount,
          );
          continue;
        }

        final currentProteinGroups =
            groupUsageCount.keys.where((k) => _proteinGroups.contains(k)).length;
        final effectiveBonus =
            currentProteinGroups < _minProteinGroups ? _diversityBonus : 0;

        final scored = available.map((rwd) {
          final ings = ingredientSets[rwd.recipe.id] ?? {};
          int score;
          if (globalSelected.isEmpty) {
            final freqScore =
                ings.fold<int>(0, (s, i) => s + (ingredientFrequency[i] ?? 0));
            score = (freqScore * overlapWeight).toInt();
          } else {
            final overlap = ings.where((i) => globalSelected.contains(i)).length;
            score = (overlap * overlapWeight).toInt();
          }
          final newGroups = ings
              .map((i) => resolveGroup(i))
              .where((g) => g != null && _proteinGroups.contains(g))
              .where((g) => !groupUsageCount.containsKey(g))
              .length;
          final fatPenalty = _computeFatPenalty(
            rwd.recipe.fatGrams,
            rwd.recipe.caloriesPerServing,
          );
          return (rwd, score + newGroups * effectiveBonus - fatPenalty);
        }).toList()
          ..sort((a, b) => b.$2.compareTo(a.$2));

        final topK = scored.take(_topKCandidates).toList()..shuffle();
        final best = topK.firstOrNull?.$1;

        if (best != null) {
          selected.add(best.recipe);
          selectedIds.add(best.recipe.id);
          _trackSelectedRecipe(
            ingredientSets[best.recipe.id],
            globalSelected,
            groupUsageCount,
          );
        }
      }

      result[mealType] = selected;
    }

    return result;
  }

  // ── Macro validation ─────────────────────────────────────────────────

  double _computeEffectiveFatLimit(List<Recipe> filteredRecipes) {
    final lunchDinner = filteredRecipes
        .where((r) => r.category == 'LUNCH' || r.category == 'DINNER')
        .toList();
    if (lunchDinner.isEmpty) return _defaultMaxFatPercent;

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
        : _defaultMaxFatPercent;
  }

  _MacroValidation _validateMacros(
    Map<String, List<Recipe>> plan,
    int dailyCalorieTarget,
    Map<int, Set<String>> ingredientSets,
    double maxFatPercent,
  ) {
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
          final group = resolveGroup(ing);
          if (group != null && _proteinGroups.contains(group)) {
            proteinGroupsUsed.add(group);
          }
        }
      }
    }

    if (avgFatPercent > maxFatPercent) {
      return _MacroValidation(
        isValid: false,
        recipeToBlacklist: fattiestRecipeId,
      );
    }
    if (avgProtPercent < _minProteinPercent) {
      return _MacroValidation(
        isValid: false,
        recipeToBlacklist: lowestProteinRecipeId,
      );
    }
    if (proteinGroupsUsed.length < _minProteinGroups) {
      return _MacroValidation(
        isValid: false,
        recipeToBlacklist: lowestProteinRecipeId,
      );
    }
    return const _MacroValidation(isValid: true);
  }

  int _computeFatPenalty(double fatGrams, int caloriesPerServing) {
    if (caloriesPerServing <= 0) return 0;
    final fatPercent = fatGrams * 9.0 / caloriesPerServing * 100.0;
    if (fatPercent > 50) return 4;
    if (fatPercent > 40) return 3;
    if (fatPercent > 30) return 1;
    return 0;
  }

  bool _isWithinGroupCaps(
    Set<String>? ingredients,
    Map<String, int> groupUsageCount,
  ) {
    final groups = ingredients
            ?.map((i) => resolveGroup(i))
            .whereType<String>()
            .toSet() ??
        {};
    return groups.every((group) {
      final maxCount = _maxRecipesPerGroup[group] ?? _defaultMaxPerGroup;
      return (groupUsageCount[group] ?? 0) < maxCount;
    });
  }

  void _trackSelectedRecipe(
    Set<String>? ingredients,
    Set<String> globalSelected,
    Map<String, int> groupUsageCount,
  ) {
    if (ingredients == null) return;
    globalSelected.addAll(ingredients);
    for (final group in ingredients.map((i) => resolveGroup(i)).whereType<String>().toSet()) {
      groupUsageCount[group] = (groupUsageCount[group] ?? 0) + 1;
    }
  }

  // ── Constants ────────────────────────────────────────────────────────

  static const _scoringExcludedIngredients = {
    'eau', 'sel', 'poivre', 'sel et poivre',
    "huile d'olive", 'huile d olive', 'huile',
    'beurre',
  };

  static const _defaultMaxPerGroup = 2;
  static const Map<String, int> _maxRecipesPerGroup = {};
  static const _defaultMaxFatPercent = 35.0;
  static const _relaxedMaxFatPercent = 38.0;
  static const _fatRelaxationThreshold = 35.0;
  static const _topKCandidates = 3;
  static const _minProteinPercent = 20.0;
  static const _minProteinGroups = 3;
  static const _diversityBonus = 15;
  static const _maxValidationRetries = 8;

  static const _proteinGroups = {
    'egg', 'poultry', 'salmon', 'tuna', 'whitefish', 'oily_fish',
    'red_meat', 'pork', 'shellfish', 'plant_protein', 'legume',
  };

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

class _MacroValidation {
  const _MacroValidation({required this.isValid, this.recipeToBlacklist});

  final bool isValid;
  final int? recipeToBlacklist;
}

/// Extension to mirror Kotlin's `none` on Iterable.
extension _IterableNone<T> on Iterable<T> {
  bool none(bool Function(T) test) => !any(test);
}
