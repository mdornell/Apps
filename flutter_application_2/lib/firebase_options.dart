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
    apiKey: 'AIzaSyBObLN32IjcC4RP71W-dLiHov6jarjOIGE',
    appId: '1:368988581494:web:c8a8e7e420e68d734d7957',
    messagingSenderId: '368988581494',
    projectId: 'flutterapp-2a8e6',
    authDomain: 'flutterapp-2a8e6.firebaseapp.com',
    storageBucket: 'flutterapp-2a8e6.firebasestorage.app',
    measurementId: 'G-Y215KXZLCF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZAHTf4VOGIZ5_NfnC3aPLqMkA6DG1U4k',
    appId: '1:368988581494:android:32008de8f918156a4d7957',
    messagingSenderId: '368988581494',
    projectId: 'flutterapp-2a8e6',
    storageBucket: 'flutterapp-2a8e6.firebasestorage.app',
  );
}
