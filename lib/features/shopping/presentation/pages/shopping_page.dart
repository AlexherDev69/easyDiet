import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/solid_card.dart';
import '../../../onboarding/domain/models/supermarket_section.dart';
import '../cubit/shopping_cubit.dart';
import '../cubit/shopping_state.dart';
import '../widgets/add_item_dialog.dart';
import '../widgets/item_detail_dialog.dart';
import '../widgets/section_header.dart';
import '../widgets/shopping_item_row.dart';

/// Shopping list screen — port of ShoppingListScreen.kt.
class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppingCubit, ShoppingState>(
      listenWhen: (prev, curr) {
        if (prev.selectedItemSources == null &&
            curr.selectedItemSources != null) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state.selectedItemSources != null) {
          _showItemDetailDialog(context, state);
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.emeraldPrimary,
            ),
          );
        }

        return _ShoppingContent(state: state);
      },
    );
  }

  void _showItemDetailDialog(BuildContext context, ShoppingState state) {
    final cubit = context.read<ShoppingCubit>();
    showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => ItemDetailDialog(
        itemName: state.selectedItemName ?? '',
        totalQuantity: state.selectedItemQuantity ?? '',
        sources: state.selectedItemSources ?? [],
        onDismiss: () {
          Navigator.pop(dialogContext);
          cubit.hideItemDetail();
        },
      ),
    ).then((_) {
      if (cubit.state.selectedItemSources != null) {
        cubit.hideItemDetail();
      }
    });
  }
}

// How long the celebration banner stays visible.
const Duration _kCelebrationDuration = Duration(seconds: 3);

class _ShoppingContent extends StatefulWidget {
  const _ShoppingContent({required this.state});

  final ShoppingState state;

  @override
  State<_ShoppingContent> createState() => _ShoppingContentState();
}

class _ShoppingContentState extends State<_ShoppingContent> {
  bool _showCelebration = false;
  Timer? _celebrationTimer;

  @override
  void dispose() {
    _celebrationTimer?.cancel();
    super.dispose();
  }

  void _triggerCelebration() {
    if (!mounted) return;
    setState(() => _showCelebration = true);
    _celebrationTimer?.cancel();
    _celebrationTimer = Timer(_kCelebrationDuration, () {
      if (mounted) setState(() => _showCelebration = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final theme = Theme.of(context);
    final cubit = context.read<ShoppingCubit>();

    final totalItems = state.items.length;
    final checkedItems = state.items.where((i) => i.isChecked).length;
    final progressFraction =
        totalItems > 0 ? checkedItems / totalItems : 0.0;
    final progressPercent = (progressFraction * 100).round();

    return BlocListener<ShoppingCubit, ShoppingState>(
      // Fire only when the trip goes to 100% for the first time per transition.
      listenWhen: (prev, curr) {
        final prevTotal = prev.items.length;
        final currTotal = curr.items.length;
        if (currTotal == 0) return false;
        final prevPercent =
            prevTotal > 0 ? (prev.items.where((i) => i.isChecked).length / prevTotal * 100).round() : 0;
        final currPercent =
            (curr.items.where((i) => i.isChecked).length / currTotal * 100).round();
        // Trigger only on the edge from <100 to 100.
        return prevPercent < 100 && currPercent == 100;
      },
      listener: (context, state) => _triggerCelebration(),
      child: Stack(
        children: [
          _ShoppingScaffold(
            state: state,
            theme: theme,
            cubit: cubit,
            progressFraction: progressFraction,
            progressPercent: progressPercent,
          ),
          // Celebration overlay — shown briefly when all trip items are checked.
          _CelebrationBanner(visible: _showCelebration),
        ],
      ),
    );
  }
}

/// Pure display scaffold, extracted to keep build() readable.
class _ShoppingScaffold extends StatelessWidget {
  const _ShoppingScaffold({
    required this.state,
    required this.theme,
    required this.cubit,
    required this.progressFraction,
    required this.progressPercent,
  });

  final ShoppingState state;
  final ThemeData theme;
  final ShoppingCubit cubit;
  final double progressFraction;
  final int progressPercent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste de courses',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: cubit.resetChecks,
            icon: const Icon(Icons.replay),
            tooltip: 'Tout decocher',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, cubit),
        backgroundColor: AppColors.emeraldPrimary,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Trip tabs
          if (state.totalTrips > 1)
            _TripTabs(
              totalTrips: state.totalTrips,
              selectedTrip: state.selectedTrip,
              tripDaySummaries: state.tripDaySummaries,
              onSelectTrip: cubit.selectTrip,
            ),

          // Progress card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SolidCard(
              backgroundColor: AppColors.emeraldSurface,
              elevation: 4,
              contentPadding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progression',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.emeraldPrimary,
                        ),
                      ),
                      Text(
                        '$progressPercent%',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.emeraldPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _AnimatedProgressBar(
                    progress: progressFraction,
                  ),
                  if (state.estimatedWeight > 0) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Poids estime : ${state.estimatedWeight.toStringAsFixed(1)} kg',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.emeraldPrimary
                              .withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Grouped items
          Expanded(
            child: _GroupedItemsList(state: state),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, ShoppingCubit cubit) {
    showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AddItemDialog(
        onAdd: (name, qty, unit, section) {
          Navigator.pop(dialogContext);
          cubit.addItem(name, qty, unit, section);
        },
        onDismiss: () => Navigator.pop(dialogContext),
      ),
    );
  }
}

class _TripTabs extends StatefulWidget {
  const _TripTabs({
    required this.totalTrips,
    required this.selectedTrip,
    required this.tripDaySummaries,
    required this.onSelectTrip,
  });

