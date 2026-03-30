import 'package:equatable/equatable.dart';

import '../../../../data/local/models/recipe_with_details.dart';

/// State for the recipe list screen.
class RecipeListState extends Equatable {
  const RecipeListState({
    this.allRecipes = const [],
    this.weekRecipeIds = const {},
    this.selectedTab = 0,
    this.selectedCategory,
    this.isLoading = true,
    this.errorMessage,
  });

  final List<RecipeWithDetails> allRecipes;
  final Set<int> weekRecipeIds;
  final int selectedTab;
  final String? selectedCategory;
  final bool isLoading;
  final String? errorMessage;

  static const _mealTypeOrder = ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK'];

  /// Pre-computed filtered, sorted, and grouped recipe list.
  List<(String, List<RecipeWithDetails>)> get filteredGroupedRecipes {
    final baseRecipes = selectedTab == 0
        ? allRecipes.where((r) => weekRecipeIds.contains(r.recipe.id)).toList()
        : allRecipes;

    final filtered = selectedCategory != null
        ? baseRecipes
            .where((r) => r.recipe.category == selectedCategory)
            .toList()
        : baseRecipes;

    final sorted = List.of(filtered)
      ..sort((a, b) {
        final ai = _mealTypeOrder.indexOf(a.recipe.category);
        final bi = _mealTypeOrder.indexOf(b.recipe.category);
        return (ai == -1 ? 999 : ai).compareTo(bi == -1 ? 999 : bi);
      });

    final grouped = <String, List<RecipeWithDetails>>{};
    for (final recipe in sorted) {
      grouped.putIfAbsent(recipe.recipe.category, () => []).add(recipe);
    }
    for (final list in grouped.values) {
      list.sort((a, b) => a.recipe.name.compareTo(b.recipe.name));
    }

    return _mealTypeOrder
        .where(grouped.containsKey)
        .map((cat) => (cat, grouped[cat]!))
        .toList();
  }

  @override
  List<Object?> get props => [
        allRecipes,
        weekRecipeIds,
        selectedTab,
        selectedCategory,
        isLoading,
        errorMessage,
      ];

  RecipeListState copyWith({
    List<RecipeWithDetails>? allRecipes,
    Set<int>? weekRecipeIds,
    int? selectedTab,
    String? selectedCategory,
    bool? isLoading,
    bool clearCategory = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RecipeListState(
      allRecipes: allRecipes ?? this.allRecipes,
      weekRecipeIds: weekRecipeIds ?? this.weekRecipeIds,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
