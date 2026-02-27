import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/features/video_call/presentation/pages/video_call_screen.dart';
import 'package:mail_messanger/features/video_call/presentation/provider/video_call_service_provider.dart';
import 'package:provider/provider.dart';

/// Listens to incoming video calls and navigates to [VideoCallScreen] with incoming mode.
/// Place this wrapped around your main navigation widget, beneath [MultiProvider].
class IncomingVideoCallListener extends StatefulWidget {
  const IncomingVideoCallListener({super.key, required this.child});

  final Widget child;

  @override
  State<IncomingVideoCallListener> createState() =>
      _IncomingVideoCallListenerState();
}

class _IncomingVideoCallListenerState extends State<IncomingVideoCallListener> {
  StreamSubscription? _subscription;
  final Set<String> _shownCallIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _listen());
  }

  void _listen() {
    final service = context.read<VideoCallServiceProvider>();
    _subscription?.cancel();
    _subscription = service.incomingCallsStream.listen(
      (call) {
        debugPrint(
          'IncomingVideoCallListener: Received call ${call.callId} from ${call.callerName}',
        );

        if (!mounted) return;
        if (_shownCallIds.contains(call.callId)) return;

        _shownCallIds.add(call.callId);
        debugPrint(
          'IncomingVideoCallListener: Navigating to video call screen',
        );

        Navigator.of(context)
            .pushNamed(
              RouteName.videoCallScreen,
              arguments: {
                'mode': VideoCallMode.incoming,
                'callId': call.callId,
                'otherUserId': call.callerId,
                'otherUserName': call.callerName ?? 'Unknown',
                'otherPhotoUrl': null,
              },
            )
            .whenComplete(() {
              _shownCallIds.remove(call.callId);
            });
      },
      onError: (e) {
        debugPrint('IncomingVideoCallListener Error: $e');
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
