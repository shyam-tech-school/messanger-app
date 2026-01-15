import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';

import '../widgets/chat_list_tile.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      //backgroundColor: Colors.grey,
      body: CustomScrollView(
        slivers: [
          // Appbar
          SliverAppBar(
            title: Text(
              "Chats",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontFamily: 'LuckiestGuy',
                color: ColorConstants.primaryColor,
                letterSpacing: 2,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  debugPrint("camera button");
                },
                icon: const Icon(
                  CupertinoIcons.photo_camera,
                  color: ColorConstants.white,
                ),
                highlightColor: Colors.transparent,
              ),
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, RouteName.contactListScreen),
                icon: const Icon(
                  CupertinoIcons.square_pencil,
                  color: ColorConstants.white,
                ),
                highlightColor: Colors.transparent,
              ),
            ],
            pinned: true,
            expandedHeight: 60,
            collapsedHeight: 60,
            automaticallyImplyLeading: false,
            actionsPadding: const .only(right: 8),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 6)),

          // Chat search
          SliverPersistentHeader(
            pinned: false,
            floating: false,
            delegate: _SearchBarDelegate(),
          ),

          // -- PINNED MESSAGES --

          //   SliverToBoxAdapter(
          //     child: Padding(
          //       padding: const .symmetric(horizontal: 16, vertical: 6),
          //       child: Text(
          //         "pinned message".toUpperCase(),
          //         style: const TextStyle(
          //           color: ColorConstants.grey,
          //           fontSize: 14,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ),
          //   ),
          //   SliverList.builder(
          //     itemCount: pinnedChats.length,
          //     itemBuilder: (context, index) {
          //       return ChatListTile(
          //         ontap: () {
          //           debugPrint(index.toString());
          //           Navigator.pushNamed(
          //             context,
          //             RouteName.chatScreen,
          //             arguments: pinnedChats[index],
          //           );
          //         },
          //         chats: pinnedChats[index],
          //       );
          //     },
          //   ),
          // ],

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
            itemCount: 2,
            itemBuilder: (context, index) {
              return ChatListTile(
                ontap: () {
                  debugPrint(index.toString());
                  Navigator.pushNamed(context, RouteName.chatScreen);
                },
              );
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
