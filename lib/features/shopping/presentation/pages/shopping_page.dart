import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/local/database.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glass_dialog.dart';
import '../../../onboarding/domain/models/supermarket_section.dart';
import '../cubit/shopping_cubit.dart';
import '../cubit/shopping_state.dart';
import '../widgets/add_item_dialog.dart';
import '../widgets/item_detail_dialog.dart';
import '../widgets/section_header.dart';
import '../widgets/shopping_item_row.dart';

const Duration _kCelebrationDuration = Duration(seconds: 3);

enum _SortMode { category, recipe }

/// Flattened entry used by the virtualized [SliverList.builder] — either a
/// section header or a shopping item row.
sealed class _ListEntry {
  const _ListEntry();
}

class _HeaderEntry extends _ListEntry {
  const _HeaderEntry({
    required this.sectionKey,
    required this.title,
    required this.itemCount,
    required this.checkedCount,
    required this.isCollapsed,
  });

  final String sectionKey;
  final String title;
  final int itemCount;
  final int checkedCount;
  final bool isCollapsed;
}

class _ItemEntry extends _ListEntry {
  const _ItemEntry(this.item);
  final ShoppingItem item;
}

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppingCubit, ShoppingState>(
      listenWhen: (prev, curr) =>
          prev.selectedItemSources == null && curr.selectedItemSources != null,
      listener: (context, state) {
        if (state.selectedItemSources != null) {
          _showItemDetailDialog(context, state);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            // BlobBG retiré ici : même paused + RepaintBoundary, le
            // composite des 3 blobs floutés plein écran sature le
            // raster thread sur cette page (liste virtuelle longue +
            // GlassCards translucides). On garde un gradient statique
            // équivalent au fond du BlobBG, sans coût GPU continu.
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-0.8, -1.0),
                    radius: 1.4,
                    colors: [
                      Color(0xFFECFDF5),
                      Color(0xFFF0FDF4),
                      Color(0xFFF0FDFA),
                    ],
                    stops: [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
            if (state.isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: AppColors.emeraldPrimary,
                ),
              )
            else
              _ShoppingContent(state: state),
          ],
        );
      },
    );
  }

  void _showItemDetailDialog(BuildContext context, ShoppingState state) {
    final cubit = context.read<ShoppingCubit>();
    showGlassDialog<void>(
      context: context,
      useRootNavigator: true,
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
      if (cubit.state.selectedItemSources != null) cubit.hideItemDetail();
    });
  }
}

class _ShoppingContent extends StatefulWidget {
  const _ShoppingContent({required this.state});

  final ShoppingState state;

  @override
  State<_ShoppingContent> createState() => _ShoppingContentState();
}

class _ShoppingContentState extends State<_ShoppingContent> {
  bool _showCelebration = false;
  bool _hideChecked = false;
  _SortMode _sortMode = _SortMode.category;
  Timer? _celebrationTimer;

  /// IDs of items checked during this session, most-recent first. Used to
  /// promote just-checked items to the **top** of their section's checked
  /// block so the flight animation lands them right below the last
  /// unchecked row instead of at the very bottom of the section.
  final List<int> _recentlyCheckedIds = [];

  @override
  void dispose() {
    _celebrationTimer?.cancel();
    super.dispose();
  }

  /// Called from the row when it dispatches a toggle. Tracks the most
  /// recently checked IDs so [_appendGroupEntries] can order them at the
  /// top of the checked block.
  void _handleItemToggle(ShoppingCubit cubit, ShoppingItem item) {
    if (!item.isChecked) {
      // About to become checked → remember as most recent.
      _recentlyCheckedIds.remove(item.id);
      _recentlyCheckedIds.insert(0, item.id);
    } else {
      // About to be unchecked → drop from the recent list.
      _recentlyCheckedIds.remove(item.id);
    }
    cubit.toggleItemChecked(item.id, item.isChecked);
  }

