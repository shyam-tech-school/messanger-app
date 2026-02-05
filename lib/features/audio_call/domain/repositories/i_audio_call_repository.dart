abstract class IAudioCallRepository {
  Future<void> createCall(String callId, Map<String, dynamic> offer);
  Future<Map<String, dynamic>> getOffer(String callId);
  Future<void> saveAnswer(String callId, Map<String, dynamic> answer);
}
