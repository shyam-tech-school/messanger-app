import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mail_messanger/features/audio_call/domain/entities/call_entity.dart';
import 'package:mail_messanger/features/video_call/presentation/provider/video_call_service_provider.dart';
import 'package:provider/provider.dart';

enum VideoCallMode { outgoing, incoming, inCall }

class VideoCallScreen extends StatefulWidget {
  final VideoCallMode mode;
  final String otherUserId;
  final String otherUserName;
  final String? otherPhotoUrl;
  final String? callId;

  const VideoCallScreen({
    super.key,
    required this.mode,
    required this.otherUserId,
    required this.otherUserName,
    this.otherPhotoUrl,
    this.callId,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  StreamSubscription<CallEntity?>? _incomingSubscription;
  String _callDuration = '00:00';
  Timer? _durationTimer;
  DateTime? _connectedAt;
  bool _seenNonNullCall = false;
  bool _localPipDragged = false;
  Offset _pipOffset = const Offset(16, 16);

  /// True once initRenderers() has completed — guards RTCVideoView construction.
  bool _renderersReady = false;

  @override
  void initState() {
    super.initState();
    _initAndStart();
  }

  /// Initialize renderers first, then start/watch the call.
  Future<void> _initAndStart() async {
    final service = context.read<VideoCallServiceProvider>();

    // 1. Initialize renderers — must finish before any RTCVideoView is shown.
    await service.initRenderers();
    if (!mounted) return;
    setState(() => _renderersReady = true);

    // 2. Kick off signaling depending on mode.
    if (widget.mode == VideoCallMode.outgoing && service.currentCall == null) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();
          final name =
              doc.data()?['name'] ??
              currentUser.displayName ??
              currentUser.email ??
              'Unknown';

          if (mounted) {
            await service.startCall(
              calleeId: widget.otherUserId,
              calleeName: widget.otherUserName,
              callerName: name,
            );
          }
        } catch (e) {
          debugPrint('VideoCallScreen: failed to start call: $e');
        }
      }
    }

