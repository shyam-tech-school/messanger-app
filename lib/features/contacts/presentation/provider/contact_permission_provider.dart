import 'package:flutter/foundation.dart';
import 'package:mail_messanger/features/contacts/core/contacts_permission_manager.dart';
import 'package:mail_messanger/features/contacts/domain/entities/matched_contact.dart';
import 'package:mail_messanger/features/contacts/domain/usecases/sync_contacts_usecases.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsProvider extends ChangeNotifier {
  final SyncContactsUsecases syncContactsUsecases;
  final ContactsPermissionManager contactsPermissionManager;

  ContactsProvider(this.syncContactsUsecases, this.contactsPermissionManager);

  bool isSyncing = false;
  bool permanentlyDenied = false;

  List<MatchedContact> matchedContacts = [];

  Future<bool> requestAndSyncContacts() async {
    final status = await contactsPermissionManager.getStatus();

    if (status.isGranted) {
      return await _sync();
    }

    final granted = await contactsPermissionManager.requestPermission();

    if (!granted) {
      final updatedStatus = await contactsPermissionManager.getStatus();
      permanentlyDenied = updatedStatus.isPermanentlyDenied;
      notifyListeners();
      return false;
    }

    return await _sync();
  }

  Future<bool> _sync() async {
    try {
      isSyncing = true;
      notifyListeners();

      matchedContacts = await syncContactsUsecases();

      isSyncing = false;
      notifyListeners();
      return true;
    } catch (e) {
      isSyncing = false;
      notifyListeners();
      return false;
    }
  }

  void openSettings() {
    contactsPermissionManager.openSettings();
  }
}
