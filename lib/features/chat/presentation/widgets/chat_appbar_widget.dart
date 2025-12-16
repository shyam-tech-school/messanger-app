import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/core/common/widget/dp_circle_image_widget.dart';
import 'package:mail_messanger/core/routes/route_name.dart';

import '../../../../core/constants/color_constants.dart';

class ChatAppbarWidget extends StatelessWidget {
  const ChatAppbarWidget({super.key, required this.chats});

  final Map<String, dynamic> chats;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteName.externalProfileScreen,
            arguments: chats,
          );
        },
        child: Row(
          spacing: 12,

          children: [
            DpCircleImageWidget(imageUrl: chats['profileDp']),

            Column(
              spacing: 2,
              crossAxisAlignment: .start,
              children: [
                Text(
                  chats['name'],
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const Text(
                  'Typing..',
                  style: TextStyle(
                    color: ColorConstants.primaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            debugPrint("video call button");
          },
          icon: Image.asset(
            'assets/icons/video.png',
            height: 28,
            color: ColorConstants.white,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              RouteName.audioCallScreen,
              arguments: chats,
            );
          },
          icon: const Icon(CupertinoIcons.phone, color: ColorConstants.white),
          highlightColor: Colors.transparent,
        ),
      ],

      centerTitle: false,
      leadingWidth: 35,
      toolbarHeight: 70,
      actionsPadding: const .only(right: 8),
    );
  }
}
