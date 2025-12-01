import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({super.key, required this.chats});

  final Map<String, dynamic> chats;

  @override
  Widget build(BuildContext context) {
    final bool isSent = chats['isLastMessageSent'] ?? false;
    final String message = isSent ? chats['sendMessage'] : chats['lastMessage'];

    final String time = isSent ? chats['sendTime'] : chats['receivedTime'];

    return ListTile(
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
        message,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontSize: 14),
          ),

          // time
          if (!isSent && chats['messageCount'] > 0) ...[
            Container(
              padding: const .all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstants.primary,
              ),
              child: Text(
                chats['messageCount'].toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.white,
                ),
              ),
            ),
          ] else ...[
            Image.asset(
              chats['isRead']
                  ? 'assets/icons/double-check.png'
                  : 'assets/icons/double-tick.png',
              height: 24,
            ),
          ],
        ],
      ),
    );
  }
}
