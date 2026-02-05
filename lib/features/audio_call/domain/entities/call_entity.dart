enum CallStatus { idle, calling, ringing, connected, ended, error }

class CallEntity {
  final String callId;
  final CallStatus callStatus;

  CallEntity({required this.callId, required this.callStatus});

  CallEntity copyWith({CallStatus? callStatus}) {
    return CallEntity(
      callId: callId,
      callStatus: callStatus ?? this.callStatus,
    );
  }
}
