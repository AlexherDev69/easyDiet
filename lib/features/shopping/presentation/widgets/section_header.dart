import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Collapsible section header for a supermarket section.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    required this.itemCount,
    required this.checkedCount,
    required this.isCollapsed,
    required this.onToggle,
    super.key,
  });

  final String title;
  final int itemCount;
  final int checkedCount;
  final bool isCollapsed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allChecked = checkedCount == itemCount && itemCount > 0;

    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isCollapsed
                      ? Icons.keyboard_arrow_right
                      : Icons.keyboard_arrow_down,
                  color: AppColors.emeraldPrimary,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.emeraldPrimary,
                  ),
                ),
              ],
            ),
            Text(
              '$checkedCount/$itemCount',
              style: theme.textTheme.labelMedium?.copyWith(
                color: allChecked
                    ? AppColors.emeraldPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
