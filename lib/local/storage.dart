import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  static Future<Directory> _mediaDir() async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory(p.join(base.path, 'app_data', 'media', 'ai_logs'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    if (Platform.isAndroid) {
      final noMedia = File(p.join(dir.path, '.nomedia'));
      if (!await noMedia.exists()) {
        await noMedia.writeAsBytes(const [], flush: true);
      }
    }
    return dir;
  }

  static Future<String> saveBytes(
    Uint8List data, {
    required String basename,
    String ext = 'jpg',
    bool overwrite = false,
  }) async {
    final dir = await _mediaDir();
    final cleanExt = ext.toLowerCase().replaceAll('.', '');
    String name = '$basename.$cleanExt';
    String fullPath = p.join(dir.path, name);

    if (!overwrite) {
      var i = 1;
      while (await File(fullPath).exists()) {
        name = '$basename-$i.$cleanExt';
        fullPath = p.join(dir.path, name);
        i++;
      }
    }

    final tmp = File(p.join(dir.path, '.$name.tmp'));
    await tmp.writeAsBytes(data, flush: true);
    final file = File(fullPath);
    if (await file.exists()) {
      await file.delete();
    }
    await tmp.rename(fullPath);
    return fullPath;
  }

  static Future<bool> exists(String? path) async {
    if (path == null || path.isEmpty) return false;
    return File(path).exists();
  }

  static Future<void> deletePath(String? path) async {
    if (path == null || path.isEmpty) return;
    final f = File(path);
    if (await f.exists()) {
      try { await f.delete(); } catch (_) {}
    }
  }

  static Future<void> clearAll() async {
    final dir = await _mediaDir();
    if (await dir.exists()) {
      try {
        await for (final e in dir.list(recursive: false, followLinks: false)) {
          if (e is File && !e.path.endsWith('.nomedia')) {
            try { await e.delete(); } catch (_) {}
          }
        }
      } catch (_) {}
    }
  }
}
