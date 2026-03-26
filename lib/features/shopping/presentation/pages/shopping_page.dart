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

class _ShoppingContent extends StatelessWidget {
  const _ShoppingContent({required this.state});

  final ShoppingState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<ShoppingCubit>();

    final totalItems = state.items.length;
    final checkedItems = state.items.where((i) => i.isChecked).length;
    final progressFraction =
        totalItems > 0 ? checkedItems / totalItems : 0.0;
    final progressPercent = (progressFraction * 100).round();

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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: progressFraction,
                      minHeight: 10,
                      backgroundColor: AppColors.gray400
                          .withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.emeraldPrimary,
                      ),
                    ),
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

class _TripTabs extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: totalTrips,
      initialIndex: (selectedTrip - 1).clamp(0, totalTrips - 1),
      child: TabBar(
        isScrollable: true,
        onTap: (index) => onSelectTrip(index + 1),
        tabs: List.generate(totalTrips, (i) {
          final trip = i + 1;
          final isSelected = trip == selectedTrip;
          final summary = tripDaySummaries[trip];

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
      ),
    );
  }
}

class _GroupedItemsList extends StatelessWidget {
  const _GroupedItemsList({required this.state});

  final ShoppingState state;

  @override
  Widget build(BuildContext context) {
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
