import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/core/common/widget/dp_circle_image_widget.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/utils/timer_helper_util.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mail_messanger/features/call/presentation/provider/call_history_provider.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Voice Call",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontFamily: 'LuckiestGuy',
            color: ColorConstants.primaryColor,
            letterSpacing: 2,
          ),
        ),

        automaticallyImplyLeading: false,
      ),
      body: Consumer<CallHistoryProvider>(
        builder: (context, provider, _) {
          final audioLogs = provider.callLogs
              .where((log) => log.type == 'audio' || log.type == null)
              .toList();

          return CustomScrollView(
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

          if (provider.isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          else if (audioLogs.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: Text("No audio calls yet")),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final log = audioLogs[index];
                final myUid = FirebaseAuth.instance.currentUser?.uid;
                final isIncoming = log.calleeId == myUid;

                final username = isIncoming
                    ? (log.callerName ?? 'Unknown')
                    : (log.calleeName ?? 'Unknown');
                final dpImage = isIncoming
                    ? (log.callerAvatar ?? '')
                    : (log.calleeAvatar ?? '');
                
                final direction = isIncoming ? 'incoming' : 'outgoing';
                
                // Simplified missed call logic: if we were the callee and ended rejected or untouched
                final isMissed = isIncoming &&
                    log.callStatus.name == 'rejected' || 
                    (isIncoming && log.callStatus.name == 'ended' && log.answer == null);

                return Column(
                  children: [
                    CallTile(
                      username: username.isEmpty ? 'Unknown' : username,
                      dpImage: dpImage,
                      callType: log.type ?? 'audio',
                      direction: direction,
                      time: log.createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
                      isMissed: isMissed,
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.3,
                      color: Colors.grey.shade400,
                      indent: 70,
                    ),
                  ],
                );
              }, childCount: audioLogs.length),
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
      );
    }),
  );
}
}

class CallTile extends StatelessWidget {
  const CallTile({
    super.key,
    required this.username,
    required this.dpImage,
    required this.callType,
    required this.direction,
    required this.time,
    required this.isMissed,
  });

  final String username;
  final String dpImage;
  final String callType;
  final String direction;
  final String time;
  final bool isMissed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: DpCircleImageWidget(imageUrl: dpImage),
      title: Text(
        username,
        maxLines: 1,
        overflow: .ellipsis,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: isMissed ? Colors.red : null,
        ),
      ),
      subtitle: Row(
        spacing: 4,
        children: [
          if (callType == 'audio') ...[
            Icon(
              direction == 'incoming'
                  ? CupertinoIcons.phone_fill_arrow_down_left
                  : CupertinoIcons.phone_fill_arrow_up_right,
              size: 20,
              color: ColorConstants.primaryColor,
            ),
          ] else ...[
            Image.asset(
              direction == 'incoming'
                  ? 'assets/icons/video_incoming.png'
                  : 'assets/icons/video_outgoing.png',
              height: 22,
              color: ColorConstants.primaryColor,
            ),
          ],
          Text(direction),
        ],
      ),
      trailing: Text(
        TimerHelperUtil.formatChatListTime(time),
        style: const TextStyle(color: ColorConstants.grey),
      ),
    );
  }
}
