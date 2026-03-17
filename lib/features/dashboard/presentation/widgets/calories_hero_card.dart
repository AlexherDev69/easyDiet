import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/gradient_card.dart';

/// Main hero card showing animated circular calorie progress + macro bars.
class CaloriesHeroCard extends StatelessWidget {
  const CaloriesHeroCard({
    required this.todayCalories,
    required this.dailyTarget,
    required this.isFreeDay,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    super.key,
  });

  final int todayCalories;
  final int dailyTarget;
  final bool isFreeDay;
  final double protein;
  final double carbs;
  final double fat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = dailyTarget > 0
        ? (todayCalories / dailyTarget).clamp(0.0, 1.0)
        : 0.0;

    return GradientCard(
      gradientColors: [
        AppColors.emeraldPrimary.withValues(alpha: 0.08),
        AppColors.emeraldLight.withValues(alpha: 0.12),
      ],
      contentPadding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Repas du jour',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isFreeDay)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Jour libre',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Animated circular progress
          SizedBox(
            width: 160,
            height: 160,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, animatedProgress, _) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: animatedProgress,
                        strokeWidth: 14,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.emeraldPrimary,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated counter
                        _AnimatedCalorieCounter(
                          targetValue: todayCalories,
                          style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ) ??
                              const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        Text(
                          '/ $dailyTarget kcal',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          // Macro bars
          if (protein + carbs + fat > 0) ...[
            const SizedBox(height: 12),
            _MacroBar(
              label: 'P',
              grams: protein,
              total: protein + carbs + fat,
              color: AppColors.accentRose,
            ),
            const SizedBox(height: 6),
            _MacroBar(
              label: 'C',
              grams: carbs,
              total: protein + carbs + fat,
              color: AppColors.accentAmber,
            ),
            const SizedBox(height: 6),
            _MacroBar(
              label: 'L',
              grams: fat,
              total: protein + carbs + fat,
              color: AppColors.waterBlue,
            ),
          ],
        ],
      ),
    );
  }
}

/// Animated integer counter that counts up to the target value.
class _AnimatedCalorieCounter extends StatelessWidget {
  const _AnimatedCalorieCounter({
    required this.targetValue,
    required this.style,
  });

  final int targetValue;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: targetValue),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Text('$value', style: style);
      },
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

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, animatedProgress, _) {
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
                  value: animatedProgress,
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
      },
    );
  }
}
