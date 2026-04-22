import 'package:flutter/material.dart';

import '../../../../shared/widgets/gradient_title.dart';
import '../../../../shared/widgets/pill_chip.dart';
import '../../domain/models/allergy.dart';
import '../../domain/models/excluded_meat.dart';

/// Step 4: Allergies and excluded meats.
class AllergiesStep extends StatelessWidget {
  const AllergiesStep({
    required this.selectedAllergies,
    required this.excludedMeats,
    required this.onToggleAllergy,
    required this.onToggleExcludedMeat,
    super.key,
  });

  final Set<Allergy> selectedAllergies;
  final Set<ExcludedMeat> excludedMeats;
  final ValueChanged<Allergy> onToggleAllergy;
  final ValueChanged<ExcludedMeat> onToggleExcludedMeat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GradientTitle('Allergies & restrictions'),
          const SizedBox(height: 8),
          Text(
            'Selectionnez vos allergies et les viandes a exclure.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Allergies — PillChip
          Text('Allergies', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: Allergy.values.map((allergy) {
              return PillChip(
                label: allergy.displayName,
                selected: selectedAllergies.contains(allergy),
                onTap: () => onToggleAllergy(allergy),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Excluded meats — PillChip
          Text('Viandes exclues', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ExcludedMeat.values.map((meat) {
              return PillChip(
                label: meat.displayName,
                selected: excludedMeats.contains(meat),
                onTap: () => onToggleExcludedMeat(meat),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
