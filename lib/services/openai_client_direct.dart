import 'dart:convert';
import 'dart:typed_data';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import '../core/env.dart';

class VeloraClient {
  static Uri _u(String path) => Uri.parse('${Env.veloraBaseUrl.replaceAll(RegExp(r"/$"), "")}$path');
  static Map<String,String> get _h => {'x-api-key': Env.veloraAppKey, 'Content-Type': 'application/json'};

  static Future<Map<String,dynamic>> identifyMulti(List<Uint8List> images, {String? userHint}) async {
    final imgs = images.map((b) => 'data:image/jpeg;base64,${base64Encode(b)}').toList();
    final body = {'images': imgs, if (userHint!=null && userHint.trim().isNotEmpty) 'user_hint': userHint!.trim()};
    final req = jsonEncode(body);
    dev.log('REQ identify len=${req.length}', name: 'Velora');
    final r = await http.post(_u('/identify'), headers: _h, body: req);
    dev.log('STATUS ${r.statusCode}', name: 'Velora');
    if (r.statusCode<200||r.statusCode>=300) throw Exception('HTTP ${r.statusCode}');
    return jsonDecode(r.body) as Map<String,dynamic>;
  }

  static Future<Map<String,dynamic>> priceFromSelection(Map<String,dynamic> sel, {Map<String,dynamic>? primaryMeta}) async {
    final body = {
      'brand': sel['brand']??'',
      'model': sel['model']??'',
      'reference': sel['reference']??'',
      'condition': primaryMeta?['condition']??'Good',
      'box_papers': primaryMeta?['box_papers']??false,
      'material': primaryMeta?['material']??'',
      'dial_color': primaryMeta?['dial_color']??'',
    };
    final r = await http.post(_u('/price'), headers: _h, body: jsonEncode(body));
    if (r.statusCode<200||r.statusCode>=300) throw Exception('HTTP ${r.statusCode}');
    return jsonDecode(r.body) as Map<String,dynamic>;
  }

  static Future<Map<String,dynamic>> estimateMulti(List<Uint8List> images) async {
    final imgs = images.map((b) => 'data:image/jpeg;base64,${base64Encode(b)}').toList();
    final r = await http.post(_u('/estimate'), headers: _h, body: jsonEncode({'images': imgs}));
    if (r.statusCode<200||r.statusCode>=300) throw Exception('HTTP ${r.statusCode}');
    return jsonDecode(r.body) as Map<String,dynamic>;
  }
}