  /// Confirme avec l'utilisateur avant de tout décocher : action
  /// destructive sans undo, on évite les regrets après un mauvais clic.
  Future<void> _confirmReset(
    BuildContext context,
    ShoppingCubit cubit,
  ) async {
    final confirmed = await showGlassDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) => GlassDialogContent(
        icon: LucideIcons.rotateCcw,
        iconColor: AppColors.accentRose,
        title: 'Tout decocher ?',
        subtitle:
            'Cette action remettra a zero la progression de la liste de courses.',
        child: GlassDialogActions(
          secondary: GlassDialogButton(
            label: 'Annuler',
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          primary: GlassDialogDangerButton(
            label: 'Tout decocher',
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ),
      ),
    );
    if (confirmed == true) cubit.resetChecks();
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
    final cubit = context.read<ShoppingCubit>();
    final topPadding = MediaQuery.of(context).padding.top;

    final totalItems = state.items.length;
    final checkedItems = state.items.where((i) => i.isChecked).length;
    final progressFraction =
        totalItems > 0 ? checkedItems / totalItems : 0.0;
    final progressPercent = (progressFraction * 100).round();

    return BlocListener<ShoppingCubit, ShoppingState>(
      listenWhen: (prev, curr) {
        final prevTotal = prev.items.length;
        final currTotal = curr.items.length;
        if (currTotal == 0) return false;
        final prevPercent = prevTotal > 0
            ? (prev.items.where((i) => i.isChecked).length /
                        prevTotal *
                        100)
                    .round()
            : 0;
        final currPercent =
            (curr.items.where((i) => i.isChecked).length / currTotal * 100)
                .round();
        return prevPercent < 100 && currPercent == 100;
      },
      listener: (context, state) => _triggerCelebration(),
      child: Stack(
        children: [
          // CustomScrollView + SliverList.builder virtualizes the (often
          // long) list of shopping items — only visible rows are built per
          // frame, massively cheaper than materialising everything.
          CustomScrollView(
            // Heavy rows (glass cards + shadows + gradient avatars) make
            // the default 250 px cache extent expensive. 180 px still
            // prevents blank flashes on fast flings without building too
            // many off-screen rows.
            cacheExtent: 180,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20, topPadding + 14, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    _Header(
                      hideChecked: _hideChecked,
                      onToggleHide: () =>
                          setState(() => _hideChecked = !_hideChecked),
                      onReset: () => _confirmReset(context, cubit),
                    ),
                    const SizedBox(height: 16),
                    if (state.totalTrips > 1) ...[
                      _TripPills(
                        totalTrips: state.totalTrips,
                        selectedTrip: state.selectedTrip,
                        summaries: state.tripDaySummaries,
                        onSelect: cubit.selectTrip,
                      ),
                      const SizedBox(height: 14),
                    ],
                    _ProgressionCard(
                      done: checkedItems,
                      total: totalItems,
                      percent: progressPercent,
                      fraction: progressFraction,
                      estimatedWeight: state.estimatedWeight,
                    ),
                    if (state.items.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _SortSelector(
                        mode: _sortMode,
                        onChanged: (m) => setState(() => _sortMode = m),
                      ),
                    ],
                    const SizedBox(height: 14),
                  ]),
                ),
              ),
              if (state.items.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 180),
                  sliver: SliverToBoxAdapter(child: _EmptyState()),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 180),
                  sliver: _EntriesSliver(
                    entries: _buildEntries(state),
                    onToggleSection: cubit.toggleSection,
                    onToggleItem: (item) => _handleItemToggle(cubit, item),
                    onDeleteItem: (item) => cubit.deleteItem(item.id),
                    onShowDetail: cubit.showItemDetail,
                  ),
                ),
            ],
          ),
          Positioned(
            right: 20,
            bottom: 110,
            child: _AddFab(
              onTap: () => _showAddDialog(context, cubit),
            ),
          ),
          _CelebrationBanner(visible: _showCelebration),
        ],
      ),
    );
  }

  /// Flattens the grouped shopping items into a single indexable list of
  /// [_ListEntry]s — one header per section followed by its visible items.
  /// This is what powers the virtualized [SliverList.builder]: each entry
  /// maps to exactly one row widget, so only on-screen rows are built.
  List<_ListEntry> _buildEntries(ShoppingState state) {
    if (state.items.isEmpty) return const [];
    return _sortMode == _SortMode.category
        ? _buildCategoryEntries(state)
        : _buildRecipeEntries(state);
  }

  List<_ListEntry> _buildCategoryEntries(ShoppingState state) {
    final grouped = <String, List<ShoppingItem>>{};
    for (final item in state.items) {
      grouped.putIfAbsent(item.supermarketSection, () => []).add(item);
    }
    final entries = <_ListEntry>[];
    for (final section in SupermarketSection.values) {
      final sectionItems = grouped[section.name];
      if (sectionItems == null || sectionItems.isEmpty) continue;
      _appendGroupEntries(
        entries: entries,
        key: 'cat_${section.name}',
        title: section.displayName,
        items: sectionItems,
        collapsedSections: state.collapsedSections,
      );
    }
    return entries;
  }

  List<_ListEntry> _buildRecipeEntries(ShoppingState state) {
    // Un item est "commun" si ses sourceDetails referencent ≥2 recettes
    // distinctes. Il est promu dans la section "Ingredients communs" en
    // tete, et n'apparait pas sous chaque recette individuelle (un seul
    // checkbox = une seule entree visuelle).
    final shared = <ShoppingItem>[];
    final grouped = <String, List<ShoppingItem>>{};
    for (final item in state.items) {
      final names = _recipeNames(item);
      if (names.length >= 2) {
        shared.add(item);
      } else {
        final key = names.isEmpty ? 'Autres' : names.first;
        grouped.putIfAbsent(key, () => []).add(item);
      }
    }
    final entries = <_ListEntry>[];
    if (shared.isNotEmpty) {
      _appendGroupEntries(
        entries: entries,
        key: 'rec__shared',
        title: 'Ingredients communs',
        items: shared,
        collapsedSections: state.collapsedSections,
      );
    }
    for (final e in grouped.entries) {
      if (e.key == 'Autres') continue;
      _appendGroupEntries(
        entries: entries,
        key: 'rec_${e.key}',
        title: e.key,
        items: e.value,
        collapsedSections: state.collapsedSections,
      );
    }
    final others = grouped['Autres'];
    if (others != null && others.isNotEmpty) {
      _appendGroupEntries(
        entries: entries,
        key: 'rec_Autres',
        title: 'Autres',
        items: others,
        collapsedSections: state.collapsedSections,
      );
    }
    return entries;
  }

  /// Retourne l'ensemble des noms de recettes referencees par les
  /// sourceDetails d'un item. Vide pour un item manuel ou sans sources.
  Set<String> _recipeNames(ShoppingItem item) {
    final raw = item.sourceDetails;
    if (raw.isEmpty) return const {};
    try {
      final decoded = json.decode(raw);
      if (decoded is! List) return const {};
      final names = <String>{};
      for (final entry in decoded) {
        if (entry is Map) {
          final name = entry['recipeName'];
          if (name is String && name.isNotEmpty) names.add(name);
        }
      }
      return names;
    } catch (_) {
      return const {};
    }
  }

  void _appendGroupEntries({
    required List<_ListEntry> entries,
    required String key,
    required String title,
    required List<ShoppingItem> items,
    required Set<String> collapsedSections,
  }) {
    final unchecked = items.where((i) => !i.isChecked).toList();
    final checked = items.where((i) => i.isChecked).toList();
    // Promote just-checked items to the top of the checked block so the
    // flight animation lands them right below the last unchecked row,
    // instead of at the very bottom of the section.
    checked.sort((a, b) {
      final ai = _recentlyCheckedIds.indexOf(a.id);
      final bi = _recentlyCheckedIds.indexOf(b.id);
      if (ai == -1 && bi == -1) return 0;
      if (ai == -1) return 1;
      if (bi == -1) return -1;
      return ai.compareTo(bi);
    });
    final ordered = _hideChecked ? unchecked : [...unchecked, ...checked];
    if (ordered.isEmpty && _hideChecked) return;

    final isCollapsed = collapsedSections.contains(key);
    entries.add(_HeaderEntry(
      sectionKey: key,
      title: title,
      itemCount: items.length,
      checkedCount: checked.length,
      isCollapsed: isCollapsed,
    ));
    if (!isCollapsed) {
      for (final item in ordered) {
        entries.add(_ItemEntry(item));
      }
    }
  }

  void _showAddDialog(BuildContext context, ShoppingCubit cubit) {
    showGlassDialog<void>(
      context: context,
      useRootNavigator: true,
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

/// Virtualized sliver that renders [_ListEntry]s via a keyed
/// [SliverChildBuilderDelegate]. Only visible rows (headers or item tiles)
/// are built per frame.
///
/// [findChildIndexCallback] is **critical**: without it, Flutter cannot
/// match a [ValueKey] across reorders and will destroy/recreate the
/// [State] at the new index. That breaks our check-flight animation (the
/// optimistic `_pendingChecked` + `_oldGlobalAtDispatch` live on State).
/// With it, moving an item just shifts its Element to the new slot, State
/// preserved, `didUpdateWidget` fires, flight launches.
class _EntriesSliver extends StatelessWidget {
  const _EntriesSliver({
    required this.entries,
    required this.onToggleSection,
    required this.onToggleItem,
    required this.onDeleteItem,
    required this.onShowDetail,
  });

  final List<_ListEntry> entries;
  final ValueChanged<String> onToggleSection;
  final ValueChanged<ShoppingItem> onToggleItem;
  final ValueChanged<ShoppingItem> onDeleteItem;
  final ValueChanged<ShoppingItem> onShowDetail;

  static String _entryKey(_ListEntry e) => switch (e) {
        _HeaderEntry() => 'h_${e.sectionKey}',
        _ItemEntry() => 'i_${e.item.id}',
      };

  @override
  Widget build(BuildContext context) {
    // Build an index map once per rebuild so findChildIndexCallback is
    // O(1) per lookup instead of O(n). On reorder (check-toggle), Flutter
    // calls it once per keyed child — previously O(n²) for the whole
    // list, now O(n).
    final indexByKey = <String, int>{};
    for (var i = 0; i < entries.length; i++) {
      indexByKey[_entryKey(entries[i])] = i;
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          final entry = entries[i];
          switch (entry) {
            case _HeaderEntry():
              return Padding(
                key: ValueKey(_entryKey(entry)),
                padding: const EdgeInsets.only(top: 6, bottom: 2),
                child: SectionHeader(
                  title: entry.title,
                  itemCount: entry.itemCount,
                  checkedCount: entry.checkedCount,
                  isCollapsed: entry.isCollapsed,
                  onToggle: () => onToggleSection(entry.sectionKey),
                ),
              );
            case _ItemEntry():
              final item = entry.item;
              return ShoppingItemRow(
                key: ValueKey(_entryKey(entry)),
                item: item,
                onToggle: () => onToggleItem(item),
                onDelete: () => onDeleteItem(item),
                onShowDetail: () => onShowDetail(item),
              );
          }
        },
        childCount: entries.length,
        findChildIndexCallback: (Key key) {
          if (key is! ValueKey<String>) return null;
          return indexByKey[key.value];
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.hideChecked,
    required this.onToggleHide,
    required this.onReset,
  });

  final bool hideChecked;
  final VoidCallback onToggleHide;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final gradient = ExtendedColorsProvider.of(context).primaryGradient;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CETTE SEMAINE',
                style: AppText.eyebrow12,
              ),
              const SizedBox(height: 2),
              ShaderMask(
                shaderCallback: (rect) => gradient.createShader(rect),
                blendMode: BlendMode.srcIn,
                child: Text(
                  'Liste de courses',
                  style: AppText.h1.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        _CircleButton(
          icon: hideChecked ? LucideIcons.eyeOff : LucideIcons.eye,
          tooltip: hideChecked
              ? 'Afficher les articles coches'
              : 'Cacher les articles coches',
          active: hideChecked,
          onTap: onToggleHide,
        ),
        const SizedBox(width: 8),
        _CircleButton(
          icon: LucideIcons.rotateCcw,
          tooltip: 'Tout decocher',
          onTap: onReset,
        ),
      ],
    );
  }
}

