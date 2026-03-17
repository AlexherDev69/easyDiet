import 'package:flutter/services.dart';

/// Allows digits, dot and comma. Replaces commas with dots automatically.
/// Ensures only one decimal separator is present.
class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Replace comma with dot.
    var text = newValue.text.replaceAll(',', '.');

    // Remove anything that's not a digit or dot.
    text = text.replaceAll(RegExp(r'[^\d.]'), '');

    // Allow at most one dot.
    final dotIndex = text.indexOf('.');
    if (dotIndex != -1) {
      final beforeDot = text.substring(0, dotIndex + 1);
      final afterDot = text.substring(dotIndex + 1).replaceAll('.', '');
      text = '$beforeDot$afterDot';
    }

    // Limit to 1 decimal place for weight.
    if (dotIndex != -1 && text.length - dotIndex - 1 > 1) {
      text = text.substring(0, dotIndex + 2);
    }

    // Adjust cursor position.
    final cursorOffset = text.length.clamp(0, text.length);

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }
}
