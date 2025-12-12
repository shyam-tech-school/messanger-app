import 'package:flutter/material.dart';

class ChatBottomSheetOptions extends StatelessWidget {
  const ChatBottomSheetOptions({
    super.key,
    required this.icon,
    required this.label,
    required this.ontap,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final Function()? ontap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6.0,
      children: [
        InkWell(
          onTap: ontap,
          child: Container(
            padding: const .all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: iconColor),
          ),
        ),
        Text(label),
      ],
    );
  }
}
