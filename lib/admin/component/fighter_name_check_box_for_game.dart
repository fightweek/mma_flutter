import 'package:flutter/material.dart';

class FighterNameCheckBoxForGame extends StatelessWidget {
  final String name;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  const FighterNameCheckBoxForGame({
    required this.name,
    required this.isSelected,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isSelected,
      onChanged:  (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
