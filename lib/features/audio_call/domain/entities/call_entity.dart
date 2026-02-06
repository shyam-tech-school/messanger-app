/// Call status for signaling and UI.
enum CallStatus {
  idle,
  calling,   // caller: dialing
  ringing,   // callee: incoming
  connected,
  ended,
  rejected,
  error,
}

extension CallStatusX on CallStatus {
  String get firestoreValue => name;

  static CallStatus fromString(String? value) {
    if (value == null) return CallStatus.idle;
    return CallStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => CallStatus.idle,
    );
  }
}

/// Domain entity for an active or past call.
class CallEntity {
  final String callId;
  final String callerId;
  final String calleeId;
  final CallStatus callStatus;
  final Map<String, dynamic>? offer;
  final Map<String, dynamic>? answer;
  final DateTime? createdAt;
  final DateTime? endedAt;
  final String? callerName;
  final String? calleeName;

  const CallEntity({
    required this.callId,
    required this.callerId,
    required this.calleeId,
    required this.callStatus,
    this.offer,
    this.answer,
    this.createdAt,
    this.endedAt,
    this.callerName,
    this.calleeName,
  });

  CallEntity copyWith({
    String? callId,
    String? callerId,
    String? calleeId,
    CallStatus? callStatus,
    Map<String, dynamic>? offer,
    Map<String, dynamic>? answer,
    DateTime? createdAt,
    DateTime? endedAt,
    String? callerName,
    String? calleeName,
  }) {
    return CallEntity(
      callId: callId ?? this.callId,
      callerId: callerId ?? this.callerId,
      calleeId: calleeId ?? this.calleeId,
      callStatus: callStatus ?? this.callStatus,
      offer: offer ?? this.offer,
      answer: answer ?? this.answer,
      createdAt: createdAt ?? this.createdAt,
      endedAt: endedAt ?? this.endedAt,
      callerName: callerName ?? this.callerName,
      calleeName: calleeName ?? this.calleeName,
    );
  }

  /// Whether this user is the caller (vs callee).
  bool isCaller(String myUserId) => callerId == myUserId;

  /// Whether the call is in a terminal state (ended, rejected, error).
  bool get isTerminal =>
      callStatus == CallStatus.ended ||
      callStatus == CallStatus.rejected ||
      callStatus == CallStatus.error;
}
