/// Represents where a shopping ingredient comes from.
class IngredientSource {
  const IngredientSource({
    required this.recipeName,
    required this.dayOfWeek,
    required this.quantity,
    required this.unit,
    this.mealType,
  });

  final String recipeName;
  final int dayOfWeek;
  final double quantity;
  final String unit;

  /// Uppercase meal type (BREAKFAST/LUNCH/DINNER/SNACK). Null for legacy
  /// items generated before the meal grouping feature.
  final String? mealType;

  factory IngredientSource.fromJson(Map<String, dynamic> json) {
    return IngredientSource(
      recipeName: json['recipeName'] as String? ?? '',
      dayOfWeek: json['dayOfWeek'] as int? ?? 0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String? ?? '',
      mealType: json['mealType'] as String?,
    );
  }
}
