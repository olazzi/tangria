// lib/services/velora_client.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../core/env.dart';
import '../models/collection_item.dart';

class VeloraClient {
static Uri _u(String path) {
  String base = Env.veloraBaseUrl.trim();
  if (base.endsWith('/')) base = base.substring(0, base.length - 1);
  String p = path.startsWith('/') ? path : '/$path';
  if (base.toLowerCase().endsWith('/ai') && p.toLowerCase().startsWith('/ai/')) {
    p = p.substring(3);
  }
  return Uri.parse('$base$p');
}

  static Map<String,String> get _h => {'x-api-key': Env.veloraAppKey, 'Content-Type': 'application/json'};

  static Future<Map<String,dynamic>> identifyMulti(List<Uint8List> images, {String? userHint}) async {
    final imgs = images.map((b) => 'data:image/jpeg;base64,${base64Encode(b)}').toList();
    final body = {'images': imgs, if (userHint!=null && userHint.trim().isNotEmpty) 'user_hint': userHint.trim()};
    final r = await http.post(_u('/ai/identify'), headers: _h, body: jsonEncode(body));
    if (r.statusCode<200||r.statusCode>=300) { throw Exception('HTTP ${r.statusCode}: ${r.body}'); }
    return jsonDecode(r.body) as Map<String,dynamic>;
  }

  static Future<Map<String,dynamic>> priceFromSelection(Map<String,dynamic> sel, {Map<String,dynamic>? primaryMeta}) async {
    final body = {
      'brand': sel['brand'] ?? '',
      'model': sel['model'] ?? '',
      'reference': sel['reference'] ?? '',
      'condition': primaryMeta?['condition'] ?? 'Good',
      'box_papers': primaryMeta?['box_papers'] ?? false,
      'material': primaryMeta?['material'] ?? '',
      'dial_color': primaryMeta?['dial_color'] ?? '',
    };
    final r = await http.post(_u('/ai/price'), headers: _h, body: jsonEncode(body));
    if (r.statusCode<200||r.statusCode>=300) { throw Exception('HTTP ${r.statusCode}: ${r.body}'); }
    return jsonDecode(r.body) as Map<String,dynamic>;
  }

  static Future<Map<String,dynamic>> recommendCollection(List<CollectionItem> items, {int n = 2}) async {
    final payload = items.map((e) => {
      'title': e.title,
      'price': e.price,
      'min': e.minPrice,
      'max': e.maxPrice,
    }).toList();
    final r = await http.post(_u('/ai/recommend-collection'), headers: _h, body: jsonEncode({'items': payload, 'n': n}));
    if (r.statusCode<200||r.statusCode>=300) { throw Exception('HTTP ${r.statusCode}: ${r.body}'); }
    return jsonDecode(r.body) as Map<String,dynamic>;
  }
}
