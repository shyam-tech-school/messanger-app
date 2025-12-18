import 'package:mail_messanger/features/otp/domain/repositories/i_auth_repository.dart';

class SendOtpUsecase {
  final IAuthRepository repository;

  SendOtpUsecase(this.repository);

  Future<String> call(String phoneNumber) {
    return repository.sendOtp(phoneNumber);
  }
}
