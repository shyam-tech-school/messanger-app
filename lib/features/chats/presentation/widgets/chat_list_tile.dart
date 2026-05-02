import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mail_messanger/core/common/widget/dp_circle_image_widget.dart';
import 'package:mail_messanger/core/utils/timer_helper_util.dart';

import '../../../../core/constants/color_constants.dart';

class ChatListTile extends StatelessWidget {
  final VoidCallback ontap;

  /// Called when the user swipes to delete. Should show a confirmation dialog
  /// and return [true] to proceed with deletion, [false] to cancel.
  final Future<bool> Function()? confirmDelete;

  final String username;
  final String? userImageUrl;
  final String lastMessage;
  final int unreadCount;
  final Timestamp? lastMessageTime;

  const ChatListTile({
    super.key,
    required this.ontap,
    this.confirmDelete,
    required this.username,
    required this.userImageUrl,
    required this.lastMessage,
    required this.unreadCount,
    this.lastMessageTime,
  });

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
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

    if (confirmDelete == null) return tile;

    return Dismissible(
      key: Key(username),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (_) => confirmDelete!(),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        color: const Color(0xFFE53935),
        child: const Row(
          children: [
            Icon(Icons.delete_rounded, color: Colors.white, size: 26),
            SizedBox(width: 8),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      child: tile,
    );
  }
}
