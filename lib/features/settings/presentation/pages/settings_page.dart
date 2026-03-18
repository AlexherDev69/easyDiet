import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/decimal_input_formatter.dart';
import '../../../../navigation/app_router.dart';
import '../../../onboarding/domain/models/models.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/settings_widgets.dart';

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
                    _ProfileSection(state: state, cubit: cubit),
                    const SizedBox(height: 16),
                    const SettingsDivider(),
                    const SizedBox(height: 16),
                    _ObjectiveSection(state: state, cubit: cubit),
                    const SizedBox(height: 16),
                    const SettingsDivider(),
                    const SizedBox(height: 16),
                    _AllergiesSection(state: state, cubit: cubit),
                    const SizedBox(height: 16),
                    _ObjectiveSummary(state: state),
                    const SizedBox(height: 24),
                    _ResetButton(onPressed: cubit.showResetDialog),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              if (state.showRegenerateDialog)
                RegenerateDialog(
                  onConfirm: () {
                    cubit.onRegenerateConfirmed();
                    context.push(AppRoutes.planConfig);
                  },
                  onDismiss: cubit.dismissRegenerateDialog,
                ),
              if (state.showResetDialog)
                ResetDialog(
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
}

// ── Profile section ─────────────────────────────────────────────────

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.state, required this.cubit});

  final SettingsState state;
  final SettingsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle('Profil'),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: state.name)
            ..selection =
                TextSelection.collapsed(offset: state.name.length),
          onChanged: cubit.updateName,
          decoration: _inputDecoration('Prenom'),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(text: state.age)
                  ..selection =
                      TextSelection.collapsed(offset: state.age.length),
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
        ChipRow(
          options: Sex.values,
          selected: state.sex,
          labelOf: (s) => s.displayName,
          onSelected: cubit.updateSex,
        ),
      ],
    );
  }
}

// ── Objective section ───────────────────────────────────────────────

class _ObjectiveSection extends StatelessWidget {
  const _ObjectiveSection({required this.state, required this.cubit});

  final SettingsState state;
  final SettingsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle('Objectif'),
        const SizedBox(height: 8),
        _WeightFields(state: state, cubit: cubit),
        const SizedBox(height: 12),
        const SettingsSubSectionTitle('Regime alimentaire'),
        const SizedBox(height: 4),
        ChipRow(
          options: DietType.values,
          selected: state.dietType,
          labelOf: (d) => d.displayName,
          onSelected: cubit.updateDietType,
        ),
        const SizedBox(height: 8),
        const SettingsSubSectionTitle('Rythme de perte'),
        const SizedBox(height: 4),
        ChipRow(
          options: LossPace.values,
          selected: state.lossPace,
          labelOf: (lp) => lp.displayName,
          onSelected: cubit.updateLossPace,
        ),
        const SettingsSubSectionTitle('Activite'),
        const SizedBox(height: 4),
        ChipRow(
          options: ActivityLevel.values,
          selected: state.activityLevel,
          labelOf: (al) => al.displayName,
          onSelected: cubit.updateActivityLevel,
        ),
        const SizedBox(height: 8),
        const SettingsSubSectionTitle('Date de demarrage'),
        const SizedBox(height: 4),
        DietStartDateSelector(
          dietStartDate: state.dietStartDate,
          onDateChange: cubit.updateDietStartDate,
        ),
        const SizedBox(height: 8),
        const SettingsSubSectionTitle('Jours libres (sans regime)'),
        const SizedBox(height: 4),
        Text(
          '${state.dietDaysPerWeek} jours de regime / '
          '${state.freeDays.length} jours libres',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        FreeDaysChips(
          freeDays: state.freeDays,
          onToggle: cubit.toggleFreeDay,
        ),
        const SizedBox(height: 4),
        StepperField(
          label: 'Sessions batch cooking',
          value: state.batchCookingSessions,
          min: 1,
          max: 2,
          onChanged: cubit.updateBatchCooking,
        ),
        BatchCookingToggle(
          batchCookingBeforeDiet: state.batchCookingBeforeDiet,
          onChanged: cubit.updateBatchCookingBeforeDiet,
        ),
        const SizedBox(height: 4),
        StepperField(
          label: 'Courses / sem.',
          value: state.shoppingTrips,
          min: 1,
          max: 2,
          onChanged: cubit.updateShoppingTrips,
        ),
        const SizedBox(height: 8),
        _EconomicModeRow(
          economicMode: state.economicMode,
          onChanged: cubit.updateEconomicMode,
        ),
        const SizedBox(height: 12),
        const SettingsSubSectionTitle('Repas inclus'),
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
        const SettingsSubSectionTitle('Variete des recettes'),
        const SizedBox(height: 4),
        _RecipeVarietySteppers(state: state, cubit: cubit),
      ],
    );
  }
}

