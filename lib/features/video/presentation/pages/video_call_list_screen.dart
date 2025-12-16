import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/features/chats/data/datasources/chat_data_mock.dart';

import '../../../call/presentation/pages/call_screen.dart';

class VideoCallListScreen extends StatelessWidget {
  const VideoCallListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Video Call",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontFamily: 'LuckiestGuy',
            color: ColorConstants.primaryColor,
            letterSpacing: 2,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: .all(16.0),
              child: CupertinoSearchTextField(),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const .symmetric(horizontal: 16, vertical: 4),
              child: Text(
                "Recent",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final chatList = chatData[index];
              final logs = chatList['callLogs'] as List<Map<String, dynamic>>;
              logs.sort(
                (a, b) => DateTime.parse(
                  b['time'],
                ).compareTo(DateTime.parse(a['time'])),
              );

              final firstLog = logs.first;

              return Column(
                children: [
                  CallTile(
                    username: chatList['name'],
                    dpImage: chatList['profileDp'],
                    callType: firstLog['type'],
                    direction: firstLog['direction'],
                    time: firstLog['time'],
                    isMissed: firstLog['isMissed'],
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.3,
                    color: Colors.grey.shade400,
                    indent: 70,
                  ),
                ],
              );
            }, childCount: chatData.length),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const .all(16.0),
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  const Icon(CupertinoIcons.lock_fill, size: 18),
                  Text(
                    'Your personal calls are',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(fontSize: 13),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'end-to-end encrypted',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
