import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/widgets/solid_card.dart';

/// Section title (bold, 16px).
class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

/// Sub-section title (semi-bold, 14px).
class SettingsSubSectionTitle extends StatelessWidget {
  const SettingsSubSectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }
}

/// Thin divider for settings sections.
class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context)
          .colorScheme
          .outlineVariant
          .withValues(alpha: 0.3),
    );
  }
}

/// Generic chip row for selecting one option from a list.
class ChipRow<T> extends StatelessWidget {
  const ChipRow({
    super.key,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
  });

  final List<T> options;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: options.map((o) {
        return FilterChip(
          selected: o == selected,
          onSelected: (_) => onSelected(o),
          label: Text(labelOf(o)),
        );
      }).toList(),
    );
  }
}

/// Free day selector chips (Mon–Sun).
class FreeDaysChips extends StatelessWidget {
  const FreeDaysChips({
    super.key,
    required this.freeDays,
    required this.onToggle,
  });

  final Set<int> freeDays;
  final ValueChanged<int> onToggle;

  static const _dayNames = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: List.generate(7, (index) {
        final isFree = freeDays.contains(index);
        final canToggle = isFree || freeDays.length < 3;
        return FilterChip(
          selected: isFree,
          onSelected: canToggle ? (_) => onToggle(index) : null,
          label: Text(_dayNames[index]),
        );
      }),
    );
  }
}

/// Integer stepper field with label, -, value, +.
class StepperField extends StatelessWidget {
  const StepperField({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          IconButton(
            onPressed: value > min ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove, size: 18),
          ),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add, size: 18),
          ),
        ],
      ),
    );
  }
}

/// Diet start date selector with Today / Tomorrow / Other chips.
class DietStartDateSelector extends StatelessWidget {
  const DietStartDateSelector({
    super.key,
    required this.dietStartDate,
    required this.onDateChange,
  });

  final DateTime? dietStartDate;
  final ValueChanged<DateTime> onDateChange;

  @override
  Widget build(BuildContext context) {
    final today = AppDateUtils.today();
    final tomorrow = today.add(const Duration(days: 1));
    final date = dietStartDate ?? today;

    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    final isTomorrow = date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
    final isOther = !isToday && !isTomorrow;

    return Wrap(
      spacing: 8,
      children: [
        FilterChip(
          selected: isToday,
          onSelected: (_) => onDateChange(today),
          label: const Text("Aujourd'hui"),
        ),
        FilterChip(
          selected: isTomorrow,
          onSelected: (_) => onDateChange(tomorrow),
          label: const Text('Demain'),
        ),
        FilterChip(
          selected: isOther,
          onSelected: (_) async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: today,
              lastDate: today.add(const Duration(days: 365)),
            );
            if (picked != null) onDateChange(picked);
          },
          label: Text(
            isOther ? AppDateUtils.formatShortDate(date) : 'Autre date',
          ),
        ),
      ],
    );
  }
}

/// Colored objective card (calories / hydration).
class ObjectiveCard extends StatelessWidget {
  const ObjectiveCard({
    super.key,
    required this.text,
    required this.color,
    required this.backgroundColor,
  });

  final String text;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

/// Batch cooking toggle with switch.
class BatchCookingToggle extends StatelessWidget {
  const BatchCookingToggle({
    super.key,
    required this.batchCookingBeforeDiet,
    required this.onChanged,
  });

  final bool batchCookingBeforeDiet;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SolidCard(
      elevation: 1,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              batchCookingBeforeDiet
                  ? 'Batch cooking la veille'
                  : 'Batch cooking le jour meme',
            ),
          ),
          Switch(
            value: batchCookingBeforeDiet,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Regenerate plan confirmation dialog.
class RegenerateDialog extends StatelessWidget {
  const RegenerateDialog({
    super.key,
    required this.onConfirm,
    required this.onDismiss,
  });

  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Plan mis a jour',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'Vos parametres de regime ont change. '
        'Voulez-vous regenerer le plan de repas et la liste de courses ?',
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: const Text('Plus tard'),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text(
            'Regenerer',
            style: TextStyle(color: AppColors.emeraldPrimary),
          ),
        ),
      ],
    );
  }
}

/// App reset confirmation dialog.
class ResetDialog extends StatelessWidget {
  const ResetDialog({
    super.key,
    required this.onConfirm,
    required this.onDismiss,
  });

  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reinitialiser ?'),
      content: const Text(
        'Voulez-vous vraiment supprimer toutes vos donnees ? '
        'Cette action est irreversible.',
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: onConfirm,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Supprimer'),
        ),
      ],
    );
  }
}
