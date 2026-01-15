import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mail_messanger/core/utils/chat_helper_util.dart';
import 'package:mail_messanger/core/utils/timer_helper_util.dart';

import '../../../../core/constants/color_constants.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({super.key, required this.ontap});

  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    // final List messages = chats['messages'];
    // final lastMessage = messages.isNotEmpty ? messages.last : null;
    // final previewMessage = ChatHelperUtil.buildPreviewMessage(lastMessage);
    // final time = lastMessage != null ? lastMessage['time'] : "";
    // final unreadCount = ChatHelperUtil.calculateUnread(
    //   messages,
    //   chats['isRead'],
    // );

    return ListTile(
      onTap: ontap,
      leading: Container(
        height: 55,
        width: 55,
        padding: const .all(1),
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: ColorConstants.dotColor,
          shape: BoxShape.circle,
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
          child: Image.network(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLat8bZvhXD3ChSXyzGsFVh6qgplm1KhYPKA&s",
          ),
        ),
      ),
      title: Text(
        "user name",
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        "message",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            TimerHelperUtil.formatChatListTime("2025-12-01 09:12"),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontSize: 14),
          ),

          // time
          //if (unreadCount > 0)
          // Container(
          //   padding: const .all(8),
          //   decoration: const BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: ColorConstants.primaryColor,
          //   ),
          //   child: Text(
          //     "2",
          //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          //       fontSize: 14,
          //       fontWeight: FontWeight.w600,
          //       color: ColorConstants.black,
          //     ),
          //   ),
          // ),
          // if (lastMessage != null && lastMessage['isMe'] == true)
          //   chats['isRead']
          //       ? const Icon(
          //           Ionicons.checkmark_done,
          //           size: 22,
          //           fontWeight: FontWeight.bold,
          //         )
          //       :
          const Icon(
            Ionicons.checkmark_done,
            size: 22,
            color: ColorConstants.primary,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
