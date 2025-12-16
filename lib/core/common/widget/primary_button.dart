import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.onTap, required this.label});

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: .maxFinite,
        decoration: BoxDecoration(
          color: ColorConstants.primaryColor,
          borderRadius: .circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorConstants.black,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}
