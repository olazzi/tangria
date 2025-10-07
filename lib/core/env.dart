import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Future<void> load() => dotenv.load(fileName: '.env');

  static String get openAIKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static String get veloraBaseUrl => dotenv.env['VELORA_BASE_URL'] ?? 'http://10.0.2.2:8080/ai/chat';
  static String get veloraAppKey => dotenv.env['VELORA_APP_KEY'] ?? 'velora-secret-key';
}
