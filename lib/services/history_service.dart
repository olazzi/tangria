import 'dart:convert';
import '../local/db.dart';
import '../repository/ai_logs_repository.dart';

class HistoryCardData {
  final String id;
  final String title;
  final String price;
  final String desc;
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
          final pricing = j['pricing'] ?? {};
          final identify = j['identify'] ?? {};
          final primary = (identify['primary'] ?? {}) as Map<String, dynamic>;
          final brand = (primary['brand'] ?? '') is String ? primary['brand'] : '';
          final model = (primary['model'] ?? '') is String ? primary['model'] : '';
          title = '${brand ?? ''} ${model ?? ''}'.trim();
          price = '${pricing['price_estimate'] ?? ''}';
          desc = primary['category']?.toString() ?? '';
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
}
