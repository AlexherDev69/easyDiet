import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

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

class _RecipeTabs extends StatefulWidget {
  const _RecipeTabs({
    required this.selectedTab,
    required this.onSelectTab,
  });

  final int selectedTab;
  final ValueChanged<int> onSelectTab;

  @override
  State<_RecipeTabs> createState() => _RecipeTabsState();
}

class _RecipeTabsState extends State<_RecipeTabs>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      initialIndex: widget.selectedTab,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        widget.onSelectTab(_tabController.index);
      }
    });
  }

  @override
  void didUpdateWidget(_RecipeTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTab != widget.selectedTab &&
        _tabController.index != widget.selectedTab) {
      _tabController.animateTo(widget.selectedTab);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Cette semaine'),
        Tab(text: 'Toutes les recettes'),
      ],
    );
  }
}

class _RecipeListBody extends StatelessWidget {
  const _RecipeListBody({required this.state});

  final RecipeListState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderedGroups = state.filteredGroupedRecipes;

    if (orderedGroups.isEmpty) {
      final hasFilter = state.selectedCategory != null;
      final message = hasFilter
          ? 'Aucune recette ne correspond a ce filtre'
          : state.selectedTab == 0
              ? 'Aucune recette cette semaine'
              : 'Aucune recette disponible';
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                hasFilter ? Icons.filter_list_off : Icons.restaurant_menu,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (hasFilter) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () =>
                      context.read<RecipeListCubit>().selectCategory(null),
                  child: const Text('Effacer le filtre'),
                ),
              ],
              if (!hasFilter && state.selectedTab == 0) ...[
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: () => context.push(AppRoutes.planConfig),
                  child: const Text('Generer un plan'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      itemCount: orderedGroups.fold<int>(
        0,
        (sum, g) => sum + 1 + g.$2.length, // header + items
      ),
      itemBuilder: (context, index) {
        var offset = 0;
        for (final (category, recipes) in orderedGroups) {
          // Header
          if (index == offset) {
            final filter = categoryFilters.where((f) => f.key == category);
            final label =
                filter.isNotEmpty ? filter.first.label : category;
            final color =
                filter.isNotEmpty ? filter.first.color : AppColors.emeraldPrimary;
            return CategoryHeader(
              label: label,
              color: color,
              count: recipes.length,
            );
          }
          offset++;

          // Items
          if (index < offset + recipes.length) {
            final recipe = recipes[index - offset];
            final filter = categoryFilters.where((f) => f.key == category);
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
          offset += recipes.length;
        }
        return const SizedBox.shrink();
      },
    );
  }
}
