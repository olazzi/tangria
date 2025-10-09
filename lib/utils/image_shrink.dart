import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

Future<Uint8List> shrinkOne(Uint8List bytes) => compute(_shrinkOneImpl, bytes);

Future<List<Uint8List>> shrinkBatch(List<Uint8List> raws) async {
  return Future.wait(raws.map(shrinkOne));
}

Uint8List _shrinkOneImpl(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return bytes;
  final resized = img.copyResize(
    decoded,
    width: 1280,
    height: 1280,
    maintainAspect: true,
    interpolation: img.Interpolation.average,
  );
  final jpg = img.encodeJpg(resized, quality: 85);
  return Uint8List.fromList(jpg);
}
