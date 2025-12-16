import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';

class ChatBottomSheetOptions extends StatelessWidget {
  const ChatBottomSheetOptions({
    super.key,
    required this.icon,
    required this.label,
    required this.ontap,
  });

  final IconData icon;
  final String label;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6.0,
      children: [
        InkWell(
          onTap: ontap,
          child: Container(
            padding: const .all(15),
            decoration: const BoxDecoration(
              color: ColorConstants.darkScaffoldBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: ColorConstants.white),
          ),
        ),
        Text(label),
      ],
    );
  }
}
