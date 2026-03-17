import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/decimal_input_formatter.dart';

/// Step 1: Height and weight.
class BodyMetricsStep extends StatelessWidget {
  const BodyMetricsStep({
    required this.height,
    required this.weight,
    required this.onHeightChange,
    required this.onWeightChange,
    super.key,
  });

  final String height;
  final String weight;
  final ValueChanged<String> onHeightChange;
  final ValueChanged<String> onWeightChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mensurations', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Ces donnees permettent de calculer vos besoins caloriques.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Height
          TextField(
            decoration: const InputDecoration(
              labelText: 'Taille',
              suffixText: 'cm',
              prefixIcon: Icon(Icons.height),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: TextEditingController(text: height)
              ..selection = TextSelection.collapsed(offset: height.length),
            onChanged: onHeightChange,
          ),
          const SizedBox(height: 16),

          // Weight
          TextField(
            decoration: const InputDecoration(
              labelText: 'Poids',
              suffixText: 'kg',
              prefixIcon: Icon(Icons.monitor_weight_outlined),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [DecimalInputFormatter()],
            controller: TextEditingController(text: weight)
              ..selection = TextSelection.collapsed(offset: weight.length),
            onChanged: onWeightChange,
          ),
        ],
      ),
    );
  }
}
