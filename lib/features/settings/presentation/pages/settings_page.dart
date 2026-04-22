import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../navigation/app_router.dart';
import '../../../../shared/widgets/blob_bg.dart';
import '../../../../shared/widgets/glass_dialog.dart';
import '../../../../shared/widgets/gradient_title.dart';
import '../../../onboarding/domain/models/models.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/settings_primitives.dart';
import '../widgets/settings_widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) =>
          (!prev.showRegenerateDialog && curr.showRegenerateDialog) ||
          (!prev.showResetDialog && curr.showResetDialog),
      listener: (context, state) {
        final cubit = context.read<SettingsCubit>();
        if (state.showRegenerateDialog) {
          _showRegenerateDialog(context, cubit);
        }
        if (state.showResetDialog) {
          _showResetDialog(context, cubit);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              const Positioned.fill(child: BlobBG()),
              Positioned.fill(
                child: SafeArea(
                  child: state.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.emeraldPrimary,
                          ),
                        )
                      : _Content(state: state),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRegenerateDialog(BuildContext context, SettingsCubit cubit) {
    showGlassDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _RegenerateDialogWrapper(
          onConfirmed: () {
            cubit.onRegenerateConfirmed();
            context.push(AppRoutes.planConfig);
          },
        ),
      ),
    ).then((_) {
      if (cubit.state.showRegenerateDialog) {
        cubit.dismissRegenerateDialog();
      }
    });
  }

  void _showResetDialog(BuildContext context, SettingsCubit cubit) {
    showGlassDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _ResetDialogWrapper(
          onConfirmed: () async {
            await cubit.resetApp();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Donnees reinitialisees avec succes'),
                ),
              );
              context.go(AppRoutes.onboarding);
            }
          },
        ),
      ),
    ).then((_) {
      if (cubit.state.showResetDialog) {
        cubit.hideResetDialog();
      }
    });
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.state});

  final SettingsState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      children: [
        _Header(state: state, onSave: cubit.saveProfile),
        const SizedBox(height: 14),
        _ProfileSection(state: state, cubit: cubit),
        _DietSection(state: state, cubit: cubit),
        _PlanSection(state: state, cubit: cubit),
        _AdvancedSection(state: state, cubit: cubit),
        _AboutSection(),
        const SizedBox(height: 8),
        _ResetButton(onPressed: cubit.showResetDialog),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.state, required this.onSave});

  final SettingsState state;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackPill(onTap: () => context.pop()),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'COMPTE',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: const Color(0xFF64748B),
                ),
              ),
              GradientTitle(
                'Parametres',
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onSave,
          child: Text(
            state.isSaved ? 'Enregistre' : 'Enregistrer',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.emeraldPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Profile ─────────────────────────────────────────────────────────

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.state, required this.cubit});

  final SettingsState state;
  final SettingsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      eyebrow: 'Vous',
      title: 'Profil',
      children: [
        SettingsRow(
          icon: LucideIcons.user,
          color: AppColors.emeraldPrimary,
          label: 'Nom',
          value: state.name.isEmpty ? '—' : state.name,
          onTap: () => _editText(
            context,
            title: 'Nom',
            initial: state.name,
            keyboardType: TextInputType.name,
            onSave: cubit.updateName,
          ),
        ),
        SettingsRow(
          icon: LucideIcons.cake,
          color: const Color(0xFFF59E0B),
          label: 'Age',
          value: state.age.isEmpty ? '—' : '${state.age} ans',
          onTap: () => _editText(
            context,
            title: 'Age',
            initial: state.age,
            keyboardType: TextInputType.number,
            onSave: cubit.updateAge,
          ),
        ),
        SettingsRow(
          icon: LucideIcons.users,
          color: const Color(0xFF8B5CF6),
          label: 'Sexe',
          value: state.sex.displayName,
          onTap: () => _pickSex(context, state.sex, cubit.updateSex),
        ),
        SettingsRow(
          icon: LucideIcons.ruler,
          color: const Color(0xFF0EA5E9),
          label: 'Taille',
          value: state.heightCm.isEmpty ? '—' : '${state.heightCm} cm',
          onTap: () => _editText(
            context,
            title: 'Taille (cm)',
            initial: state.heightCm,
            keyboardType: TextInputType.number,
            onSave: cubit.updateHeight,
          ),
        ),
        SettingsRow(
          icon: LucideIcons.scale,
          color: const Color(0xFFF43F5E),
          label: 'Poids actuel',
          value: state.weightKg.isEmpty ? '—' : '${state.weightKg} kg',
          onTap: () => _editText(
            context,
            title: 'Poids (kg)',
            initial: state.weightKg,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onSave: cubit.updateWeight,
          ),
        ),
        SettingsRow(
          icon: LucideIcons.target,
          color: AppColors.emeraldDark,
          label: 'Poids cible',
          value:
              state.targetWeightKg.isEmpty ? '—' : '${state.targetWeightKg} kg',
          last: true,
          onTap: () => _editText(
            context,
            title: 'Poids cible (kg)',
            initial: state.targetWeightKg,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onSave: cubit.updateTargetWeight,
          ),
        ),
      ],
    );
  }
}

