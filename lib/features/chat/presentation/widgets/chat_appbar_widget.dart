import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/core/common/widget/dp_circle_image_widget.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import '../../../../core/constants/color_constants.dart';
import 'package:mail_messanger/features/chat/domain/usecases/stream_typing_status_usecase.dart';
import '../../../../core/services/presence_service.dart';
import '../../../../core/utils/timer_helper_util.dart';

class ChatAppbarWidget extends StatelessWidget {
  final String? otherPhotoUrl;
  final String otherUserName;
  final String? otherUserId;
  final String? chatId;
  final String? currentUserId;
  final bool isBlocked;
  final StreamTypingStatusUsecase? streamTypingStatusUsecase;

  const ChatAppbarWidget({
    super.key,
    required this.otherPhotoUrl,
    required this.otherUserName,
    this.otherUserId,
    this.chatId,
    this.currentUserId,
    this.isBlocked = false,
    this.streamTypingStatusUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteName.externalProfileScreen,
            arguments: {
              'userId': otherUserId ?? '',
              'chatRoomId': chatId,
              'currentUserId': currentUserId ?? '',
            },
          );
        },
        child: Row(
          spacing: 12,

          children: [
            DpCircleImageWidget(imageUrl: otherPhotoUrl),

            Expanded(
              child: Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUserName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (otherUserId != null)
                    StreamBuilder<bool>(
                      stream:
                          (chatId != null && streamTypingStatusUsecase != null)
                          ? streamTypingStatusUsecase!(chatId!, otherUserId!)
                          : Stream.value(false),
                      builder: (context, typingSnapshot) {
                        if (typingSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }

                        if (typingSnapshot.data == true) {
                          return const Text(
                            'typing...',
                            style: TextStyle(
                              color: ColorConstants.primaryColor,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          );
                        }

                        return StreamBuilder<Map<String, dynamic>>(
                          stream: PresenceService().streamUserPresence(
                            otherUserId!,
                          ),
                          builder: (context, presenceSnapshot) {
                            if (presenceSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text(
                                '...',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              );
                            }

                            final isOnline =
                                presenceSnapshot.data?['isOnline'] ?? false;
                            final lastSeen = presenceSnapshot.data?['lastSeen'];

                            String displayStatus = '';
                            if (isOnline) {
                              displayStatus = 'online';
                            } else if (lastSeen != null && lastSeen != 0) {
                              displayStatus = TimerHelperUtil.formatLastSeen(
                                lastSeen,
                              );
                            } else {
                              displayStatus = 'offline';
                            }

                            return Text(
                              displayStatus,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isOnline
                                    ? ColorConstants.primaryColor
                                    : Colors.grey,
                                fontSize: 12,
                              ),
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Video call
        Opacity(
          opacity: isBlocked ? 0.35 : 1.0,
          child: IconButton(
            onPressed: isBlocked
                ? null
                : () {
                    if (otherUserId == null) return;
                    Navigator.pushNamed(
                      context,
                      RouteName.videoCallScreen,
                      arguments: {
                        'mode': 'outgoing',
                        'otherUserId': otherUserId!,
                        'otherUserName': otherUserName,
                        'otherPhotoUrl': otherPhotoUrl,
                      },
                    );
                  },
            icon: Image.asset(
              'assets/icons/video.png',
              height: 28,
              color: ColorConstants.white,
            ),
          ),
        ),
        // Audio call
        Opacity(
          opacity: isBlocked ? 0.35 : 1.0,
          child: IconButton(
            onPressed: isBlocked
                ? null
                : () {
                    if (otherUserId == null) return;
                    Navigator.pushNamed(
                      context,
                      RouteName.audioCallScreen,
                      arguments: {
                        'mode': 'outgoing',
                        'otherUserId': otherUserId!,
                        'otherUserName': otherUserName,
                        'otherPhotoUrl': otherPhotoUrl,
                      },
                    );
                  },
            icon: const Icon(CupertinoIcons.phone, color: ColorConstants.white),
            highlightColor: Colors.transparent,
          ),
        ),
      ],
      centerTitle: false,
      leadingWidth: 35,
      toolbarHeight: 70,
      actionsPadding: const EdgeInsets.only(right: 8),
    );
  }
}
