class WebrtcRemoteDatasource {
  Future<void> ensureMicPermission() async {
    // permission handler logic
  }

  Future<Map<String, dynamic>> createOffer() async {
    return {};
    // flutter webrtc logic
  }

  Future<Map<String, dynamic>> createAnswer() async {
    return {};
  }

  Future<void> setRemoteDescription(Map<String, dynamic> sdp) async {}

  Future<void> dispose() async {}
}
