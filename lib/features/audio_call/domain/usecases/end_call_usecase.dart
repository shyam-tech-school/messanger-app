import 'package:mail_messanger/features/audio_call/domain/repositories/i_rtc_repository.dart';

class EndCallUsecase {
  final IRTCPRepository irtcpRepo;

  EndCallUsecase(this.irtcpRepo);

  Future<void> call() async {
    await irtcpRepo.dispose();
  }
}
