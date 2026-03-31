import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../onboarding/domain/models/supermarket_section.dart';

/// Dialog to manually add a shopping item.
class AddItemDialog extends StatefulWidget {
  const AddItemDialog({
    required this.onAdd,
    required this.onDismiss,
    super.key,
  });

  final void Function(String name, double quantity, String unit, String section)
      onAdd;
  final VoidCallback onDismiss;

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController(text: 'unite');
  SupermarketSection _selectedSection = SupermarketSection.produce;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _nameController,
      builder: (context, nameValue, _) => AlertDialog(
      title: const Text(
        'Ajouter un article',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nom'),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: 'Quantite'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _unitController,
                  decoration: const InputDecoration(labelText: 'Unite'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<SupermarketSection>(
            initialValue: _selectedSection,
            decoration: const InputDecoration(labelText: 'Rayon'),
            items: SupermarketSection.values
                .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.displayName),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedSection = value);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onDismiss,
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: nameValue.text.trim().isEmpty ? null : _submit,
          child: const Text('Ajouter'),
        ),
      ],
    ),
    );
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final qty = double.tryParse(_quantityController.text) ?? 1;
    widget.onAdd(name, qty, _unitController.text, _selectedSection.name);
  }
}
