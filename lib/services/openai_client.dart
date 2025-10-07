import 'dart:typed_data';
import '../models/price_quote.dart';

abstract class OpenAIClient {
  Future<String> analyzeImage(Uint8List bytes, {String prompt});
  Future<Uint8List> generateImage(String prompt, {String size});
  Future<PriceQuote> estimatePrice(Uint8List bytes);
}
