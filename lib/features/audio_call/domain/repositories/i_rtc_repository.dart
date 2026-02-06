/// WebRTC peer connection operations (audio only).
abstract class IRTCPRepository {
  /// Request microphone permission; throws if denied.
  Future<void> ensureMicPermission();

  /// Create offer SDP after local description is set. Caller only.
  Future<Map<String, dynamic>> createOffer();

  /// Create answer SDP after remote description (offer) is set. Callee only.
  Future<Map<String, dynamic>> createAnswer();

  /// Set remote description (offer for callee, answer for caller).
  Future<void> setRemoteDescription(Map<String, dynamic> sdp);

  /// Add a remote ICE candidate.
  Future<void> addIceCandidate(Map<String, dynamic> candidate);

  /// Set callback to send local ICE candidates (e.g. to Firestore). Call before createOffer/createAnswer.
  void setOnIceCandidate(void Function(Map<String, dynamic>) onCandidate);

  /// Dispose peer connection and release media resources.
  Future<void> dispose();

  /// Stream of ICE connection state for UI (e.g. connecting, connected, failed).
  Stream<String> get connectionStateStream;
}
