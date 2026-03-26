import 'package:equatable/equatable.dart';

import '../../domain/models/batch_cooking_models.dart';

/// State for the batch cooking overview screen.
class BatchCookingState extends Equatable {
  const BatchCookingState({
    this.sessionNumber = 1,
    this.recipes = const [],
    this.commonIngredients = const [],
    this.allIngredients = const [],
    this.totalPrepTime = 0,
    this.totalCookTime = 0,
    this.isLoading = true,
    this.errorMessage,
  });

  final int sessionNumber;
  final List<BatchCookingRecipeInfo> recipes;
  final List<MergedIngredient> commonIngredients;
  final List<MergedIngredient> allIngredients;
  final int totalPrepTime;
  final int totalCookTime;
  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        sessionNumber,
        recipes,
        commonIngredients,
        allIngredients,
        totalPrepTime,
        totalCookTime,
        isLoading,
        errorMessage,
      ];

  BatchCookingState copyWith({
    int? sessionNumber,
    List<BatchCookingRecipeInfo>? recipes,
    List<MergedIngredient>? commonIngredients,
    List<MergedIngredient>? allIngredients,
    int? totalPrepTime,
    int? totalCookTime,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return BatchCookingState(
      sessionNumber: sessionNumber ?? this.sessionNumber,
      recipes: recipes ?? this.recipes,
      commonIngredients: commonIngredients ?? this.commonIngredients,
      allIngredients: allIngredients ?? this.allIngredients,
      totalPrepTime: totalPrepTime ?? this.totalPrepTime,
      totalCookTime: totalCookTime ?? this.totalCookTime,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
