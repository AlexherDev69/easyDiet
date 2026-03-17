import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../../../data/local/database.dart';
import '../../../../shared/widgets/solid_card.dart';

/// A single shopping item row with checkbox, name, and actions.
class ShoppingItemRow extends StatelessWidget {
  const ShoppingItemRow({
    required this.item,
    required this.onToggle,
    required this.onDelete,
    required this.onShowDetail,
    super.key,
  });

  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onShowDetail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SolidCard(
        elevation: 1,
        contentPadding: EdgeInsets.zero,
        onTap: onShowDetail,
        child: Row(
          children: [
            Checkbox(
              value: item.isChecked,
              onChanged: (_) => onToggle(),
              activeColor: AppColors.emeraldPrimary,
            ),
            Expanded(
              child: Text(
                '${item.name} - ${QuantityFormatter.formatWithUnit(item.quantity, item.unit)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  decoration:
                      item.isChecked ? TextDecoration.lineThrough : null,
                  color: item.isChecked
                      ? AppColors.gray400
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
            if (item.isManuallyAdded)
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete,
                  color: theme.colorScheme.error,
                ),
              )
            else
              IconButton(
                onPressed: onShowDetail,
                icon: Icon(
                  Icons.info,
                  color: AppColors.emeraldPrimary.withValues(alpha: 0.6),
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
