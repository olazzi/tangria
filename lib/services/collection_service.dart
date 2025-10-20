import 'dart:convert';
import 'package:intl/intl.dart';
import '../local/db.dart';
import '../repository/ai_logs_repository.dart';
import '../models/collection_item.dart';

class CollectionService {
  static String _extractMoneySnippet(String raw) {
    final s = raw.toLowerCase();
    final rx = RegExp(r'((?:\$|€|£|usd|eur|gbp)\s*[\d\.,k]+(?:\s*[-–—]\s*[\d\.,k]+)?)', caseSensitive: false);
    final m = rx.firstMatch(s);
    if (m != null) return raw.substring(m.start, m.end);
    final rxK = RegExp(r'(\d[\d\.,]*\s*[kK](?:\s*[-–—]\s*\d[\d\.,]*\s*[kK])?)');
    final mk = rxK.firstMatch(raw);
    if (mk != null) return raw.substring(mk.start, mk.end);
    final rxNum = RegExp(r'(\d[\d\.,]*(?:\s*[-–—]\s*\d[\d\.,]*)?)');
    final mn = rxNum.firstMatch(raw);
    return mn != null ? raw.substring(mn.start, mn.end) : '';
  }

  static List<double> _numbers(String s) {
    String t = s.toLowerCase().replaceAll(RegExp(r'[–—−]'), '-').replaceAll(RegExp(r'\bto\b'), '-');
    final ms = RegExp(r'(\d+(?:[.,]\d+)?)(\s*[kK])?').allMatches(t).toList();
    double parse(String a, bool k) {
      String x = a;
      if (x.contains('.') && x.contains(',')) {
        x = x.replaceAll('.', '').replaceAll(',', '.');
      } else if (RegExp(r'\d{1,3}(?:,\d{3})+').hasMatch(x)) {
        x = x.replaceAll(',', '');
      } else if (RegExp(r'\d{1,3}(?:\.\d{3})+').hasMatch(x)) {
        x = x.replaceAll('.', '');
      } else {
        x = x.replaceAll(',', '.');
      }
      final v = double.tryParse(x) ?? 0.0;
      return k ? v * 1000.0 : v;
    }
    return ms.map((m) => parse(m.group(1) ?? '', (m.group(2) ?? '').trim().isNotEmpty)).where((v) => v > 0).toList();
  }

  static (double,double) _parseRange(String raw) {
    final vals = _numbers(raw);
    if (vals.isEmpty) return (0.0, 0.0);
    if (vals.length == 1) return (vals.first, vals.first);
    final a = vals.first;
    final b = vals.last;
    final lo = a < b ? a : b;
    final hi = a < b ? b : a;
    return (lo, hi);
  }

  static (double,double) _priceRangeFromRequest(AiRequestData r) {
    try {
      if ((r.responseJson ?? '').isNotEmpty) {
        final j = jsonDecode(r.responseJson!);
        final est = (j['pricing']?['price_estimate'] ?? '').toString();
        if (est.trim().isNotEmpty) {
          final sn = _extractMoneySnippet(est);
          final pr = _parseRange(sn.isNotEmpty ? sn : est);
          if (pr.$1 > 0 || pr.$2 > 0) return pr;
        }
      }
    } catch (_) {}
    final t = (r.responseText ?? '').trim();
    if (t.isEmpty) return (0.0, 0.0);
    final sn = _extractMoneySnippet(t);
    return _parseRange(sn.isNotEmpty ? sn : t);
  }

  static Future<List<CollectionItem>> load() async {
    final db = await AppDb.instance();
    final reqs = await db.listRequests(limit: 1000);
    final repo = AiLogsRepository();
    final out = <CollectionItem>[];
    for (final r in reqs) {
      final imgs = await repo.imagesOf(r.id);
      final p = imgs.isNotEmpty ? (imgs.first.path ?? '') : '';
      final title = (r.responseText ?? '').trim();
      final range = _priceRangeFromRequest(r);
      final avg = range.$1 == 0 && range.$2 == 0 ? 0.0 : (range.$1 + range.$2) / 2.0;
      out.add(CollectionItem(
        id: r.id,
        title: title.isEmpty ? 'Item' : title.split('\n').first,
        desc: '',
        imagePath: p,
        price: avg,
        minPrice: range.$1,
        maxPrice: range.$2,
      ));
    }
    return out;
  }

  static String formatCurrency(double v) {
    final f = NumberFormat.simpleCurrency();
    return f.format(v);
  }

  static String formatTotalRange(List<CollectionItem> items) {
    final minSum = items.fold<double>(0, (a, b) => a + (b.minPrice > 0 ? b.minPrice : b.price));
    final maxSum = items.fold<double>(0, (a, b) => a + (b.maxPrice > 0 ? b.maxPrice : b.price));
    if (minSum == 0 && maxSum == 0) return formatCurrency(0);
    if ((minSum - maxSum).abs() < 0.01) return formatCurrency(minSum);
    return '${formatCurrency(minSum)} – ${formatCurrency(maxSum)}';
  }
}
