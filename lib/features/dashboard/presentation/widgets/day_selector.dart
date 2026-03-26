import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/dashboard_models.dart';

/// Horizontal day selector for the week schedule.
class DaySelector extends StatelessWidget {
  const DaySelector({
    required this.weekSchedule,
    required this.selectedIndex,
    required this.onSelectDay,
    super.key,
  });

  final List<DayScheduleItem> weekSchedule;
  final int selectedIndex;
  final ValueChanged<int> onSelectDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(weekSchedule.length, (index) {
        final day = weekSchedule[index];
        final isSelected = index == selectedIndex;

        return Semantics(
          label: '${day.dayName}, ${day.date.day}'
              '${day.isToday ? ", aujourd hui" : ""}',
          button: true,
          selected: isSelected,
          child: GestureDetector(
          onTap: () => onSelectDay(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.emeraldPrimary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  day.dayName.substring(0, 3),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight:
                        (isSelected || day.isToday) ? FontWeight.bold : null,
                    color: _dayNameColor(theme, isSelected, day),
                  ),
                ),
                Text(
                  '${day.date.day}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight:
                        (isSelected || day.isToday) ? FontWeight.bold : null,
                    color: _dayNumberColor(theme, isSelected, day),
                  ),
                ),
                if (day.isToday && !isSelected)
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.emeraldPrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
        );
      }),
    );
  }

  Color _dayNameColor(
      ThemeData theme, bool isSelected, DayScheduleItem day) {
    if (isSelected) return Colors.white;
    if (day.isToday) return AppColors.emeraldPrimary;
    if (!day.hasPlan) {
      return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4);
    }
    return theme.colorScheme.onSurfaceVariant;
  }

  Color _dayNumberColor(
      ThemeData theme, bool isSelected, DayScheduleItem day) {
    if (isSelected) return Colors.white;
    if (day.isToday) return AppColors.emeraldPrimary;
    if (!day.hasPlan) {
      return theme.colorScheme.onSurface.withValues(alpha: 0.4);
    }
    return theme.colorScheme.onSurface;
  }
}
