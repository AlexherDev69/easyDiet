import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/widgets/sync_text_field.dart';
import '../../domain/models/sex.dart';

/// Step 0: Name, age, sex.
class PersonalInfoStep extends StatelessWidget {
  const PersonalInfoStep({
    required this.name,
    required this.age,
    required this.sex,
    required this.onNameChange,
    required this.onAgeChange,
    required this.onSexChange,
    super.key,
  });

  final String name;
  final String age;
  final Sex sex;
  final ValueChanged<String> onNameChange;
  final ValueChanged<String> onAgeChange;
  final ValueChanged<Sex> onSexChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informations personnelles',
              style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Parlez-nous un peu de vous pour personnaliser votre plan.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Name
          SyncTextField(
            value: name,
            onChanged: onNameChange,
            decoration: const InputDecoration(
              labelText: 'Prenom',
              prefixIcon: Icon(Icons.person_outline),
            ),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          // Age
          SyncTextField(
            value: age,
            onChanged: onAgeChange,
            decoration: const InputDecoration(
              labelText: 'Age',
              suffixText: 'ans',
              prefixIcon: Icon(Icons.cake_outlined),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),

          // Sex
          Text('Sexe', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: Sex.values.map((s) {
              return FilterChip(
                selected: sex == s,
                label: Text(s.displayName),
                onSelected: (_) => onSexChange(s),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
