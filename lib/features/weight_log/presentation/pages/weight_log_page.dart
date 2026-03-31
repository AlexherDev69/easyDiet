import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/decimal_input_formatter.dart';
import '../../../../data/local/database.dart';
import '../../../../shared/widgets/solid_card.dart';
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
          (!prev.isAggressiveLoss && curr.isAggressiveLoss) ||
          (!prev.showAddDialog && curr.showAddDialog) ||
          (!prev.showDuplicateDialog && curr.showDuplicateDialog),
      listener: (context, state) {
        if (state.outlierWarning != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.outlierWarning!)),
          );
          context.read<WeightLogCubit>().dismissOutlierWarning();
        }
        if (state.isAggressiveLoss) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Perte de poids rapide detectee (> 1 kg/semaine). '
                'Consultez un professionnel de sante.',
              ),
              duration: const Duration(seconds: 5),
              backgroundColor: AppColors.accentRose,
            ),
          );
        }
        if (state.showAddDialog) {
          showDialog<void>(
            context: context,
            builder: (dialogContext) => BlocProvider.value(
              value: context.read<WeightLogCubit>(),
              child: const _AddWeightDialogShell(),
            ),
          ).then((_) {
            // Dialog was dismissed (barrier tap, back button, or programmatic pop).
            // Sync cubit state only if it still thinks the dialog is open.
            if (context.mounted) {
              final cubit = context.read<WeightLogCubit>();
              if (cubit.state.showAddDialog) {
                cubit.hideAddDialog();
              }
            }
          });
        }
        if (state.showDuplicateDialog) {
          showDialog<void>(
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
        if (state.isLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Suivi du poids',
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

        final cubit = context.read<WeightLogCubit>();
        final currentWeight = state.allLogs.lastOrNull?.weightKg ?? 0.0;
        final remaining = currentWeight > state.targetWeight
            ? currentWeight - state.targetWeight
            : 0.0;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Suivi du poids',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: cubit.showAddDialog,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 28),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats row 1: Current weight + Total lost.
                Row(
                  children: [
                    Expanded(
                      child: _GradientStatCard(
                        label: 'Poids actuel',
                        value: currentWeight,
                        suffix: ' kg',
                        decimals: 1,
                        gradientColors: const [
                          AppColors.gradientPurpleStart,
                          AppColors.gradientPurpleEnd,
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _GradientStatCard(
                        label: 'Total perdu',
                        value: state.totalLost,
                        suffix: ' kg',
                        decimals: 1,
                        gradientColors: const [
                          AppColors.gradientGreenStart,
                          AppColors.gradientGreenEnd,
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Stats row 2: Remaining + Avg per week.
                Row(
                  children: [
                    Expanded(
                      child: _GradientStatCard(
                        label: 'Restant',
                        value: remaining,
                        suffix: ' kg',
                        decimals: 1,
                        gradientColors: const [
                          AppColors.accentRose,
                          AppColors.accentRoseLight,
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _GradientStatCard(
                        label: 'Moyenne / sem',
                        value: state.avgLossPerWeek,
                        suffix: ' kg',
                        decimals: 2,
                        gradientColors: [
                          AppColors.accentAmber,
                          AppColors.accentAmber.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Projected goal date.
                if (state.projectedGoalDate != null)
                  _ProjectedGoalCard(
                    projectedDate: state.projectedGoalDate!,
                    initialDate: state.initialProjectedDate,
                  ),

                const SizedBox(height: 16),

                // Period filter.
                _PeriodFilterChips(
                  selectedPeriod: state.selectedPeriod,
                  onPeriodSelected: cubit.selectPeriod,
                ),

                const SizedBox(height: 16),

                // Chart.
                _ChartSection(
                  allLogs: state.allLogs,
                  selectedPeriod: state.selectedPeriod,
                  targetWeight: state.targetWeight,
                ),

                const SizedBox(height: 16),

                // History.
                const Text(
                  'Historique',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),

                _ExpandableHistoryList(
                  allLogs: state.allLogs,
                  onDelete: cubit.deleteLog,
                ),

                // Bottom padding for FAB.
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Gradient stat card ──────────────────────────────────────────────

class _GradientStatCard extends StatelessWidget {
  const _GradientStatCard({
    required this.label,
    required this.value,
    required this.suffix,
    required this.decimals,
    required this.gradientColors,
  });

  final String label;
  final double value;
  final String suffix;
  final int decimals;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  // Keep explicit white: these sit on gradient backgrounds.
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${value.toStringAsFixed(decimals)}$suffix',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  // Tabular figures prevent layout shifts on animated/live values.
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Projected goal card ─────────────────────────────────────────────

class _ProjectedGoalCard extends StatelessWidget {
  const _ProjectedGoalCard({
    required this.projectedDate,
    this.initialDate,
  });

  final DateTime projectedDate;
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.emeraldPrimary.withValues(alpha: 0.15),
            AppColors.emeraldLight.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Objectif atteint le',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppDateUtils.formatFrenchDate(projectedDate),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.emeraldPrimary,
                ),
              ),
              if (initialDate != null) ...[
                const SizedBox(height: 2),
                Text(
                  '(rythme initial : ${AppDateUtils.formatFrenchDate(initialDate!)})',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

// ── Period filter chips ─────────────────────────────────────────────

class _PeriodFilterChips extends StatelessWidget {
  const _PeriodFilterChips({
    required this.selectedPeriod,
    required this.onPeriodSelected,
  });

  final int selectedPeriod;
  final ValueChanged<int> onPeriodSelected;

  static const _periods = ['4 sem.', '3 mois', 'Tout'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_periods.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            selected: selectedPeriod == index,
            onSelected: (_) => onPeriodSelected(index),
            label: Text(_periods[index]),
          ),
        );
      }),
    );
  }
}

// ── Chart section ───────────────────────────────────────────────────

class _ChartSection extends StatelessWidget {
  const _ChartSection({
    required this.allLogs,
    required this.selectedPeriod,
    required this.targetWeight,
  });

  final List<WeightLog> allLogs;
  final int selectedPeriod;
  final double targetWeight;

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _filterLogsByPeriod(allLogs, selectedPeriod);

    if (filteredLogs.length >= 2) {
      return SolidCard(
        elevation: 2,
        contentPadding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 250,
          width: double.infinity,
          child: WeightLineChart(
            logs: filteredLogs,
            targetWeight: targetWeight,
          ),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: Center(
        child: Text(
          'Pas assez de donnees pour afficher le graphique',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ── History list ────────────────────────────────────────────────────

class _ExpandableHistoryList extends StatefulWidget {
  const _ExpandableHistoryList({
    required this.allLogs,
    required this.onDelete,
  });

  final List<WeightLog> allLogs;
  final ValueChanged<WeightLog> onDelete;

  @override
  State<_ExpandableHistoryList> createState() => _ExpandableHistoryListState();
}

class _ExpandableHistoryListState extends State<_ExpandableHistoryList> {
  static const _previewCount = 10;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final reversed = widget.allLogs.reversed.toList();
    final displayLogs =
        _expanded ? reversed : reversed.take(_previewCount).toList();
    final hasMore = reversed.length > _previewCount;

    return Column(
      children: [
        _HistoryList(logs: displayLogs, onDelete: widget.onDelete),
        if (hasMore && !_expanded)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () => setState(() => _expanded = true),
              child: Text(
                'Voir tout (${reversed.length} entrees)',
              ),
            ),
          ),
        if (_expanded && hasMore)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () => setState(() => _expanded = false),
              child: const Text('Reduire'),
            ),
          ),
      ],
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    required this.logs,
    required this.onDelete,
  });

  final List<WeightLog> logs;
  final ValueChanged<WeightLog> onDelete;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Aucune pesee enregistree',
            style: TextStyle(color: AppColors.gray400),
          ),
        ),
      );
    }

    return Column(
      children: logs.map((log) {
        final date = AppDateUtils.fromEpochMillis(log.date);
        return Dismissible(
          key: ValueKey(log.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) async {
            return showDialog<bool>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text(
                  'Supprimer cette pesee ?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: const Text('Supprimer'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) => onDelete(log),
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColors.accentRose,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SolidCard(
              cornerRadius: 16,
              elevation: 1,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppDateUtils.formatFrenchDate(date),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${log.weightKg.toStringAsFixed(1)} kg',
                    style: const TextStyle(
                      color: AppColors.accentPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Add weight dialog shell ─────────────────────────────────────────

class _AddWeightDialogShell extends StatelessWidget {
  const _AddWeightDialogShell();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeightLogCubit, WeightLogState>(
      listenWhen: (prev, curr) => prev.showAddDialog && !curr.showAddDialog,
      listener: (context, state) {
        // Only pop if this dialog route is still on top
        final route = ModalRoute.of(context);
        if (route != null && route.isCurrent) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<WeightLogCubit>();
        final isValid = double.tryParse(state.weightInput) != null;
        return AlertDialog(
          title: const Text(
            'Ajouter une pesee',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date picker row.
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
                    AppDateUtils.formatFrenchDate(state.selectedDate ?? DateTime.now()),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Weight input.
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
            ],
          ),
          actions: [
            TextButton(onPressed: cubit.hideAddDialog, child: const Text('Annuler')),
            TextButton(
              onPressed: isValid ? cubit.addWeightLog : null,
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }
}

// ── Duplicate dialog shell ──────────────────────────────────────────

class _DuplicateDialogShell extends StatelessWidget {
  const _DuplicateDialogShell();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeightLogCubit, WeightLogState>(
      listenWhen: (prev, curr) =>
          prev.showDuplicateDialog && !curr.showDuplicateDialog,
      listener: (context, state) {
        final route = ModalRoute.of(context);
        if (route != null && route.isCurrent) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<WeightLogCubit>();
        return AlertDialog(
          title: const Text(
            'Doublon detecte',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Une entree existe deja pour aujourd'hui. "
            'Voulez-vous la remplacer ?',
          ),
          actions: [
            TextButton(
              onPressed: cubit.dismissDuplicateDialog,
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: cubit.confirmReplaceDuplicate,
              child: const Text('Remplacer'),
            ),
          ],
        );
      },
    );
  }
}

// ── Helpers ─────────────────────────────────────────────────────────

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
