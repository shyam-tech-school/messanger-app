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

    final snapshot = await firestore
        .collection('users')
        .where('phoneHash', whereIn: hashes.take(10).toList())
        .get();

    return snapshot.docs.map((e) => e.data()).toList();
  }
}
