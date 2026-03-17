import '../../../../core/utils/ingredient_normalizer.dart';
import '../../../../data/local/database.dart';
import '../../../../data/local/models/recipe_with_details.dart';

/// Info about a recipe in a batch cooking session.
class BatchRecipeInfo {
  const BatchRecipeInfo({
    required this.recipeId,
    required this.recipeName,
    required this.servings,
    required this.servingsMultiplier,
  });

  final int recipeId;
  final String recipeName;
  final double servings;
  final double servingsMultiplier;
}

/// Single ingredient info for display in batch steps.
class IngredientInfo {
  const IngredientInfo({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  final String name;
  final double quantity;
  final String unit;
}

/// A recipe step item in a batch cooking page.
class RecipeStepItem {
  const RecipeStepItem({
    required this.recipeName,
    required this.recipeId,
    required this.servings,
    required this.instruction,
    required this.timerSeconds,
    required this.ingredients,
  });

  final String recipeName;
  final int recipeId;
  final double servings;
  final String instruction;
  final int? timerSeconds;
  final List<IngredientInfo> ingredients;
}

/// A page in the batch cooking flow.
class BatchPage {
  const BatchPage({
    required this.pageNumber,
    required this.phase,
    required this.recipeSteps,
  });

  final int pageNumber;
  final StepPhase phase;
  final List<RecipeStepItem> recipeSteps;
}

enum StepPhase { prep, cook, finish }

/// Optimizes batch cooking steps by interleaving recipes across phases.
class BatchStepOptimizer {
  const BatchStepOptimizer();

  List<BatchPage> optimizeSteps(
    List<(BatchRecipeInfo, RecipeWithDetails)> recipePairs,
  ) {
    final recipePhaseSteps = _classifyStepsByRecipe(recipePairs);
    return _buildPages(recipePhaseSteps, recipePairs);
  }

  Map<int, Map<StepPhase, List<RecipeStep>>> _classifyStepsByRecipe(
    List<(BatchRecipeInfo, RecipeWithDetails)> recipePairs,
  ) {
    final result = <int, Map<StepPhase, List<RecipeStep>>>{};

    for (final (info, details) in recipePairs) {
      final sortedSteps = List.of(details.steps)
        ..sort((a, b) => a.stepNumber.compareTo(b.stepNumber));
      final totalSteps = sortedSteps.length;
      final phaseMap = <StepPhase, List<RecipeStep>>{};

      for (var i = 0; i < sortedSteps.length; i++) {
        final phase = _classifyStep(sortedSteps[i], i, totalSteps);
        phaseMap.putIfAbsent(phase, () => []).add(sortedSteps[i]);
      }

      result[info.recipeId] = phaseMap;
    }

    return result;
  }

  List<BatchPage> _buildPages(
    Map<int, Map<StepPhase, List<RecipeStep>>> recipePhaseSteps,
    List<(BatchRecipeInfo, RecipeWithDetails)> recipePairs,
  ) {
    final pages = <BatchPage>[];
    var pageNumber = 1;
    const phaseOrder = [StepPhase.prep, StepPhase.cook, StepPhase.finish];

    for (final phase in phaseOrder) {
      final maxSteps = recipePhaseSteps.values
          .map((m) => m[phase]?.length ?? 0)
          .fold(0, (a, b) => a > b ? a : b);

      for (var stepIndex = 0; stepIndex < maxSteps; stepIndex++) {
        final recipeSteps = <RecipeStepItem>[];

        for (final (info, details) in recipePairs) {
          final stepsInPhase = recipePhaseSteps[info.recipeId]?[phase];
          if (stepsInPhase == null || stepIndex >= stepsInPhase.length) continue;
          final step = stepsInPhase[stepIndex];

          final ingredients = _filterIngredientsForStep(
            step.instruction,
            details.ingredients,
            info.servingsMultiplier,
          );

          recipeSteps.add(RecipeStepItem(
            recipeName: info.recipeName,
            recipeId: info.recipeId,
            servings: info.servings,
            instruction: step.instruction,
            timerSeconds: step.timerSeconds,
            ingredients: ingredients,
          ));
        }

        if (recipeSteps.isNotEmpty) {
          pages.add(BatchPage(
            pageNumber: pageNumber++,
            phase: phase,
            recipeSteps: recipeSteps,
          ));
        }
      }
    }

    return pages;
  }

  List<IngredientInfo> _filterIngredientsForStep(
    String instruction,
    List<Ingredient> allIngredients,
    double servingsMultiplier,
  ) {
    return matchIngredientsForStep(
      instruction,
      allIngredients,
      servingsMultiplier,
    );
  }

  StepPhase _classifyStep(RecipeStep step, int index, int totalSteps) {
    final hasTimer = step.timerSeconds != null && step.timerSeconds! > 0;
    final isLastQuarter = index >= totalSteps * 3 ~/ 4;
    if (hasTimer) return StepPhase.cook;
    if (isLastQuarter) return StepPhase.finish;
    return StepPhase.prep;
  }

  /// Normalize text for ingredient matching (remove accents, lowercase).
  static String normalizeForMatch(String text) {
    return IngredientNormalizer.removeAccents(text.toLowerCase().trim());
  }

  /// Match ingredients mentioned in a step's instruction.
  static List<IngredientInfo> matchIngredientsForStep(
    String instruction,
    List<Ingredient> allIngredients,
    double servingsMultiplier,
  ) {
    final normalizedInstruction = normalizeForMatch(instruction);
    return allIngredients.where((ingredient) {
      final ingredientName = normalizeForMatch(ingredient.name);
      if (normalizedInstruction.contains(ingredientName)) return true;
      return ingredientName.split(' ').any(
        (word) => word.length >= 4 && normalizedInstruction.contains(word),
      );
    }).map((ingredient) {
      return IngredientInfo(
        name: ingredient.name,
        quantity: ingredient.quantity * servingsMultiplier,
        unit: ingredient.unit,
      );
    }).toList();
  }
}
