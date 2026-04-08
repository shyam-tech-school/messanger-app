import 'package:mail_messanger/features/audio_call/domain/entities/call_entity.dart';

abstract class ICallHistoryRepository {
  /// Stream both audio and video call logs for the given userId.
  /// This fetches calls where the user is either the caller or the callee.
  Stream<List<CallEntity>> getCallLogs(String userId);
}
