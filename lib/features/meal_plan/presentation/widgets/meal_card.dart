import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/recipe_thumb.dart';
import '../../../onboarding/domain/models/meal_type.dart';

/// Card for a single meal — gradient accent strip + uppercase type pill +
/// recipe name + kcal/time row + 28x28 check tile.
class MealCard extends StatelessWidget {
  const MealCard({
    required this.mealWithRecipe,
    required this.onSwap,
    required this.onMove,
    required this.onClick,
    required this.onToggleConsumed,
    super.key,
  });

  final MealWithRecipe mealWithRecipe;
  final VoidCallback onSwap;
  final VoidCallback onMove;
  final VoidCallback onClick;
  final VoidCallback onToggleConsumed;

  MealType? get _mealType {
    for (final t in MealType.values) {
      if (t.name.toUpperCase() == mealWithRecipe.meal.mealType) return t;
    }
    return null;
  }

  String get _mealTypeName =>
      _mealType?.displayName ?? mealWithRecipe.meal.mealType;

  Color get _mealTypeColor {
    switch (_mealType) {
      case MealType.breakfast:
        return AppColors.breakfastColor;
      case MealType.lunch:
        return AppColors.lunchColor;
      case MealType.dinner:
        return AppColors.dinnerColor;
      case MealType.snack:
        return AppColors.snackColor;
      case null:
        return AppColors.emeraldPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConsumed = mealWithRecipe.meal.isConsumed;
    final recipe = mealWithRecipe.recipe;
    final servings = mealWithRecipe.meal.servings;
    final totalKcal = (recipe.caloriesPerServing * servings).round();
    final prepMinutes = recipe.prepTimeMinutes + recipe.cookTimeMinutes;

    final content = GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 18,
      accentColor: _mealTypeColor,
      onTap: onClick,
      child: Row(
        children: [
          RecipeThumb(
            imagePath: recipe.imagePath,
            size: 56,
            radius: 12,
            fallbackColor: _mealTypeColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _mealTypeName.toUpperCase(),
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: _mealTypeColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${QuantityFormatter.formatServings(servings)} pers.',
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    const Spacer(),
                    _MoreButton(onMove: onMove, onSwap: onSwap),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  recipe.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    color: const Color(0xFF0F172A),
                    decoration:
                        isConsumed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      LucideIcons.flame,
                      size: 11,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '$totalKcal kcal',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF64748B).withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      LucideIcons.clock,
                      size: 11,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      prepMinutes > 0 ? '${prepMinutes}min' : 'pret',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _CheckTile(
            checked: isConsumed,
            color: _mealTypeColor,
            onTap: onToggleConsumed,
          ),
        ],
      ),
    );

    return isConsumed ? Opacity(opacity: 0.72, child: content) : content;
  }
}

class _CheckTile extends StatelessWidget {
  const _CheckTile({
    required this.checked,
    required this.color,
    required this.onTap,
  });

  final bool checked;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: checked ? 'Repas consomme' : 'Marquer comme consomme',
      button: true,
      toggled: checked,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: checked
                  ? color
                  : const Color(0xFF0F172A).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(9),
              border: checked
                  ? null
                  : Border.all(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.15),
                      width: 2,
                    ),
            ),
            child: checked
                ? const Icon(
                    LucideIcons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({required this.onMove, required this.onSwap});

  final VoidCallback onMove;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      iconSize: 18,
      padding: EdgeInsets.zero,
      icon: const Icon(
        LucideIcons.ellipsisVertical,
        size: 18,
        color: Color(0xFF64748B),
      ),
      tooltip: 'Actions',
      onSelected: (v) {
        if (v == 'move') onMove();
        if (v == 'swap') onSwap();
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'move',
          child: Row(
            children: [
              const Icon(LucideIcons.arrowRightLeft, size: 16),
              const SizedBox(width: 8),
              Text(
                'Deplacer',
                style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'swap',
          child: Row(
            children: [
              const Icon(LucideIcons.replace, size: 16),
              const SizedBox(width: 8),
              Text(
                'Remplacer',
                style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
