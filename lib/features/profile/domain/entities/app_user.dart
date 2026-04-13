class AppUser {
  final String uid;
  final String phone;
  final String phoneHash;
  final String name;
  final String? photoUrl;
  final String? fcmToken;
  final String? about;

  AppUser({
    required this.uid,
    required this.phone,
    required this.phoneHash,
    required this.name,
    this.photoUrl,
    this.fcmToken,
    this.about,
  });

  AppUser copyWith({
    String? name,
    String? photoUrl,
    String? about,
  }) {
    return AppUser(
      uid: uid,
      phone: phone,
      phoneHash: phoneHash,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      fcmToken: fcmToken,
      about: about ?? this.about,
    );
  }
}
