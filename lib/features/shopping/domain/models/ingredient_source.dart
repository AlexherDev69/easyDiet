/// Represents where a shopping ingredient comes from.
class IngredientSource {
  const IngredientSource({
    required this.recipeName,
    required this.dayOfWeek,
    required this.quantity,
    required this.unit,
  });

  final String recipeName;
  final int dayOfWeek;
  final double quantity;
  final String unit;

  factory IngredientSource.fromJson(Map<String, dynamic> json) {
    return IngredientSource(
      recipeName: json['recipeName'] as String? ?? '',
      dayOfWeek: json['dayOfWeek'] as int? ?? 0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String? ?? '',
    );
  }
}
