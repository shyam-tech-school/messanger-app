import 'package:mail_messanger/features/audio_call/domain/repositories/i_audio_call_repository.dart';
import 'package:mail_messanger/features/audio_call/domain/repositories/i_rtc_repository.dart';

class StartCallUsecase {
  final IAudioCallRepository audioCallRepo;
  final IRTCPRepository rtcRepo;

  StartCallUsecase(this.audioCallRepo, this.rtcRepo);

  Future<void> call(
    String callId, {
    required String callerId,
    required String calleeId,
    String? callerName,
    String? calleeName,
  }) async {
    await rtcRepo.ensureMicPermission();
    final offer = await rtcRepo.createOffer();
    await audioCallRepo.createCall(callId, offer,
        callerId: callerId,
        calleeId: calleeId,
        callerName: callerName,
        calleeName: calleeName);
  }
}
