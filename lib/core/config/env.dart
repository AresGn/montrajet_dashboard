import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfig {
  static String get supabaseUrl {
    return dotenv.env['SUPABASE_URL'] ?? '';
  }

  static String get supabaseAnonKey {
    return dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  }

  static String get twilioSid {
    return dotenv.env['TWILIO_SID'] ?? '';
  }

  static String get twilioAuthToken {
    return dotenv.env['TWILIO_AUTH_TOKEN'] ?? '';
  }

  static String get twilioPhoneNumber {
    return dotenv.env['TWILIO_PHONE_NUMBER'] ?? '';
  }

  static String get llmProvider {
    return dotenv.env['LLM_PROVIDER'] ?? 'grok';
  }

  static String get llmApiKey {
    return dotenv.env['LLM_API_KEY'] ?? '';
  }

  static List<String> get adminEmails {
    final emails = dotenv.env['ADMIN_EMAILS'] ?? 'admin@tokpa.app';
    return emails.split(',').map((e) => e.trim()).toList();
  }

  static bool get isProduction {
    return dotenv.env['ENV'] == 'production';
  }
}
