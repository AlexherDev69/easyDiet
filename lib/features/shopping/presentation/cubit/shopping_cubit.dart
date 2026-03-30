import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/quantity_formatter.dart';
import '../../../../data/local/database.dart';
import '../../../../data/local/models/week_plan_with_days.dart';
import '../../../meal_plan/domain/repositories/meal_plan_repository.dart';
import '../../../settings/domain/repositories/user_profile_repository.dart';
import '../../domain/models/ingredient_source.dart';
import '../../domain/repositories/shopping_repository.dart';
import '../../domain/usecases/shopping_list_generator.dart';
import 'shopping_state.dart';

/// Manages shopping list — port of ShoppingViewModel.kt.
class ShoppingCubit extends Cubit<ShoppingState> {
  ShoppingCubit({
    required ShoppingRepository shoppingRepository,
    required MealPlanRepository mealPlanRepository,
    required ShoppingListGenerator shoppingListGenerator,
    required UserProfileRepository userProfileRepository,
  })  : _shoppingRepository = shoppingRepository,
        _mealPlanRepository = mealPlanRepository,
        _shoppingListGenerator = shoppingListGenerator,
        _userProfileRepository = userProfileRepository,
        super(const ShoppingState()) {
    _loadShoppingList();
  }

  final ShoppingRepository _shoppingRepository;
  final MealPlanRepository _mealPlanRepository;
  final ShoppingListGenerator _shoppingListGenerator;
  final UserProfileRepository _userProfileRepository;

  StreamSubscription<WeekPlanWithDays?>? _planSubscription;
  StreamSubscription<List<ShoppingItem>>? _itemsSubscription;
  String? _lastPlanHash;
  bool _isGenerating = false;
  int? _currentWeekPlanId;

  // ── Public actions ──────────────────────────────────────────────────

  void selectTrip(int trip) {
    final filtered =
        _filterByTrip(state.allItems, trip, state.totalTrips);
    emit(state.copyWith(
      selectedTrip: trip,
      items: filtered,
      estimatedWeight: _estimateCartWeight(filtered),
    ));
  }

  void toggleSection(String section) {
    final updated = Set.of(state.collapsedSections);
    if (updated.contains(section)) {
      updated.remove(section);
    } else {
      updated.add(section);
    }
    emit(state.copyWith(collapsedSections: updated));
  }

