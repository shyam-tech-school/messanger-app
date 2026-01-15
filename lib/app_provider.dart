import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mail_messanger/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mail_messanger/features/chat/data/repositories/chat_repository.dart';
import 'package:mail_messanger/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:mail_messanger/features/contacts/data/datasources/contacts_local_datasource.dart';
import 'package:mail_messanger/features/contacts/data/datasources/contacts_remote_datasource.dart';
import 'package:mail_messanger/features/contacts/data/repositories/contacts_repository.dart';
import 'package:mail_messanger/features/contacts/domain/usecases/sync_contacts_usecases.dart';
import 'package:mail_messanger/features/contacts/presentation/provider/contact_permission_provider.dart';
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

import 'features/contacts/core/contacts_permission_manager.dart';

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
          ProfileImageRepository(ProfileRemoteDataSoruceImpl()),
        ),
      ),
    ),
    // android ip: 10.0.2.2:3000

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

    // contacts permission
    Provider(create: (_) => ContactsPermissionManager()),

    Provider(
      create: (_) => SyncContactsUsecases(
        ContactsRepository(
          ContactsRemoteDataSourceImpl(FirebaseFirestore.instance),
          ContactLocalDataSourceImpl(),
        ),
      ),
    ),

    // Contact provider
    ChangeNotifierProvider(
      create: (context) => ContactsProvider(
        context.read<SyncContactsUsecases>(),
        context.read<ContactsPermissionManager>(),
      ),
    ),

    // ---- Chat ----
    Provider(
      create: (_) => SendMessageUsecase(
        ChatRepository(ChatRemoteDataSourceImpl(FirebaseFirestore.instance)),
      ),
    ),
  ];
}
