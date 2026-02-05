import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mail_messanger/features/audio_call/domain/repositories/i_audio_call_repository.dart';

class AudiocallRepositoryImpl implements IAudioCallRepository {
  final FirebaseFirestore firestore;

  AudiocallRepositoryImpl(this.firestore);

  @override
  Future<void> createCall(String callId, Map<String, dynamic> offer) async {
    // TODO: implement createCall
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getOffer(String callId) async {
    // TODO: implement getOffer
    throw UnimplementedError();
  }

  @override
  Future<void> saveAnswer(String callId, Map<String, dynamic> answer) async {
    // TODO: implement saveAnswer
    throw UnimplementedError();
  }
}
