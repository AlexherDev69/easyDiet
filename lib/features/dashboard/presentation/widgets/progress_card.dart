import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/widgets/gradient_card.dart';

/// Weight loss progress bar + stats.
class ProgressCard extends StatelessWidget {
  const ProgressCard({
    required this.totalLost,
    required this.kgRemaining,
    required this.initialWeight,
    required this.targetWeight,
    this.estimatedGoalDate,
    super.key,
  });

  final double totalLost;
  final double kgRemaining;
  final double initialWeight;
  final double targetWeight;
  final DateTime? estimatedGoalDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalToLose = initialWeight - targetWeight;
    final progress =
        totalToLose > 0 ? (totalLost / totalToLose).clamp(0.0, 1.0) : 0.0;

    return GradientCard(
      gradientColors: [
        AppColors.accentPurple.withValues(alpha: 0.06),
        AppColors.accentPurpleLight.withValues(alpha: 0.10),
      ],
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progression',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accentPurple,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${kgRemaining.toStringAsFixed(1)} kg restants',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                'Perdu : ${totalLost.toStringAsFixed(1)} kg',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentPurple,
                ),
              ),
            ],
          ),

          if (estimatedGoalDate != null) ...[
            const SizedBox(height: 4),
            Text(
              'Objectif estime : ${AppDateUtils.formatFrenchDate(estimatedGoalDate!)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
