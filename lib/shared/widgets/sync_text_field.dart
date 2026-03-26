import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A TextField that owns a persistent [TextEditingController] across rebuilds.
///
/// The standard pattern of passing `TextEditingController(text: value)` inside
/// `build()` recreates the controller on every rebuild, resetting the cursor
/// position. This widget fixes that by managing the controller in state and
/// syncing it only when the external [value] changes.
class SyncTextField extends StatefulWidget {
  const SyncTextField({
    required this.value,
    required this.onChanged,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final InputDecoration decoration;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;

  @override
  State<SyncTextField> createState() => _SyncTextFieldState();
}

class _SyncTextFieldState extends State<SyncTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    // Position cursor at end on initial load.
    _controller.selection =
        TextSelection.collapsed(offset: widget.value.length);
  }

  @override
  void didUpdateWidget(SyncTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only sync when the external value changed AND differs from what the user
    // typed — avoids fighting the controller mid-input.
    if (widget.value != oldWidget.value &&
        widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: widget.decoration,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
    );
  }
}
