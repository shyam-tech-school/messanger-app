import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mail_messanger/features/otp/data/repositories/firebase_auth_repository.dart';
import 'package:mail_messanger/features/otp/domain/usecases/send_otp_usecase.dart';
import 'package:mail_messanger/features/otp/domain/usecases/verify_otp_usecase.dart';
import 'package:mail_messanger/features/otp/presentation/provider/otp_timer_provider.dart';
import 'package:mail_messanger/features/profile/data/datasources/auth_remote_datasource.dart';
import 'package:mail_messanger/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:mail_messanger/features/profile/data/repositories/profile_image_repository.dart';
import 'package:mail_messanger/features/profile/data/repositories/user_auth_repository.dart';
import 'package:mail_messanger/features/profile/domain/usecases/save_user_usecase.dart';
import 'package:mail_messanger/features/profile/domain/usecases/upload_image_usercase.dart';
import 'package:mail_messanger/features/profile/presentation/provider/profile_image_provider.dart';
import 'package:mail_messanger/features/profile/presentation/provider/user_provder.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:mail_messanger/features/otp/presentation/provider/auth_provider.dart';

class AppProvider {
  static List<SingleChildWidget> provider = [
    ChangeNotifierProvider(
      create: (_) => OtpTimerProvider(),
    ), // OTP timer provider
    // Send & Verify otp
    ChangeNotifierProvider(
      create: (_) {
        final repository = FirebaseAuthRepository(FirebaseAuth.instance);

        return OTPAuthProvider(
          sendOtpUsecase: SendOtpUsecase(repository),
          verifyOtpUsecase: VerifyOtpUsecase(repository),
        );
      },
    ),

    // profile image
    ChangeNotifierProvider(
      create: (_) => ProfileImageProvider(
        UploadImageUsercase(
          ProfileImageRepository(
            ProfileRemoteDataSoruceImpl("http://10.0.2.2:3000"),
          ),
        ),
      ),
    ),
    // android ip: 10.0.2.2

    // user provider
    ChangeNotifierProvider(
      create: (_) => UserProvder(
        SaveUserUsecase(
          UserAuthRepository(
            AuthRemoteDatasourceImpl(FirebaseFirestore.instance),
          ),
        ),
      ),
    ),
  ];
}
