import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Firebase configuration options loaded from environment variables.
///
/// This approach keeps sensitive API keys out of version control.
/// Make sure to:
/// 1. Copy .env.example to .env
/// 2. Fill in your actual Firebase values in .env
/// 3. Never commit .env to version control
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
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  /// Web Configuration from environment variables
  static FirebaseOptions get web => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_WEB_API_KEY'] ?? '',
    appId: dotenv.env['FIREBASE_WEB_APP_ID'] ?? '',
    messagingSenderId: dotenv.env['FIREBASE_WEB_MESSAGING_SENDER_ID'] ?? '',
    projectId: dotenv.env['FIREBASE_WEB_PROJECT_ID'] ?? '',
    authDomain: dotenv.env['FIREBASE_WEB_AUTH_DOMAIN'] ?? '',
    storageBucket: dotenv.env['FIREBASE_WEB_STORAGE_BUCKET'] ?? '',
    measurementId: dotenv.env['FIREBASE_WEB_MEASUREMENT_ID'],
  );

  /// Android Configuration from environment variables
  static FirebaseOptions get android => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_ANDROID_API_KEY'] ?? '',
    appId: dotenv.env['FIREBASE_ANDROID_APP_ID'] ?? '',
    messagingSenderId: dotenv.env['FIREBASE_WEB_MESSAGING_SENDER_ID'] ?? '',
    projectId: dotenv.env['FIREBASE_WEB_PROJECT_ID'] ?? '',
    storageBucket: dotenv.env['FIREBASE_WEB_STORAGE_BUCKET'] ?? '',
  );

  /// iOS Configuration from environment variables
  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_IOS_API_KEY'] ?? '',
    appId: dotenv.env['FIREBASE_IOS_APP_ID'] ?? '',
    messagingSenderId: dotenv.env['FIREBASE_WEB_MESSAGING_SENDER_ID'] ?? '',
    projectId: dotenv.env['FIREBASE_WEB_PROJECT_ID'] ?? '',
    storageBucket: dotenv.env['FIREBASE_WEB_STORAGE_BUCKET'] ?? '',
    iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID'] ?? '',
  );

  /// macOS Configuration from environment variables
  static FirebaseOptions get macos => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_IOS_API_KEY'] ?? '',
    appId: dotenv.env['FIREBASE_IOS_APP_ID'] ?? '',
    messagingSenderId: dotenv.env['FIREBASE_WEB_MESSAGING_SENDER_ID'] ?? '',
    projectId: dotenv.env['FIREBASE_WEB_PROJECT_ID'] ?? '',
    storageBucket: dotenv.env['FIREBASE_WEB_STORAGE_BUCKET'] ?? '',
    iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID'] ?? '',
  );

  /// Windows Configuration from environment variables
  static FirebaseOptions get windows => FirebaseOptions(
    apiKey:
        dotenv.env['FIREBASE_WINDOWS_API_KEY'] ??
        dotenv.env['FIREBASE_WEB_API_KEY'] ??
        '',
    appId:
        dotenv.env['FIREBASE_WINDOWS_APP_ID'] ??
        dotenv.env['FIREBASE_WEB_APP_ID'] ??
        '',
    messagingSenderId: dotenv.env['FIREBASE_WEB_MESSAGING_SENDER_ID'] ?? '',
    projectId: dotenv.env['FIREBASE_WEB_PROJECT_ID'] ?? '',
    authDomain: dotenv.env['FIREBASE_WEB_AUTH_DOMAIN'] ?? '',
    storageBucket: dotenv.env['FIREBASE_WEB_STORAGE_BUCKET'] ?? '',
    measurementId: dotenv.env['FIREBASE_WINDOWS_MEASUREMENT_ID'],
  );
}
