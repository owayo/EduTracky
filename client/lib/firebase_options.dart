import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'config/env.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return web; // 現時点ではWebの設定を使用
      case TargetPlatform.iOS:
        return web; // 現時点ではWebの設定を使用
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions はこのプラットフォームに対応していません。',
        );
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
        apiKey: Environment.firebaseApiKey,
        authDomain: Environment.firebaseAuthDomain,
        projectId: Environment.firebaseProjectId,
        storageBucket: Environment.firebaseStorageBucket,
        messagingSenderId: Environment.firebaseMessagingSenderId,
        appId: Environment.firebaseAppId,
        measurementId: Environment.firebaseMeasurementId,
      );
}