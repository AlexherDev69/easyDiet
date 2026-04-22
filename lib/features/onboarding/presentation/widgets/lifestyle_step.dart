import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/widgets/free_days_section.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_title.dart';
import '../../../../shared/widgets/pill_chip.dart';
import '../../domain/models/meal_type.dart';

/// Step 3: Organisation — diet start date, free days, batch cooking, shopping,
/// meal types, recipe variety.
class LifestyleStep extends StatefulWidget {
  const LifestyleStep({
    required this.freeDays,
    required this.batchCookingEnabled,
    required this.batchCooking,
    required this.shoppingTrips,
    required this.distinctBreakfasts,
    required this.distinctLunches,
    required this.distinctDinners,
    required this.distinctSnacks,
    required this.enabledMealTypes,
    required this.dietStartDate,
    required this.batchCookingBeforeDiet,
    required this.showBatchCookingInfo,
    required this.economicMode,
    required this.onToggleMealType,
    required this.onToggleFreeDay,
    required this.onBatchCookingEnabledChange,
    required this.onBatchCookingChange,
    required this.onShoppingTripsChange,
    required this.onDistinctBreakfastsChange,
    required this.onDistinctLunchesChange,
    required this.onDistinctDinnersChange,
    required this.onDistinctSnacksChange,
    required this.onDietStartDateChange,
    required this.onBatchCookingBeforeDietChange,
    required this.onEconomicModeChange,
    required this.onShowBatchCookingInfo,
    required this.onHideBatchCookingInfo,
    super.key,
  });

  final Set<int> freeDays;
  final bool batchCookingEnabled;
  final int batchCooking;
  final int shoppingTrips;
  final int distinctBreakfasts;
  final int distinctLunches;
  final int distinctDinners;
  final int distinctSnacks;
  final Set<MealType> enabledMealTypes;
  final DateTime? dietStartDate;
  final bool batchCookingBeforeDiet;
  final bool showBatchCookingInfo;
  final bool economicMode;
  final ValueChanged<MealType> onToggleMealType;
  final ValueChanged<int> onToggleFreeDay;
  final ValueChanged<bool> onBatchCookingEnabledChange;
  final ValueChanged<int> onBatchCookingChange;
  final ValueChanged<int> onShoppingTripsChange;
  final ValueChanged<int> onDistinctBreakfastsChange;
  final ValueChanged<int> onDistinctLunchesChange;
  final ValueChanged<int> onDistinctDinnersChange;
  final ValueChanged<int> onDistinctSnacksChange;
  final ValueChanged<DateTime> onDietStartDateChange;
  final ValueChanged<bool> onBatchCookingBeforeDietChange;
  final ValueChanged<bool> onEconomicModeChange;
  final VoidCallback onShowBatchCookingInfo;
  final VoidCallback onHideBatchCookingInfo;

  @override
  State<LifestyleStep> createState() => _LifestyleStepState();
}

class _LifestyleStepState extends State<LifestyleStep> {
  late final DateTime _today;
  late final DateTime _tomorrow;

  @override
  void initState() {
    super.initState();
    _today = AppDateUtils.today();
    _tomorrow = _today.add(const Duration(days: 1));
  }

