import 'package:flutter_contacts_service/flutter_contacts_service.dart';

abstract class ContactsLocalDatasource {
  Future<List<String>> getPhoneNumbers();
}

class ContactLocalDataSourceImpl implements ContactsLocalDatasource {
  @override
  Future<List<String>> getPhoneNumbers() async {
    final contacts = await FlutterContactsService.getContacts(
      withThumbnails: false,
    );

    final numbers = <String>{};

    for (final contact in contacts) {
      for (final phone in contact.phones ?? []) {
        final normalized = _normalize(phone.value);
        if (normalized != null) {
          numbers.add(normalized);
        }
      }
    }
    return numbers.toList();
  }

  String? _normalize(String? input) {
    if (input == null) return null;

    final cleaned = input.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleaned.startsWith('+')) return cleaned;
    if (cleaned.length == 10) return '+91$cleaned';
    return null;
  }
}
