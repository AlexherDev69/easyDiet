import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/local/models/recipe_with_details.dart';
import '../../../../navigation/app_router.dart';
import '../../../../shared/widgets/blob_bg.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/recipe_thumb.dart';
import '../cubit/recipe_list_cubit.dart';
import '../cubit/recipe_list_state.dart';

/// Recipe list screen — handoff design (header gradient, pills, glass cards).
class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListCubit, RecipeListState>(
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
          ],
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.state});

  final RecipeListState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecipeListCubit>();
    final topPadding = MediaQuery.of(context).padding.top;
    final recipes = _flattened(state);

    // CustomScrollView + SliverList.builder virtualizes the (up-to-96) cards
    // so only the visible ones are built/painted — massive scroll win vs a
    // plain ListView(children: [...]) which materialises every card upfront.
    //
    // L'`AnimatedSwitcher` est placé UNIQUEMENT autour de la zone liste :
    // le header (titre + tabs + catégories) reste statique pour ne pas
    // clignoter quand l'utilisateur clique. La clé combine tab+catégorie
    // pour qu'un changement déclenche le cross-fade + slide latéral.
    final filterKey = ValueKey(
      '${state.selectedTab}|${state.selectedCategory ?? 'all'}',
    );

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, topPadding + 14, 20, 12),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              const _Header(),
              const SizedBox(height: 12),
              _Tabs(selected: state.selectedTab, onSelect: cubit.selectTab),
              const SizedBox(height: 10),
              _CategoryPills(
                selected: state.selectedCategory,
                onSelect: cubit.selectCategory,
              ),
              const SizedBox(height: 12),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
          sliver: SliverToBoxAdapter(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.04, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: KeyedSubtree(
                key: filterKey,
                child: recipes.isEmpty
                    ? _EmptyState(state: state)
                    : Column(
                        children: [
                          for (var i = 0; i < recipes.length; i++)
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: i == recipes.length - 1 ? 0 : 10,
                              ),
                              child: _RecipeCard(
                                key: ValueKey(recipes[i].recipe.id),
                                recipe: recipes[i],
                                onTap: () => context.push(
                                  AppRoutes.recipeDetail(
                                    recipes[i].recipe.id,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<RecipeWithDetails> _flattened(RecipeListState s) =>
      s.filteredGroupedRecipes.expand((g) => g.$2).toList();
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
          'BIBLIOTHEQUE',
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
            'Recettes',
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

class _Tabs extends StatelessWidget {
  const _Tabs({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabPill(
          label: 'Cette semaine',
          active: selected == 0,
          onTap: () => onSelect(0),
        ),
        const SizedBox(width: 8),
        _TabPill(
          label: 'Toutes les recettes',
          active: selected == 1,
          onTap: () => onSelect(1),
        ),
      ],
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
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
        child: Ink(
          decoration: BoxDecoration(
            gradient: active ? gradient : null,
            color: active ? null : Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(999),
            border: active
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.emeraldPrimary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: active ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryPills extends StatelessWidget {
  const _CategoryPills({required this.selected, required this.onSelect});

  final String? selected;
  final ValueChanged<String?> onSelect;

  static const _items = <(String?, String)>[
    (null, 'Toutes'),
    ('BREAKFAST', 'Petit-dej'),
    ('LUNCH', 'Dejeuner'),
    ('DINNER', 'Diner'),
    ('SNACK', 'Snack'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final (key, label) = _items[i];
          final active = key == selected;
          return _CategoryChip(
            label: label,
            active: active,
            onTap: () => onSelect(active ? null : key),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
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
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF0F172A)
                : Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(999),
            border: active
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: active ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.recipe, required this.onTap, super.key});

  final RecipeWithDetails recipe;
  final VoidCallback onTap;

  Color get _color {
    switch (recipe.recipe.category) {
      case 'BREAKFAST':
        return AppColors.breakfastColor;
      case 'LUNCH':
        return AppColors.lunchColor;
      case 'DINNER':
        return AppColors.dinnerColor;
      case 'SNACK':
        return AppColors.snackColor;
      default:
        return AppColors.emeraldPrimary;
    }
  }

  String get _categoryLabel {
    switch (recipe.recipe.category) {
      case 'BREAKFAST':
        return 'PETIT-DEJ';
      case 'LUNCH':
        return 'DEJEUNER';
      case 'DINNER':
        return 'DINER';
      case 'SNACK':
        return 'SNACK';
      default:
        return recipe.recipe.category;
    }
  }

  (String, Color, Color) get _difficulty {
    switch (recipe.recipe.difficulty) {
      case 'EASY':
        return ('Facile', const Color(0xFF059669), const Color(0x2610B981));
      case 'MEDIUM':
        return ('Moyen', const Color(0xFFB45309), const Color(0x26F59E0B));
      case 'HARD':
        return ('Difficile', const Color(0xFFBE123C), const Color(0x26F43F5E));
      default:
        return (recipe.recipe.difficulty, AppColors.gray500, const Color(0x260F172A));
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = recipe.recipe;
    final totalTime = r.prepTimeMinutes + r.cookTimeMinutes;
    final color = _color;
    final (diffLabel, diffFg, diffBg) = _difficulty;

    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 16,
      accentColor: color,
      onTap: onTap,
      child: Row(
        children: [
          RecipeThumb(
            imagePath: r.imagePath,
            size: 58,
            radius: 14,
            fallbackColor: color,
            fallbackIcon: r.category == 'SNACK'
                ? LucideIcons.leaf
                : LucideIcons.utensils,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _categoryLabel,
                  style: GoogleFonts.nunito(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  r.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    letterSpacing: -0.2,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(LucideIcons.flame, size: 11, color: Color(0xFF64748B)),
                    const SizedBox(width: 3),
                    Text(
                      '${r.caloriesPerServing} kcal',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFF64748B).withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(LucideIcons.clock, size: 11, color: Color(0xFF64748B)),
                    const SizedBox(width: 3),
                    Text(
                      '$totalTime min',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: diffBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        diffLabel,
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: diffFg,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.state});

  final RecipeListState state;

  @override
  Widget build(BuildContext context) {
    final hasFilter = state.selectedCategory != null;
    final message = hasFilter
        ? 'Aucune recette ne correspond a ce filtre'
        : state.selectedTab == 0
            ? 'Aucune recette cette semaine'
            : 'Aucune recette disponible';
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(
            hasFilter ? LucideIcons.listFilter : LucideIcons.utensils,
            size: 48,
            color: const Color(0xFF64748B).withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
            ),
          ),
          if (hasFilter) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  context.read<RecipeListCubit>().selectCategory(null),
              child: const Text('Effacer le filtre'),
            ),
          ],
          if (!hasFilter && state.selectedTab == 0) ...[
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () => context.push(AppRoutes.planConfig),
              child: const Text('Generer un plan'),
            ),
          ],
        ],
      ),
    );
  }
}
