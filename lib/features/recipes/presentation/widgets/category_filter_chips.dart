import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/pill_chip.dart';

/// Category filter definition.
class CategoryFilter {
  const CategoryFilter({
    required this.key,
    required this.label,
    required this.color,
  });

  final String key;
  final String label;
  final Color color;
}

/// Predefined category filters.
const categoryFilters = [
  CategoryFilter(key: 'BREAKFAST', label: 'Petit-dej', color: AppColors.breakfastColor),
  CategoryFilter(key: 'LUNCH', label: 'Dejeuner', color: AppColors.lunchColor),
  CategoryFilter(key: 'DINNER', label: 'Diner', color: AppColors.dinnerColor),
  CategoryFilter(key: 'SNACK', label: 'Collation', color: AppColors.snackColor),
];

/// Horizontal scrollable category filter chips — PillChip style.
class CategoryFilterChips extends StatelessWidget {
  const CategoryFilterChips({
    required this.selectedCategory,
    required this.onSelectCategory,
    super.key,
  });

  final String? selectedCategory;
  final ValueChanged<String?> onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          PillChip(
            label: 'Tout',
            selected: selectedCategory == null,
            onTap: () => onSelectCategory(null),
          ),
          for (final filter in categoryFilters) ...[
            const SizedBox(width: 8),
            PillChip(
              label: filter.label,
              selected: selectedCategory == filter.key,
              onTap: () => onSelectCategory(
                selectedCategory == filter.key ? null : filter.key,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
