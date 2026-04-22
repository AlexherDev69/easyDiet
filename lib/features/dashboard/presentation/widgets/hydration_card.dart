import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';

/// Small card displaying daily water intake target.
class HydrationCard extends StatelessWidget {
  const HydrationCard({
    required this.dailyWaterMl,
    super.key,
  });

  final int dailyWaterMl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.water_drop,
            color: AppColors.waterBlue,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            'Hydratation',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${(dailyWaterMl / 1000).toStringAsFixed(1)} L',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.waterBlue,
            ),
          ),
          Text(
            '/ jour',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
