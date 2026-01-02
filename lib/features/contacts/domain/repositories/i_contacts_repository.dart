import 'package:mail_messanger/features/contacts/domain/entities/matched_contact.dart';

abstract class IContactsRepository {
  Future<List<MatchedContact>> syncContacts();
}
