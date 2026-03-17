import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../../shared/widgets/solid_card.dart';

/// Daily macro summary card shown at top of day meals list.
class MacroSummaryCard extends StatelessWidget {
  const MacroSummaryCard({
    required this.meals,
    super.key,
  });

  final List<MealWithRecipe> meals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final totalCal = meals.fold<int>(
      0,
      (sum, m) =>
          sum + (m.recipe.caloriesPerServing * m.meal.servings).round(),
    );
    final totalP = meals.fold<double>(
      0,
      (sum, m) => sum + m.recipe.proteinGrams * m.meal.servings,
    );
    final totalC = meals.fold<double>(
      0,
      (sum, m) => sum + m.recipe.carbsGrams * m.meal.servings,
    );
    final totalF = meals.fold<double>(
      0,
      (sum, m) => sum + m.recipe.fatGrams * m.meal.servings,
    );
    final totalMacroGrams = totalP + totalC + totalF;

    return SolidCard(
      elevation: 2,
      contentPadding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total du jour',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '$totalCal kcal',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentAmber,
                ),
              ),
            ],
          ),
          if (totalMacroGrams > 0) ...[
            const SizedBox(height: 10),
            _MacroBar(
              label: 'P',
              grams: totalP,
              total: totalMacroGrams,
              color: AppColors.breakfastColor,
            ),
            const SizedBox(height: 6),
            _MacroBar(
              label: 'C',
              grams: totalC,
              total: totalMacroGrams,
              color: AppColors.accentAmber,
            ),
            const SizedBox(height: 6),
            _MacroBar(
              label: 'L',
              grams: totalF,
              total: totalMacroGrams,
              color: AppColors.lunchColor,
            ),
          ],
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar({
    required this.label,
    required this.grams,
    required this.total,
    required this.color,
  });

  final String label;
  final double grams;
  final double total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = total > 0 ? (grams / total).clamp(0.0, 1.0) : 0.0;

    return Row(
      children: [
        SizedBox(
          width: 16,
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 36,
          child: Text(
            '${grams.round()}g',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
