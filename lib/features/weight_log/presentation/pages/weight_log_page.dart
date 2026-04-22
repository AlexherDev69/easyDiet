import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/decimal_input_formatter.dart';
import '../../../../data/local/database.dart';
import '../../../../shared/widgets/blob_bg.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glass_dialog.dart';
import '../cubit/weight_log_cubit.dart';
import '../cubit/weight_log_state.dart';
import '../widgets/weight_line_chart.dart';

class WeightLogPage extends StatelessWidget {
  const WeightLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeightLogCubit, WeightLogState>(
      listenWhen: (prev, curr) =>
          (prev.outlierWarning != curr.outlierWarning &&
              curr.outlierWarning != null) ||
          (!prev.showAddDialog && curr.showAddDialog) ||
          (!prev.showDuplicateDialog && curr.showDuplicateDialog),
      listener: (context, state) {
        if (state.outlierWarning != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.outlierWarning!)),
          );
          context.read<WeightLogCubit>().dismissOutlierWarning();
        }
        if (state.showAddDialog) {
          showGlassDialog<void>(
            context: context,
            builder: (dialogContext) => BlocProvider.value(
              value: context.read<WeightLogCubit>(),
              child: const _AddWeightDialogShell(),
            ),
          ).then((_) {
            if (context.mounted) {
              final cubit = context.read<WeightLogCubit>();
              if (cubit.state.showAddDialog) cubit.hideAddDialog();
            }
          });
        }
        if (state.showDuplicateDialog) {
          showGlassDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => BlocProvider.value(
              value: context.read<WeightLogCubit>(),
              child: const _DuplicateDialogShell(),
            ),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            const Positioned.fill(child: BlobBG()),
            if (state.isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: AppColors.emeraldPrimary,
                ),
              )
            else
              _Content(state: state),
            Positioned(
              right: 20,
              bottom: 110,
              child: _AddFab(
                onTap: () => context.read<WeightLogCubit>().showAddDialog(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.state});

  final WeightLogState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WeightLogCubit>();
    final topPadding = MediaQuery.of(context).padding.top;
    final currentWeight = state.allLogs.lastOrNull?.weightKg ?? 0.0;

    return ListView(
      padding: EdgeInsets.fromLTRB(20, topPadding + 14, 20, 140),
      children: [
        const _Header(),
        const SizedBox(height: 12),
        _StatsGrid(state: state, currentWeight: currentWeight),
        if (state.projectedGoalDate != null) ...[
          const SizedBox(height: 10),
          _ProjectedGoalCard(
            projectedDate: state.projectedGoalDate!,
            weeksRemaining: _weeksUntil(state.projectedGoalDate!),
          ),
        ],
        const SizedBox(height: 12),
        _EvolutionCard(
          state: state,
          onPeriodChanged: cubit.selectPeriod,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'HISTORIQUE',
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        _HistoryList(
          logs: state.allLogs.reversed.toList(),
          onDelete: cubit.deleteLog,
        ),
      ],
    );
  }

  int _weeksUntil(DateTime target) {
    final diff = target.difference(DateTime.now()).inDays;
    return (diff / 7).ceil().clamp(0, 999);
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final gradient = ExtendedColorsProvider.of(context).primaryGradient;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SUIVI',
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 2),
        ShaderMask(
          shaderCallback: (rect) => gradient.createShader(rect),
          blendMode: BlendMode.srcIn,
          child: Text(
            'Mon poids',
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.state, required this.currentWeight});

  final WeightLogState state;
  final double currentWeight;

  @override
  Widget build(BuildContext context) {
    final stats = <_StatData>[
      _StatData(
        label: 'Poids actuel',
        value: '${currentWeight.toStringAsFixed(1)} kg',
        icon: LucideIcons.scale,
        color: const Color(0xFF8B5CF6),
      ),
      _StatData(
        label: 'Objectif',
        value: '${state.targetWeight.toStringAsFixed(1)} kg',
        icon: LucideIcons.target,
        color: AppColors.emeraldPrimary,
      ),
      _StatData(
        label: 'Total perdu',
        value:
            '${state.totalLost >= 0 ? '-' : '+'}${state.totalLost.abs().toStringAsFixed(1)} kg',
        icon: state.totalLost >= 0
            ? LucideIcons.trendingDown
            : LucideIcons.trendingUp,
        color: const Color(0xFFF43F5E),
      ),
      _StatData(
        label: 'Rythme / sem',
        value:
            '${state.avgLossPerWeek >= 0 ? '-' : '+'}${state.avgLossPerWeek.abs().toStringAsFixed(2)} kg',
        icon: state.avgLossPerWeek >= 0
            ? LucideIcons.trendingDown
            : LucideIcons.trendingUp,
        color: const Color(0xFFF59E0B),
      ),
    ];
    // GridView.count + shrinkWrap dans un ListView reservait beaucoup
    // trop de hauteur (~140px de vide sous la grille). On utilise 2 Row
    // de cartes : la hauteur s'aligne sur le contenu intrinseque.
    return Column(
      children: [
        _statRow(stats[0], stats[1]),
        const SizedBox(height: 10),
        _statRow(stats[2], stats[3]),
      ],
    );
  }

  Widget _statRow(_StatData left, _StatData right) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _StatCard(data: left)),
          const SizedBox(width: 10),
          Expanded(child: _StatCard(data: right)),
        ],
      ),
    );
  }
}

