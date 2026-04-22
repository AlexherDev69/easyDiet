import 'package:flutter/material.dart';

import '../../core/utils/date_utils.dart';
import 'pill_chip.dart';

/// Section to pick free (cheat) days — max 3.
class FreeDaysSection extends StatelessWidget {
  const FreeDaysSection({
    required this.freeDays,
    required this.onToggleFreeDay,
    super.key,
  });

  final Set<int> freeDays;
  final ValueChanged<int> onToggleFreeDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jours libres (max 3)', style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          'Ces jours ne seront pas planifies.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(7, (index) {
            // index is 0-based (0=Mon, 6=Sun), matching Kotlin's forEachIndexed.
            return PillChip(
              label: AppDateUtils.getDayOfWeekFrench(index + 1),
              selected: freeDays.contains(index),
              onTap: () => onToggleFreeDay(index),
            );
          }),
        ),
      ],
    );
  }
}
