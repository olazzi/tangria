import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Future<void> load() => dotenv.load(fileName: '.env');

  static String get openAIKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static String get veloraBaseUrl => dotenv.env['VELORA_BASE_URL'] ?? 'http://3.90.12.45:8080/ai';
  static String get veloraAppKey => dotenv.env['VELORA_APP_KEY'] ?? 'velora-secret-key';
}
