import 'package:flutter_webrtc/flutter_webrtc.dart';

/// WebRTC peer connection + media operations for video calls.
abstract class IVideoRtcRepository {
  /// Local video renderer (from getUserMedia with video+audio).
  RTCVideoRenderer get localRenderer;

  /// Remote video renderer (from remote peer's stream).
  RTCVideoRenderer get remoteRenderer;

  /// Initialize renderers. Must be called before use.
  Future<void> initRenderers();

  /// Request camera + microphone permissions; throws if denied.
  Future<void> ensurePermissions();

  /// Create offer SDP after local description is set. Caller only.
  Future<Map<String, dynamic>> createOffer();

  /// Create answer SDP after remote description (offer) is set. Callee only.
  Future<Map<String, dynamic>> createAnswer();

  /// Set remote description (offer for callee, answer for caller).
  Future<void> setRemoteDescription(Map<String, dynamic> sdp);

  /// Add a remote ICE candidate.
  Future<void> addIceCandidate(Map<String, dynamic> candidate);

  /// Set callback to send local ICE candidates (e.g. to Firestore).
  void setOnIceCandidate(void Function(Map<String, dynamic>) onCandidate);

  /// Toggle microphone mute state.
  void toggleMute(bool isMuted);

  /// Toggle video track (camera on/off).
  void toggleVideo(bool isOff);

  /// Switch front/back camera.
  Future<void> switchCamera();

  /// Stream of ICE connection state for UI (connecting, connected, failed, etc.)
  Stream<String> get connectionStateStream;

  /// Dispose peer connection, stop tracks, and release renderers.
  Future<void> dispose();
}
