import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/local/database.dart';
import '../../../../shared/widgets/glass_dialog.dart';

/// Dialog for choosing an alternative recipe to swap in.
class SwapMealDialog extends StatelessWidget {
  const SwapMealDialog({
    required this.alternatives,
    required this.otherOccurrencesCount,
    required this.currentRecipeName,
    required this.onSelectRecipe,
    required this.onDismiss,
    super.key,
  });

  final List<Recipe> alternatives;
  final int otherOccurrencesCount;
  final String currentRecipeName;
  final void Function(Recipe recipe, bool replaceAll) onSelectRecipe;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassDialogContent(
      icon: Icons.restaurant_menu,
      title: 'Choisir un repas alternatif',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Scrollable recipe list — capped so it doesn't overflow on small screens
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 360),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: alternatives.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final recipe = alternatives[index];
                return GlassDialogListTile(
                  onTap: () {
                    if (otherOccurrencesCount > 0) {
                      _showReplaceAllDialog(context, recipe);
                    } else {
                      onSelectRecipe(recipe, false);
                    }
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.emeraldPrimary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      size: 18,
                      color: AppColors.emeraldPrimary,
                    ),
                  ),
                  title: Text(
                    recipe.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${recipe.caloriesPerServing} kcal  '
                    'P:${recipe.proteinGrams.round()}g '
                    'C:${recipe.carbsGrams.round()}g '
                    'L:${recipe.fatGrams.round()}g',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          GlassDialogButton(label: 'Annuler', onPressed: onDismiss),
        ],
      ),
    );
  }

  void _showReplaceAllDialog(BuildContext context, Recipe recipe) {
    final count = otherOccurrencesCount;
    final plural = count > 1 ? 's' : '';
    final theme = Theme.of(context);

    showGlassDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) => GlassDialogContent(
        icon: Icons.info_outline,
        // Orange gradient to signal a choice that affects more than one day
        iconGradient: const LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFEA580C)],
        ),
        title: 'Remplacer partout ?',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '"$currentRecipeName" apparait aussi $count autre$plural '
              'jour$plural. Remplacer partout par "${recipe.name}" ?',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GlassDialogActions(
              secondary: GlassDialogButton(
                label: 'Ce jour uniquement',
                onPressed: () {
                  Navigator.pop(dialogContext);
                  onSelectRecipe(recipe, false);
                },
              ),
              primary: GlassDialogPrimaryButton(
                label: 'Tout remplacer',
                onPressed: () {
                  Navigator.pop(dialogContext);
                  onSelectRecipe(recipe, true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
