abstract class IAuthRepository {
  Future<String> sendOtp(String phoneNumber);
  Future<void> verifyOtp(String verificationId, String otp);
}
