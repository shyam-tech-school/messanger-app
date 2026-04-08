/// Call status for signaling and UI.
enum CallStatus {
  idle,
  calling, // caller: dialing
  ringing, // callee: incoming
  connected,
  ended,
  rejected,
  error,
}

extension CallStatusX on CallStatus {
  String get firestoreValue {
    switch (this) {
      case CallStatus.idle:
        return 'idle';
      case CallStatus.calling:
        return 'calling';
      case CallStatus.ringing:
        return 'ringing';
      case CallStatus.connected:
        return 'connected';
      case CallStatus.ended:
        return 'ended';
      case CallStatus.rejected:
        return 'rejected';
      case CallStatus.error:
        return 'error';
    }
  }

  static CallStatus fromString(String? value) {
    if (value == null) return CallStatus.idle;
    switch (value) {
      case 'idle':
        return CallStatus.idle;
      case 'calling':
        return CallStatus.calling;
      case 'ringing':
        return CallStatus.ringing;
      case 'connected':
        return CallStatus.connected;
      case 'ended':
        return CallStatus.ended;
      case 'rejected':
        return CallStatus.rejected;
      case 'error':
        return CallStatus.error;
      default:
        return CallStatus.idle;
    }
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
  final String? callerAvatar;
  final String? calleeAvatar;
  final String? type;

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
    this.callerAvatar,
    this.calleeAvatar,
    this.type,
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
    String? callerAvatar,
    String? calleeAvatar,
    String? type,
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
      callerAvatar: callerAvatar ?? this.callerAvatar,
      calleeAvatar: calleeAvatar ?? this.calleeAvatar,
      type: type ?? this.type,
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
