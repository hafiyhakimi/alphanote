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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCZZUiuhpPP-cWOl0P1szpEjUKPeDpC9a0',
    appId: '1:148163652625:web:c8e634da3daa56324655b0',
    messagingSenderId: '148163652625',
    projectId: 'noteappmap',
    authDomain: 'noteappmap.firebaseapp.com',
    databaseURL: 'https://noteappmap-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'noteappmap.appspot.com',
    measurementId: 'G-BD0ZNXVC5W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVylwe7rfei5E5wFgR44OXRok6-DARKeI',
    appId: '1:148163652625:android:644ffa4eea93fd8d4655b0',
    messagingSenderId: '148163652625',
    projectId: 'noteappmap',
    databaseURL: 'https://noteappmap-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'noteappmap.appspot.com',
  );
}
