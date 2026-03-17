import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/solid_card.dart';
import '../../../onboarding/domain/models/meal_type.dart';
import '../../domain/models/dashboard_models.dart';

/// Card teasing the next batch cooking session.
class NextBatchCookingCard extends StatelessWidget {
  const NextBatchCookingCard({
    required this.batch,
    this.onTap,
    super.key,
  });

  final NextBatchCookingInfo batch;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SolidCard(
      elevation: 2,
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.emeraldPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.kitchen,
                color: AppColors.emeraldPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prochain batch cooking',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    batch.dayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...batch.meals.map((meal) {
                    final mealType = _parseMealType(meal.meal.mealType);
                    final label =
                        mealType?.displayName ?? meal.meal.mealType;
                    return Text(
                      '$label : ${meal.recipe.name}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  MealType? _parseMealType(String raw) {
    try {
      return MealType.values.firstWhere(
        (t) => t.name.toUpperCase() == raw,
      );
    } catch (_) {
      return null;
    }
  }
}