  Future<void> toggleItemChecked(int itemId, bool currentlyChecked) async {
    emit(state.copyWith(clearErrorMessage: true));
    try {
      await _shoppingRepository.updateChecked(itemId, !currentlyChecked);
    } catch (e) {
      debugPrint('Error in toggleItemChecked: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> deleteItem(int itemId) async {
    emit(state.copyWith(clearErrorMessage: true));
    try {
      await _shoppingRepository.deleteItem(itemId);
    } catch (e) {
      debugPrint('Error in deleteItem: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> resetChecks() async {
    emit(state.copyWith(clearErrorMessage: true));
    try {
      final weekPlanId = state.weekPlanId;
      if (weekPlanId == null) return;
      await _shoppingRepository.uncheckAll(weekPlanId);
    } catch (e) {
      debugPrint('Error in resetChecks: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void showItemDetail(ShoppingItem item) {
    final sources = _parseSourceDetails(item.sourceDetails);
    final qtyStr = QuantityFormatter.formatWithUnit(item.quantity, item.unit);
    emit(state.copyWith(
      selectedItemName: item.name,
      selectedItemQuantity: qtyStr,
      selectedItemSources: sources,
    ));
  }

  void hideItemDetail() {
    emit(state.copyWith(clearItemDetail: true));
  }

  Future<void> addItem(
    String name,
    double quantity,
    String unit,
    String section,
  ) async {
    emit(state.copyWith(clearErrorMessage: true));
    try {
      final weekPlanId = state.weekPlanId;
      if (weekPlanId == null) return;

      await _shoppingRepository.insertItem(
        ShoppingItemsCompanion.insert(
          weekPlanId: weekPlanId,
          name: name,
          quantity: quantity,
          unit: unit,
          supermarketSection: section,
          isManuallyAdded: const Value(true),
          tripNumber: Value(state.selectedTrip),
        ),
      );
    } catch (e) {
      debugPrint('Error in addItem: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // ── Private ───────────────────────────────────────────────────────

  Future<void> _loadShoppingList() async {
    try {
      final profile = await _userProfileRepository.getProfile();
      final tripsPerWeek = profile?.shoppingTripsPerWeek ?? 1;

      _planSubscription =
        _mealPlanRepository.watchCurrentWeekPlan().listen((weekPlan) {
      if (weekPlan == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      emit(state.copyWith(weekPlanId: weekPlan.weekPlan.id));
      final tripSummaries = _buildTripDaySummaries(weekPlan, tripsPerWeek);
      final currentHash = _computePlanHash(weekPlan);
      final planChanged = _lastPlanHash != null && currentHash != _lastPlanHash;
      _lastPlanHash = currentHash;

      if (planChanged && !_isGenerating) {
        _regenerateList(weekPlan, tripsPerWeek);
      }

      // Only re-subscribe to item stream when weekPlanId actually changes.
      if (_currentWeekPlanId != weekPlan.weekPlan.id) {
        _currentWeekPlanId = weekPlan.weekPlan.id;
        _itemsSubscription?.cancel();
        _itemsSubscription = _shoppingRepository
            .watchItemsForWeek(weekPlan.weekPlan.id)
            .listen((items) {
        if (items.isEmpty && !_isGenerating) {
          _regenerateList(weekPlan, tripsPerWeek);
        } else if (items.isNotEmpty) {
          // Check if existing items still match the current plan.
          // This handles the case where the cubit is re-created after
          // a recipe swap (e.g. navigating back to the shopping tab).
          if (!planChanged && _shouldRegenerate(items, weekPlan)) {
            _regenerateList(weekPlan, tripsPerWeek);
            return;
          }
          final deduped = _deduplicateItems(items);
          final filtered =
              _filterByTrip(deduped, state.selectedTrip, tripsPerWeek);
          emit(state.copyWith(
            allItems: deduped,
            items: filtered,
            isLoading: false,
            estimatedWeight: _estimateCartWeight(filtered),
            totalTrips: tripsPerWeek,
            tripDaySummaries: tripSummaries,
          ));
        }
      }, onError: (Object e) {
        debugPrint('Error in watchItemsForWeek: $e');
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      });
      } // end if (_currentWeekPlanId != weekPlan.weekPlan.id)
    }, onError: (Object e) {
      debugPrint('Error in watchCurrentWeekPlan: $e');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    });
    } catch (e) {
      debugPrint('Error in _loadShoppingList: $e');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _regenerateList(
    WeekPlanWithDays weekPlan,
    int tripsPerWeek,
  ) async {
    try {
      _isGenerating = true;
      await _shoppingListGenerator.generateShoppingList(
        weekPlan,
        shoppingTripsPerWeek: tripsPerWeek,
      );
      _isGenerating = false;
    } catch (e) {
      _isGenerating = false;
      debugPrint('Error in _regenerateList: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  List<ShoppingItem> _deduplicateItems(List<ShoppingItem> items) {
    final grouped = <String, List<ShoppingItem>>{};
    for (final item in items) {
      final key =
          '${item.name.toLowerCase()}|${item.unit.toLowerCase()}|${item.supermarketSection}|${item.tripNumber}';
      grouped.putIfAbsent(key, () => []).add(item);
    }
    return grouped.values.map((duplicates) {
      if (duplicates.length == 1) return duplicates.first;
      final totalQty =
          duplicates.fold<double>(0, (s, i) => s + i.quantity);
      final anyChecked = duplicates.any((i) => i.isChecked);
      return duplicates.first.copyWith(
        quantity: totalQty,
        isChecked: anyChecked,
      );
    }).toList();
  }

  List<ShoppingItem> _filterByTrip(
    List<ShoppingItem> items,
    int trip,
    int totalTrips,
  ) {
    if (totalTrips <= 1) return items;
    return items.where((i) => i.tripNumber == trip).toList();
  }

  /// Checks if the shopping items were generated from a different plan version.
  /// Compares recipe names in sourceDetails against the current plan recipes.
  bool _shouldRegenerate(
    List<ShoppingItem> items,
    WeekPlanWithDays weekPlan,
  ) {
    // Only check auto-generated items (not manually added).
    final autoItems = items.where((i) => !i.isManuallyAdded).toList();
    if (autoItems.isEmpty) return false;

    // Build set of recipe names from the current plan.
    final planRecipeNames = weekPlan.days
        .where((d) => !d.dayPlan.isFreeDay)
        .expand((d) => d.meals)
        .map((m) => m.recipe.name)
        .toSet();

    // Extract recipe names from source details of shopping items.
    final itemRecipeNames = <String>{};
    for (final item in autoItems) {
      try {
        final sources = jsonDecode(item.sourceDetails) as List;
        for (final s in sources) {
          if (s is Map<String, dynamic> && s.containsKey('recipeName')) {
            itemRecipeNames.add(s['recipeName'] as String);
          }
        }
      } catch (_) {}
    }

    // If recipe names don't match, the list is stale.
    if (itemRecipeNames.isEmpty) return false;
    return !planRecipeNames.containsAll(itemRecipeNames) ||
        !itemRecipeNames.containsAll(planRecipeNames);
  }

  String _computePlanHash(WeekPlanWithDays weekPlan) {
    final sorted = List.of(weekPlan.days)
      ..sort((a, b) => a.dayPlan.date.compareTo(b.dayPlan.date));
    return sorted
        .expand(
            (d) => d.meals.map((m) => '${m.meal.recipeId}:${m.meal.servings}'))
        .join(',');
  }

  Map<int, String> _buildTripDaySummaries(
    WeekPlanWithDays weekPlan,
    int tripsPerWeek,
  ) {
    if (tripsPerWeek <= 1) return {};
    final dietDays = weekPlan.days
        .where((d) => !d.dayPlan.isFreeDay)
        .toList()
      ..sort((a, b) => a.dayPlan.date.compareTo(b.dayPlan.date));

    final splitIndex = (dietDays.length / 2).ceil();
    const shortNames = {
      1: 'Lun',
      2: 'Mar',
      3: 'Mer',
      4: 'Jeu',
      5: 'Ven',
      6: 'Sam',
      7: 'Dim',
    };
    final trip1 = dietDays
        .take(splitIndex)
        .map((d) => shortNames[d.dayPlan.dayOfWeek] ?? '?')
        .join(' · ');
    final trip2 = dietDays
        .skip(splitIndex)
        .map((d) => shortNames[d.dayPlan.dayOfWeek] ?? '?')
        .join(' · ');

    return {1: trip1, 2: trip2};
  }

  List<IngredientSource> _parseSourceDetails(String json) {
    try {
      final list = jsonDecode(json) as List;
      return list
          .map((e) => IngredientSource.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  double _estimateCartWeight(List<ShoppingItem> items) {
    return items.where((i) => !i.isChecked).fold<double>(0, (sum, item) {
      switch (item.unit.toLowerCase()) {
        case 'kg':
          return sum + item.quantity;
        case 'g':
          return sum + item.quantity / 1000;
        case 'ml':
          return sum + item.quantity / 1000;
        case 'l':
          return sum + item.quantity;
        default:
          return sum + 0.1;
      }
    });
  }

  @override
  Future<void> close() {
    _planSubscription?.cancel();
    _itemsSubscription?.cancel();
    return super.close();
  }
}
