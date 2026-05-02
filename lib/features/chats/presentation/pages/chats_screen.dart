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
                          confirmDelete: () => _confirmAndDeleteChat(
                            context: context,
                            chatId: chatId,
                            otherUserName: otherUserName,
                            currentUserId: currentUserId,
                          ),
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

  /// Shows a confirmation bottom sheet.
  /// Returns [true] if the user confirmed deletion, [false] otherwise.
  Future<bool> _confirmAndDeleteChat({
    required BuildContext context,
    required String chatId,
    required String otherUserName,
    required String currentUserId,
  }) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _DeleteChatSheet(username: otherUserName),
    );

    if (confirmed != true) return false;

    try {
      await _chatRepository.deleteChat(chatId, currentUserId);
      return true;
    } catch (e) {
      AppLogger.e(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete chat. Try again.')),
        );
      }
      return false;
    }
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

// -- DELETE CHAT CONFIRMATION BOTTOM SHEET --
class _DeleteChatSheet extends StatelessWidget {
  final String username;

  const _DeleteChatSheet({required this.username});

  @override
  Widget build(BuildContext context) {
    // Respect the system nav bar / gesture area so buttons are never clipped
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.fromLTRB(12, 0, 12, 16 + bottomPadding),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              children: [
                const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFE53935),
                  size: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  'Delete Chat',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Delete your chat with $username?\nThis will only remove it for you.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white60,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Delete
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