    // 3. Watch incoming call doc for cancellation before accepting.
    if (widget.mode == VideoCallMode.incoming && widget.callId != null) {
      _incomingSubscription = service.listenToCall(widget.callId!).listen((
        call,
      ) {
        if (call == null) return;
        if (call.isTerminal && mounted) {
          Navigator.of(context).maybePop();
        }
      });
    }
  }

  @override
  void dispose() {
    _incomingSubscription?.cancel();
    _durationTimer?.cancel();
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
      if (mounted) {
        setState(
          () => _callDuration =
              '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
        );
      }
    });
  }

  Future<void> _rejectCall() async {
    final callId =
        widget.callId ??
        context.read<VideoCallServiceProvider>().currentCall?.callId;
    if (callId != null) {
      await context.read<VideoCallServiceProvider>().rejectCall(callId);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _acceptCall() async {
    final callId = widget.callId!;
    await context.read<VideoCallServiceProvider>().answerCall(callId);
    _startDurationTimer();
  }

  Future<void> _endCall() async {
    await context.read<VideoCallServiceProvider>().endCall();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Block the whole screen until renderers are ready — prevents
    // RTCVideoView from being built with an uninitialized renderer.
    if (!_renderersReady) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A2E),
        body: Center(child: CircularProgressIndicator(color: Colors.white54)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<VideoCallServiceProvider>(
        builder: (context, service, _) {
          final call = service.currentCall;
          final isConnected = call?.callStatus == CallStatus.connected;

          // Auto-close when call ends from either side.
          if (call != null && !_seenNonNullCall) {
            _seenNonNullCall = true;
          } else if (call == null && _seenNonNullCall) {
            _seenNonNullCall = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) Navigator.of(context).maybePop();
            });
          }

          if (isConnected && _connectedAt == null) _startDurationTimer();

          return Stack(
            fit: StackFit.expand,
            children: [
              // ── Remote video / waiting screen ──────────────────────────
              _buildRemoteVideo(service, isConnected),

              // ── Dark gradient — top ────────────────────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 180,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.75),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ── Status bar ──────────────────────────────────────────────
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.otherUserName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(blurRadius: 8, color: Colors.black54),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildStatusText(service, isConnected),
                    ],
                  ),
                ),
              ),

              // ── Local video PiP — shown as soon as camera is ready ─────
              _buildLocalPip(service),

              // ── Dark gradient — bottom ─────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 220,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.88),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ── Controls ───────────────────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(child: _buildControls(service, isConnected)),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Remote video fills the background once connected; avatar/name while waiting.
  Widget _buildRemoteVideo(VideoCallServiceProvider service, bool isConnected) {
    if (!isConnected) {
      return Container(
        color: const Color(0xFF1A1A2E),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 64,
                backgroundColor: Colors.white12,
                backgroundImage: (widget.otherPhotoUrl?.isNotEmpty ?? false)
                    ? NetworkImage(widget.otherPhotoUrl!)
                    : null,
                child: (widget.otherPhotoUrl?.isEmpty ?? true)
                    ? const Icon(Icons.person, size: 64, color: Colors.white38)
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                widget.otherUserName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RTCVideoView(
      service.remoteRenderer,
      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      mirror: false,
    );
  }

  /// Local camera PiP — visible whenever the camera is active (even before
  /// the call connects, so the caller can see their own preview while ringing).
  Widget _buildLocalPip(VideoCallServiceProvider service) {
    // Hide PiP only if camera is explicitly turned off by the user.
    if (service.isCameraOff) {
      return Positioned(
        top: 80 + MediaQuery.of(context).padding.top,
        right: 16,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 100,
            height: 140,
            color: Colors.black87,
            child: const Icon(
              Icons.videocam_off,
              color: Colors.white38,
              size: 30,
            ),
          ),
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    const pipW = 100.0;
    const pipH = 140.0;

    if (!_localPipDragged) {
      _pipOffset = Offset(
        size.width - pipW - 16,
        80 + MediaQuery.of(context).padding.top,
      );
    }

    return Positioned(
      left: _pipOffset.dx,
      top: _pipOffset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _localPipDragged = true;
            _pipOffset += details.delta;
            _pipOffset = Offset(
              _pipOffset.dx.clamp(0.0, size.width - pipW),
              _pipOffset.dy.clamp(0.0, size.height - pipH),
            );
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: pipW,
            height: pipH,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white30, width: 1.5),
            ),
            child: RTCVideoView(
              service.localRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              mirror: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusText(VideoCallServiceProvider service, bool isConnected) {
    String text;
    Color color = Colors.white70;

    if (widget.mode == VideoCallMode.incoming && !isConnected) {
      text = 'Incoming video call…';
    } else if (isConnected) {
      text = _callDuration;
      color = const Color(0xFF00E676);
    } else {
      final status = service.currentCall?.callStatus;
      final conn = service.connectionState;
      if (conn == 'connected' || conn == 'completed') {
        text = 'Connected';
      } else if (conn == 'checking' || conn == 'new') {
        text = 'Connecting…';
      } else if (status == CallStatus.ringing) {
        text = 'Ringing…';
      } else {
        text = 'Calling…';
      }
    }

    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 15,
        shadows: const [Shadow(blurRadius: 6, color: Colors.black54)],
      ),
    );
  }

  Widget _buildControls(VideoCallServiceProvider service, bool isConnected) {
    if (widget.mode == VideoCallMode.incoming && !isConnected) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ControlButton(
              icon: CupertinoIcons.phone_down_fill,
              color: Colors.red,
              label: 'Decline',
              onTap: _rejectCall,
            ),
            _ControlButton(
              icon: CupertinoIcons.videocam_fill,
              color: Colors.green,
              label: 'Accept',
              onTap: _acceptCall,
              iconSize: 30,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ControlButton(
            icon: service.isMuted ? Icons.mic_off : Icons.mic,
            color: service.isMuted ? Colors.white : Colors.white24,
            iconColor: service.isMuted ? Colors.black : Colors.white,
            label: service.isMuted ? 'Unmute' : 'Mute',
            onTap: () => service.toggleMute(),
          ),
          _ControlButton(
            icon: service.isCameraOff ? Icons.videocam_off : Icons.videocam,
            color: service.isCameraOff ? Colors.white : Colors.white24,
            iconColor: service.isCameraOff ? Colors.black : Colors.white,
            label: service.isCameraOff ? 'Cam On' : 'Cam Off',
            onTap: () => service.toggleCamera(),
          ),
          _ControlButton(
            icon: Icons.flip_camera_ios,
            color: Colors.white24,
            label: 'Flip',
            onTap: () => service.switchCamera(),
          ),
          _ControlButton(
            icon: CupertinoIcons.phone_down_fill,
            color: Colors.red,
            label: 'End',
            onTap: _endCall,
            iconSize: 28,
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final double iconSize;

  const _ControlButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.iconColor = Colors.white,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
