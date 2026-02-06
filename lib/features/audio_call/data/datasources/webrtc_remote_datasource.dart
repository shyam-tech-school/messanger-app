import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';

/// STUN/TURN configuration. Replace with your coturn server for production.
const Map<String, dynamic> _defaultIceServers = {
  'iceServers': [
    {'urls': 'stun:stun.l.google.com:19302'},

    {
      'urls': 'turn:72.61.174.27:3478',
      'username': 'webrtcuser',
      'credential': 'webrtcpassword',
    },

    // TURN over TCP (fallback – important)
    {
      'urls': 'turn:72.61.174.27:3478?transport=tcp',
      'username': 'webrtcuser',
      'credential': 'webrtcpassword',
    },
  ],
};

/// Audio-only media constraints for getUserMedia.
const Map<String, dynamic> _audioOnlyConstraints = {
  'audio': true,
  'video': false,
};

/// WebRTC peer connection and media (audio only). Handles permission, PC lifecycle, ICE.
class WebrtcRemoteDatasource {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  void Function(Map<String, dynamic>)? _onIceCandidate;
  final StreamController<String> _connectionStateController =
      StreamController<String>.broadcast();
  bool _disposed = false;

  Stream<String> get connectionStateStream => _connectionStateController.stream;

  /// Request microphone permission. Throws if permanently denied.
  Future<void> ensureMicPermission() async {
    final status = await Permission.microphone.request();
    if (status.isPermanentlyDenied) {
      throw Exception(
        'Microphone permission denied. Please enable in app settings.',
      );
    }
    if (!status.isGranted) {
      throw Exception('Microphone permission is required for calls.');
    }
  }

  /// Initialize peer connection and local audio stream. Call once before createOffer/createAnswer.
  Future<void> _ensurePeerConnection() async {
    if (_peerConnection != null) return;
    _peerConnection = await createPeerConnection(
      _defaultIceServers,
      <String, dynamic>{},
    );
    _localStream = await Helper.openCamera(_audioOnlyConstraints);
    for (var track in _localStream!.getTracks()) {
      await _peerConnection!.addTrack(track, _localStream!);
    }
    _peerConnection!.onIceConnectionState = (state) {
      if (_disposed) return;
      final name = state.name;
      if (!_connectionStateController.isClosed) {
        _connectionStateController.add(name);
      }
    };
    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      _onIceCandidate?.call({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };
  }

  /// Create offer (caller). Ensures PC + local stream, then createOffer + setLocalDescription.
  Future<Map<String, dynamic>> createOffer() async {
    await _ensurePeerConnection();
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    return {'type': offer.type, 'sdp': offer.sdp};
  }

  /// Set remote description (offer for callee, answer for caller).
  Future<void> setRemoteDescription(Map<String, dynamic> sdp) async {
    if (_peerConnection == null) await _ensurePeerConnection();
    final desc = RTCSessionDescription(sdp['sdp'], sdp['type']);
    await _peerConnection!.setRemoteDescription(desc);
  }

  /// Create answer (callee). Call after setRemoteDescription(offer).
  Future<Map<String, dynamic>> createAnswer() async {
    if (_peerConnection == null) await _ensurePeerConnection();
    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);
    return {'type': answer.type, 'sdp': answer.sdp};
  }

  /// Add remote ICE candidate. Map must contain sdpMid, sdpMLineIndex, candidate.
  Future<void> addIceCandidate(Map<String, dynamic> candidate) async {
    if (_peerConnection == null) return;
    final c = RTCIceCandidate(
      candidate['candidate'],
      candidate['sdpMid'],
      candidate['sdpMLineIndex'],
    );
    await _peerConnection!.addCandidate(c);
  }

  /// Register callback to send local ICE candidates (e.g. to Firestore). Call before createOffer/createAnswer.
  void setOnIceCandidate(void Function(Map<String, dynamic>) onCandidate) {
    _onIceCandidate = onCandidate;
  }

  /// Close peer connection and stop all tracks. Idempotent.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await _connectionStateController.close();
    _localStream?.getTracks().forEach((t) => t.stop());
    _localStream = null;
    await _peerConnection?.close();
    _peerConnection = null;
  }
}
