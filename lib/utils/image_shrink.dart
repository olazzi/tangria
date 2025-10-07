import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Uint8List> shrinkOne(Uint8List src) async {
  return Uint8List.fromList(await FlutterImageCompress.compressWithList(
    src, minWidth: 1024, minHeight: 1024, quality: 80, format: CompressFormat.jpeg,
  ));
}

Future<List<Uint8List>> shrinkBatch(List<Uint8List> list) async {
  // CPU dalgalanmasını azaltmak için sırayla veya küçük batch’lerle çalıştır
  final out = <Uint8List>[];
  for (final b in list) { out.add(await compute(shrinkOne, b)); }
  return out;
}
