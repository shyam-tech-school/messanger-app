import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mail_messanger/features/audio_call/domain/entities/call_entity.dart';
import 'package:mail_messanger/features/video_call/domain/repositories/i_video_call_repository.dart';
import 'package:mail_messanger/features/video_call/domain/repositories/i_video_rtc_repository.dart';

/// Orchestrates video WebRTC + Firestore signaling. Single active call per instance.
class VideoCallServiceProvider extends ChangeNotifier {
  VideoCallServiceProvider({
    required IVideoCallRepository videoRepo,
    required IVideoRtcRepository rtcRepo,
  }) : _videoRepo = videoRepo,
       _rtcRepo = rtcRepo;

  final IVideoCallRepository _videoRepo;
  final IVideoRtcRepository _rtcRepo;

  CallEntity? _currentCall;
  StreamSubscription<CallEntity?>? _callSubscription;
  StreamSubscription<Map<String, dynamic>>? _candidatesSubscription;
  StreamSubscription<String>? _connectionStateSubscription;

  CallEntity? get currentCall => _currentCall;
  String? get connectionState => _connectionState;
  String? _connectionState;
  bool _remoteAnswerApplied = false;

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  bool _isCameraOff = false;
  bool get isCameraOff => _isCameraOff;

  RTCVideoRenderer get localRenderer => _rtcRepo.localRenderer;
  RTCVideoRenderer get remoteRenderer => _rtcRepo.remoteRenderer;

  /// Initialize video renderers. Must be called before building RTCVideoView.
  Future<void> initRenderers() => _rtcRepo.initRenderers();

  String? get _myUid => FirebaseAuth.instance.currentUser?.uid;

  /// Start an outgoing video call.
  Future<void> startCall({
    required String calleeId,
    String? calleeName,
    String? callerName,
    String? callerAvatar,
    String? calleeAvatar,
  }) async {
    final myUid = _myUid;
    if (myUid == null) throw Exception('Not authenticated');
    if (_currentCall != null) return;

    final callId =
        '${myUid}_${calleeId}_${DateTime.now().millisecondsSinceEpoch}';
    _currentCall = CallEntity(
      callId: callId,
      callerId: myUid,
      calleeId: calleeId,
      callStatus: CallStatus.calling,
      callerName: callerName,
      calleeName: calleeName,
      callerAvatar: callerAvatar,
      calleeAvatar: calleeAvatar,
    );
    notifyListeners();

    await _rtcRepo.initRenderers();
    await _rtcRepo.ensurePermissions();
    _rtcRepo.setOnIceCandidate((c) {
      _videoRepo.addIceCandidate(callId, c, 'caller');
    });
    final offer = await _rtcRepo.createOffer();
    await _videoRepo.createCall(
      callId,
      offer,
      callerId: myUid,
      calleeId: calleeId,
      callerName: callerName,
      calleeName: calleeName,
      callerAvatar: callerAvatar,
      calleeAvatar: calleeAvatar,
    );
    _currentCall = _currentCall!.copyWith(callStatus: CallStatus.ringing);
    notifyListeners();

    _callSubscription = _videoRepo.streamCall(callId).listen((call) async {
      if (call == null) return;
      _currentCall = call;
      notifyListeners();

      if (call.answer != null && !_remoteAnswerApplied) {
        _remoteAnswerApplied = true;
        await _rtcRepo.setRemoteDescription(call.answer!);
      }

      if (call.isTerminal) {
        await _cleanup();
      }
    });

    _candidatesSubscription = _videoRepo
        .streamCandidates(callId, 'caller')
        .listen((candidate) {
          _rtcRepo.addIceCandidate(candidate);
        });

    _connectionStateSubscription = _rtcRepo.connectionStateStream.listen((
      state,
    ) {
      _connectionState = state;
      notifyListeners();
    });
  }

  /// Accept an incoming video call.
  Future<void> answerCall(String callId) async {
    final myUid = _myUid;
    if (myUid == null) throw Exception('Not authenticated');
    if (_currentCall != null) return;

    final offer = await _videoRepo.getOffer(callId);
    if (offer == null) throw Exception('Offer not found');

    _currentCall = CallEntity(
      callId: callId,
      callerId: '',
      calleeId: myUid,
      callStatus: CallStatus.connected,
    );
    notifyListeners();

    await _rtcRepo.initRenderers();
    await _rtcRepo.ensurePermissions();
    _rtcRepo.setOnIceCandidate((c) {
      _videoRepo.addIceCandidate(callId, c, 'callee');
    });
    await _rtcRepo.setRemoteDescription(offer);
    final answer = await _rtcRepo.createAnswer();
    await _videoRepo.saveAnswer(callId, answer);

    _callSubscription = _videoRepo.streamCall(callId).listen((call) {
      if (call == null) return;
      _currentCall = call;
      notifyListeners();
      if (call.isTerminal) _cleanup();
    });

    _candidatesSubscription = _videoRepo
        .streamCandidates(callId, 'callee')
        .listen((candidate) {
          _rtcRepo.addIceCandidate(candidate);
        });

    _connectionStateSubscription = _rtcRepo.connectionStateStream.listen((
      state,
    ) {
      _connectionState = state;
      notifyListeners();
    });
  }

  /// Reject incoming call (callee).
  Future<void> rejectCall(String callId) async {
    await _videoRepo.updateCallStatus(callId, CallStatus.rejected);
    _cleanup();
  }

  /// End call (either party).
  Future<void> endCall() async {
    final callId = _currentCall?.callId;
    if (callId != null) {
      await _videoRepo.updateCallStatus(callId, CallStatus.ended);
    }
    await _cleanup();
  }

  /// Toggle mute.
  void toggleMute() {
    _isMuted = !_isMuted;
    _rtcRepo.toggleMute(_isMuted);
    notifyListeners();
  }

  /// Toggle camera on/off.
  void toggleCamera() {
    _isCameraOff = !_isCameraOff;
    _rtcRepo.toggleVideo(_isCameraOff);
    notifyListeners();
  }

  /// Switch front/back camera.
  Future<void> switchCamera() async {
    await _rtcRepo.switchCamera();
  }

  /// Attach incoming call to this provider (called from IncomingVideoCallListener).
  void setIncomingCall(CallEntity call) {
    if (_currentCall != null) return;
    _currentCall = call;
    notifyListeners();
  }

  /// Listen to a specific call (for pre-accept watching).
  Stream<CallEntity?> listenToCall(String callId) {
    return _videoRepo.streamCall(callId);
  }

  /// Stream of incoming video calls for the current user.
  Stream<CallEntity> get incomingCallsStream {
    final uid = _myUid;
    if (uid == null || uid.isEmpty) return Stream.empty();
    return _videoRepo.streamIncomingCalls(uid);
  }

  Future<void> _cleanup() async {
    _callSubscription?.cancel();
    _callSubscription = null;
    _candidatesSubscription?.cancel();
    _candidatesSubscription = null;
    _connectionStateSubscription?.cancel();
    _connectionStateSubscription = null;
    _videoRepo.cancelListeners();
    await _rtcRepo.dispose();
    _currentCall = null;
    _connectionState = null;
    _remoteAnswerApplied = false;
    _isMuted = false;
    _isCameraOff = false;
    notifyListeners();
  }
}
