import 'package:flutter/material.dart';

import 'solid_card.dart';

/// A card with a label, value, and +/- buttons — used for numeric steppers.
class StepperCard extends StatelessWidget {
  const StepperCard({
    required this.label,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onValueChange,
    super.key,
  });

  final String label;
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onValueChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SolidCard(
      backgroundColor:
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: theme.textTheme.bodyLarge),
          ),
          IconButton(
            onPressed: value > minValue
                ? () => onValueChange(value - 1)
                : null,
            icon: const Icon(Icons.remove),
            tooltip: 'Retirer',
            iconSize: 20,
            constraints: const BoxConstraints.tightFor(
              width: 48,
              height: 48,
            ),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: value < maxValue
                ? () => onValueChange(value + 1)
                : null,
            icon: const Icon(Icons.add),
            tooltip: 'Ajouter',
            iconSize: 20,
            constraints: const BoxConstraints.tightFor(
              width: 48,
              height: 48,
            ),
          ),
        ],
      ),
    );
  }
}