/// "Trier par :" row with two pill buttons (category / recipe).
class _SortSelector extends StatelessWidget {
  const _SortSelector({required this.mode, required this.onChanged});

  final _SortMode mode;
  final ValueChanged<_SortMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Trier par :',
          style: AppText.eyebrow12.copyWith(letterSpacing: 0),
        ),
        const SizedBox(width: 10),
        _SortPill(
          label: 'Categorie',
          icon: LucideIcons.layoutGrid,
          active: mode == _SortMode.category,
          onTap: () => onChanged(_SortMode.category),
        ),
        const SizedBox(width: 8),
        _SortPill(
          label: 'Plat',
          icon: LucideIcons.utensils,
          active: mode == _SortMode.recipe,
          onTap: () => onChanged(_SortMode.recipe),
        ),
      ],
    );
  }
}

class _SortPill extends StatelessWidget {
  const _SortPill({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final gradient = ExtendedColorsProvider.of(context).primaryGradient;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            gradient: active ? gradient : null,
            color: active ? null : Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(999),
            border: active
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.emeraldPrimary.withValues(alpha: 0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 13,
                color: active ? Colors.white : const Color(0xFF475569),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppText.caption12Black.copyWith(
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

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final bg = active
        ? const Color(0xFF10B981).withValues(alpha: 0.16)
        : Colors.white.withValues(alpha: 0.65);
    final iconColor =
        active ? const Color(0xFF059669) : const Color(0xFF475569);
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Ink(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
        ),
      ),
    );
  }
}

class _TripPills extends StatelessWidget {
  const _TripPills({
    required this.totalTrips,
    required this.selectedTrip,
    required this.summaries,
    required this.onSelect,
  });

