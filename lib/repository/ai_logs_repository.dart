 import 'dart:convert';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import '../local/db.dart';
import '../local/storage.dart';
import 'package:drift/drift.dart' show Value;

class AiLogsRepository {
  final _uuid = const Uuid();

  Future<String> logRequest({
    required String model,
    required double temperature,
    required int statusCode,
    required int latencyMs,
    String? prompt,
    String? responseText,
    Map<String, dynamic>? responseJson,
    String? errorText,
    List<Uint8List>? images,
    List<String>? imageMimeTypes,
  }) async {
    final db = await AppDb.instance();
    final id = _uuid.v4();

    await db.transaction(() async {
      await db.insertRequest(
        id: id,
        model: model,
        temperature: temperature,
        statusCode: statusCode,
        latencyMs: latencyMs,
        prompt: prompt,
        errorText: errorText,
        responseText: responseText,
        responseJson: responseJson == null ? null : jsonEncode(responseJson),
      );

      if (images != null && images.isNotEmpty) {
        final items = <AiRequestImageCompanion>[];
        final mimes = imageMimeTypes ?? const <String>[];
        final ts = DateTime.now().millisecondsSinceEpoch;

        for (var i = 0; i < images.length; i++) {
          final mime = (i < mimes.length ? mimes[i] : 'image/jpeg').toLowerCase();
          final ext = mime.contains('png') ? 'png' : 'jpg';
          final name = '$ts-$id-$i';
          final savedPath = await LocalStorage.saveBytes(images[i], basename: name, ext: ext);

          items.add(AiRequestImageCompanion.insert(
            id: _uuid.v4(),
            requestId: id,
            idx: i,
            mimeType: Value(mime),
            path: Value(savedPath),
          ));
        }

        await db.insertImages(id, items);
      }
    });

    return id;
  }

  Future<List<AiRequestData>> list({int limit = 50}) async {
    final db = await AppDb.instance();
    return db.listRequests(limit: limit);
  }

  Future<List<AiRequestImageData>> imagesOf(String requestId) async {
    final db = await AppDb.instance();
    return db.imagesOf(requestId);
  }

  Future<void> delete(String id) async {
    final db = await AppDb.instance();
    await db.deleteRequestCascade(id);
  }
}
