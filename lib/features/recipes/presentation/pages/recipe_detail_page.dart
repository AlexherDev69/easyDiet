import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../../../navigation/app_router.dart';
import '../../../../shared/widgets/blob_bg.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../cubit/recipe_detail_cubit.dart';
import '../cubit/recipe_detail_state.dart';

/// Recipe detail screen — handoff design with hero banner + glass macros.
class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({
    required this.recipeId,
    this.planServings = 0,
    super.key,
  });

  final int recipeId;
  final double planServings;

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<RecipeDetailCubit>()
        .loadRecipe(widget.recipeId, planServings: widget.planServings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(child: BlobBG()),
          BlocBuilder<RecipeDetailCubit, RecipeDetailState>(
            builder: (context, state) {
              if (state.isLoading || state.recipe == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.emeraldPrimary,
                  ),
                );
              }
              return _Content(recipeId: widget.recipeId);
            },
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.recipeId});

  final int recipeId;

  Color _categoryColor(String category) {
    switch (category) {
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

  String _categoryLabel(String category) {
    switch (category) {
      case 'BREAKFAST':
        return 'Petit-dej';
      case 'LUNCH':
        return 'Dejeuner';
      case 'DINNER':
        return 'Diner';
      case 'SNACK':
        return 'Snack';
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecipeDetailCubit>();
    final state = context.watch<RecipeDetailCubit>().state;
    final recipe = state.recipe!;
    final r = recipe.recipe;
    final servings = state.servings;
    final servingsMultiplier = servings / r.servings;
    final color = _categoryColor(r.category);
    final topPadding = MediaQuery.of(context).padding.top;

    final sortedIngredients = List.of(recipe.ingredients)
      ..sort((a, b) => a.name.compareTo(b.name));
    final sortedSteps = List.of(recipe.steps)
      ..sort((a, b) => a.stepNumber.compareTo(b.stepNumber));

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.only(top: topPadding + 8, bottom: 140),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _BackPill(onTap: () => context.pop()),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _HeroBanner(
                accent: color,
                categoryLabel: _categoryLabel(r.category).toUpperCase(),
                imagePath: r.imagePath,
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.name,
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                      height: 1.2,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    r.description,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MacrosRow(
                    calories: (r.caloriesPerServing * servings).round(),
                    protein: (r.proteinGrams * servings).round(),
                    carbs: (r.carbsGrams * servings).round(),
                    fat: (r.fatGrams * servings).round(),
                  ),
                  const SizedBox(height: 12),
                  _ServingsRow(
                    servings: servings,
                    prepMinutes: r.prepTimeMinutes,
                    cookMinutes: r.cookTimeMinutes,
                    onIncrease: cubit.increaseServings,
                    onDecrease: cubit.decreaseServings,
                  ),
                  const SizedBox(height: 18),
                  _SectionTitle('Ingredients'),
                  const SizedBox(height: 8),
                  for (var i = 0; i < sortedIngredients.length; i++)
                    _IngredientRow(
                      name: sortedIngredients[i].name,
                      quantity: sortedIngredients[i].quantity *
                          servingsMultiplier,
                      unit: sortedIngredients[i].unit,
                      isAlternate: i.isOdd,
                    ),
                  const SizedBox(height: 20),
                  _SectionTitle('Etapes'),
                  const SizedBox(height: 10),
                  for (final s in sortedSteps)
                    _StepRow(
                      stepNumber: s.stepNumber,
                      instruction: s.instruction,
                      timerSeconds: s.timerSeconds,
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: _StartCookingButton(
            onTap: () => context.push(
              AppRoutes.cookingMode(recipeId, planServings: servings),
            ),
          ),
        ),
      ],
    );
  }
}

class _BackPill extends StatelessWidget {
  const _BackPill({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Ink(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.chevronLeft,
                    size: 16, color: Color(0xFF475569)),
                const SizedBox(width: 4),
                Text(
                  'Recettes',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.accent,
    required this.categoryLabel,
    this.imagePath,
  });

  final Color accent;
  final String categoryLabel;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.emeraldPrimary.withValues(alpha: 0.3),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _gradientBg(),
              )
            else
              _gradientBg(),
            // Dark overlay for legible label/title on top of photo.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.28),
                      Colors.black.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.35),
                    ],
                    stops: const [0, 0.5, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  categoryLabel,
                  style: GoogleFonts.nunito(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradientBg() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent,
            const Color(0xFF6EE7B7),
            const Color(0xFF14B8A6),
            const Color(0xFF8B5CF6),
          ],
          stops: const [0, 0.4, 0.7, 1.2],
        ),
      ),
    );
  }
}