// ── Weight fields ───────────────────────────────────────────────────

class _WeightFields extends StatelessWidget {
  const _WeightFields({required this.state, required this.cubit});

  final SettingsState state;
  final SettingsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: TextEditingController(text: state.weightKg)
              ..selection =
                  TextSelection.collapsed(offset: state.weightKg.length),
            onChanged: cubit.updateWeight,
            decoration: _inputDecoration('Poids (kg)'),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [DecimalInputFormatter()],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller:
                TextEditingController(text: state.targetWeightKg)
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
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [DecimalInputFormatter()],
          ),
        ),
      ],
    );
  }
}

// ── Economic mode row ───────────────────────────────────────────────

class _EconomicModeRow extends StatelessWidget {
  const _EconomicModeRow({
    required this.economicMode,
    required this.onChanged,
  });

  final bool economicMode;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mode economique',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'Ingredients communs entre recettes',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: economicMode,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ── Recipe variety steppers ─────────────────────────────────────────

class _RecipeVarietySteppers extends StatelessWidget {
  const _RecipeVarietySteppers({required this.state, required this.cubit});

  final SettingsState state;
  final SettingsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (state.enabledMealTypes.contains(MealType.breakfast))
          StepperField(
            label: 'Petits-dej. differents',
            value: state.distinctBreakfasts,
            min: 1,
            max: 6,
            onChanged: cubit.updateDistinctBreakfasts,
          ),
        if (state.enabledMealTypes.contains(MealType.lunch))
          StepperField(
            label: 'Dejeuners differents',
            value: state.distinctLunches,
            min: 1,
            max: 7,
            onChanged: cubit.updateDistinctLunches,
          ),
        if (state.enabledMealTypes.contains(MealType.dinner))
          StepperField(
            label: 'Diners differents',
            value: state.distinctDinners,
            min: 1,
            max: 7,
            onChanged: cubit.updateDistinctDinners,
          ),
        if (state.enabledMealTypes.contains(MealType.snack))
          StepperField(
            label: 'Snacks differents',
            value: state.distinctSnacks,
            min: 1,
            max: 5,
            onChanged: cubit.updateDistinctSnacks,
          ),
      ],
    );
  }
}

// ── Allergies section ───────────────────────────────────────────────

class _AllergiesSection extends StatelessWidget {
  const _AllergiesSection({required this.state, required this.cubit});

  final SettingsState state;
  final SettingsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle('Allergies'),
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
        const SettingsSectionTitle('Viandes exclues'),
        const SizedBox(height: 4),
        Text(
          'Excluez certaines viandes selon vos '
          'convictions ou preferences.',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
      ],
    );
  }
}

// ── Objective summary ───────────────────────────────────────────────

class _ObjectiveSummary extends StatelessWidget {
  const _ObjectiveSummary({required this.state});

  final SettingsState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.calculatedCalories > 0)
          ObjectiveCard(
            text: 'Objectif : ${state.calculatedCalories} kcal / jour',
            color: AppColors.emeraldPrimary,
            backgroundColor:
                AppColors.emeraldPrimary.withValues(alpha: 0.08),
          ),
        if (state.calculatedWaterMl > 0) ...[
          const SizedBox(height: 8),
          ObjectiveCard(
            text:
                'Hydratation : ${(state.calculatedWaterMl / 1000).toStringAsFixed(1)} L / jour',
            color: AppColors.waterBlue,
            backgroundColor:
                AppColors.waterBlue.withValues(alpha: 0.08),
          ),
        ],
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.push(AppRoutes.aboutCalculations),
          child: const Text(
              'Comment sont calcules ces objectifs ?'),
        ),
      ],
    );
  }
}

// ── Reset button ────────────────────────────────────────────────────

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          "Reinitialiser l'application",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ── Shared input decoration ─────────────────────────────────────────

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
