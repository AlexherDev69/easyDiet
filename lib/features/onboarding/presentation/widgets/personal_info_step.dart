import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_title.dart';
import '../../../../shared/widgets/pill_chip.dart';
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
          const GradientTitle('Informations personnelles'),
          const SizedBox(height: 8),
          Text(
            'Parlez-nous un peu de vous pour personnaliser votre plan.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Name and age grouped in a glass card for visual cohesion.
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
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

                // Age with a pill badge suffix instead of plain suffixText.
                SyncTextField(
                  value: age,
                  onChanged: onAgeChange,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    prefixIcon: const Icon(Icons.cake_outlined),
                    suffixIcon: _UnitPillBadge(label: 'ans'),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sex
          Text('Sexe', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: Sex.values.map((s) {
              return PillChip(
                label: s.displayName,
                selected: sex == s,
                onTap: () => onSexChange(s),
                icon: Icon(
                  s == Sex.male ? Icons.male : Icons.female,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Small pill-shaped badge used as a [suffixIcon] to display a unit label.
///
/// Using a dedicated widget (rather than suffixText) gives us full control
/// over the pill shape, color, and padding to match the glassmorphism system.
class _UnitPillBadge extends StatelessWidget {
  const _UnitPillBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      // Keeps the badge vertically centred inside the TextField's suffix area.
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
