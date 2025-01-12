import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class Environment {
  static Future<void> load() async {
    await dotenv.dotenv.load(fileName: '.env');
  }

  static String get firebaseApiKey => dotenv.dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseAuthDomain => dotenv.dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '';
  static String get firebaseProjectId => dotenv.dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseStorageBucket => dotenv.dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';
  static String get firebaseMessagingSenderId => dotenv.dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseAppId => dotenv.dotenv.env['FIREBASE_APP_ID'] ?? '';
  static String get firebaseMeasurementId => dotenv.dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? '';
}