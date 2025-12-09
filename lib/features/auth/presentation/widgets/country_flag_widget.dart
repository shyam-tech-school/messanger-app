import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';

class CountryFlagWidget extends StatelessWidget {
  const CountryFlagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ColorConstants.primary),
      ),
      alignment: Alignment.center,
      child: const Text("🇮🇳", style: TextStyle(fontSize: 28)),
    );
  }
}
