import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../domain/models/ingredient_source.dart';

/// Dialog showing ingredient sources for a shopping item.
class ItemDetailDialog extends StatelessWidget {
  const ItemDetailDialog({
    required this.itemName,
    required this.totalQuantity,
    required this.sources,
    required this.onDismiss,
    super.key,
  });

  final String itemName;
  final String totalQuantity;
  final List<IngredientSource> sources;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _capitalize(itemName),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Total : $totalQuantity',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.emeraldPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: sources.isEmpty
          ? Text(
              'Aucun detail disponible',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < sources.length; i++) ...[
                  _SourceRow(source: sources[i]),
                  if (i < sources.length - 1)
                    Divider(
                      height: 12,
                      color: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.3),
                    ),
                ],
              ],
            ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: const Text('Fermer'),
        ),
      ],
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.source});

  final IngredientSource source;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                source.recipeName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                AppDateUtils.getDayOfWeekFrench(source.dayOfWeek),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Text(
          QuantityFormatter.formatWithUnit(source.quantity, source.unit),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.emeraldPrimary,
          ),
        ),
      ],
    );
  }
}
