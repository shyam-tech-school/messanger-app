import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/core/utils/app_logger.dart';
import 'package:mail_messanger/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mail_messanger/features/chat/data/repositories/chat_repository.dart';

import '../widgets/chat_list_tile.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late final ChatRepository _chatRepository;
  bool _initialLoadDone = false;
  final Map<String, Map<String, dynamic>> _userCache = {};

  @override
  void initState() {
    super.initState();
    _chatRepository = ChatRepository(
      ChatRemoteDataSourceImpl(FirebaseFirestore.instance),
    );
  }

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

          // Sliver list builder
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _chatRepository.streamChats(currentUserId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !_initialLoadDone) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                AppLogger.e(snapshot.error); // error logger

                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        const Text("Something went wrong"),
                        Text(snapshot.error.toString()),
                      ],
                    ),
                  ),
                );
              }

              if (snapshot.hasData) {
                _initialLoadDone = true;
                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        "No Chats Yet!",
                        style: TextStyle(color: ColorConstants.white),
                      ),
                    ),
                  );
                }

                return SliverMainAxisGroup(
                  slivers: [
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

                    // -- CHAT TILE LIST --
                    SliverList.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final chatDoc = docs[index];
                        final chatData = chatDoc.data();
                        final chatId = chatDoc.id;

                        final participants = List<String>.from(
                          chatData['participants'],
                        );

                        final otherUserId = participants.firstWhere(
                          (id) => id != currentUserId,
                        );

                        _loadProfileUser(otherUserId);

                        final otherUserData = _userCache[otherUserId];
                        final otherUserName =
                            (otherUserData?['name'] as String?) ?? 'Unknown';
                        final otherUserImageUrl =
                            (otherUserData?['photoUrl'] as String?);

                        final lastMessage =
                            (chatData['lastMessage'] as String?) ?? '';

                        final lastMessageTime =
                            chatData['lastMessageTime'] as Timestamp?;

                        final unreadCount =
                            chatDoc['unreadCount']?[currentUserId] ?? 0;

                        return ChatListTile(
                          ontap: () {
                            Navigator.pushNamed(
                              context,
                              RouteName.chatScreen,
                              arguments: {
                                'chatRoomId': chatId,
                                'otherUserId': otherUserId,
                                'otherUserName': otherUserName,
                                'otherUserImageUrl': otherUserImageUrl,
                                'currentUserId': currentUserId,
                              },
                            );
                          },
                          username: otherUserName,
                          userImageUrl: otherUserImageUrl,
                          unreadCount: unreadCount,
                          lastMessage: lastMessage,
                          lastMessageTime: lastMessageTime,
                        );
                      },
                    ),
                  ],
                );
              }
              return const SliverFillRemaining(child: SizedBox());
            },
          ),
        ],
      ),
    );
  }

  Future<void> _loadProfileUser(String userId) async {
    if (_userCache.containsKey(userId)) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (doc.exists) {
      _userCache[userId] = doc.data()!;
      setState(() {});
    }
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


/*

SliverList.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return ChatListTile(
                ontap: () {
                  debugPrint(index.toString());
                  Navigator.pushNamed(context, RouteName.chatScreen);
                },
              );
            },
          ),

      
*/


