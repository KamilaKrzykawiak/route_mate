import 'package:flutter/material.dart';

class NumberField extends StatelessWidget {
  NumberField({super.key, required this.hint, required this.onChanged});

  final Function(double) onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
        hintText: hint,
      ),
      onChanged: (text) => onChanged(double.parse(text)),
    );
  }
}
