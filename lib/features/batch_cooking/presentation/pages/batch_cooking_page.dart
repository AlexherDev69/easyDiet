import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../../../navigation/app_router.dart';
import '../../../../shared/widgets/solid_card.dart';
import '../../domain/models/batch_cooking_models.dart';
import '../cubit/batch_cooking_cubit.dart';
import '../cubit/batch_cooking_state.dart';

/// Batch cooking overview screen — port of BatchCookingScreen.kt.
class BatchCookingPage extends StatelessWidget {
  const BatchCookingPage({
    required this.dayPlanId,
    super.key,
  });

  final int dayPlanId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BatchCookingCubit>();
    cubit.loadBatchCooking(dayPlanId);

    return BlocBuilder<BatchCookingCubit, BatchCookingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Batch Cooking - Session ${state.sessionNumber}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, BatchCookingState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.emeraldPrimary),
      );
    }

    if (state.recipes.isEmpty) {
      return Center(
        child: Text(
          'Aucune recette pour cette session',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time summary card
          _TimeSummaryCard(state: state),
          const SizedBox(height: 12),

          // Start batch cooking button
          _StartBatchCookingButton(
            onTap: () => context.push(
              AppRoutes.batchCookingMode(dayPlanId),
            ),
          ),
          const SizedBox(height: 16),

          // Common ingredients
          if (state.commonIngredients.isNotEmpty) ...[
            _CommonIngredientsSection(
              ingredients: state.commonIngredients,
            ),
            const SizedBox(height: 16),
          ],

          // Recipes
          Text(
            'Recettes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          ...state.recipes.map((recipe) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RecipeCard(
                  recipe: recipe,
                  onStartCooking: () => context.push(
                    AppRoutes.recipeDetail(recipe.recipeId),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _TimeSummaryCard extends StatelessWidget {
  const _TimeSummaryCard({required this.state});

  final BatchCookingState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.emeraldPrimary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${state.recipes.length} recettes a preparer',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.schedule, size: 18,
                  color: Colors.white.withValues(alpha: 0.85)),
              const SizedBox(width: 6),
              Text(
                'Prep : ~${state.totalPrepTime} min',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
              ),
              const SizedBox(width: 16),
              Text(
                'Cuisson : ~${state.totalCookTime} min',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StartBatchCookingButton extends StatelessWidget {
  const _StartBatchCookingButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.emeraldPrimary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_arrow, size: 24, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Lancer le batch cooking',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommonIngredientsSection extends StatelessWidget {
  const _CommonIngredientsSection({required this.ingredients});

  final List<MergedIngredient> ingredients;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SolidCard(
      elevation: 3,
      contentPadding: EdgeInsets.zero,
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            color: AppColors.emeraldPrimary.withValues(alpha: 0.08),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.emeraldPrimary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🥝', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ingredients communs',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.emeraldPrimary,
                        ),
                      ),
                      Text(
                        'Preparez-les en une seule fois',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${ingredients.length}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Ingredient rows
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              children: List.generate(ingredients.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < ingredients.length - 1 ? 10 : 0,
                  ),
                  child: _CommonIngredientRow(
                    ingredient: ingredients[index],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommonIngredientRow extends StatelessWidget {
  const _CommonIngredientRow({required this.ingredient});

  final MergedIngredient ingredient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: ingredient.fromRecipes.map((recipeName) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        recipeName,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.emeraldPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentAmber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              QuantityFormatter.formatWithUnit(
                ingredient.quantity,
                ingredient.unit,
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.accentAmber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({
    required this.recipe,
    required this.onStartCooking,
  });

  final BatchCookingRecipeInfo recipe;
  final VoidCallback onStartCooking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SolidCard(
      cornerRadius: 16,
      elevation: 2,
      contentPadding: const EdgeInsets.all(14),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe name + badges
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.recipeName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _Badge(
                      label: _formatMealType(recipe.mealType),
                      color: AppColors.emeraldPrimary,
                    ),
                    _Badge(
                      label:
                          '${QuantityFormatter.formatServings(recipe.servings)} portions',
                      color: AppColors.accentAmber,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.schedule, size: 12,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 2),
                        Text(
                          '${recipe.totalTimeMinutes} min',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 10),

            // Ingredients
            Text(
              'Ingredients',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            ...List.generate(recipe.ingredients.length, (index) {
              final ingredient = recipe.ingredients[index];
              final adjustedQty =
                  ingredient.quantity * recipe.servingsMultiplier;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: index.isEven
                      ? theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3)
                      : null,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        ingredient.name,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    Text(
                      QuantityFormatter.formatWithUnit(
                        adjustedQty,
                        ingredient.unit,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),

            // Start cooking button
            InkWell(
              onTap: onStartCooking,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.gradientGreenStart,
                      AppColors.gradientGreenEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emeraldPrimary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow, size: 20, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'Lancer la cuisson',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  String _formatMealType(String mealType) {
    return switch (mealType.toUpperCase()) {
      'BREAKFAST' => 'Petit-dej',
      'LUNCH' => 'Dejeuner',
      'DINNER' => 'Diner',
      'SNACK' => 'Snack',
      _ => mealType,
    };
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// Helper to create a RoundedRectangleBorder.
// ignore: non_constant_identifier_names
RoundedRectangleBorder RoundedCornerShape(double radius) =>
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