  final int totalTrips;
  final int selectedTrip;
  final Map<int, String> summaries;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final gradient = ExtendedColorsProvider.of(context).primaryGradient;
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: totalTrips,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final trip = i + 1;
          final selected = trip == selectedTrip;
          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              onTap: () => onSelect(trip),
              borderRadius: BorderRadius.circular(999),
              child: Ink(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: selected ? gradient : null,
                  color: selected
                      ? null
                      : Colors.white.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(999),
                  border: selected
                      ? null
                      : Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF10B981)
                                .withValues(alpha: 0.28),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Course $trip',
                  style: AppText.caption12Black.copyWith(
                    color: selected ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProgressionCard extends StatelessWidget {
  const _ProgressionCard({
    required this.done,
    required this.total,
    required this.percent,
    required this.fraction,
    required this.estimatedWeight,
  });

  final int done;
  final int total;
  final int percent;
  final double fraction;
  final double estimatedWeight;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROGRESSION',
                  style: AppText.eyebrow12,
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$done',
                      style: AppText.h1.copyWith(
                        letterSpacing: -0.6,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '/ $total articles',
                      style: AppText.body13Bold,
                    ),
                  ],
                ),
                if (estimatedWeight > 0) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Poids estime : ${estimatedWeight.toStringAsFixed(1)} kg',
                    style: AppText.meta11.copyWith(
                      color: const Color(0xFF059669),
                    ),
                  ),
                ],
              ],
            ),
          ),
          _ProgressRing(fraction: fraction, percent: percent),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.fraction, required this.percent});

  final double fraction;
  final int percent;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: fraction, end: fraction),
      duration: reducedMotion
          ? Duration.zero
          : const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return SizedBox(
          width: 52,
          height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size.square(52),
                painter: _RingPainter(fraction: value),
              ),
              Text(
                '$percent%',
                style: AppText.caption12Black.copyWith(
                  color: const Color(0xFF059669),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.fraction});

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final bgPaint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: 0.08);
    canvas.drawCircle(center, radius, bgPaint);

    if (fraction > 0) {
      final fgPaint = Paint()..color = const Color(0xFF10B981);
      final rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawArc(
        rect,
        -math.pi / 2,
        fraction.clamp(0.0, 1.0) * 2 * math.pi,
        true,
        fgPaint,
      );
    }

    final holePaint = Paint()..color = Colors.white.withValues(alpha: 0.98);
    canvas.drawCircle(center, radius - 6, holePaint);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.fraction != fraction;
}

class _AddFab extends StatelessWidget {
  const _AddFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final gradient = ExtendedColorsProvider.of(context).primaryGradient;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.45),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            LucideIcons.plus,
            size: 26,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          LucideIcons.shoppingCart,
          size: 48,
          color: const Color(0xFF64748B).withValues(alpha: 0.5),
        ),
        const SizedBox(height: 12),
        Text(
          'Aucun article dans votre liste',
          textAlign: TextAlign.center,
          style: AppText.body14Bold.copyWith(
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Generez un plan repas pour remplir votre liste',
          textAlign: TextAlign.center,
          style: AppText.empty12,
        ),
      ],
    );
  }
}

class _CelebrationBanner extends StatelessWidget {
  const _CelebrationBanner({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: topPadding + 16),
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
                      LucideIcons.partyPopper,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Toutes les courses sont faites !',
                      style: AppText.body14Black.copyWith(color: Colors.white),
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
