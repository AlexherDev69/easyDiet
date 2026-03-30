import 'package:flutter/material.dart';

import '../../../../data/local/database.dart';
import '../../../../shared/widgets/solid_card.dart';

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
    return AlertDialog(
      title: const Text(
        'Choisir un repas alternatif',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: alternatives.length,
          itemBuilder: (context, index) {
            final recipe = alternatives[index];
            return _SwapRecipeItem(
              recipe: recipe,
              onTap: () {
                if (otherOccurrencesCount > 0) {
                  _showReplaceAllDialog(context, recipe);
                } else {
                  onSelectRecipe(recipe, false);
                }
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: const Text('Annuler'),
        ),
      ],
    );
  }

  void _showReplaceAllDialog(BuildContext context, Recipe recipe) {
    final count = otherOccurrencesCount;
    final plural = count > 1 ? 's' : '';

    showDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Remplacer partout ?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '"$currentRecipeName" apparait aussi $count autre$plural '
          'jour$plural. Remplacer partout par "${recipe.name}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onSelectRecipe(recipe, false);
            },
            child: const Text('Ce jour uniquement'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onSelectRecipe(recipe, true);
            },
            child: const Text('Tout remplacer'),
          ),
        ],
      ),
    );
  }
}

class _SwapRecipeItem extends StatelessWidget {
  const _SwapRecipeItem({
    required this.recipe,
    required this.onTap,
  });

  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SolidCard(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        elevation: 1,
        contentPadding: const EdgeInsets.all(12),
        cornerRadius: 12,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.name,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${recipe.caloriesPerServing} kcal | '
              'P:${recipe.proteinGrams.round()}g '
              'C:${recipe.carbsGrams.round()}g '
              'L:${recipe.fatGrams.round()}g',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
