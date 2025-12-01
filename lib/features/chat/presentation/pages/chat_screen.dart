import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/features/chat/data/datasources/chat_data_mock.dart';

import '../widgets/chat_list_tile.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pinnedChats = chatData.where((e) => e['isPinned'] == true).toList();
    final normalChats = chatData.where((e) => e['isPinned'] == false).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Appbar
          SliverAppBar(
            title: Text(
              "Chat",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  debugPrint("camera button");
                },
                icon: const Icon(
                  CupertinoIcons.camera,
                  color: ColorConstants.primary,
                ),
                highlightColor: Colors.transparent,
              ),
              IconButton(
                onPressed: () {
                  debugPrint("contacts button");
                },
                icon: const Icon(
                  CupertinoIcons.square_pencil,
                  color: ColorConstants.primary,
                ),
                highlightColor: Colors.transparent,
              ),
            ],
            pinned: true,
            elevation: 0,
            centerTitle: false,
            expandedHeight: 60,
            collapsedHeight: 60,
            automaticallyImplyLeading: false,
            actionsPadding: const .only(right: 8),
          ),

          // Chat search
          SliverPersistentHeader(
            pinned: false,
            floating: false,
            delegate: _SearchBarDelegate(),
          ),

          // -- PINNED MESSAGES --
          if (pinnedChats.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const .symmetric(horizontal: 16, vertical: 6),
                child: Text(
                  "pinned message".toUpperCase(),
                  style: const TextStyle(
                    color: ColorConstants.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SliverList.builder(
              itemCount: pinnedChats.length,
              itemBuilder: (context, index) {
                return ChatListTile(chats: pinnedChats[index]);
              },
            ),
          ],

          // -- ALL MESSAGES --
          SliverToBoxAdapter(
            child: Padding(
              padding: const .symmetric(horizontal: 16, vertical: 6),
              child: Text(
                "all message".toUpperCase(),
                style: const TextStyle(
                  color: ColorConstants.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SliverList.builder(
            itemCount: normalChats.length,
            itemBuilder: (context, index) {
              return ChatListTile(chats: normalChats[index]);
            },
          ),
        ],
      ),
    );
  }
}

// -- SEARCH BAR --
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 0; // hidden when scrolling up
  @override
  double get maxExtent => 60; // visible height

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: const CupertinoSearchTextField(),
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) => false;
}
