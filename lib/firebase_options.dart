// This file is auto-generated by the Firebase CLI
// Replace this with your actual Firebase configuration
// Run: flutter packages pub global activate flutterfire_cli
// Then: flutterfire configure

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example of how to use default [FirebaseOptions] to initialize Firebase:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC63kLYvF_5x9oo96ZUmBE-u6ibUThFP4M',
    appId: '1:321077969662:web:66f9d57c3a2b16834e5baf',
    messagingSenderId: '321077969662',
    projectId: 'notes-app-68680',
    authDomain: 'notes-app-68680.firebaseapp.com',
    storageBucket: 'notes-app-68680.firebasestorage.app',
    measurementId: 'G-ZY7BPL47KM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDa_4mpdNBP_SPD7Fh8LAypYlF2wzJUj_4',
    appId: '1:321077969662:android:4114749b97060eee4e5baf',
    messagingSenderId: '321077969662',
    projectId: 'notes-app-68680',
    storageBucket: 'notes-app-68680.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'your-ios-api-key',
    appId: 'your-ios-app-id',
    messagingSenderId: 'your-messaging-sender-id',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
    iosBundleId: 'com.example.notesApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'your-macos-api-key',
    appId: 'your-macos-app-id',
    messagingSenderId: 'your-messaging-sender-id',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
    iosBundleId: 'com.example.notesApp',
  );
} 