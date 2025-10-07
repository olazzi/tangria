import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  static Future<Directory> _mediaDir() async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory(p.join(base.path, 'app_data', 'media', 'ai_logs'));
    await dir.create(recursive: true);
    return dir;
  }

  static Future<String> saveBytes(Uint8List data, {required String basename, String ext = 'jpg'}) async {
    final dir = await _mediaDir();
    final file = File(p.join(dir.path, '$basename.$ext'));
    await file.writeAsBytes(data, flush: true);
    return file.path;
  }
}
