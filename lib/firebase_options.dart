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
    apiKey: 'AIzaSyArmhbpimMX9Nk2cSKip0Vc9zdNdMpH-qY',
    appId: '1:841665318228:web:0bc75a3483310b0b670cc1',
    messagingSenderId: '841665318228',
    projectId: 'oun-firebase',
    authDomain: 'oun-firebase.firebaseapp.com',
    storageBucket: 'oun-firebase.appspot.com',
    measurementId: 'G-3G08V521YK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCL0ctTxrSXhomP2ohlEd7wYmRvypeKOxk',
    appId: '1:841665318228:android:06eed122d1ee032b670cc1',
    messagingSenderId: '841665318228',
    projectId: 'oun-firebase',
    storageBucket: 'oun-firebase.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAEjDHquEFDEQT0cYsBwC43bwu6pAhyUpc',
    appId: '1:841665318228:ios:fef9e34125440d86670cc1',
    messagingSenderId: '841665318228',
    projectId: 'oun-firebase',
    storageBucket: 'oun-firebase.appspot.com',
    iosClientId: '841665318228-v50qagsa22v6un9t66tudtlbbqrhte0d.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterAuth',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAEjDHquEFDEQT0cYsBwC43bwu6pAhyUpc',
    appId: '1:841665318228:ios:fef9e34125440d86670cc1',
    messagingSenderId: '841665318228',
    projectId: 'oun-firebase',
    storageBucket: 'oun-firebase.appspot.com',
    iosClientId: '841665318228-v50qagsa22v6un9t66tudtlbbqrhte0d.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterAuth',
  );
}
