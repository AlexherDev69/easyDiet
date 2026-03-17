import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../navigation/app_router.dart';
import '../../../../shared/widgets/solid_card.dart';
import '../../../onboarding/domain/models/models.dart';
import '../cubit/plan_config_cubit.dart';
import '../cubit/plan_config_state.dart';

class PlanConfigPage extends StatelessWidget {
  const PlanConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanConfigCubit, PlanConfigState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Configurer le plan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(
                color: AppColors.emeraldPrimary,
              ),
            ),
          );
        }

        final cubit = context.read<PlanConfigCubit>();

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              'Configurer le plan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Diet start date.
                      const Text(
                        'Date de demarrage du regime',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      _DateSelector(
                        date: state.dietStartDate,
                        onDateChange: cubit.updateDietStartDate,
                      ),

                      const SizedBox(height: 20),

                      // Diet type.
                      const Text(
                        'Regime alimentaire',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: DietType.values.map((dt) {
                          return FilterChip(
                            selected: dt == state.dietType,
                            onSelected: (_) => cubit.updateDietType(dt),
                            label: Text(dt.displayName),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // Free days.
                      const Text(
                        'Jours libres (sans regime)',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${state.dietDaysPerWeek} jours de regime / '
                        '${state.freeDays.length} jours libres',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _FreeDaysChips(
                        freeDays: state.freeDays,
                        onToggle: cubit.toggleFreeDay,
                      ),

                      const SizedBox(height: 20),

                      // Enabled meal types.
                      const Text(
                        'Repas inclus dans le plan',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: MealType.values.map((mt) {
                          return FilterChip(
                            selected: state.enabledMealTypes.contains(mt),
                            onSelected: (_) => cubit.toggleMealType(mt),
                            label: Text(mt.displayName),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // Recipe variety.
                      const Text(
                        'Variete des recettes',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Moins de variete = liste de courses plus courte.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _StepperCard(
                        label: 'Petits-dejeuners differents',
                        value: state.distinctBreakfasts,
                        min: 1,
                        max: 6,
                        onChanged: cubit.updateDistinctBreakfasts,
                      ),
                      const SizedBox(height: 8),
                      _StepperCard(
                        label: 'Dejeuners differents',
                        value: state.distinctLunches,
                        min: 1,
                        max: 7,
                        onChanged: cubit.updateDistinctLunches,
                      ),
                      const SizedBox(height: 8),
                      _StepperCard(
                        label: 'Diners differents',
                        value: state.distinctDinners,
                        min: 1,
                        max: 7,
                        onChanged: cubit.updateDistinctDinners,
                      ),
                      const SizedBox(height: 8),
                      _StepperCard(
                        label: 'Snacks differents',
                        value: state.distinctSnacks,
                        min: 1,
                        max: 5,
                        onChanged: cubit.updateDistinctSnacks,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Generate button.
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            await cubit.saveAndProceed();
                            if (context.mounted) {
                              context.push(AppRoutes.planPreview);
                            }
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.emeraldPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Generer le plan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Widgets ─────────────────────────────────────────────────────────

class _DateSelector extends StatelessWidget {
  const _DateSelector({
    required this.date,
    required this.onDateChange,
  });

  final DateTime? date;
  final ValueChanged<DateTime> onDateChange;

  @override
  Widget build(BuildContext context) {
    final today = AppDateUtils.today();
    final tomorrow = today.add(const Duration(days: 1));
    final d = date ?? today;

    final isToday = d.year == today.year &&
        d.month == today.month &&
        d.day == today.day;
    final isTomorrow = d.year == tomorrow.year &&
        d.month == tomorrow.month &&
        d.day == tomorrow.day;
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
              initialDate: d,
              firstDate: today,
              lastDate: today.add(const Duration(days: 365)),
            );
            if (picked != null) onDateChange(picked);
          },
          label: Text(
            isOther ? AppDateUtils.formatShortDate(d) : 'Autre date',
          ),
        ),
      ],
    );
  }
}

class _FreeDaysChips extends StatelessWidget {
  const _FreeDaysChips({
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

class _StepperCard extends StatelessWidget {
  const _StepperCard({
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
    return SolidCard(
      elevation: 1,
      cornerRadius: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
