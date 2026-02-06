import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/constants/color_constants.dart';
import 'call_action_button.dart';

class CallScreenBottomOptionWidget extends StatelessWidget {
  const CallScreenBottomOptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorConstants.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CallActionButton(icon: Icons.more_horiz, ontap: () {}),
          CallActionButton(icon: Ionicons.videocam, ontap: () {}),
          CallActionButton(icon: CupertinoIcons.speaker_2, ontap: () {}),
          CallActionButton(icon: CupertinoIcons.mic_off, ontap: () {}),
          CallActionButton(
            icon: CupertinoIcons.phone_down_fill,
            color: Colors.red,
            ontap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
