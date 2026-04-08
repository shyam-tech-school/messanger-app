import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mail_messanger/features/audio_call/domain/entities/call_entity.dart';
import 'package:mail_messanger/features/call/domain/repositories/call_history_repository.dart';

class CallHistoryRepositoryImpl implements ICallHistoryRepository {
  final FirebaseFirestore _firestore;

  CallHistoryRepositoryImpl(this._firestore);

  @override
  Stream<List<CallEntity>> getCallLogs(String userId) {
    // We listen to both collections where callerId == userId OR calleeId == userId.
    // However, Firestore limits 'Filter.or' across different collections (unless using Collection Group queries which requires an index).
    // The easiest way is to combine two streams: one for audio calls, one for video calls.
    
    final audioStream = _firestore
        .collection('calls')
        .where(Filter.or(
          Filter('callerId', isEqualTo: userId),
          Filter('calleeId', isEqualTo: userId),
        ))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => _docToCallEntity(doc, 'audio'))
            .whereType<CallEntity>()
            .toList());

    final videoStream = _firestore
        .collection('video_calls')
        .where(Filter.or(
          Filter('callerId', isEqualTo: userId),
          Filter('calleeId', isEqualTo: userId),
        ))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => _docToCallEntity(doc, 'video'))
            .whereType<CallEntity>()
            .toList());

    // Combine both streams into a single list
    return _combineStreams(audioStream, videoStream);
  }

  Stream<List<CallEntity>> _combineStreams(
    Stream<List<CallEntity>> stream1,
    Stream<List<CallEntity>> stream2,
  ) {
    List<CallEntity> list1 = [];
    List<CallEntity> list2 = [];

    late StreamController<List<CallEntity>> controller;
    StreamSubscription<List<CallEntity>>? sub1;
    StreamSubscription<List<CallEntity>>? sub2;

    void emitMerged() {
      if (controller.isClosed) return;
      final merged = [...list1, ...list2];
      merged.sort((a, b) {
        final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
      controller.add(merged);
    }

    controller = StreamController<List<CallEntity>>.broadcast(
      onListen: () {
        sub1 = stream1.listen(
          (data) { list1 = data; emitMerged(); },
          onError: controller.addError,
        );
        sub2 = stream2.listen(
          (data) { list2 = data; emitMerged(); },
          onError: controller.addError,
        );
      },
      onCancel: () {
        sub1?.cancel();
        sub2?.cancel();
      },
    );

    return controller.stream;
  }

  CallEntity? _docToCallEntity(DocumentSnapshot<Map<String, dynamic>> doc, String defaultType) {
    if (!doc.exists) return null;
    final d = doc.data()!;
    final createdAt = d['createdAt'] is Timestamp
        ? (d['createdAt'] as Timestamp).toDate()
        : null;
    final endedAt = d['endedAt'] is Timestamp
        ? (d['endedAt'] as Timestamp).toDate()
        : null;

    final type = d['type'] as String? ?? defaultType;

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
      type: type,
    );
  }
}
