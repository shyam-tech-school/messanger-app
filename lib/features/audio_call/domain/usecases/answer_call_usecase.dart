import 'package:mail_messanger/features/audio_call/domain/repositories/i_audio_call_repository.dart';
import 'package:mail_messanger/features/audio_call/domain/repositories/i_rtc_repository.dart';

class AnswerCallUsecase {
  final IAudioCallRepository iAudioRepo;
  final IRTCPRepository irtcpRepo;

  AnswerCallUsecase(this.iAudioRepo, this.irtcpRepo);

  Future<void> call(String callId) async {
    final offer = await iAudioRepo.getOffer(callId);
    await irtcpRepo.setRemoteDescription(offer);
    final answer = await irtcpRepo.createAnswer();
    await iAudioRepo.saveAnswer(callId, answer);
  }
}
