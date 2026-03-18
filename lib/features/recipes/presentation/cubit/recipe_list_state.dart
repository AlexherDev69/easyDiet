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
  });

  final List<RecipeWithDetails> allRecipes;
  final Set<int> weekRecipeIds;
  final int selectedTab;
  final String? selectedCategory;
  final bool isLoading;

  @override
  List<Object?> get props => [
        allRecipes,
        weekRecipeIds,
        selectedTab,
        selectedCategory,
        isLoading,
      ];

  RecipeListState copyWith({
    List<RecipeWithDetails>? allRecipes,
    Set<int>? weekRecipeIds,
    int? selectedTab,
    String? selectedCategory,
    bool? isLoading,
    bool clearCategory = false,
  }) {
    return RecipeListState(
      allRecipes: allRecipes ?? this.allRecipes,
      weekRecipeIds: weekRecipeIds ?? this.weekRecipeIds,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
