import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';

class RadioOptionTile<T> extends StatelessWidget {
  final String label;
  final T value;
  final T selectedValue;
  final ValueChanged<T> onChanged;

  const RadioOptionTile({
    super.key,
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;

    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const .only(top: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Radio<T>(
              value: value,
              groupValue: selectedValue,
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
              fillColor: WidgetStateColor.resolveWith((states) {
                return isSelected
                    ? ColorConstants.primary
                    : ColorConstants.black;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
