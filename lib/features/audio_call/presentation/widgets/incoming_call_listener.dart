import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/features/audio_call/presentation/pages/audio_call_screen.dart';
import 'package:mail_messanger/features/audio_call/presentation/provider/call_service_provider.dart';
import 'package:provider/provider.dart';

/// Listens to incoming calls and navigates to [AudioCallScreen] with mode incoming.
/// Place under [MaterialApp] and where [CallServiceProvider] is available.
class IncomingCallListener extends StatefulWidget {
  const IncomingCallListener({super.key, required this.child});

  final Widget child;

  @override
  State<IncomingCallListener> createState() => _IncomingCallListenerState();
}

class _IncomingCallListenerState extends State<IncomingCallListener> {
  StreamSubscription? _subscription;
  final Set<String> _shownCallIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _listen());
  }

  void _listen() {
    final service = context.read<CallServiceProvider>();
    _subscription?.cancel();
    _subscription = service.incomingCallsStream.listen((call) {
      if (!mounted) return;
      if (_shownCallIds.contains(call.callId)) return;
      _shownCallIds.add(call.callId);
      Navigator.of(context)
          .pushNamed(
            RouteName.audioCallScreen,
            arguments: {
              'mode': AudioCallMode.incoming,
              'callId': call.callId,
              'otherUserId': call.callerId,
              'otherUserName': call.callerName ?? 'Unknown',
              'otherPhotoUrl': null,
            },
          )
          .whenComplete(() {
            _shownCallIds.remove(call.callId);
          });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
