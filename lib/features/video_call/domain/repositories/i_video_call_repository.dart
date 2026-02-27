import 'package:mail_messanger/features/audio_call/domain/entities/call_entity.dart';

/// Signaling via Firestore for video calls: create call, offer/answer, ICE candidates, status.
abstract class IVideoCallRepository {
  /// Create a new video call document with offer; status = ringing.
  Future<void> createCall(
    String callId,
    Map<String, dynamic> offer, {
    required String callerId,
    required String calleeId,
    String? callerName,
    String? calleeName,
  });

  /// Get current offer from call document (callee).
  Future<Map<String, dynamic>?> getOffer(String callId);

  /// Save answer and set status to connected.
  Future<void> saveAnswer(String callId, Map<String, dynamic> answer);

  /// Stream call document updates (offer, answer, status).
  Stream<CallEntity?> streamCall(String callId);

  /// Stream incoming video calls for a user (calleeId == userId and status == ringing).
  Stream<CallEntity> streamIncomingCalls(String calleeId);

  /// Update call status (e.g. ended, rejected).
  Future<void> updateCallStatus(String callId, CallStatus status);

  /// Add an ICE candidate to the call's candidates subcollection.
  Future<void> addIceCandidate(
    String callId,
    Map<String, dynamic> candidate,
    String type,
  );

  /// Stream ICE candidates for the other peer (caller listens for callee, callee for caller).
  Stream<Map<String, dynamic>> streamCandidates(
    String callId,
    String excludeType,
  );

  /// Cancel all active listeners for this call.
  void cancelListeners();
}
