import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart'; // Added provider import
import '../../../../core/constants/color_constants.dart';
import '../provider/call_service_provider.dart'; // Added import
import 'call_action_button.dart';

class CallScreenBottomOptionWidget extends StatelessWidget {
  const CallScreenBottomOptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CallServiceProvider>(
      builder: (context, provider, child) {
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
              CallActionButton(
                icon: provider.isSpeakerOn
                    ? CupertinoIcons.speaker_2_fill
                    : CupertinoIcons.speaker_2,
                color: provider.isSpeakerOn ? Colors.red : Colors.white54,
                ontap: () => provider.toggleSpeaker(),
              ),
              CallActionButton(
                icon: provider.isMuted
                    ? CupertinoIcons.mic_off
                    : CupertinoIcons.mic_fill,
                color: provider.isMuted
                    ? Colors.red
                    : Colors.white54, // Visual feedback for mute
                ontap: () => provider.toggleMute(),
              ),
              CallActionButton(
                icon: CupertinoIcons.phone_down_fill,
                color: Colors.red,
                ontap: () async {
                  await provider.endCall();
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