// ── Diet ────────────────────────────────────────────────────────────

class _DietSection extends StatelessWidget {
  const _DietSection({required this.state, required this.cubit});

  final SettingsState state;
  final SettingsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      eyebrow: 'Alimentation',
      title: 'Regime',
      children: [
        const SizedBox(height: 4),
        _DietTilesRow(selected: state.dietType, onSelect: cubit.updateDietType),
        const SizedBox(height: 14),
        const SettingsRowDivider(),
        const SizedBox(height: 12),
        _ChipsBlock(
          icon: LucideIcons.triangleAlert,
          iconColor: const Color(0xFFF59E0B),
          title: 'Allergies & intolerances',
          children: Allergy.values
              .map((a) => SettingsChip(
                    label: a.displayName,
                    active: state.selectedAllergies.contains(a),
                    color: const Color(0xFFF59E0B),
                    onTap: () => cubit.toggleAllergy(a),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        const SettingsRowDivider(),
        const SizedBox(height: 12),
        _ChipsBlock(
          icon: LucideIcons.beef,
          iconColor: const Color(0xFFF43F5E),
          title: 'Viandes exclues',
          children: ExcludedMeat.values
              .map((m) => SettingsChip(
                    label: m.displayName,
                    active: state.excludedMeats.contains(m),
                    color: const Color(0xFFF43F5E),
                    onTap: () => cubit.toggleExcludedMeat(m),
                  ))
              .toList(),
        ),
        const SizedBox(height: 6),
        const SettingsRowDivider(),
        SettingsSwitchRow(
          icon: LucideIcons.wallet,
          color: AppColors.emeraldDark,
          label: 'Mode economique',
          subtitle: 'Privilegier les ingredients communs',
          value: state.economicMode,
          onChanged: cubit.updateEconomicMode,
          last: true,
        ),
      ],
    );
  }
}

class _DietTilesRow extends StatelessWidget {
  const _DietTilesRow({required this.selected, required this.onSelect});

  final DietType selected;
  final ValueChanged<DietType> onSelect;

  @override
  Widget build(BuildContext context) {
    const tiles = <({DietType type, String label, IconData icon})>[
      (type: DietType.omnivore, label: 'Omnivore', icon: LucideIcons.beef),
      (type: DietType.vegetarian, label: 'Vegetarien', icon: LucideIcons.leaf),
      (type: DietType.vegan, label: 'Vegan', icon: LucideIcons.leaf),
    ];
    return Row(
      children: [
        for (var i = 0; i < tiles.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: _DietTile(
              type: tiles[i].type,
              label: tiles[i].label,
              icon: tiles[i].icon,
              active: selected == tiles[i].type,
              onTap: () => onSelect(tiles[i].type),
            ),
          ),
        ],
      ],
    );
  }
}

class _DietTile extends StatelessWidget {
  const _DietTile({
    required this.type,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final DietType type;
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 62,
          decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(
                    colors: [AppColors.emeraldPrimary, Color(0xFF059669)])
                : null,
            color: active ? null : Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(14),
            border: active
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.emeraldPrimary.withValues(alpha: 0.32),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: active ? Colors.white : const Color(0xFF475569),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: active ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipsBlock extends StatelessWidget {
  const _ChipsBlock({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: children,
        ),
      ],
    );
  }
}

// ── Plan ────────────────────────────────────────────────────────────

class _PlanSection extends StatelessWidget {
  const _PlanSection({required this.state, required this.cubit});