class _MacrosRow extends StatelessWidget {
  const _MacrosRow({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  @override
  Widget build(BuildContext context) {
    final items = <(String, int, String, Color)>[
      ('Calories', calories, 'kcal', AppColors.emeraldPrimary),
      ('Proteines', protein, 'g', const Color(0xFFF43F5E)),
      ('Glucides', carbs, 'g', const Color(0xFFF59E0B)),
      ('Lipides', fat, 'g', const Color(0xFF8B5CF6)),
    ];
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      borderRadius: 18,
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: i > 0
                      ? Border(
                          left: BorderSide(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                          ),
                        )
                      : null,
                ),
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${items[i].$2}',
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            color: items[i].$4,
                          ),
                        ),
                        const SizedBox(width: 1),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            items[i].$3,
                            style: GoogleFonts.nunito(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      items[i].$1.toUpperCase(),
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ServingsRow extends StatelessWidget {
  const _ServingsRow({
    required this.servings,
    required this.prepMinutes,
    required this.cookMinutes,
    required this.onIncrease,
    required this.onDecrease,
  });

  final double servings;
  final int prepMinutes;
  final int cookMinutes;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          _ServingsStepper(
            label: '${_fmt(servings)} pers.',
            onMinus: servings > 0.5 ? onDecrease : null,
            onPlus: servings < 12 ? onIncrease : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TimePill(
              icon: LucideIcons.clock,
              iconColor: const Color(0xFF475569),
              value: '$prepMinutes min',
              label: 'prep.',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TimePill(
              icon: LucideIcons.flame,
              iconColor: const Color(0xFFF59E0B),
              value: '$cookMinutes min',
              label: 'cuisson',
            ),
          ),
        ],
      ),
    );
  }
}

class _ServingsStepper extends StatelessWidget {
  const _ServingsStepper({
    required this.label,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      borderRadius: 14,
      child: SizedBox(
        height: 28,
        child: Row(
          children: [
            _SquareButton(icon: LucideIcons.minus, onTap: onMinus),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            _SquareButton(icon: LucideIcons.plus, onTap: onPlus),
          ],
        ),
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 14, color: const Color(0xFF475569)),
        ),
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  const _TimePill({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      borderRadius: 999,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF0F172A),
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.isAlternate,
  });

  final String name;
  final double quantity;
  final String unit;
  final bool isAlternate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: isAlternate ? 0.3 : 0.55),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            Text(
              QuantityFormatter.formatWithUnit(quantity, unit),
              style: GoogleFonts.robotoMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.stepNumber,
    required this.instruction,
    this.timerSeconds,
  });

  final int stepNumber;
  final String instruction;
  final int? timerSeconds;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  AppColors.gradientGreenStart,
                  AppColors.gradientGreenEnd,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.emeraldPrimary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '$stepNumber',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    instruction,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  if (timerSeconds != null && timerSeconds! > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Minuteur : ${timerSeconds! ~/ 60} min',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentAmber,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StartCookingButton extends StatelessWidget {
  const _StartCookingButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Lancer la cuisson',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            height: 54,
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
                  color: AppColors.emeraldPrimary.withValues(alpha: 0.5),
                  blurRadius: 32,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.play, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Lancer la cuisson',
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
      ),
    );
  }
}
