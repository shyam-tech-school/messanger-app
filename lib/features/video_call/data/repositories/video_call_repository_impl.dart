import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mail_messanger/features/audio_call/domain/entities/call_entity.dart';
import 'package:mail_messanger/features/video_call/domain/repositories/i_video_call_repository.dart';

const String _videoCallsCollection = 'video_calls';
const String _candidatesSubcollection = 'candidates';

class VideoCallRepositoryImpl implements IVideoCallRepository {
  VideoCallRepositoryImpl(this._firestore);

  final FirebaseFirestore _firestore;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _callSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _candidatesSubscription;

  CollectionReference<Map<String, dynamic>> get _calls =>
      _firestore.collection(_videoCallsCollection);

  @override
  Future<void> createCall(
    String callId,
    Map<String, dynamic> offer, {
    required String callerId,
    required String calleeId,
    String? callerName,
    String? calleeName,
    String? callerAvatar,
    String? calleeAvatar,
  }) async {
    await _calls.doc(callId).set({
      'callId': callId,
      'callerId': callerId,
      'calleeId': calleeId,
      'callerName': callerName,
      'calleeName': calleeName,
      'callerAvatar': callerAvatar,
      'calleeAvatar': calleeAvatar,
      'offer': offer,
      'type': 'video',
      'status': CallStatus.ringing.firestoreValue,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<Map<String, dynamic>?> getOffer(String callId) async {
    final doc = await _calls.doc(callId).get();
    final data = doc.data();
    if (data == null) return null;
    final offer = data['offer'];
    if (offer is Map<String, dynamic>) return offer;
    return null;
  }

  @override
  Future<void> saveAnswer(String callId, Map<String, dynamic> answer) async {
    await _calls.doc(callId).update({
      'answer': answer,
      'status': CallStatus.connected.firestoreValue,
    });
  }

  static CallEntity? _docToCallEntity(
    DocumentSnapshot<Map<String, dynamic>>? doc,
  ) {
    if (doc == null || !doc.exists) return null;
    final d = doc.data()!;
    final createdAt = d['createdAt'] is Timestamp
        ? (d['createdAt'] as Timestamp).toDate()
        : null;
    final endedAt = d['endedAt'] is Timestamp
        ? (d['endedAt'] as Timestamp).toDate()
        : null;
    return CallEntity(
      callId: d['callId'] as String? ?? doc.id,
      callerId: d['callerId'] as String? ?? '',
      calleeId: d['calleeId'] as String? ?? '',
      callStatus: CallStatusX.fromString(d['status'] as String?),
      offer: d['offer'] as Map<String, dynamic>?,
      answer: d['answer'] as Map<String, dynamic>?,
      createdAt: createdAt,
      endedAt: endedAt,
      callerName: d['callerName'] as String?,
      calleeName: d['calleeName'] as String?,
      callerAvatar: d['callerAvatar'] as String?,
      calleeAvatar: d['calleeAvatar'] as String?,
      type: d['type'] as String? ?? 'video',
    );
  }

  @override
  Stream<CallEntity?> streamCall(String callId) {
    return _calls.doc(callId).snapshots().map(_docToCallEntity);
  }

  @override
  Stream<CallEntity> streamIncomingCalls(String calleeId) {
    return _calls
        .where('calleeId', isEqualTo: calleeId)
        .where('status', isEqualTo: CallStatus.ringing.firestoreValue)
        .snapshots()
        .expand((snap) => snap.docs)
        .map((doc) => _docToCallEntity(doc)!);
  }

  @override
  Future<void> updateCallStatus(String callId, CallStatus status) async {
    final updates = <String, dynamic>{'status': status.firestoreValue};
    if (status == CallStatus.ended || status == CallStatus.rejected) {
      updates['endedAt'] = FieldValue.serverTimestamp();
    }
    await _calls.doc(callId).update(updates);
  }

  @override
  Future<void> addIceCandidate(
    String callId,
    Map<String, dynamic> candidate,
    String type,
  ) async {
    await _calls.doc(callId).collection(_candidatesSubcollection).add({
      'type': type,
      'sdpMid': candidate['sdpMid'],
      'sdpMLineIndex': candidate['sdpMLineIndex'],
      'candidate': candidate['candidate'],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<Map<String, dynamic>> streamCandidates(
    String callId,
    String excludeType,
  ) {
    return _calls
        .doc(callId)
        .collection(_candidatesSubcollection)
        .where('type', isNotEqualTo: excludeType)
        .snapshots()
        .expand((snap) => snap.docs)
        .map((doc) {
          final d = doc.data();
          return <String, dynamic>{
            'sdpMid': d['sdpMid'],
            'sdpMLineIndex': d['sdpMLineIndex'],
            'candidate': d['candidate'],
          };
        });
  }

  @override
  void cancelListeners() {
    _callSubscription?.cancel();
    _callSubscription = null;
    _candidatesSubscription?.cancel();
    _candidatesSubscription = null;
  }
}
