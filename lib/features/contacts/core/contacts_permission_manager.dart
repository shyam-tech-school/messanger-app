import 'package:permission_handler/permission_handler.dart';

class ContactsPermissionManager {
  Future<PermissionStatus> getStatus() {
    return Permission.contacts.status;
  }

  Future<bool> requestPermission() async {
    final result = await Permission.contacts.request();
    return result.isGranted;
  }

  bool isPermanentlyDenied(PermissionStatus status) {
    return status.isPermanentlyDenied;
  }

  Future<void> openSettings() {
    return openAppSettings();
  }
}
