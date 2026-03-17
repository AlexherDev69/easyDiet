/// Smart rounding for cooking quantities.
/// Rounds up to avoid having too little of an ingredient.
///
/// - Whole numbers stay as integers: 3.0 → "3"
/// - Half values displayed as .5: 2.5 → "2.5"
/// - Small quantities (< 1): round up to nearest 0.25
/// - Larger quantities (≥ 1): round up to nearest 0.5
class QuantityFormatter {
  QuantityFormatter._();

  static double roundForCooking(double quantity) {
    if (quantity <= 0) return 0;
    if (quantity < 1) {
      return _ceilToIncrement(quantity, 0.25);
    }
    return _ceilToIncrement(quantity, 0.5);
  }

  static String format(double quantity) {
    final rounded = roundForCooking(quantity);
    if (rounded == rounded.toInt().toDouble()) {
      return rounded.toInt().toString();
    }
    final decimal = rounded - rounded.toInt();
    if ((decimal - 0.5).abs() < 0.001) return '${rounded.toInt()}.5';
    if ((decimal - 0.25).abs() < 0.001) return '${rounded.toInt()}.25';
    if ((decimal - 0.75).abs() < 0.001) return '${rounded.toInt()}.75';
    return rounded.toStringAsFixed(1);
  }

  static String formatWithUnit(double quantity, String unit) {
    final qtyStr = format(quantity);
    return unit.trim().isEmpty ? qtyStr : '$qtyStr $unit';
  }

  static double _ceilToIncrement(double value, double increment) {
    return (value / increment).ceil() * increment;
  }
}
