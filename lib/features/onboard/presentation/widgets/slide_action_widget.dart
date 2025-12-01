import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/text_constants.dart';

class SlidActionWidget extends StatelessWidget {
  const SlidActionWidget({super.key, required this.onNavigate});

  final Future<dynamic>? Function()? onNavigate;

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      height: 75,
      elevation: 0,
      innerColor: ColorConstants.white,
      outerColor: ColorConstants.primary,
      sliderButtonIcon: const Icon(
        Icons.keyboard_double_arrow_right_rounded,
        size: 28,
      ),
      text: TextConstants.swipeToConnect,
      textStyle: const TextStyle(fontSize: 16, color: ColorConstants.white),
      animationDuration: const Duration(milliseconds: 400),
      onSubmit: onNavigate,
    );
  }
}
