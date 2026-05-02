class MatchedContact {
  final String uid;
  final String name;
  final String phone;
  final String? photoUrl;
  final String? about;

  MatchedContact({
    required this.uid,
    required this.name,
    required this.phone,
    this.photoUrl,
    this.about,
  });
}
