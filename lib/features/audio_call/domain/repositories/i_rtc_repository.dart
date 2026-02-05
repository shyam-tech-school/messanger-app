abstract class IRTCPRepository {
  Future<void> ensureMicPermission();
  Future<Map<String, dynamic>> createOffer();
  Future<Map<String, dynamic>> createAnswer();
  Future<void> setRemoteDescription(Map<String, dynamic> sdp);
  Future<void> dispose();
}
