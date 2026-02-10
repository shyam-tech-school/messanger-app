import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/color_constants.dart';
import '../../domain/entities/call_entity.dart';
import '../provider/call_service_provider.dart';
import '../widgets/call_action_button.dart';
import '../widgets/call_screen_bottom_option_widget.dart';

/// Mode: outgoing (caller), incoming (callee), or in-call (both).
enum AudioCallMode { outgoing, incoming, inCall }

class AudioCallScreen extends StatefulWidget {
  /// For outgoing: pass other user; callId is created by service.
  /// For incoming: pass callId and caller display info.
  final AudioCallMode mode;
  final String otherUserId;
  final String otherUserName;
  final String? otherPhotoUrl;
  final String? callId;

  const AudioCallScreen({
    super.key,
    required this.mode,
    required this.otherUserId,
    required this.otherUserName,
    this.otherPhotoUrl,
    this.callId,
  });

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  StreamSubscription<CallEntity?>? _incomingSubscription;
  String _callDuration = '00:00';
  Timer? _durationTimer;
  DateTime? _connectedAt;
  // Becomes true once we've seen a real call on this screen. If the call
  // later disappears (currentCall becomes null), we auto-close the screen so
  // that when the *other* user hangs up, this side also exits the call UI.
  bool _seenNonNullCall = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _scale = Tween<double>(
      begin: 0.8,
      end: 1.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final service = context.read<CallServiceProvider>();
      if (widget.mode == AudioCallMode.outgoing &&
          service.currentCall == null) {
        service.startCall(
          calleeId: widget.otherUserId,
          calleeName: widget.otherUserName,
        );
      }

      // For incoming calls, watch the call document so that if the caller
      // ends or rejects the call before we answer, this screen auto-closes.
      if (widget.mode == AudioCallMode.incoming && widget.callId != null) {
        _incomingSubscription = service.listenToCall(widget.callId!).listen((
          call,
        ) {
          if (call == null) return;
          if (call.isTerminal && mounted) {
            Navigator.of(context).maybePop();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _incomingSubscription?.cancel();
    _durationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startDurationTimer() {
    _connectedAt ??= DateTime.now();
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_connectedAt == null) return;
      final elapsed = DateTime.now().difference(_connectedAt!).inSeconds;
      final m = elapsed ~/ 60;
      final s = elapsed % 60;
      if (mounted)
        setState(
          () => _callDuration =
              '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
        );
    });
  }

  Future<void> _rejectCall() async {
    final callId =
        widget.callId ??
        context.read<CallServiceProvider>().currentCall?.callId;
    if (callId != null) {
      await context.read<CallServiceProvider>().rejectCall(callId);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _acceptCall() async {
    final callId = widget.callId!;
    await context.read<CallServiceProvider>().answerCall(callId);
    _startDurationTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23243A),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: AppBar(
            backgroundColor: const Color(0xFF23243A),
            title: Column(
              children: [
                Text(
                  widget.otherUserName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Consumer<CallServiceProvider>(
                  builder: (_, service, __) {
                    final status = service.currentCall?.callStatus;
                    final isConnected = status == CallStatus.connected;
                    if (isConnected && _connectedAt == null)
                      _startDurationTimer();
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isConnected) ...[
                          const Icon(
                            Icons.fiber_manual_record,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _callDuration,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ] else
                          Text(
                            _statusText(service),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            _buildTopSection(),
            const Spacer(),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  String _statusText(CallServiceProvider service) {
    if (widget.mode == AudioCallMode.incoming) return 'Incoming call…';
    final status = service.currentCall?.callStatus;
    final conn = service.connectionState;
    if (status == CallStatus.connected) return 'Connected';
    if (conn == 'connected' || conn == 'completed') return 'Connected';
    if (conn == 'checking' || conn == 'new') return 'Connecting…';
    if (status == CallStatus.ringing) return 'Ringing…';
    return 'Calling…';
  }

  Widget _buildTopSection() {
    return Column(
      children: [
        SizedBox(
          height: 230,
          width: 230,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scale.value,
                    child: Opacity(
                      opacity: _opacity.value,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange.withOpacity(0.3),
                        ),
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scale.value * 1.2,
                    child: Opacity(
                      opacity: _opacity.value * 0.7,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange.withOpacity(0.2),
                        ),
                      ),
                    ),
                  );
                },
              ),
              CircleAvatar(
                radius: 80,
                backgroundColor: ColorConstants.primaryColor.withOpacity(0.3),
                child:
                    widget.otherPhotoUrl == null ||
                        widget.otherPhotoUrl!.isEmpty
                    ? const Icon(Icons.person, size: 40, color: Colors.white)
                    : Image.network(widget.otherPhotoUrl!, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Consumer<CallServiceProvider>(
      builder: (context, service, _) {
        final call = service.currentCall;
        final isConnected = call?.callStatus == CallStatus.connected;

        // Auto-close when a previously active call has ended (either side).
        if (call != null && !_seenNonNullCall) {
          _seenNonNullCall = true;
        } else if (call == null && _seenNonNullCall) {
          _seenNonNullCall = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).maybePop();
            }
          });
        }

        if (widget.mode == AudioCallMode.incoming && !isConnected) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ColorConstants.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CallActionButton(
                  icon: CupertinoIcons.phone_down_fill,
                  color: Colors.red,
                  ontap: _rejectCall,
                ),
                CallActionButton(
                  icon: CupertinoIcons.phone_fill,
                  color: Colors.green,
                  ontap: _acceptCall,
                ),
              ],
            ),
          );
        }

        return const CallScreenBottomOptionWidget();
      },
    );
  }
}
