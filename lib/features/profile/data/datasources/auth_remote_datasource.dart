import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mail_messanger/features/profile/domain/entities/app_user.dart';

abstract class AuthRemoteDataSource {
  Future<void> saveUser(AppUser user);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDataSource {
  final FirebaseFirestore firestore;

  AuthRemoteDatasourceImpl(this.firestore);

  @override
  Future<void> saveUser(AppUser user) async {
    await firestore.collection('users').doc(user.uid).set({
      "uid": user.uid,
      "phone": user.phone,
      "phoneHash": user.phoneHash,
      "name": user.name,
      "photoUrl": user.photoUrl,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
