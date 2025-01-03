// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBfV64bl-NZaMnUiwVTTxB6C7JRMiTEvbU',
    appId: '1:404077597399:ios:38a236891859fae449d692',
    messagingSenderId: '404077597399',
    projectId: 'personalfinance-30e87',
    storageBucket: 'personalfinance-30e87.firebasestorage.app',
    iosBundleId: 'dev.donmanuel.app.personalFinance',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNw0tuDOcMdh7GnY3nOb1K9Rdc6Lrn6Yo',
    appId: '1:404077597399:android:9c9a8298a57ecd6349d692',
    messagingSenderId: '404077597399',
    projectId: 'personalfinance-30e87',
    storageBucket: 'personalfinance-30e87.firebasestorage.app',
  );

}