  final SettingsState state;
  final SettingsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      eyebrow: 'Structure',
      title: 'Plan',
      children: [
        SettingsSwitchRow(
          icon: LucideIcons.coffee,
          color: const Color(0xFFF59E0B),
          label: 'Petit-dejeuner',
          value: state.enabledMealTypes.contains(MealType.breakfast),
          onChanged: (_) => cubit.toggleMealType(MealType.breakfast),
        ),
        SettingsSwitchRow(
          icon: LucideIcons.utensils,
          color: AppColors.emeraldPrimary,
          label: 'Dejeuner',
          value: state.enabledMealTypes.contains(MealType.lunch),
          onChanged: (_) => cubit.toggleMealType(MealType.lunch),
        ),
        SettingsSwitchRow(
          icon: LucideIcons.cookie,
          color: const Color(0xFFEC4899),
          label: 'Collation',
          value: state.enabledMealTypes.contains(MealType.snack),
          onChanged: (_) => cubit.toggleMealType(MealType.snack),
        ),
        SettingsSwitchRow(
          icon: LucideIcons.moon,
          color: const Color(0xFF6366F1),
          label: 'Diner',
          value: state.enabledMealTypes.contains(MealType.dinner),
          onChanged: (_) => cubit.toggleMealType(MealType.dinner),
        ),
        const SizedBox(height: 6),
        const SettingsRowDivider(),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(
              LucideIcons.calendarX,
              size: 14,
              color: Color(0xFF8B5CF6),
            ),
            const SizedBox(width: 8),
            Text(
              'Jours libres (hors plan)',
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _FreeDaysRow(freeDays: state.freeDays, onToggle: cubit.toggleFreeDay),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _FreeDaysRow extends StatelessWidget {
  const _FreeDaysRow({required this.freeDays, required this.onToggle});

  final Set<int> freeDays;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    const labels = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: _FreeDayTile(
              label: labels[i],
              active: freeDays.contains(i),
              onTap: () => onToggle(i),
            ),
          ),
        ],
      ],
    );
  }
}

class _FreeDayTile extends StatelessWidget {
  const _FreeDayTile({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF8B5CF6)
                : const Color(0xFF0F172A).withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: active
                  ? const Color(0xFF8B5CF6)
                  : const Color(0xFF0F172A).withValues(alpha: 0.06),
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: active ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Advanced (keeps existing extra fields) ──────────────────────────

class _AdvancedSection extends StatelessWidget {
  const _AdvancedSection({required this.state, required this.cubit});

  final SettingsState state;
  final SettingsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      eyebrow: 'Avance',
      title: 'Reglages fins',
      children: [
        _InlinePicker<LossPace>(
          label: 'Rythme de perte',
          options: LossPace.values,
          selected: state.lossPace,
          labelOf: (v) => v.displayName,
          onSelect: cubit.updateLossPace,
        ),
        const SettingsRowDivider(),
        _InlinePicker<ActivityLevel>(
          label: 'Activite',
          options: ActivityLevel.values,
          selected: state.activityLevel,
          labelOf: (v) => v.displayName,
          onSelect: cubit.updateActivityLevel,
        ),
        const SettingsRowDivider(),
        _StepperRow(
          label: 'Petits-dej. differents',
          value: state.distinctBreakfasts,
          min: 1,
          max: 6,
          enabled: state.enabledMealTypes.contains(MealType.breakfast),
          onChanged: cubit.updateDistinctBreakfasts,
        ),
        const SettingsRowDivider(),
        _StepperRow(
          label: 'Dejeuners differents',
          value: state.distinctLunches,
          min: 1,
          max: 7,
          enabled: state.enabledMealTypes.contains(MealType.lunch),
          onChanged: cubit.updateDistinctLunches,
        ),
        const SettingsRowDivider(),
        _StepperRow(
          label: 'Diners differents',
          value: state.distinctDinners,
          min: 1,
          max: 7,
          enabled: state.enabledMealTypes.contains(MealType.dinner),
          onChanged: cubit.updateDistinctDinners,
        ),
        const SettingsRowDivider(),
        _StepperRow(
          label: 'Snacks differents',
          value: state.distinctSnacks,
          min: 1,
          max: 5,
          enabled: state.enabledMealTypes.contains(MealType.snack),
          onChanged: cubit.updateDistinctSnacks,
        ),
        const SettingsRowDivider(),
        // Batch cooking — TEMPORAIREMENT MASQUE
        // _StepperRow(
        //   label: 'Sessions batch cooking',
        //   value: state.batchCookingSessions,
        //   min: 1,
        //   max: 2,
        //   enabled: true,
        //   onChanged: cubit.updateBatchCooking,
        // ),
        // const SettingsRowDivider(),
        _StepperRow(
          label: 'Courses / semaine',
          value: state.shoppingTrips,
          min: 1,
          max: 2,
          enabled: true,
          onChanged: cubit.updateShoppingTrips,
          last: true,
        ),
      ],
    );
  }
}

class _InlinePicker<T> extends StatelessWidget {
  const _InlinePicker({
    required this.label,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onSelect,
  });

