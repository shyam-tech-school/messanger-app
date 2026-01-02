import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mail_messanger/core/config/app_config.dart';
import 'package:mail_messanger/core/utils/app_logger.dart';
import 'package:mime/mime.dart';

abstract class ProfileRemoteDatasource {
  Future<String> uploadProfileImage(File imageFile);
}

class ProfileRemoteDataSoruceImpl implements ProfileRemoteDatasource {
  @override
  Future<String> uploadProfileImage(File imageFile) async {
    final url = Uri.parse(AppConfig.uploadProfileImageUrl);

    final Uint8List bytes = await imageFile.readAsBytes();
    final mimeFromBytes = lookupMimeType(imageFile.path, headerBytes: bytes);

    log("Mime type: $mimeFromBytes");

    if (mimeFromBytes == null || !mimeFromBytes.startsWith('image/')) {
      throw Exception('Selected file is not a valid image');
    }

    final request = http.MultipartRequest("POST", url);
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: imageFile.path.split('/').last,
        contentType: MediaType.parse(mimeFromBytes),
      ),
    );

    //  ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    AppLogger.e("Status code: ${response.statusCode}");

    if (response.statusCode != 200) {
      AppLogger.e("Image upload failed");
      throw Exception('Image upload failed');
    }

    final decoded = jsonDecode(responseBody);

    return decoded['imageUrl'];
  }
}