  final int totalTrips;
  final int selectedTrip;
  final Map<int, String> tripDaySummaries;
  final ValueChanged<int> onSelectTrip;

  @override
  State<_TripTabs> createState() => _TripTabsState();
}

class _TripTabsState extends State<_TripTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.totalTrips,
      initialIndex: (widget.selectedTrip - 1).clamp(0, widget.totalTrips - 1),
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
  }

  @override
  void didUpdateWidget(_TripTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.totalTrips != oldWidget.totalTrips) {
      _tabController.removeListener(_onTabChanged);
      _tabController.dispose();
      _tabController = TabController(
        length: widget.totalTrips,
        initialIndex:
            (widget.selectedTrip - 1).clamp(0, widget.totalTrips - 1),
        vsync: this,
      );
      _tabController.addListener(_onTabChanged);
    } else if (widget.selectedTrip != oldWidget.selectedTrip) {
      final target = (widget.selectedTrip - 1).clamp(0, widget.totalTrips - 1);
      if (_tabController.index != target) {
        _tabController.animateTo(target);
      }
    }
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      widget.onSelectTrip(_tabController.index + 1);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: List.generate(widget.totalTrips, (i) {
        final trip = i + 1;
        final isSelected = trip == widget.selectedTrip;
        final summary = widget.tripDaySummaries[trip];

        return Tab(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 16,
                    color: isSelected
                        ? AppColors.emeraldPrimary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Course $trip',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.emeraldPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (summary != null && summary.isNotEmpty)
                Text(
                  summary,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: (isSelected
                            ? AppColors.emeraldPrimary
                            : theme.colorScheme.onSurfaceVariant)
                        .withValues(alpha: 0.7),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _GroupedItemsList extends StatelessWidget {
  const _GroupedItemsList({required this.state});

  final ShoppingState state;

  @override
  Widget build(BuildContext context) {
    if (state.items.isEmpty) {
      final theme = Theme.of(context);
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'Aucun article dans votre liste',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Generez un plan repas pour remplir votre liste',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final cubit = context.read<ShoppingCubit>();
    final grouped = <String, List<dynamic>>{};
    for (final item in state.items) {
      grouped.putIfAbsent(item.supermarketSection, () => []).add(item);
    }

    // Order by enum
    final sectionOrder = SupermarketSection.values.map((s) => s.name).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        for (final sectionName in sectionOrder)
          if (grouped.containsKey(sectionName)) ...[
            Builder(builder: (context) {
              final sectionItems = grouped[sectionName]!;
              final unchecked =
                  sectionItems.where((i) => !i.isChecked).toList();
              final checked = sectionItems.where((i) => i.isChecked).toList();
              final allItems = [...unchecked, ...checked];
              final isCollapsed =
                  state.collapsedSections.contains(sectionName);

              final displayName = _sectionDisplayName(sectionName);

              return Column(
                children: [
                  SectionHeader(
                    title: displayName,
                    itemCount: sectionItems.length,
                    checkedCount: checked.length,
                    isCollapsed: isCollapsed,
                    onToggle: () => cubit.toggleSection(sectionName),
                  ),
                  if (!isCollapsed)
                    ...allItems.map((item) => ShoppingItemRow(
                          item: item,
                          onToggle: () => cubit.toggleItemChecked(
                            item.id,
                            item.isChecked,
                          ),
                          onDelete: () => cubit.deleteItem(item.id),
                          onShowDetail: () => cubit.showItemDetail(item),
                        )),
                ],
              );
            }),
          ],
      ],
    );
  }

  String _sectionDisplayName(String sectionName) {
    try {
      return SupermarketSection.values
          .firstWhere((s) => s.name == sectionName)
          .displayName;
    } catch (_) {
      return sectionName;
    }
  }
}

/// Custom animated progress bar with quarter marks and glow at 100%.
class _AnimatedProgressBar extends StatelessWidget {
  const _AnimatedProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return CustomPaint(
          size: const Size(double.infinity, 12),
          painter: _ProgressBarPainter(progress: value),
        );
      },
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  const _ProgressBarPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.height / 2;
    final bgRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    // Background track
    canvas.drawRRect(
      bgRect,
      Paint()..color = AppColors.gray400.withValues(alpha: 0.15),
    );

    // Filled portion
    if (progress > 0) {
      final fillWidth = size.width * progress.clamp(0.0, 1.0);
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, fillWidth, size.height),
        Radius.circular(radius),
      );

      // Glow when complete
      if (progress >= 1.0) {
        canvas.drawRRect(
          fillRect.inflate(2),
          Paint()
            ..color = AppColors.emeraldPrimary.withValues(alpha: 0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
      }

      // Gradient fill: emerald -> warmer gold as it progresses
      final fillPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            AppColors.emeraldPrimary,
            progress >= 0.8
                ? AppColors.accentAmber
                : AppColors.emeraldLight,
          ],
        ).createShader(Offset.zero & size);
      canvas.drawRRect(fillRect, fillPaint);
    }

    // Quarter marks (25%, 50%, 75%)
    final markPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 1;
    for (final fraction in [0.25, 0.5, 0.75]) {
      final x = size.width * fraction;
      canvas.drawLine(
        Offset(x, 2),
        Offset(x, size.height - 2),
        markPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressBarPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Celebration banner that slides in from the top and fades out.
/// Shown briefly when all items in the current trip are checked.
class _CelebrationBanner extends StatelessWidget {
  const _CelebrationBanner({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      // Ignore pointer events when invisible so taps fall through.
      child: IgnorePointer(
        ignoring: !visible,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(24),
              color: AppColors.emeraldPrimary,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.celebration,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Toutes les courses sont faites !',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
