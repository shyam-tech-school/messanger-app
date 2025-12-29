import 'dart:convert';
import 'package:crypto/crypto.dart';

class PhoneHashUtils {
  static String hash(String phone) {
    return sha256.convert(utf8.encode(phone)).toString();
  }
}
