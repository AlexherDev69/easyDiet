import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

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

/// Horizontal scrollable category filter chips.
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
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: selectedCategory == null,
              onSelected: (_) => onSelectCategory(null),
              label: const Text(
                'Tout',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              selectedColor: AppColors.emeraldPrimary.withValues(alpha: 0.15),
              checkmarkColor: AppColors.emeraldPrimary,
            ),
          ),
          for (final filter in categoryFilters)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: selectedCategory == filter.key,
                onSelected: (_) => onSelectCategory(
                  selectedCategory == filter.key ? null : filter.key,
                ),
                label: Text(
                  filter.label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                selectedColor: filter.color.withValues(alpha: 0.15),
                checkmarkColor: filter.color,
              ),
            ),
        ],
      ),
    );
  }
}
