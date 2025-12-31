import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase configuration options.
///
/// IMPORTANT: Replace the placeholder values below with your actual Firebase project configuration.
/// You can find these values in your Firebase Console:
/// 1. Go to https://console.firebase.google.com
/// 2. Select your project (or create a new one)
/// 3. Click the gear icon (Settings) > Project settings
/// 4. Scroll down to "Your apps" section
/// 5. Click "Add app" and select Web (</>)
/// 6. Register your app and copy the configuration values
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

  /// TODO: Replace with your Firebase Web configuration

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAwjtQYbga6m6ouhozBKucuJKcpMaKPtHE',
    appId: '1:962827526326:web:7dc812dfe5f5d8eaaf8617',
    messagingSenderId: '962827526326',
    projectId: 'fruit-box-game',
    authDomain: 'fruit-box-game.firebaseapp.com',
    storageBucket: 'fruit-box-game.firebasestorage.app',
    measurementId: 'G-FJZ1T72TKG',
  );

  /// Get these values from Firebase Console > Project Settings > Your apps > Web app

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDUASqAyS827sBYpWfWIGvbHzqIsuEIxvQ',
    appId: '1:962827526326:android:fbbd38a51b9fe4c8af8617',
    messagingSenderId: '962827526326',
    projectId: 'fruit-box-game',
    storageBucket: 'fruit-box-game.firebasestorage.app',
  );

  /// TODO: Replace with your Firebase Android configuration (if needed)

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDVqQ524QyCCCPajmnFZP8-E9utSu2C7sw',
    appId: '1:962827526326:ios:f23c59540f61707caf8617',
    messagingSenderId: '962827526326',
    projectId: 'fruit-box-game',
    storageBucket: 'fruit-box-game.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  /// TODO: Replace with your Firebase iOS configuration (if needed)

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDVqQ524QyCCCPajmnFZP8-E9utSu2C7sw',
    appId: '1:962827526326:ios:f23c59540f61707caf8617',
    messagingSenderId: '962827526326',
    projectId: 'fruit-box-game',
    storageBucket: 'fruit-box-game.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  /// TODO: Replace with your Firebase macOS configuration (if needed)

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAwjtQYbga6m6ouhozBKucuJKcpMaKPtHE',
    appId: '1:962827526326:web:985877c8d242b430af8617',
    messagingSenderId: '962827526326',
    projectId: 'fruit-box-game',
    authDomain: 'fruit-box-game.firebaseapp.com',
    storageBucket: 'fruit-box-game.firebasestorage.app',
    measurementId: 'G-3JZB883Y4D',
  );

  /// TODO: Replace with your Firebase Windows configuration (if needed)
}