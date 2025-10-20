import 'package:drift/drift.dart';
import '../local/db.dart';

class RecommendationService {
  static Future<void> saveFromApi(Map<String, dynamic> data) async {
    final db = await AppDb.instance();
    final List list = (data['recommendations'] ?? []) as List;
    final rows = <Map<String, String>>[];
    for (int i = 0; i < list.length; i++) {
      final r = (list[i] as Map).map((k, v) => MapEntry(k.toString(), v));
      rows.add({
        'title': r['title']?.toString() ?? '',
        'reason': r['reason']?.toString() ?? '',
      });
    }
    await db.replaceRecommendationsRaw(rows);
  }

  static Future<List<RecommendationData>> loadPreview({int limit = 2}) async {
    final db = await AppDb.instance();
    return db.latestRecommendations(limit: limit);
  }

  static Future<void> clear() async {
    final db = await AppDb.instance();
    await db.delete(db.recommendation).go();
  }
}
