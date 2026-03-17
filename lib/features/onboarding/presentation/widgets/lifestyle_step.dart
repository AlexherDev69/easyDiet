import 'package:flutter/material.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../shared/widgets/free_days_section.dart';
import '../../../../shared/widgets/solid_card.dart';
import '../../../../shared/widgets/stepper_card.dart';
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
        Text('Organisation', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Adaptez le plan a votre rythme de vie.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),

        // Diet start date
        Text('Date de demarrage du regime',
            style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              selected: _selectedOption == _DateOption.today,
              onSelected: (_) => widget.onDietStartDateChange(_today),
              label: const Text("Aujourd'hui"),
            ),
            FilterChip(
              selected: _selectedOption == _DateOption.tomorrow,
              onSelected: (_) => widget.onDietStartDateChange(_tomorrow),
              label: const Text('Demain'),
            ),
            FilterChip(
              selected: _selectedOption == _DateOption.other,
              onSelected: (_) => _showDatePicker(),
              label: Text(
                _selectedOption == _DateOption.other &&
                        widget.dietStartDate != null
                    ? AppDateUtils.formatShortDate(widget.dietStartDate!)
                    : 'Autre date',
              ),
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

        // Batch cooking
        _BatchCookingSection(
          batchCookingEnabled: widget.batchCookingEnabled,
          batchCooking: widget.batchCooking,
          batchCookingBeforeDiet: widget.batchCookingBeforeDiet,
          onBatchCookingEnabledChange: widget.onBatchCookingEnabledChange,
          onBatchCookingChange: widget.onBatchCookingChange,
          onBatchCookingBeforeDietChange: widget.onBatchCookingBeforeDietChange,
          onShowInfo: widget.onShowBatchCookingInfo,
        ),
        const SizedBox(height: 16),

        // Shopping trips
        StepperCard(
          label: 'Courses par semaine',
          value: widget.shoppingTrips,
          minValue: 1,
          maxValue: 2,
          onValueChange: widget.onShoppingTripsChange,
        ),
        const SizedBox(height: 16),

        // Economic mode
        SolidCard(
          backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
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

        // Meal types
        Text('Repas inclus dans le plan',
            style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: MealType.values.map((mt) {
            return FilterChip(
              selected: widget.enabledMealTypes.contains(mt),
              onSelected: (_) => widget.onToggleMealType(mt),
              label: Text(mt.displayName),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Recipe variety
        Text('Variete des recettes', style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          'Moins de variete = liste de courses plus courte.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        StepperCard(
          label: 'Petits-dejeuners differents',
          value: widget.distinctBreakfasts,
          minValue: 1,
          maxValue: 6,
          onValueChange: widget.onDistinctBreakfastsChange,
        ),
        const SizedBox(height: 8),
        StepperCard(
          label: 'Dejeuners differents',
          value: widget.distinctLunches,
          minValue: 1,
          maxValue: 7,
          onValueChange: widget.onDistinctLunchesChange,
        ),
        const SizedBox(height: 8),
        StepperCard(
          label: 'Diners differents',
          value: widget.distinctDinners,
          minValue: 1,
          maxValue: 7,
          onValueChange: widget.onDistinctDinnersChange,
        ),
        const SizedBox(height: 8),
        StepperCard(
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

/// Batch cooking card with toggle, sessions stepper, before/after switch.
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

    return SolidCard(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
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
                      constraints: const BoxConstraints.tightFor(
                        width: 32,
                        height: 32,
                      ),
                      icon: Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
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
            StepperCard(
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
