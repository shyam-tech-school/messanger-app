class AppUser {
  final String uid;
  final String phone;
  final String phoneHash;
  final String name;
  final String? photoUrl;
  final String? fcmToken;

  AppUser({
    required this.uid,
    required this.phone,
    required this.phoneHash,
    required this.name,
    this.photoUrl,
    this.fcmToken,
  });
}
