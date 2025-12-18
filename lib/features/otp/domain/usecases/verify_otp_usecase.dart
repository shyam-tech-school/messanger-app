import 'package:mail_messanger/features/otp/domain/repositories/i_auth_repository.dart';

class VerifyOtpUsecase {
  final IAuthRepository repository;

  VerifyOtpUsecase(this.repository);

  Future<void> call(String verificationId, String otp) async {
    return repository.verifyOtp(verificationId, otp);
  }
}
