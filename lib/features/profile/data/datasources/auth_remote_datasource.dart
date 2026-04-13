import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mail_messanger/features/profile/domain/entities/app_user.dart';

abstract class AuthRemoteDataSource {
  Future<void> saveUser(AppUser user);
  Future<AppUser?> getUser(String uid);
  Future<void> updateProfile({
    required String uid,
    required String name,
    String? about,
    String? photoUrl,
  });
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
      "fcmToken": user.fcmToken,
      "about": user.about,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<AppUser?> getUser(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    final d = doc.data()!;
    return AppUser(
      uid: d['uid'] as String? ?? uid,
      phone: d['phone'] as String? ?? '',
      phoneHash: d['phoneHash'] as String? ?? '',
      name: d['name'] as String? ?? '',
      photoUrl: d['photoUrl'] as String?,
      fcmToken: d['fcmToken'] as String?,
      about: d['about'] as String?,
    );
  }

  @override
  Future<void> updateProfile({
    required String uid,
    required String name,
    String? about,
    String? photoUrl,
  }) async {
    final data = <String, dynamic>{
      'name': name,
      'about': about,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (photoUrl != null) data['photoUrl'] = photoUrl;
    await firestore.collection('users').doc(uid).update(data);
  }
}
