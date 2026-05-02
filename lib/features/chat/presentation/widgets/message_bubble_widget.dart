import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';

import '../../../../core/utils/timer_helper_util.dart';

class MessageBubbleWidget extends StatelessWidget {
  final bool isMe;
  final String message;
  final DateTime timestamp;
  final bool isSeen;
  final bool isDelivered;

  const MessageBubbleWidget({
    super.key,
    required this.isMe,
    required this.message,
    required this.timestamp,
    this.isSeen = false,
    this.isDelivered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          spacing: 6,
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe
                    ? ColorConstants.primaryColor
                    : ColorConstants.white,
                borderRadius: BorderRadius.only(
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
                message,
                style: const TextStyle(color: ColorConstants.black),
              ),
            ),

            // Timestamp + tick indicator (only for sent messages)
            Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Row(
                spacing: 6,
                mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Text(
                    TimerHelperUtil.formatChatTime(timestamp),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isMe) _buildTick(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTick() {
    // Blue double tick — message was read
    if (isSeen) {
      return const Icon(
        Ionicons.checkmark_done,
        size: 18,
        color: ColorConstants.primaryColor,
      );
    }

    // Grey double tick — message delivered (receiver received it)
    if (isDelivered) {
      return const Icon(
        Ionicons.checkmark_done,
        size: 18,
        color: Colors.grey,
      );
    }

    // Single grey tick — sent but not yet delivered
    return const Icon(
      Ionicons.checkmark,
      size: 18,
      color: Colors.grey,
    );
  }
}
