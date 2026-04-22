import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../onboarding/domain/models/meal_type.dart';
import '../../domain/models/dashboard_models.dart';

/// "Prochain repas" card with left accent strip + gradient icon tile.
class NextMealCard extends StatelessWidget {
  const NextMealCard({
    required this.nextMeal,
    this.onTap,
    super.key,
  });

  final NextMealInfo nextMeal;
  final VoidCallback? onTap;

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
    final totalCalories =
        (nextMeal.caloriesPerServing * nextMeal.servings).round();
    final color = _mealColor;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      accentColor: color,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.25),
                  color.withValues(alpha: 0.18),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withValues(alpha: 0.25),
              ),
            ),
            child: Icon(
              LucideIcons.utensils,
              size: 24,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PROCHAIN REPAS - ${nextMeal.mealType.displayName.toUpperCase()}',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  nextMeal.recipeName,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$totalCalories kcal - ${nextMeal.servings.toStringAsFixed(nextMeal.servings.truncateToDouble() == nextMeal.servings ? 0 : 1)} portion',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            LucideIcons.chevronRight,
            size: 20,
            color: Color(0xFF94A3B8),
          ),
        ],
      ),
    );
  }
}
