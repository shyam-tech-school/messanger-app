import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';

import '../../../../core/utils/timer_helper_util.dart';

class MessageBubbleWidget extends StatelessWidget {
  const MessageBubbleWidget({super.key, required this.message});

  final Map<String, dynamic> message;

  @override
  Widget build(BuildContext context) {
    final isMe = message['isMe'] as bool;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const .symmetric(horizontal: 16, vertical: 8),
        child: Column(
          spacing: 6,
          crossAxisAlignment: isMe ? .end : .start,
          children: [
            Container(
              padding: const .all(12),
              decoration: BoxDecoration(
                color: isMe
                    ? ColorConstants.chatBubbleSecondary
                    : ColorConstants.white,
                borderRadius: .only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomLeft: isMe
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                ),
              ),

              constraints: const BoxConstraints(maxWidth: 280),
              child: Text(
                message['text'],
                style: TextStyle(color: isMe ? ColorConstants.white : null),
              ),
            ),
            Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                TimerHelperUtil.formatMessageBubbleTime(message['time']),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