class _StatData {
  const _StatData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data});
  final _StatData data;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(data.icon, size: 15, color: data.color),
          ),
          const SizedBox(height: 6),
          Text(
            data.label.toUpperCase(),
            style: GoogleFonts.nunito(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            data.value,
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectedGoalCard extends StatelessWidget {
  const _ProjectedGoalCard({
    required this.projectedDate,
    required this.weeksRemaining,
  });

  final DateTime projectedDate;
  final int weeksRemaining;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 18,
      accentColor: AppColors.emeraldPrimary,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.emeraldPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              LucideIcons.calendar,
              size: 18,
              color: Color(0xFF059669),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OBJECTIF ATTEINT',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: const Color(0xFF059669),
                  ),
                ),
                const SizedBox(height: 1),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                    children: [
                      const TextSpan(text: 'Autour du '),
                      TextSpan(
                        text: AppDateUtils.formatFrenchDate(projectedDate),
                        style: const TextStyle(color: Color(0xFF059669)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$weeksRemaining sem.',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                'restantes',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EvolutionCard extends StatelessWidget {
  const _EvolutionCard({
    required this.state,
    required this.onPeriodChanged,
  });

  final WeightLogState state;
  final ValueChanged<int> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final filtered = _filterLogsByPeriod(state.allLogs, state.selectedPeriod);
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Evolution',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              _PeriodToggle(
                selected: state.selectedPeriod,
                onChanged: onPeriodChanged,
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (filtered.length >= 2)
            SizedBox(
              height: 220,
              child: WeightLineChart(
                logs: filtered,
                targetWeight: state.targetWeight,
              ),
            )
          else
            SizedBox(
              height: 120,
              child: Center(
                child: Text(
                  'Pas assez de donnees',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PeriodToggle extends StatelessWidget {
  const _PeriodToggle({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  static const _labels = ['4 sem', '3 mois', 'Tout'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < _labels.length; i++)
            _PeriodBtn(
              label: _labels[i],
              active: selected == i,
              onTap: () => onChanged(i),
            ),
        ],
      ),
    );
  }
}

class _PeriodBtn extends StatelessWidget {
  const _PeriodBtn({
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
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Ink(
          height: 26,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: active
                    ? const Color(0xFF0F172A)
                    : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.logs, required this.onDelete});

  final List<WeightLog> logs;
  final ValueChanged<WeightLog> onDelete;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Aucune pesee enregistree',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < logs.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _HistoryRow(
              log: logs[i],
              previousWeight:
                  i + 1 < logs.length ? logs[i + 1].weightKg : null,
              onDelete: () => _confirmDelete(context, logs[i]),
            ),
          ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, WeightLog log) async {
    final confirmed = await showGlassDialog<bool>(
      context: context,
      builder: (dialogContext) => GlassDialogContent(
        icon: Icons.delete_outline,
        iconGradient: LinearGradient(
          colors: [
            AppColors.accentRose,
            AppColors.accentRose.withValues(alpha: 0.8),
          ],
        ),
        title: 'Supprimer cette pesee ?',
        child: GlassDialogActions(
          secondary: GlassDialogButton(
            label: 'Annuler',
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          primary: GlassDialogDangerButton(
            label: 'Supprimer',
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ),
      ),
    );
    if (confirmed ?? false) onDelete(log);
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.log,
    required this.previousWeight,
    required this.onDelete,
  });

  final WeightLog log;
  final double? previousWeight;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final date = AppDateUtils.fromEpochMillis(log.date);
    final diff = previousWeight != null ? log.weightKg - previousWeight! : null;
    final isNeg = diff != null && diff < 0;

    return Dismissible(
      key: ValueKey(log.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.accentRose,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        borderRadius: 14,
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.emeraldPrimary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                LucideIcons.scale,
                size: 15,
                color: Color(0xFF059669),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${log.weightKg.toStringAsFixed(1)} kg',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    AppDateUtils.formatFrenchDate(date),
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            if (diff != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (isNeg
                          ? AppColors.emeraldPrimary
                          : const Color(0xFFF43F5E))
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isNeg ? LucideIcons.trendingDown : LucideIcons.trendingUp,
                      size: 11,
                      color: isNeg
                          ? const Color(0xFF059669)
                          : const Color(0xFFBE123C),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(1)}',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isNeg
                            ? const Color(0xFF059669)
                            : const Color(0xFFBE123C),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddFab extends StatelessWidget {
  const _AddFab({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Ajouter une pesee',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.gradientGreenStart,
                  AppColors.gradientGreenEnd,
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.emeraldPrimary.withValues(alpha: 0.45),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const Icon(LucideIcons.plus, color: Colors.white, size: 26),
          ),
        ),
      ),
    );
  }
}

// ── Dialog shells & helpers ─────────────────────────────────────────

class _AddWeightDialogShell extends StatelessWidget {
  const _AddWeightDialogShell();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeightLogCubit, WeightLogState>(
      listenWhen: (prev, curr) => prev.showAddDialog && !curr.showAddDialog,
      listener: (context, state) {
        final route = ModalRoute.of(context);
        if (route != null && route.isCurrent) Navigator.pop(context);
      },
      builder: (context, state) {
        final cubit = context.read<WeightLogCubit>();
        final isValid = double.tryParse(state.weightInput) != null;
        return GlassDialogContent(
          icon: Icons.monitor_weight_outlined,
          title: 'Ajouter une pesee',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: state.selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) cubit.updateSelectedDate(picked);
                },
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today, size: 20),
                  ),
                  child: Text(
                    AppDateUtils.formatFrenchDate(
                      state.selectedDate ?? DateTime.now(),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DecimalInputFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Poids (kg)',
                  border: OutlineInputBorder(),
                ),
                onChanged: cubit.updateWeightInput,
              ),
              const SizedBox(height: 20),
              GlassDialogActions(
                secondary: GlassDialogButton(
                  label: 'Annuler',
                  onPressed: cubit.hideAddDialog,
                ),
                primary: GlassDialogPrimaryButton(
                  label: 'Ajouter',
                  onPressed: isValid ? cubit.addWeightLog : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DuplicateDialogShell extends StatelessWidget {
  const _DuplicateDialogShell();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeightLogCubit, WeightLogState>(
      listenWhen: (prev, curr) =>
          prev.showDuplicateDialog && !curr.showDuplicateDialog,
      listener: (context, state) {
        final route = ModalRoute.of(context);
        if (route != null && route.isCurrent) Navigator.pop(context);
      },
      builder: (context, state) {
        final cubit = context.read<WeightLogCubit>();
        return GlassDialogContent(
          icon: Icons.info_outline,
          iconGradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.orange.shade600],
          ),
          title: 'Doublon detecte',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Une entree existe deja pour aujourd'hui. "
                'Voulez-vous la remplacer ?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GlassDialogActions(
                secondary: GlassDialogButton(
                  label: 'Annuler',
                  onPressed: cubit.dismissDuplicateDialog,
                ),
                primary: GlassDialogPrimaryButton(
                  label: 'Remplacer',
                  onPressed: cubit.confirmReplaceDuplicate,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

List<WeightLog> _filterLogsByPeriod(List<WeightLog> logs, int period) {
  if (period == 2) return logs;

  final now = DateTime.now();
  final cutoff = switch (period) {
    0 => now.subtract(const Duration(days: 28)),
    1 => DateTime(now.year, now.month - 3, now.day),
    _ => now,
  };
  final cutoffMillis = cutoff.millisecondsSinceEpoch;
  return logs.where((l) => l.date >= cutoffMillis).toList();
}
