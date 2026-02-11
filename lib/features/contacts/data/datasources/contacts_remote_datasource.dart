import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ContactsRemoteDatasource {
  Future<List<Map<String, dynamic>>> matchContacts(List<String> hashes);
}

class ContactsRemoteDataSourceImpl implements ContactsRemoteDatasource {
  final FirebaseFirestore firestore;

  ContactsRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<Map<String, dynamic>>> matchContacts(List<String> hashes) async {
    if (hashes.isEmpty) return [];

    final List<Map<String, dynamic>> allMatches = [];

    // Chunk hashes into groups of 10 (Firestore whereIn limit) for larger lists
    for (var i = 0; i < hashes.length; i += 10) {
      final end = (i + 10 < hashes.length) ? i + 10 : hashes.length;
      final chunk = hashes.sublist(i, end);

      final snapshot = await firestore
          .collection('users')
          .where('phoneHash', whereIn: chunk)
          .get();

      allMatches.addAll(snapshot.docs.map((e) => e.data()));
    }

    return allMatches;
  }
}
