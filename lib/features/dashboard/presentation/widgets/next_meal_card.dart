import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../onboarding/domain/models/meal_type.dart';
import '../../domain/models/dashboard_models.dart';

/// Small card showing the next upcoming meal.
class NextMealCard extends StatelessWidget {
  const NextMealCard({
    required this.nextMeal,
    super.key,
  });

  final NextMealInfo nextMeal;

  Color get _mealColor {
    switch (nextMeal.mealType) {
      case MealType.breakfast:
        return AppColors.breakfastColor;
      case MealType.lunch:
        return AppColors.lunchColor;
      case MealType.dinner:
        return AppColors.dinnerColor;
      case MealType.snack:
        return AppColors.snackColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalCalories =
        (nextMeal.caloriesPerServing * nextMeal.servings).round();

    return GradientCard(
      gradientColors: [
        _mealColor.withValues(alpha: 0.08),
        _mealColor.withValues(alpha: 0.12),
      ],
      elevation: 2,
      contentPadding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.schedule,
            color: _mealColor,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            nextMeal.mealType.displayName,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            nextMeal.recipeName,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '$totalCalories kcal',
            style: theme.textTheme.bodySmall?.copyWith(
              color: _mealColor,
            ),
          ),
        ],
      ),
    );
  }
}
