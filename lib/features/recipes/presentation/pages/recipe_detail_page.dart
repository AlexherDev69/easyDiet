import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../../../navigation/app_router.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../../shared/widgets/solid_card.dart';
import '../cubit/recipe_detail_cubit.dart';
import '../cubit/recipe_detail_state.dart';

/// Recipe detail screen — port of RecipeDetailScreen.kt.
class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({
    required this.recipeId,
    this.planServings = 0,
    super.key,
  });

  final int recipeId;
  final double planServings;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecipeDetailCubit>();

    // Load recipe on first build
    cubit.loadRecipe(recipeId, planServings: planServings);

    return BlocBuilder<RecipeDetailCubit, RecipeDetailState>(
      builder: (context, state) {
        if (state.isLoading || state.recipe == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(
                color: AppColors.emeraldPrimary,
              ),
            ),
          );
        }

        return _RecipeDetailContent(
          recipeId: recipeId,
          planServings: planServings,
        );
      },
    );
  }
}

class _RecipeDetailContent extends StatelessWidget {
  const _RecipeDetailContent({
    required this.recipeId,
    required this.planServings,
  });

  final int recipeId;
  final double planServings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<RecipeDetailCubit>();
    final state = context.watch<RecipeDetailCubit>().state;
    final recipe = state.recipe!;
    final r = recipe.recipe;

    final macroMultiplier = state.servings;
    final servingsMultiplier = state.servings / r.servings;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          r.name,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Macros card
            _MacrosCard(
              calories: (r.caloriesPerServing * macroMultiplier).toInt(),
              protein: (r.proteinGrams * macroMultiplier).round(),
              carbs: (r.carbsGrams * macroMultiplier).round(),
              fat: (r.fatGrams * macroMultiplier).round(),
            ),
            const SizedBox(height: 16),

            // Time info
            _TimeInfoRow(
              prepMinutes: r.prepTimeMinutes,
              cookMinutes: r.cookTimeMinutes,
            ),
            const SizedBox(height: 20),

            // Servings adjuster
            _ServingsAdjuster(
              servings: state.servings,
              onIncrease: cubit.increaseServings,
              onDecrease: cubit.decreaseServings,
            ),
            const SizedBox(height: 20),

            // Ingredients
            Text(
              'Ingredients',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(recipe.ingredients.length, (index) {
              final sortedIngredients = List.of(recipe.ingredients)
                ..sort((a, b) => a.name.compareTo(b.name));
              final ingredient = sortedIngredients[index];
              final adjustedQty = ingredient.quantity * servingsMultiplier;
              return _IngredientRow(
                name: ingredient.name,
                quantity: adjustedQty,
                unit: ingredient.unit,
                isAlternate: index.isOdd,
              );
            }),
            const SizedBox(height: 20),

            Divider(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 20),

            // Steps
            Text(
              'Preparation',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(recipe.steps.length, (index) {
              final sortedSteps = List.of(recipe.steps)
                ..sort((a, b) => a.stepNumber.compareTo(b.stepNumber));
              final step = sortedSteps[index];
              return _StepRow(
                stepNumber: step.stepNumber,
                instruction: step.instruction,
                timerSeconds: step.timerSeconds,
              );
            }),
            const SizedBox(height: 24),

            // Start cooking button
            _StartCookingButton(
              onTap: () => context.push(
                AppRoutes.cookingMode(
                  recipeId,
                  planServings: state.servings,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _MacrosCard extends StatelessWidget {
  const _MacrosCard({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      gradientColors: [
        AppColors.emeraldPrimary.withValues(alpha: 0.08),
        AppColors.emeraldPrimary.withValues(alpha: 0.03),
      ],
      elevation: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _MacroItem('Calories', '$calories', 'kcal', AppColors.emeraldPrimary),
          _MacroItem('Proteines', '$protein', 'g', AppColors.accentAmber),
          _MacroItem('Glucides', '$carbs', 'g', AppColors.waterBlue),
          _MacroItem('Lipides', '$fat', 'g', AppColors.accentPurple),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  const _MacroItem(this.label, this.value, this.unit, this.color);

  final String label;
  final String value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          '$label ($unit)',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _TimeInfoRow extends StatelessWidget {
  const _TimeInfoRow({
    required this.prepMinutes,
    required this.cookMinutes,
  });

  final int prepMinutes;
  final int cookMinutes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimeChip(Icons.schedule, 'Prep.', '$prepMinutes min', theme),
        _buildTimeChip(Icons.outdoor_grill, 'Cuisson', '$cookMinutes min', theme),
        _buildTimeChip(
          Icons.schedule,
          'Total',
          '${prepMinutes + cookMinutes} min',
          theme,
        ),
      ],
    );
  }

  Widget _buildTimeChip(
    IconData icon,
    String label,
    String time,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 2),
          Text(
            time,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServingsAdjuster extends StatelessWidget {
  const _ServingsAdjuster({
    required this.servings,
    required this.onIncrease,
    required this.onDecrease,
  });

  final double servings;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  String _formatServings(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SolidCard(
      elevation: 1,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Portions :',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: servings > 0.5 ? onDecrease : null,
            icon: const Icon(Icons.remove, size: 20),
          ),
          Text(
            _formatServings(servings),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: servings < 12 ? onIncrease : null,
            icon: const Icon(Icons.add, size: 20),
          ),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.isAlternate,
  });

  final String name;
  final double quantity;
  final String unit;
  final bool isAlternate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isAlternate
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              QuantityFormatter.formatWithUnit(quantity, unit),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.stepNumber,
    required this.instruction,
    this.timerSeconds,
  });

  final int stepNumber;
  final String instruction;
  final int? timerSeconds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$stepNumber',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(instruction, style: theme.textTheme.bodyMedium),
                if (timerSeconds != null && timerSeconds! > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Minuteur : ${timerSeconds! ~/ 60} min',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentAmber,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StartCookingButton extends StatelessWidget {
  const _StartCookingButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
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
            Icon(
              Icons.play_circle,
              color: theme.colorScheme.onPrimary,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              'Lancer la cuisson',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
