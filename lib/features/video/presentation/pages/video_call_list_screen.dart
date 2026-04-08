import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/features/audio_call/domain/entities/call_entity.dart';
import 'package:mail_messanger/features/video_call/presentation/pages/video_call_screen.dart';
import 'package:provider/provider.dart';
import 'package:mail_messanger/features/call/presentation/provider/call_history_provider.dart';

class VideoCallListScreen extends StatelessWidget {
  const VideoCallListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Video Calls",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontFamily: 'LuckiestGuy',
            color: ColorConstants.primaryColor,
            letterSpacing: 2,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: myUid == null
          ? const Center(child: Text('Not signed in'))
          : Consumer<CallHistoryProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Filter for video calls only
                final videoLogs = provider.callLogs
                    .where((log) => log.type == 'video')
                    .toList();

                if (videoLogs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.videocam_off,
                          size: 64,
                          color: Colors.white24,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No video calls yet',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: videoLogs.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    thickness: 0.3,
                    color: Colors.grey.shade800,
                    indent: 72,
                  ),
                  itemBuilder: (context, index) {
                    final d = videoLogs[index];
                    final isOutgoing = d.callerId == myUid;
                    final otherUserId = isOutgoing
                        ? d.calleeId
                        : d.callerId;
                    final otherName = isOutgoing
                        ? (d.calleeName ?? 'Unknown')
                        : (d.callerName ?? 'Unknown');
                    final status = d.callStatus;
                    final isMissed =
                        !isOutgoing &&
                        (status == CallStatus.ended ||
                            status == CallStatus.rejected);
                    final createdAt = d.createdAt;

                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteName.videoCallScreen,
                          arguments: {
                            'mode': VideoCallMode.outgoing,
                            'otherUserId': otherUserId,
                            'otherUserName': otherName,
                            'otherPhotoUrl': null,
                          },
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: ColorConstants.primaryColor
                            .withOpacity(0.15),
                        child: const Icon(
                          Icons.videocam,
                          color: ColorConstants.primaryColor,
                        ),
                      ),
                      title: Text(
                        otherName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isMissed ? Colors.red : null,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            isOutgoing ? Icons.call_made : Icons.call_received,
                            size: 14,
                            color: isMissed ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isOutgoing
                                ? 'Outgoing'
                                : (isMissed ? 'Missed' : 'Incoming'),
                            style: TextStyle(
                              color: isMissed ? Colors.red : Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 6),
                          _StatusBadge(status),
                        ],
                      ),
                      trailing: createdAt != null
                          ? Text(
                              _formatTime(createdAt),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            )
                          : null,
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, RouteName.contactListScreen);
        },
        child: const Icon(Icons.videocam, color: Colors.white),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return DateFormat('h:mm a').format(dt);
    }
    return DateFormat('MMM d').format(dt);
  }
}

class _StatusBadge extends StatelessWidget {
  final CallStatus status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case CallStatus.connected:
      case CallStatus.ended:
        color = Colors.green;
        label = 'Completed';
        break;
      case CallStatus.rejected:
        color = Colors.red;
        label = 'Declined';
        break;
      case CallStatus.ringing:
        color = Colors.orange;
        label = 'Missed';
        break;
      default:
        return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
