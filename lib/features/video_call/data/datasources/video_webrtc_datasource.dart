import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';

/// Build ICE servers config from environment variables.
Map<String, dynamic> _getIceServers() {
  final turnUrl = dotenv.env['TURN_SERVER_URL'] ?? '';
  final turnUsername = dotenv.env['TURN_USERNAME'] ?? '';
  final turnPassword = dotenv.env['TURN_PASSWORD'] ?? '';

  return {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {
        'urls': 'turn:$turnUrl',
        'username': turnUsername,
        'credential': turnPassword,
      },
      {
        'urls': 'turn:$turnUrl?transport=tcp',
        'username': turnUsername,
        'credential': turnPassword,
      },
    ],
  };
}

/// Video + audio media constraints for getUserMedia.
const Map<String, dynamic> _videoAudioConstraints = {
  'audio': true,
  'video': {'facingMode': 'user'},
};

/// WebRTC peer connection with video+audio. Manages renderers, tracks, ICE.
class VideoWebrtcDatasource {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  void Function(Map<String, dynamic>)? _onIceCandidate;

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  final StreamController<String> _connectionStateController =
      StreamController<String>.broadcast();

  bool _disposed = false;
  bool _renderersInitialized = false;

  RTCVideoRenderer get localRenderer => _localRenderer;
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;
  Stream<String> get connectionStateStream => _connectionStateController.stream;

  /// Initialize video renderers. Must be called before opening peer connection.
  Future<void> initRenderers() async {
    if (_renderersInitialized) return;
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    _renderersInitialized = true;
  }

  /// Request camera + microphone permissions.
  Future<void> ensurePermissions() async {
    final mic = await Permission.microphone.request();
    final cam = await Permission.camera.request();

    if (mic.isPermanentlyDenied) {
      throw Exception('Microphone permission denied. Enable in app settings.');
    }
    if (!mic.isGranted) {
      throw Exception('Microphone permission is required for video calls.');
    }
    if (cam.isPermanentlyDenied) {
      throw Exception('Camera permission denied. Enable in app settings.');
    }
    if (!cam.isGranted) {
      throw Exception('Camera permission is required for video calls.');
    }
  }

  /// Initialize peer connection and local stream (video+audio).
  Future<void> _ensurePeerConnection() async {
    if (_peerConnection != null) return;

    await _cleanupPeerConnection();

    _peerConnection = await createPeerConnection(
      _getIceServers(),
      <String, dynamic>{},
    );

    _localStream = await Helper.openCamera(_videoAudioConstraints);
    _localRenderer.srcObject = _localStream;

    for (final track in _localStream!.getTracks()) {
      await _peerConnection!.addTrack(track, _localStream!);
    }

    // Receive remote stream and attach to renderer
    _peerConnection!.onAddStream = (MediaStream stream) {
      if (!_disposed) {
        _remoteRenderer.srcObject = stream;
      }
    };

    // Also handle onTrack for newer WebRTC implementations
    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (!_disposed && event.streams.isNotEmpty) {
        _remoteRenderer.srcObject = event.streams.first;
      }
    };

    _peerConnection!.onIceConnectionState = (state) {
      if (_disposed) return;
      if (!_connectionStateController.isClosed) {
        _connectionStateController.add(state.name);
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

  /// Create offer (caller).
  Future<Map<String, dynamic>> createOffer() async {
    await _ensurePeerConnection();
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    return {'type': offer.type, 'sdp': offer.sdp};
  }

  /// Set remote description.
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

  /// Add remote ICE candidate.
  Future<void> addIceCandidate(Map<String, dynamic> candidate) async {
    if (_peerConnection == null) return;
    final c = RTCIceCandidate(
      candidate['candidate'],
      candidate['sdpMid'],
      candidate['sdpMLineIndex'],
    );
    await _peerConnection!.addCandidate(c);
  }

  /// Register callback to send local ICE candidates.
  void setOnIceCandidate(void Function(Map<String, dynamic>) onCandidate) {
    _onIceCandidate = onCandidate;
  }

  /// Toggle microphone mute.
  void toggleMute(bool isMuted) {
    if (_localStream != null) {
      for (final track in _localStream!.getAudioTracks()) {
        track.enabled = !isMuted;
      }
    }
  }

  /// Toggle video track (camera on/off).
  void toggleVideo(bool isOff) {
    if (_localStream != null) {
      for (final track in _localStream!.getVideoTracks()) {
        track.enabled = !isOff;
      }
    }
  }

  /// Switch front/back camera.
  Future<void> switchCamera() async {
    if (_localStream == null) return;
    final videoTracks = _localStream!.getVideoTracks();
    if (videoTracks.isNotEmpty) {
      await Helper.switchCamera(videoTracks.first);
    }
  }

  /// Clean up peer connection and local stream.
  Future<void> _cleanupPeerConnection() async {
    if (_peerConnection != null) {
      await _peerConnection!.close();
      _peerConnection = null;
    }
    if (_localStream != null) {
      _localStream!.getTracks().forEach((t) => t.stop());
      _localStream = null;
    }
    _localRenderer.srcObject = null;
    _remoteRenderer.srcObject = null;
  }

  /// Dispose all resources.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await _connectionStateController.close();
    await _cleanupPeerConnection();
    if (_renderersInitialized) {
      _localRenderer.dispose();
      _remoteRenderer.dispose();
      _renderersInitialized = false;
    }
  }
}