  _DateOption get _selectedOption {
    final startDate = widget.dietStartDate;
    if (startDate == null || startDate == _today) return _DateOption.today;
    if (startDate == _tomorrow) return _DateOption.tomorrow;
    return _DateOption.other;
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.dietStartDate ?? _today,
      firstDate: _today,
      lastDate: _today.add(const Duration(days: 365)),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      widget.onDietStartDateChange(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      children: [
        const GradientTitle('Organisation'),
        const SizedBox(height: 8),
        Text(
          'Adaptez le plan a votre rythme de vie.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),

        // Diet start date — PillChip per option
        Text('Date de demarrage du regime',
            style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            PillChip(
              label: "Aujourd'hui",
              selected: _selectedOption == _DateOption.today,
              onTap: () => widget.onDietStartDateChange(_today),
            ),
            PillChip(
              label: 'Demain',
              selected: _selectedOption == _DateOption.tomorrow,
              onTap: () => widget.onDietStartDateChange(_tomorrow),
            ),
            PillChip(
              label: _selectedOption == _DateOption.other &&
                      widget.dietStartDate != null
                  ? AppDateUtils.formatShortDate(widget.dietStartDate!)
                  : 'Autre date',
              selected: _selectedOption == _DateOption.other,
              onTap: _showDatePicker,
              icon: const Icon(Icons.calendar_today_outlined),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Free days
        FreeDaysSection(
          freeDays: widget.freeDays,
          onToggleFreeDay: widget.onToggleFreeDay,
        ),
        const SizedBox(height: 16),

        // Batch cooking — TEMPORAIREMENT MASQUE
        // _BatchCookingSection(
        //   batchCookingEnabled: widget.batchCookingEnabled,
        //   batchCooking: widget.batchCooking,
        //   batchCookingBeforeDiet: widget.batchCookingBeforeDiet,
        //   onBatchCookingEnabledChange: widget.onBatchCookingEnabledChange,
        //   onBatchCookingChange: widget.onBatchCookingChange,
        //   onBatchCookingBeforeDietChange: widget.onBatchCookingBeforeDietChange,
        //   onShowInfo: widget.onShowBatchCookingInfo,
        // ),
        // const SizedBox(height: 16),

        // Shopping trips — GlassCard stepper
        _GlassStepperCard(
          label: 'Courses par semaine',
          value: widget.shoppingTrips,
          minValue: 1,
          maxValue: 2,
          onValueChange: widget.onShoppingTripsChange,
        ),
        const SizedBox(height: 16),

        // Economic mode — GlassCard with Switch
        GlassCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mode economique',
                        style: theme.textTheme.bodyLarge),
                    Text(
                      'Privilegie des recettes avec des ingredients communs '
                      'pour reduire les courses',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.economicMode,
                onChanged: widget.onEconomicModeChange,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Meal types — PillChip
        Text('Repas inclus dans le plan',
            style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MealType.values.map((mt) {
            return PillChip(
              label: mt.displayName,
              selected: widget.enabledMealTypes.contains(mt),
              onTap: () => widget.onToggleMealType(mt),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Recipe variety — GlassCard steppers
        Text('Variete des recettes', style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          'Moins de variete = liste de courses plus courte.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        _GlassStepperCard(
          label: 'Petits-dejeuners differents',
          value: widget.distinctBreakfasts,
          minValue: 1,
          maxValue: 6,
          onValueChange: widget.onDistinctBreakfastsChange,
        ),
        const SizedBox(height: 8),
        _GlassStepperCard(
          label: 'Dejeuners differents',
          value: widget.distinctLunches,
          minValue: 1,
          maxValue: 7,
          onValueChange: widget.onDistinctLunchesChange,
        ),
        const SizedBox(height: 8),
        _GlassStepperCard(
          label: 'Diners differents',
          value: widget.distinctDinners,
          minValue: 1,
          maxValue: 7,
          onValueChange: widget.onDistinctDinnersChange,
        ),
        const SizedBox(height: 8),
        _GlassStepperCard(
          label: 'Snacks differents',
          value: widget.distinctSnacks,
          minValue: 1,
          maxValue: 5,
          onValueChange: widget.onDistinctSnacksChange,
        ),
      ],
    );

    // Batch cooking info dialog is handled by the parent screen
  }
}

enum _DateOption { today, tomorrow, other }

/// GlassCard-wrapped numeric stepper — same layout and semantics as StepperCard
/// but uses the glassmorphism surface instead of SolidCard.
class _GlassStepperCard extends StatelessWidget {
  const _GlassStepperCard({
    required this.label,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onValueChange,
  });

  final String label;
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onValueChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: theme.textTheme.bodyLarge),
          ),
          IconButton(
            onPressed:
                value > minValue ? () => onValueChange(value - 1) : null,
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
                color: AppColors.emeraldPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed:
                value < maxValue ? () => onValueChange(value + 1) : null,
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

/// Batch cooking card with toggle, sessions stepper, before/after switch.
/// Uses GlassCard as the outer surface; the inner stepper also uses glass.
// ignore: unused_element
class _BatchCookingSection extends StatelessWidget {
  const _BatchCookingSection({
    required this.batchCookingEnabled,
    required this.batchCooking,
    required this.batchCookingBeforeDiet,
    required this.onBatchCookingEnabledChange,
    required this.onBatchCookingChange,
    required this.onBatchCookingBeforeDietChange,
    required this.onShowInfo,
  });

  final bool batchCookingEnabled;
  final int batchCooking;
  final bool batchCookingBeforeDiet;
  final ValueChanged<bool> onBatchCookingEnabledChange;
  final ValueChanged<int> onBatchCookingChange;
  final ValueChanged<bool> onBatchCookingBeforeDietChange;
  final VoidCallback onShowInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Batch cooking',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: onShowInfo,
                      iconSize: 18,
                      tooltip: 'Informations',
                      constraints: const BoxConstraints.tightFor(
                        width: 32,
                        height: 32,
                      ),
                      icon: const Icon(
                        Icons.info_outline,
                        color: AppColors.emeraldPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: batchCookingEnabled,
                onChanged: onBatchCookingEnabledChange,
              ),
            ],
          ),
          if (batchCookingEnabled) ...[
            const SizedBox(height: 12),
            // Inner stepper stays as a glass card for visual consistency
            _GlassStepperCard(
              label: 'Sessions par semaine',
              value: batchCooking,
              minValue: 1,
              maxValue: 2,
              onValueChange: onBatchCookingChange,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    batchCookingBeforeDiet
                        ? 'Cuisiner la veille'
                        : 'Cuisiner le jour meme',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Switch(
                  value: batchCookingBeforeDiet,
                  onChanged: onBatchCookingBeforeDietChange,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
