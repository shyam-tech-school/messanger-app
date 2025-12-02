import 'package:flutter/material.dart';
import 'package:mail_messanger/core/utils/chat_helper_util.dart';
import 'package:mail_messanger/core/utils/timer_helper_util.dart';

import '../../../../core/constants/color_constants.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({super.key, required this.chats, required this.ontap});

  final Map<String, dynamic> chats;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    final List messages = chats['messages'];
    final lastMessage = messages.isNotEmpty ? messages.last : null;
    final previewMessage = ChatHelperUtil.buildPreviewMessage(lastMessage);
    final time = lastMessage != null ? lastMessage['time'] : "";
    final unreadCount = ChatHelperUtil.calculateUnread(
      messages,
      chats['isRead'],
    );

    return ListTile(
      onTap: ontap,
      leading: Container(
        height: 55,
        width: 55,
        padding: const .all(2),
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: ColorConstants.primary,
          shape: BoxShape.circle,
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
          child: Image.network(chats['profileDp']),
        ),
      ),
      title: Text(
        chats['name'],
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        previewMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            TimerHelperUtil.formatChatListTime(time),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontSize: 14),
          ),

          // time
          if (unreadCount > 0)
            Container(
              padding: const .all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstants.primary,
              ),
              child: Text(
                unreadCount.toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.white,
                ),
              ),
            ),
          if (lastMessage != null && lastMessage['isMe'] == true)
            Image.asset(
              chats['isRead']
                  ? 'assets/icons/double-check.png'
                  : 'assets/icons/double-tick.png',
              height: 24,
            ),
        ],
      ),
    );
  }
}
