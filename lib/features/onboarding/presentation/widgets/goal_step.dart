import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/widgets/solid_card.dart';
import '../../domain/models/models.dart';

/// Step 2: Target weight, loss pace, activity, diet type, calorie display.
class GoalStep extends StatelessWidget {
  const GoalStep({
    required this.targetWeight,
    required this.currentWeight,
    required this.lossPace,
    required this.activityLevel,
    required this.dietType,
    required this.calculatedCalories,
    required this.calculatedWaterMl,
    required this.onTargetWeightChange,
    required this.onLossPaceChange,
    required this.onActivityLevelChange,
    required this.onDietTypeChange,
    super.key,
  });

  final String targetWeight;
  final String currentWeight;
  final LossPace lossPace;
  final ActivityLevel activityLevel;
  final DietType dietType;
  final int calculatedCalories;
  final int calculatedWaterMl;
  final ValueChanged<String> onTargetWeightChange;
  final ValueChanged<LossPace> onLossPaceChange;
  final ValueChanged<ActivityLevel> onActivityLevelChange;
  final ValueChanged<DietType> onDietTypeChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Objectifs', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Definissez votre objectif de poids et votre rythme.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Loss pace
          Text('Rythme de perte', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ...LossPace.values.map((pace) => ListTile(
                leading: Icon(
                  lossPace == pace
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: lossPace == pace
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                title: Text(pace.displayName),
                subtitle: Text(pace.description),
                dense: true,
                contentPadding: EdgeInsets.zero,
                onTap: () => onLossPaceChange(pace),
              )),
          const SizedBox(height: 16),

          // Activity level
          Text('Niveau d\'activite', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ...ActivityLevel.values.map((level) => ListTile(
                leading: Icon(
                  activityLevel == level
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: activityLevel == level
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                title: Text(level.displayName),
                subtitle: Text(level.description),
                dense: true,
                contentPadding: EdgeInsets.zero,
                onTap: () => onActivityLevelChange(level),
              )),
          const SizedBox(height: 16),

          // Diet type
          Text('Type de regime', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: DietType.values.map((dt) {
              return FilterChip(
                selected: dietType == dt,
                label: Text(dt.displayName),
                onSelected: (_) => onDietTypeChange(dt),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Target weight
          Text('Objectif', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Poids cible',
              suffixText: 'kg',
              prefixIcon: Icon(Icons.flag_outlined),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            ],
            controller: TextEditingController(text: targetWeight)
              ..selection =
                  TextSelection.collapsed(offset: targetWeight.length),
            onChanged: onTargetWeightChange,
          ),
          const SizedBox(height: 24),

          // Calorie display
          if (calculatedCalories > 0)
            SolidCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CalorieInfo(
                        label: 'Calories / jour',
                        value: calculatedCalories.toString(),
                        unit: 'kcal',
                      ),
                      _CalorieInfo(
                        label: 'Eau / jour',
                        value: (calculatedWaterMl / 1000).toStringAsFixed(1),
                        unit: 'L',
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CalorieInfo extends StatelessWidget {
  const _CalorieInfo({
    required this.label,
    required this.value,
    required this.unit,
  });

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(unit, style: theme.textTheme.labelSmall),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
