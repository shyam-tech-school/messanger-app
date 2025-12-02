import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';

class ChatAppbarWidget extends StatelessWidget {
  const ChatAppbarWidget({super.key, required this.chats});

  final Map<String, dynamic> chats;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        spacing: 12,

        children: [
          Container(
            height: 55,
            width: 55,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Image.network(chats['profileDp']),
          ),
          Column(
            spacing: 2,
            crossAxisAlignment: .start,
            children: [
              Text(chats['name']),
              const Text(
                'Typing..',
                style: TextStyle(color: Colors.green, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            debugPrint("video call button");
          },
          icon: Image.asset('assets/icons/video.png', height: 28),
        ),
        IconButton(
          onPressed: () {
            debugPrint("phone button");
          },
          icon: const Icon(CupertinoIcons.phone, color: ColorConstants.black),
          highlightColor: Colors.transparent,
        ),
      ],
      centerTitle: false,
      leadingWidth: 35,
      toolbarHeight: 70,
      backgroundColor: ColorConstants.white,
      actionsPadding: const .only(right: 8),
    );
  }
}
