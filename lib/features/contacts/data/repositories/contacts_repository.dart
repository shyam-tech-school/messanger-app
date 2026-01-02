import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mail_messanger/features/contacts/data/datasources/contacts_local_datasource.dart';
import 'package:mail_messanger/features/contacts/data/datasources/contacts_remote_datasource.dart';
import 'package:mail_messanger/features/contacts/domain/entities/matched_contact.dart';
import 'package:mail_messanger/features/contacts/domain/repositories/i_contacts_repository.dart';

class ContactsRepository implements IContactsRepository {
  final ContactsRemoteDataSourceImpl contactRemote;
  final ContactLocalDataSourceImpl contactLocal;

  ContactsRepository(this.contactRemote, this.contactLocal);

  @override
  Future<List<MatchedContact>> syncContacts() async {
    final numbers = await contactLocal.getPhoneNumbers();

    final hashes = numbers
        .map((e) => sha256.convert(utf8.encode(e)).toString())
        .toList();

    final matched = await contactRemote.matchContacts(hashes);

    return matched
        .map(
          (e) => MatchedContact(
            uid: e['uid'],
            name: e['name'],
            phone: e['phone'],
            photoUrl: e['photoUrl'],
          ),
        )
        .toList();
  }
}
