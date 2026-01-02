import 'package:mail_messanger/features/contacts/domain/entities/matched_contact.dart';
import 'package:mail_messanger/features/contacts/domain/repositories/i_contacts_repository.dart';

class SyncContactsUsecases {
  final IContactsRepository repository;

  SyncContactsUsecases(this.repository);

  Future<List<MatchedContact>> call() {
    return repository.syncContacts();
  }
}
