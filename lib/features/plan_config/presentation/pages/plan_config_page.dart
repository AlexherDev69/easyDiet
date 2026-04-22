import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../navigation/app_router.dart';
import '../../../../shared/widgets/blob_bg.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_title.dart';
import '../../../onboarding/domain/models/models.dart';
import '../../../settings/presentation/widgets/settings_primitives.dart';
import '../cubit/plan_config_cubit.dart';
import '../cubit/plan_config_state.dart';

class PlanConfigPage extends StatelessWidget {
  const PlanConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanConfigCubit, PlanConfigState>(
      builder: (context, state) {
        final cubit = context.read<PlanConfigCubit>();
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
                      : _Content(state: state, cubit: cubit),
                ),
              ),
              if (!state.isLoading)
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: _GenerateButton(
                    onTap: () async {
                      await cubit.saveAndProceed();
                      if (context.mounted) {
                        context.push(AppRoutes.planPreview);
                      }
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.state, required this.cubit});

  final PlanConfigState state;
  final PlanConfigCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      children: [
        _Header(),
        const SizedBox(height: 12),
        _DietTypeCard(selected: state.dietType, onSelect: cubit.updateDietType),
        const SizedBox(height: 12),
        _MealsCard(
          enabled: state.enabledMealTypes,
          onToggle: cubit.toggleMealType,
        ),
        const SizedBox(height: 12),
        _FreeDaysCard(
          freeDays: state.freeDays,
          onToggle: cubit.toggleFreeDay,
        ),
        const SizedBox(height: 12),
        _ModeCard(
          economicMode: state.economicMode,
          onChange: cubit.toggleEconomicMode,
        ),
        const SizedBox(height: 12),
        _StartDateCard(
          date: state.dietStartDate,
          onChange: cubit.updateDietStartDate,
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
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
              GradientTitle(
                'Nouveau plan',
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Section shell ────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.eyebrow,
    required this.title,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow.toUpperCase(),
            style: GoogleFonts.nunito(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.emeraldDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ── Diet type ────────────────────────────────────────────────────────

class _DietTypeCard extends StatelessWidget {
  const _DietTypeCard({required this.selected, required this.onSelect});

  final DietType selected;
  final ValueChanged<DietType> onSelect;

  @override
  Widget build(BuildContext context) {
    const tiles = <({DietType type, String label, String subtitle, IconData icon})>[
      (
        type: DietType.omnivore,
        label: 'Omnivore',
        subtitle: 'Viandes, poissons',
        icon: LucideIcons.beef,
      ),
      (
        type: DietType.vegetarian,
        label: 'Vegetarien',
        subtitle: 'Sans viande',
        icon: LucideIcons.leaf,
      ),
      (
        type: DietType.vegan,
        label: 'Vegan',
        subtitle: 'Zero produit animal',
        icon: LucideIcons.sprout,
      ),
    ];
    return _SectionCard(
      eyebrow: 'Type de regime',
      title: 'Que mangez-vous ?',
      child: Row(
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: _DietTile(
                label: tiles[i].label,
                subtitle: tiles[i].subtitle,
                icon: tiles[i].icon,
                active: selected == tiles[i].type,
                onTap: () => onSelect(tiles[i].type),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DietTile extends StatelessWidget {
  const _DietTile({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 14, 8, 12),
          decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(
                    colors: [AppColors.emeraldPrimary, Color(0xFF059669)],
                  )
                : null,
            color: active ? null : Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(16),
            border: active
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.5)),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.emeraldPrimary.withValues(alpha: 0.32),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: active
                      ? Colors.white.withValues(alpha: 0.22)
                      : AppColors.emeraldDark.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: active ? Colors.white : AppColors.emeraldDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: active ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? Colors.white.withValues(alpha: 0.85)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Meals card ───────────────────────────────────────────────────────

class _MealsCard extends StatelessWidget {
  const _MealsCard({required this.enabled, required this.onToggle});

  final Set<MealType> enabled;
  final ValueChanged<MealType> onToggle;

  @override
  Widget build(BuildContext context) {
    const rows = <({MealType type, IconData icon, Color color, String label, String time})>[
      (type: MealType.breakfast, icon: LucideIcons.coffee, color: Color(0xFFF59E0B), label: 'Petit-dejeuner', time: '07h30'),
      (type: MealType.lunch, icon: LucideIcons.utensils, color: AppColors.emeraldPrimary, label: 'Dejeuner', time: '12h30'),
      (type: MealType.snack, icon: LucideIcons.cookie, color: Color(0xFFEC4899), label: 'Collation', time: '16h00'),
      (type: MealType.dinner, icon: LucideIcons.moon, color: Color(0xFF6366F1), label: 'Diner', time: '19h30'),
    ];
    return _SectionCard(
      eyebrow: 'Repas actives',
      title: 'Quels repas planifier ?',
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            SettingsSwitchRow(
              icon: rows[i].icon,
              color: rows[i].color,
              label: rows[i].label,
              subtitle: rows[i].time,
              value: enabled.contains(rows[i].type),
              onChanged: (_) => onToggle(rows[i].type),
              last: i == rows.length - 1,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Free days card ───────────────────────────────────────────────────

class _FreeDaysCard extends StatelessWidget {
  const _FreeDaysCard({required this.freeDays, required this.onToggle});

  final Set<int> freeDays;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    const labels = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return _SectionCard(
      eyebrow: 'Jours libres',
      title: 'Jours hors plan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < labels.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: _DayPill(
                    label: labels[i],
                    active: freeDays.contains(i),
                    canToggle: freeDays.contains(i) || freeDays.length < 3,
                    onTap: () => onToggle(i),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Ces jours ne seront pas inclus dans les courses ni les repas generes.',
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.label,
    required this.active,
    required this.canToggle,
    required this.onTap,
  });

  final String label;
  final bool active;
  final bool canToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: canToggle ? 1 : 0.45,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: canToggle ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFF8B5CF6)
                  : const Color(0xFF0F172A).withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: active
                    ? const Color(0xFF8B5CF6)
                    : const Color(0xFF0F172A).withValues(alpha: 0.06),
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.32),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: active ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Mode card ────────────────────────────────────────────────────────

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.economicMode, required this.onChange});

  final bool economicMode;
  final ValueChanged<bool> onChange;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      eyebrow: 'Mode de generation',
      title: 'Priorite du plan',
      child: Row(
        children: [
          Expanded(
            child: _ModeTile(
              label: 'Variete',
              subtitle: 'Recettes diverses chaque jour',
              icon: LucideIcons.sparkles,
              color: AppColors.emeraldPrimary,
              active: !economicMode,
              onTap: () => onChange(false),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ModeTile(
              label: 'Economique',
              subtitle: 'Restes et ingredients optimises',
              icon: LucideIcons.wallet,
              color: const Color(0xFFF59E0B),
              active: economicMode,
              onTap: () => onChange(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: active
                ? color.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: active ? 2 : 1,
              color: active
                  ? color
                  : Colors.white.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 17, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Start date card ──────────────────────────────────────────────────

class _StartDateCard extends StatelessWidget {
  const _StartDateCard({required this.date, required this.onChange});

  final DateTime? date;
  final ValueChanged<DateTime> onChange;

  @override
  Widget build(BuildContext context) {
    final today = AppDateUtils.today();
    final tomorrow = today.add(const Duration(days: 1));
    final d = date ?? today;
    final isToday = _sameDay(d, today);
    final isTomorrow = _sameDay(d, tomorrow);
    final isOther = !isToday && !isTomorrow;

    return _SectionCard(
      eyebrow: 'Demarrage',
      title: 'Quand commence-t-on ?',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _DateChip(
            label: "Aujourd'hui",
            active: isToday,
            onTap: () => onChange(today),
          ),
          _DateChip(
            label: 'Demain',
            active: isTomorrow,
            onTap: () => onChange(tomorrow),
          ),
          _DateChip(
            label: AppDateUtils.formatShortDate(isOther ? d : today),
            active: isOther,
            icon: LucideIcons.calendar,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: isOther ? d : today,
                firstDate: today,
                lastDate: today.add(const Duration(days: 365)),
              );
              if (picked != null) onChange(picked);
            },
          ),
        ],
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(
                    colors: [AppColors.emeraldPrimary, Color(0xFF059669)])
                : null,
            color: active ? null : Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active
                  ? AppColors.emeraldPrimary
                  : Colors.white.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 13,
                  color: active ? Colors.white : const Color(0xFF0F172A),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 12,
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

// ── Generate button ──────────────────────────────────────────────────

class _GenerateButton extends StatelessWidget {
  const _GenerateButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.emeraldPrimary, Color(0xFF059669)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.emeraldPrimary.withValues(alpha: 0.45),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.sparkles,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                'Generer mon plan',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.1,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
