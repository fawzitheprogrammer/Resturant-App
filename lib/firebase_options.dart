// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDSlXm4NXkLNdzjZIJsQ8LYyiWJY52YBGc',
    appId: '1:88309537787:web:ad3a7f5caa782750e0895e',
    messagingSenderId: '88309537787',
    projectId: 'resturant-f093a',
    authDomain: 'resturant-f093a.firebaseapp.com',
    storageBucket: 'resturant-f093a.appspot.com',
    measurementId: 'G-TXH02YHLKC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBC6OqnwCHTjgeRZjatFOgqUGTLuuJ15Mk',
    appId: '1:88309537787:android:5bbe15c67d60d2bae0895e',
    messagingSenderId: '88309537787',
    projectId: 'resturant-f093a',
    storageBucket: 'resturant-f093a.appspot.com',
    authDomain: 'resturant-f093a.firebaseapp.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC58anUcvr_J7qSO3eKUYG99shmzBMxptM',
    appId: '1:88309537787:ios:4814aa0ecdbad3efe0895e',
    messagingSenderId: '88309537787',
    projectId: 'resturant-f093a',
    storageBucket: 'resturant-f093a.appspot.com',
    iosBundleId: 'com.sixamtech.stackFood',
    authDomain: 'resturant-f093a.firebaseapp.com',
  );
}
