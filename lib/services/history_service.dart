import 'dart:convert';
import 'dart:io';
import '../local/db.dart';
import '../repository/ai_logs_repository.dart';

class HistoryCardData {
  final String id;
  final String title;
  final String price;
  final String desc;      // detailed description (long prose)
  final String imagePath;
  HistoryCardData(this.id, this.title, this.price, this.desc, this.imagePath);
}

class HistoryService {
  static Future<List<HistoryCardData>> load() async {
    final db = await AppDb.instance();
    final repo = AiLogsRepository();
    final reqs = await db.listRequests(limit: 1000);

    final List<HistoryCardData> out = [];
    for (final r in reqs) {
      final imgs = await repo.imagesOf(r.id);
      final img = imgs.isNotEmpty ? (imgs.first.path ?? '') : '';

      String title = '';
      String price = '';
      String desc = '';

      if ((r.responseJson ?? '').isNotEmpty) {
        try {
          final j = jsonDecode(r.responseJson!);

          // title & price
          final identify = j['identify'] ?? {};
          final primary  = (identify['primary'] ?? {}) as Map<String, dynamic>;
          final brand    = (primary['brand'] ?? '') is String ? primary['brand'] : '';
          final model    = (primary['model'] ?? '') is String ? primary['model'] : '';
          title = '$brand $model'.trim();

          final pricing = j['pricing'] ?? {};
          price = '${pricing['price_estimate'] ?? ''}';

          // detailed description (new): prefer top-level, else nested under "description"
          if (j['detailed_description'] is String && (j['detailed_description'] as String).trim().isNotEmpty) {
            desc = (j['detailed_description'] as String).trim();
          } else if (j['description'] is Map && (j['description']['detailed_description'] ?? '').toString().trim().isNotEmpty) {
            desc = j['description']['detailed_description'].toString().trim();
          } else {
            // gentle fallback to a compact one-liner from primary fields
            final ref   = (primary['reference'] ?? '').toString();
            final mat   = (primary['material'] ?? '').toString();
            final dial  = (primary['dial_color'] ?? '').toString();
            final mov   = (primary['movement'] ?? '').toString();
            final diam  = (primary['diameter_mm'] ?? '').toString();
            final thick = (primary['thickness_mm'] ?? '').toString();
            final cond  = (primary['condition'] ?? '').toString();

            final parts = <String>[
              if (brand.toString().trim().isNotEmpty || model.toString().trim().isNotEmpty) '$brand $model',
              if (ref.isNotEmpty) 'Ref. $ref',
              if (mat.isNotEmpty) mat,
              if (dial.isNotEmpty) '$dial dial',
              if (mov.isNotEmpty) mov,
              if (diam.isNotEmpty) '$diam mm',
              if (thick.isNotEmpty) 'thickness $thick mm',
              if (cond.isNotEmpty) 'condition: $cond',
            ].where((e) => e.trim().isNotEmpty).join(', ');
            desc = parts;
          }

          // if title still empty, fallback to responseText first line
          if (title.trim().isEmpty && (r.responseText ?? '').isNotEmpty) {
            title = r.responseText!.split('\n').first;
          }
        } catch (_) {
          title = (r.responseText ?? '').split('\n').first;
        }
      } else {
        title = (r.responseText ?? '').split('\n').first;
      }

      out.add(HistoryCardData(r.id, title, price, desc, img));
    }
    return out;
  }

  static Future<void> delete(String requestId) async {
    final db = await AppDb.instance();
    final repo = AiLogsRepository();

    // delete image files from disk
    try {
      final imgs = await repo.imagesOf(requestId);
      for (final img in imgs) {
        final p = img.path ?? '';
        if (p.isNotEmpty) {
          try {
            final f = File(p);
            if (await f.exists()) {
              await f.delete();
            }
          } catch (_) {}
        }
      }
    } catch (_) {}

    // delete image rows
    try {
      await (db.delete(db.aiRequestImage)
            ..where((t) => t.requestId.equals(requestId)))
          .go();
    } catch (_) {}

    // delete request row
    try {
      await db.deleteRequest(requestId);
    } catch (_) {}
  }
}
