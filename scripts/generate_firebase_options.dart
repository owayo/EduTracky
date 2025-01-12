import 'dart:io';

void main() {
  final apiKey = Platform.environment['FIREBASE_API_KEY'] ?? '';
  final appId = Platform.environment['FIREBASE_APP_ID'] ?? '';
  final messagingSenderId = Platform.environment['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  final projectId = Platform.environment['FIREBASE_PROJECT_ID'] ?? '';
  final authDomain = Platform.environment['FIREBASE_AUTH_DOMAIN'] ?? '';
  final storageBucket = Platform.environment['FIREBASE_STORAGE_BUCKET'] ?? '';
  final iosClientId = Platform.environment['FIREBASE_IOS_CLIENT_ID'] ?? '';
  final iosBundleId = Platform.environment['FIREBASE_IOS_BUNDLE_ID'] ?? '';
  final androidClientId = Platform.environment['FIREBASE_ANDROID_CLIENT_ID'] ?? '';
  final androidPackageName = Platform.environment['FIREBASE_ANDROID_PACKAGE_NAME'] ?? '';

  final content = '''
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// デフォルトのFirebase設定オプション
///
/// 環境変数から設定を読み込みます
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions は Windows プラットフォームに対応していません。',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions は Linux プラットフォームに対応していません。',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions は \$defaultTargetPlatform に対応していません。',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: '$apiKey',
    appId: '$appId',
    messagingSenderId: '$messagingSenderId',
    projectId: '$projectId',
    authDomain: '$authDomain',
    storageBucket: '$storageBucket',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '$apiKey',
    appId: '$appId',
    messagingSenderId: '$messagingSenderId',
    projectId: '$projectId',
    storageBucket: '$storageBucket',
    androidClientId: '$androidClientId',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '$apiKey',
    appId: '$appId',
    messagingSenderId: '$messagingSenderId',
    projectId: '$projectId',
    storageBucket: '$storageBucket',
    iosClientId: '$iosClientId',
    iosBundleId: '$iosBundleId',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: '$apiKey',
    appId: '$appId',
    messagingSenderId: '$messagingSenderId',
    projectId: '$projectId',
    storageBucket: '$storageBucket',
    iosClientId: '$iosClientId',
    iosBundleId: '$iosBundleId',
  );
}
''';

  File('client/lib/firebase_options.dart').writeAsStringSync(content);
}
