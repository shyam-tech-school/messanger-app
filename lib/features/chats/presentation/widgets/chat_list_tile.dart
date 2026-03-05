import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mail_messanger/core/common/widget/dp_circle_image_widget.dart';
import 'package:mail_messanger/core/utils/timer_helper_util.dart';

import '../../../../core/constants/color_constants.dart';

class ChatListTile extends StatelessWidget {
  final VoidCallback ontap;
  final String username;
  final String? userImageUrl;
  final String lastMessage;
  final int unreadCount;
  final Timestamp? lastMessageTime;

  const ChatListTile({
    super.key,
    required this.ontap,
    required this.username,
    required this.userImageUrl,
    required this.lastMessage,
    required this.unreadCount,
    this.lastMessageTime,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ontap,
      leading: DpCircleImageWidget(imageUrl: userImageUrl),
      title: Text(
        username,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            lastMessageTime != null
                ? TimerHelperUtil.formatChatListTime(lastMessageTime)
                : '',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 13,
              color: unreadCount > 0 ? ColorConstants.primaryColor : null,
            ),
          ),
          const SizedBox(height: 4),

          // Unread badge — visible only when there are unread messages
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: ColorConstants.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                unreadCount > 99 ? '99+' : unreadCount.toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.black,
                ),
              ),
            )
          else
            const Icon(
              Ionicons.checkmark_done,
              size: 20,
              color: ColorConstants.primary,
            ),
        ],
      ),
    );
  }
}