  final String label;
  final List<T> options;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: options
                .map((o) => SettingsChip(
                      label: labelOf(o),
                      active: selected == o,
                      onTap: () => onSelect(o),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  const _StepperRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.enabled,
    required this.onChanged,
    this.last = false,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final bool enabled;
  final ValueChanged<int> onChanged;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            _StepBtn(
              icon: LucideIcons.minus,
              onTap: enabled && value > min ? () => onChanged(value - 1) : null,
            ),
            Container(
              width: 32,
              alignment: Alignment.center,
              child: Text(
                '$value',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            _StepBtn(
              icon: LucideIcons.plus,
              onTap: enabled && value < max ? () => onChanged(value + 1) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 14,
            color: disabled
                ? const Color(0xFF94A3B8)
                : const Color(0xFF0F172A),
          ),
        ),
      ),
    );
  }
}

// ── About ───────────────────────────────────────────────────────────

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      eyebrow: 'Application',
      title: 'A propos',
      children: [
        const SettingsRow(
          icon: LucideIcons.info,
          color: Color(0xFF0EA5E9),
          label: 'Version',
          value: '1.4.2',
        ),
        SettingsRow(
          icon: LucideIcons.calculator,
          color: const Color(0xFF8B5CF6),
          label: 'Calculs nutritionnels',
          value: 'Mifflin-St Jeor',
          last: true,
          onTap: () => context.push(AppRoutes.aboutCalculations),
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
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF43F5E).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFF43F5E).withValues(alpha: 0.28),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.trash2,
                size: 16,
                color: Color(0xFFBE123C),
              ),
              const SizedBox(width: 8),
              Text(
                "Reinitialiser l'application",
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.1,
                  color: const Color(0xFFBE123C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helpers: dialogs ────────────────────────────────────────────────

Future<void> _editText(
  BuildContext context, {
  required String title,
  required String initial,
  required TextInputType keyboardType,
  required ValueChanged<String> onSave,
}) async {
  final controller = TextEditingController(text: initial);
  final result = await showGlassDialog<String>(
    context: context,
    builder: (dialogCtx) => GlassDialogContent(
      icon: Icons.edit_outlined,
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 14),
          GlassDialogActions(
            secondary: GlassDialogButton(
              label: 'Annuler',
              onPressed: () => Navigator.of(dialogCtx).pop(),
            ),
            primary: GlassDialogPrimaryButton(
              label: 'Enregistrer',
              onPressed: () =>
                  Navigator.of(dialogCtx).pop(controller.text.trim()),
            ),
          ),
        ],
      ),
    ),
  );
  if (result != null) onSave(result);
}

Future<void> _pickSex(
  BuildContext context,
  Sex current,
  ValueChanged<Sex> onSelect,
) async {
  final result = await showGlassDialog<Sex>(
    context: context,
    builder: (dialogCtx) => GlassDialogContent(
      icon: Icons.person_outline,
      title: 'Sexe',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final s in Sex.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassDialogListTile(
                onTap: () => Navigator.of(dialogCtx).pop(s),
                title: Text(
                  s.displayName,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: current == s
                        ? FontWeight.w800
                        : FontWeight.w600,
                    color: current == s
                        ? AppColors.emeraldPrimary
                        : const Color(0xFF0F172A),
                  ),
                ),
                trailing: current == s
                    ? const Icon(
                        LucideIcons.check,
                        color: AppColors.emeraldPrimary,
                        size: 18,
                      )
                    : null,
              ),
            ),
        ],
      ),
    ),
  );
  if (result != null) onSelect(result);
}

// ── Existing dialog wrappers (unchanged) ────────────────────────────

class _RegenerateDialogWrapper extends StatelessWidget {
  const _RegenerateDialogWrapper({required this.onConfirmed});

  final VoidCallback onConfirmed;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) =>
          prev.showRegenerateDialog && !curr.showRegenerateDialog,
      listener: (context, state) {
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return RegenerateDialog(
          onConfirm: () {
            Navigator.of(context).pop();
            onConfirmed();
          },
          onDismiss: () {
            Navigator.of(context).pop();
            context.read<SettingsCubit>().dismissRegenerateDialog();
          },
        );
      },
    );
  }
}

class _ResetDialogWrapper extends StatelessWidget {
  const _ResetDialogWrapper({required this.onConfirmed});

  final VoidCallback onConfirmed;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) =>
          prev.showResetDialog && !curr.showResetDialog,
      listener: (context, state) {
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return ResetDialog(
          onConfirm: () {
            Navigator.of(context).pop();
            onConfirmed();
          },
          onDismiss: () {
            Navigator.of(context).pop();
            context.read<SettingsCubit>().hideResetDialog();
          },
        );
      },
    );
  }
}
