import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/local/models/recipe_with_details.dart';
import '../../../../navigation/app_router.dart';
import '../cubit/recipe_list_cubit.dart';
import '../cubit/recipe_list_state.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/category_header.dart';
import '../widgets/recipe_list_card.dart';

/// Recipe list screen — port of RecipeListScreen.kt.
class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListCubit, RecipeListState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.emeraldPrimary,
            ),
          );
        }

        return _RecipeListContent(state: state);
      },
    );
  }
}

class _RecipeListContent extends StatelessWidget {
  const _RecipeListContent({required this.state});

  final RecipeListState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecipeListCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recettes',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          // Tabs: This week / All recipes
          _RecipeTabs(
            selectedTab: state.selectedTab,
            onSelectTab: cubit.selectTab,
          ),

          // Category filter chips
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CategoryFilterChips(
              selectedCategory: state.selectedCategory,
              onSelectCategory: cubit.selectCategory,
            ),
          ),

          // Recipe list
          Expanded(
            child: _RecipeListBody(state: state),
          ),
        ],
      ),
    );
  }
}

class _RecipeTabs extends StatelessWidget {
  const _RecipeTabs({
    required this.selectedTab,
    required this.onSelectTab,
  });

  final int selectedTab;
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: selectedTab,
      child: TabBar(
        onTap: onSelectTab,
        tabs: const [
          Tab(text: 'Cette semaine'),
          Tab(text: 'Toutes les recettes'),
        ],
      ),
    );
  }
}

class _RecipeListBody extends StatelessWidget {
  const _RecipeListBody({required this.state});

  final RecipeListState state;

  static const _mealTypeOrder = ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter by tab
    final baseRecipes = state.selectedTab == 0
        ? state.allRecipes
            .where((r) => state.weekRecipeIds.contains(r.recipe.id))
            .toList()
        : state.allRecipes;

    // Filter by category
    final filteredRecipes = state.selectedCategory != null
        ? baseRecipes
            .where((r) => r.recipe.category == state.selectedCategory)
            .toList()
        : baseRecipes;

    // Sort by meal type order
    final sortedRecipes = List.of(filteredRecipes)
      ..sort((a, b) {
        final ai = _mealTypeOrder.indexOf(a.recipe.category);
        final bi = _mealTypeOrder.indexOf(b.recipe.category);
        return (ai == -1 ? 999 : ai).compareTo(bi == -1 ? 999 : bi);
      });

    if (sortedRecipes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            state.selectedTab == 0
                ? 'Aucune recette cette semaine'
                : 'Aucune recette disponible',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    // Group by category, sorted alphabetically within each group
    final grouped = <String, List<RecipeWithDetails>>{};
    for (final recipe in sortedRecipes) {
      grouped.putIfAbsent(recipe.recipe.category, () => []).add(recipe);
    }
    for (final list in grouped.values) {
      list.sort((a, b) => a.recipe.name.compareTo(b.recipe.name));
    }

    final orderedGroups = _mealTypeOrder
        .where(grouped.containsKey)
        .map((cat) => MapEntry(cat, grouped[cat]!))
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      itemCount: orderedGroups.fold<int>(
        0,
        (sum, g) => sum + 1 + g.value.length, // header + items
      ),
      itemBuilder: (context, index) {
        var offset = 0;
        for (final group in orderedGroups) {
          // Header
          if (index == offset) {
            final filter = categoryFilters.where((f) => f.key == group.key);
            final label =
                filter.isNotEmpty ? filter.first.label : group.key;
            final color =
                filter.isNotEmpty ? filter.first.color : AppColors.emeraldPrimary;
            return CategoryHeader(
              label: label,
              color: color,
              count: group.value.length,
            );
          }
          offset++;

          // Items
          if (index < offset + group.value.length) {
            final recipe = group.value[index - offset];
            final filter = categoryFilters.where((f) => f.key == group.key);
            final color =
                filter.isNotEmpty ? filter.first.color : AppColors.emeraldPrimary;
            return RecipeListCard(
              recipe: recipe,
              categoryColor: color,
              onTap: () => context.push(
                AppRoutes.recipeDetail(recipe.recipe.id),
              ),
            );
          }
          offset += group.value.length;
        }
        return const SizedBox.shrink();
      },
    );
  }
}
