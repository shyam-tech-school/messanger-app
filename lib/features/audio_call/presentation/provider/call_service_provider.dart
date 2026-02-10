import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mail_messanger/features/audio_call/domain/entities/call_entity.dart';
import 'package:mail_messanger/features/audio_call/domain/repositories/i_audio_call_repository.dart';
import 'package:mail_messanger/features/audio_call/domain/repositories/i_rtc_repository.dart';

/// Orchestrates WebRTC + Firestore signaling. Single active call per service instance.
/// Clean up via endCall() or rejectCall() to avoid memory leaks.
class CallServiceProvider extends ChangeNotifier {
  CallServiceProvider({
    required IAudioCallRepository audioRepo,
    required IRTCPRepository rtcRepo,
  }) : _audioRepo = audioRepo,
       _rtcRepo = rtcRepo;

  final IAudioCallRepository _audioRepo;
  final IRTCPRepository _rtcRepo;

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

  bool _isSpeakerOn = false;
  bool get isSpeakerOn => _isSpeakerOn;

  String? get _myUid => FirebaseAuth.instance.currentUser?.uid;

  /// Toggle mute state.
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    notifyListeners();
    await _rtcRepo.toggleMute(_isMuted);
  }

  /// Toggle speaker state.
  Future<void> toggleSpeaker() async {
    _isSpeakerOn = !_isSpeakerOn;
    notifyListeners();
    await _rtcRepo.toggleSpeaker(_isSpeakerOn);
  }

  /// Start an outgoing call. Creates offer, writes to Firestore, listens for answer and ICE.
  Future<void> startCall({
    required String calleeId,
    String? calleeName,
    String? callerName,
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
    );
    notifyListeners();

    await _rtcRepo.ensureMicPermission();
    _rtcRepo.setOnIceCandidate((c) {
      _audioRepo.addIceCandidate(callId, c, 'caller');
    });
    final offer = await _rtcRepo.createOffer();
    await _audioRepo.createCall(
      callId,
      offer,
      callerId: myUid,
      calleeId: calleeId,
      callerName: callerName,
      calleeName: calleeName,
    );
    _currentCall = _currentCall!.copyWith(callStatus: CallStatus.ringing);
    notifyListeners();

    _callSubscription = _audioRepo.streamCall(callId).listen((call) async {
      if (call == null) return;
      _currentCall = call;
      notifyListeners();

      // Only apply remote answer SDP once. Subsequent updates (e.g. status
      // changing from connected -> ended) will still contain the same answer
      // and must NOT call setRemoteDescription again, otherwise WebRTC will
      // throw \"Called in wrong state: stable\".
      if (call.answer != null && !_remoteAnswerApplied) {
        _remoteAnswerApplied = true;
        await _rtcRepo.setRemoteDescription(call.answer!);
      }

      if (call.isTerminal) {
        await _cleanup();
      }
    });

    _candidatesSubscription = _audioRepo
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

  /// Accept an incoming call. Sets remote description (offer), creates answer, writes to Firestore.
  Future<void> answerCall(String callId) async {
    final myUid = _myUid;
    if (myUid == null) throw Exception('Not authenticated');
    if (_currentCall != null) return;

    final offer = await _audioRepo.getOffer(callId);
    if (offer == null) throw Exception('Offer not found');

    _currentCall = CallEntity(
      callId: callId,
      callerId: '', // will be set from stream
      calleeId: myUid,
      callStatus: CallStatus.connected,
    );
    notifyListeners();

    await _rtcRepo.ensureMicPermission();
    _rtcRepo.setOnIceCandidate((c) {
      _audioRepo.addIceCandidate(callId, c, 'callee');
    });
    await _rtcRepo.setRemoteDescription(offer);
    final answer = await _rtcRepo.createAnswer();
    await _audioRepo.saveAnswer(callId, answer);

    _callSubscription = _audioRepo.streamCall(callId).listen((call) {
      if (call == null) return;
      _currentCall = call;
      notifyListeners();
      if (call.isTerminal) _cleanup();
    });

    _candidatesSubscription = _audioRepo
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

  /// Reject call (callee). Updates status and cleans up.
  Future<void> rejectCall(String callId) async {
    await _audioRepo.updateCallStatus(callId, CallStatus.rejected);
    _cleanup();
  }

  /// End call (either party). Updates status, disposes WebRTC, cancels listeners.
  Future<void> endCall() async {
    final callId = _currentCall?.callId;
    if (callId != null) {
      await _audioRepo.updateCallStatus(callId, CallStatus.ended);
    }
    await _cleanup();
  }

  /// Attach to an incoming call (set currentCall from Firestore doc). Used when app receives call.
  void setIncomingCall(CallEntity call) {
    if (_currentCall != null) return;
    _currentCall = call;
    notifyListeners();
  }

  /// Listen to a specific call (for incoming screen). Returns stream of call updates.
  Stream<CallEntity?> listenToCall(String callId) {
    return _audioRepo.streamCall(callId);
  }

  /// Stream of incoming calls for the current user (calleeId == myUid, status ringing).
  Stream<CallEntity> get incomingCallsStream {
    final uid = _myUid;
    if (uid == null || uid.isEmpty) return Stream.empty();
    return _audioRepo.streamIncomingCalls(uid);
  }

  Future<void> _cleanup() async {
    _callSubscription?.cancel();
    _callSubscription = null;
    _candidatesSubscription?.cancel();
    _candidatesSubscription = null;
    _connectionStateSubscription?.cancel();
    _connectionStateSubscription = null;
    _audioRepo.cancelListeners();
    await _rtcRepo.dispose();
    _currentCall = null;
    _connectionState = null;
    _remoteAnswerApplied = false;
    _isMuted = false;
    _isSpeakerOn = false;
    notifyListeners();
  }
}
