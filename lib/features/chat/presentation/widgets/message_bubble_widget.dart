import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';

import '../../../../core/utils/timer_helper_util.dart';

class MessageBubbleWidget extends StatelessWidget {
  const MessageBubbleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      // alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const .symmetric(horizontal: 16, vertical: 8),
        child: Column(
          spacing: 6,
          //   crossAxisAlignment: isMe ? .end : .start,
          children: [
            Container(
              padding: const .all(12),
              decoration: BoxDecoration(
                // color: isMe
                //     ? ColorConstants.primaryColor
                //     :
                color: ColorConstants.dotColor,
                borderRadius: .only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  // bottomRight: isMe
                  //     ? const Radius.circular(0)
                  //     : const Radius.circular(12),
                  // bottomLeft: isMe
                  //     ? const Radius.circular(12)
                  //     : const Radius.circular(0),
                ),
              ),

              constraints: const BoxConstraints(maxWidth: 280),
              child: Text(
                "hello",
                style: TextStyle(color: ColorConstants.black),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                spacing: 12,
                mainAxisAlignment: .start,
                children: [
                  Text(
                    TimerHelperUtil.formatMessageBubbleTime("2025-12-01 09:12"),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // const Icon(
                  //   Ionicons.checkmark_done,
                  //   size: 20,
                  //   color: ColorConstants.primary,
                  //   fontWeight: FontWeight.bold,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
