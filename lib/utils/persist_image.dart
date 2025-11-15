import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<String> persistImage(Uint8List bytes, {String ext = 'jpg'}) async {
  final base = await getApplicationSupportDirectory();
  final dir = Directory(p.join(base.path, 'app_data', 'images'));
  await dir.create(recursive: true);
  final ts = DateTime.now().millisecondsSinceEpoch;
  final file = File(p.join(dir.path, '$ts.$ext'));
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}
