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
    apiKey: 'AIzaSyBnKDTnsJ6ebV5ikZUK1qF6iBF_c-rFP4w',
    appId: '1:381523083106:web:404a510d5bce2aca7ef63b',
    messagingSenderId: '381523083106',
    projectId: 'mobile-theft-identification',
    authDomain: 'mobile-theft-identification.firebaseapp.com',
    storageBucket: 'mobile-theft-identification.appspot.com',
    measurementId: 'G-9YKWV553NH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCxRT8UKqF1zjksPfLHCL8XTr1JAmr04qM',
    appId: '1:381523083106:android:cce7006c6ba65d6f7ef63b',
    messagingSenderId: '381523083106',
    projectId: 'mobile-theft-identification',
    storageBucket: 'mobile-theft-identification.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCpD4uqJAvJ3dQs_u1XY51xbLHrwoW-p48',
    appId: '1:381523083106:ios:40949b2f310873f97ef63b',
    messagingSenderId: '381523083106',
    projectId: 'mobile-theft-identification',
    storageBucket: 'mobile-theft-identification.appspot.com',
    iosBundleId: 'com.example.mobileApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCpD4uqJAvJ3dQs_u1XY51xbLHrwoW-p48',
    appId: '1:381523083106:ios:b5e68f96ac05fe8b7ef63b',
    messagingSenderId: '381523083106',
    projectId: 'mobile-theft-identification',
    storageBucket: 'mobile-theft-identification.appspot.com',
    iosBundleId: 'com.example.mobileApp.RunnerTests',
  );
}
