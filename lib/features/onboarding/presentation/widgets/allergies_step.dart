import 'package:flutter/material.dart';

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
          Text('Allergies & restrictions',
              style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Selectionnez vos allergies et les viandes a exclure.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Allergies
          Text('Allergies', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: Allergy.values.map((allergy) {
              return FilterChip(
                selected: selectedAllergies.contains(allergy),
                label: Text(allergy.displayName),
                onSelected: (_) => onToggleAllergy(allergy),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Excluded meats
          Text('Viandes exclues', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: ExcludedMeat.values.map((meat) {
              return FilterChip(
                selected: excludedMeats.contains(meat),
                label: Text(meat.displayName),
                onSelected: (_) => onToggleExcludedMeat(meat),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
