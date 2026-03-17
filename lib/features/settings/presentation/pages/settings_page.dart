import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/decimal_input_formatter.dart';
import '../../../../navigation/app_router.dart';
import '../../../../shared/widgets/solid_card.dart';
import '../../../onboarding/domain/models/models.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) =>
          prev.showRegenerateDialog != curr.showRegenerateDialog ||
          prev.showResetDialog != curr.showResetDialog,
      listener: (context, state) {
        // Dialogs are handled inline via state flags.
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Parametres',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(
                color: AppColors.emeraldPrimary,
              ),
            ),
          );
        }

        final cubit = context.read<SettingsCubit>();

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              'Parametres',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            actions: [
              TextButton(
                onPressed: cubit.saveProfile,
                child: Text(
                  state.isSaved ? 'Enregistre !' : 'Enregistrer',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.emeraldPrimary,
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Profile section ──────────────────────────
                    _SectionTitle('Profil'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: TextEditingController(text: state.name)
                        ..selection = TextSelection.collapsed(
                            offset: state.name.length),
                      onChanged: cubit.updateName,
                      decoration: _inputDecoration('Prenom'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: state.age)
                              ..selection = TextSelection.collapsed(
                                  offset: state.age.length),
                            onChanged: (v) {
                              if (v.length <= 3 &&
                                  v.split('').every(
                                      (c) => '0123456789'.contains(c))) {
                                cubit.updateAge(v);
                              }
                            },
                            decoration: _inputDecoration('Age'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller:
                                TextEditingController(text: state.heightCm)
                                  ..selection = TextSelection.collapsed(
                                      offset: state.heightCm.length),
                            onChanged: (v) {
                              if (v.length <= 3) cubit.updateHeight(v);
                            },
                            decoration: _inputDecoration('Taille (cm)'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _ChipRow(
                      options: Sex.values,
                      selected: state.sex,
                      labelOf: (s) => s.displayName,
                      onSelected: cubit.updateSex,
                    ),

                    const SizedBox(height: 16),
                    _Divider(),
                    const SizedBox(height: 16),

                    // ── Target section ───────────────────────────
                    _SectionTitle('Objectif'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller:
                                TextEditingController(text: state.weightKg)
                                  ..selection = TextSelection.collapsed(
                                      offset: state.weightKg.length),
                            onChanged: cubit.updateWeight,
                            decoration: _inputDecoration('Poids (kg)'),
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            inputFormatters: [DecimalInputFormatter()],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                                text: state.targetWeightKg)
                              ..selection = TextSelection.collapsed(
                                  offset: state.targetWeightKg.length),
                            onChanged: cubit.updateTargetWeight,
                            decoration: InputDecoration(
                              labelText: 'Cible (kg)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              errorText: state.targetWeightError,
                            ),
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            inputFormatters: [DecimalInputFormatter()],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _SubSectionTitle('Regime alimentaire'),
                    const SizedBox(height: 4),
                    _ChipRow(
                      options: DietType.values,
                      selected: state.dietType,
                      labelOf: (d) => d.displayName,
                      onSelected: cubit.updateDietType,
                    ),
                    const SizedBox(height: 8),

                    _SubSectionTitle('Rythme de perte'),
                    const SizedBox(height: 4),
                    _ChipRow(
                      options: LossPace.values,
                      selected: state.lossPace,
                      labelOf: (lp) => lp.displayName,
                      onSelected: cubit.updateLossPace,
                    ),

                    _SubSectionTitle('Activite'),
                    const SizedBox(height: 4),
                    _ChipRow(
                      options: ActivityLevel.values,
                      selected: state.activityLevel,
                      labelOf: (al) => al.displayName,
                      onSelected: cubit.updateActivityLevel,
                    ),

                    const SizedBox(height: 8),
                    _SubSectionTitle('Date de demarrage'),
                    const SizedBox(height: 4),
                    _DietStartDateSelector(
                      dietStartDate: state.dietStartDate,
                      onDateChange: cubit.updateDietStartDate,
                    ),

                    const SizedBox(height: 8),
                    _SubSectionTitle('Jours libres (sans regime)'),
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
                    const SizedBox(height: 4),

                    _StepperField(
                      label: 'Sessions batch cooking',
                      value: state.batchCookingSessions,
                      min: 1,
                      max: 2,
                      onChanged: cubit.updateBatchCooking,
                    ),

                    SolidCard(
                      elevation: 1,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              state.batchCookingBeforeDiet
                                  ? 'Batch cooking la veille'
                                  : 'Batch cooking le jour meme',
                            ),
                          ),
                          Switch(
                            value: state.batchCookingBeforeDiet,
                            onChanged: cubit.updateBatchCookingBeforeDiet,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),

                    _StepperField(
                      label: 'Courses / sem.',
                      value: state.shoppingTrips,
                      min: 1,
                      max: 2,
                      onChanged: cubit.updateShoppingTrips,
                    ),

                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mode economique',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Ingredients communs entre recettes',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: state.economicMode,
                          onChanged: cubit.updateEconomicMode,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    _SubSectionTitle('Repas inclus'),
                    const SizedBox(height: 4),
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

                    const SizedBox(height: 12),
                    _SubSectionTitle('Variete des recettes'),
                    const SizedBox(height: 4),
                    if (state.enabledMealTypes.contains(MealType.breakfast))
                      _StepperField(
                        label: 'Petits-dej. differents',
                        value: state.distinctBreakfasts,
                        min: 1,
                        max: 6,
                        onChanged: cubit.updateDistinctBreakfasts,
                      ),
                    if (state.enabledMealTypes.contains(MealType.lunch))
                      _StepperField(
                        label: 'Dejeuners differents',
                        value: state.distinctLunches,
                        min: 1,
                        max: 7,
                        onChanged: cubit.updateDistinctLunches,
                      ),
                    if (state.enabledMealTypes.contains(MealType.dinner))
                      _StepperField(
                        label: 'Diners differents',
                        value: state.distinctDinners,
                        min: 1,
                        max: 7,
                        onChanged: cubit.updateDistinctDinners,
                      ),
                    if (state.enabledMealTypes.contains(MealType.snack))
                      _StepperField(
                        label: 'Snacks differents',
                        value: state.distinctSnacks,
                        min: 1,
                        max: 5,
                        onChanged: cubit.updateDistinctSnacks,
                      ),

                    const SizedBox(height: 16),
                    _Divider(),
                    const SizedBox(height: 16),

                    // ── Allergies ─────────────────────────────────
                    _SectionTitle('Allergies'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: Allergy.values.map((a) {
                        return FilterChip(
                          selected: state.selectedAllergies.contains(a),
                          onSelected: (_) => cubit.toggleAllergy(a),
                          label: Text(a.displayName),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),
                    _SectionTitle('Viandes exclues'),
                    const SizedBox(height: 4),
                    Text(
                      'Excluez certaines viandes selon vos '
                      'convictions ou preferences.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: ExcludedMeat.values.map((m) {
                        return FilterChip(
                          selected: state.excludedMeats.contains(m),
                          onSelected: (_) => cubit.toggleExcludedMeat(m),
                          label: Text(m.displayName),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // ── Calculated objectives ────────────────────
                    if (state.calculatedCalories > 0)
                      _ObjectiveCard(
                        text:
                            'Objectif : ${state.calculatedCalories} kcal / jour',
                        color: AppColors.emeraldPrimary,
                        backgroundColor: AppColors.emeraldPrimary
                            .withValues(alpha: 0.08),
                      ),
                    if (state.calculatedWaterMl > 0) ...[
                      const SizedBox(height: 8),
                      _ObjectiveCard(
                        text:
                            'Hydratation : ${(state.calculatedWaterMl / 1000).toStringAsFixed(1)} L / jour',
                        color: AppColors.waterBlue,
                        backgroundColor:
                            AppColors.waterBlue.withValues(alpha: 0.08),
                      ),
                    ],

                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () =>
                          context.push(AppRoutes.aboutCalculations),
                      child: const Text(
                          'Comment sont calcules ces objectifs ?'),
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: cubit.showResetDialog,
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Reinitialiser l'application",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // ── Dialogs ─────────────────────────────────────────
              if (state.showRegenerateDialog)
                _RegenerateDialog(
                  onConfirm: () {
                    cubit.onRegenerateConfirmed();
                    context.push(AppRoutes.planConfig);
                  },
                  onDismiss: cubit.dismissRegenerateDialog,
                ),
              if (state.showResetDialog)
                _ResetDialog(
                  onConfirm: () async {
                    await cubit.resetApp();
                    if (context.mounted) {
                      context.go(AppRoutes.onboarding);
                    }
                  },
                  onDismiss: cubit.hideResetDialog,
                ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

// ── Reusable widgets ────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

class _SubSectionTitle extends StatelessWidget {
  const _SubSectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }
}

class _Divider extends StatelessWidget {
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

class _ChipRow<T> extends StatelessWidget {
  const _ChipRow({
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

class _StepperField extends StatelessWidget {
  const _StepperField({
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

class _DietStartDateSelector extends StatelessWidget {
  const _DietStartDateSelector({
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

class _ObjectiveCard extends StatelessWidget {
  const _ObjectiveCard({
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

class _RegenerateDialog extends StatelessWidget {
  const _RegenerateDialog({
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

class _ResetDialog extends StatelessWidget {
  const _ResetDialog({
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
