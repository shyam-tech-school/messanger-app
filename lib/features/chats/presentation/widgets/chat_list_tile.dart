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

  const ChatListTile({
    super.key,
    required this.ontap,
    required this.username,
    required this.userImageUrl,
    required this.lastMessage,
    required this.unreadCount,
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
        children: [
          Text(
            TimerHelperUtil.formatChatListTime("2025-12-01 09:12"),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontSize: 14),
          ),

          // !time
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
