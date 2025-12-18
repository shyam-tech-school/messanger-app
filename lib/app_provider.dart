import 'package:firebase_auth/firebase_auth.dart';
import 'package:mail_messanger/features/otp/data/repositories/firebase_auth_repository.dart';
import 'package:mail_messanger/features/otp/domain/usecases/send_otp_usecase.dart';
import 'package:mail_messanger/features/otp/domain/usecases/verify_otp_usecase.dart';
import 'package:mail_messanger/features/otp/presentation/provider/otp_timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:mail_messanger/features/otp/presentation/provider/auth_provider.dart';

class AppProvider {
  static List<SingleChildWidget> provider = [
    ChangeNotifierProvider(create: (_) => OtpTimerProvider()),
    ChangeNotifierProvider(
      create: (_) {
        final repository = FirebaseAuthRepository(FirebaseAuth.instance);

        return OTPAuthProvider(
          sendOtpUsecase: SendOtpUsecase(repository),
          verifyOtpUsecase: VerifyOtpUsecase(repository),
        );
      },
    ),
  ];
}
