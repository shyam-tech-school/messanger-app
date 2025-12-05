import 'package:flutter/material.dart';

import 'radio_option_tile.dart';

class RadioGroup1<T> extends StatefulWidget {
  final T initialValue;
  final List<RadioOption<T>> options;
  final ValueChanged<T> onChanged;

  const RadioGroup1({
    super.key,
    required this.initialValue,
    required this.options,
    required this.onChanged,
  });

  @override
  State<RadioGroup1<T>> createState() => _RadioGroup1State<T>();
}

class _RadioGroup1State<T> extends State<RadioGroup1<T>> {
  late T selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.map((option) {
        return RadioOptionTile<T>(
          label: option.label,
          value: option.value,
          selectedValue: selectedValue,
          onChanged: (v) {
            setState(() => selectedValue = v);
            widget.onChanged(v);
          },
        );
      }).toList(),
    );
  }
}

class RadioOption<T> {
  final String label;
  final T value;

  RadioOption({required this.label, required this.value});
}
