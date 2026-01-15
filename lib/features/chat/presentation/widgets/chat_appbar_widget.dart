import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/core/common/widget/dp_circle_image_widget.dart';

import '../../../../core/constants/color_constants.dart';

class ChatAppbarWidget extends StatelessWidget {
  final String? otherPhotoUrl;
  final String otherUserName;

  const ChatAppbarWidget({
    super.key,
    required this.otherPhotoUrl,
    required this.otherUserName,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          //! external profile screen
        },
        child: Row(
          spacing: 12,

          children: [
            DpCircleImageWidget(imageUrl: otherPhotoUrl),

            Column(
              spacing: 2,
              crossAxisAlignment: .start,
              children: [
                Text(
                  otherUserName,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const Text(
                  'online',
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
            //! audio call screen
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
