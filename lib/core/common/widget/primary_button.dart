import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: .maxFinite,
        decoration: BoxDecoration(
          color: ColorConstants.primary,
          borderRadius: .circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          "Next",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: ColorConstants.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
