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
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCYIRvn6Jklw0DNAeBGtIYgLK5Z2G2kJrk',
    appId: '1:517412466082:web:7747ef1d6e9ab5a72756fb',
    messagingSenderId: '517412466082',
    projectId: 'horas-v3-1751f',
    authDomain: 'horas-v3-1751f.firebaseapp.com',
    storageBucket: 'horas-v3-1751f.appspot.com',
    measurementId: 'G-RGZ58RYZPM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDOn8CaZX75iuuBjJbzmaqPv0xLV-KqFII',
    appId: '1:517412466082:android:52b8495e9a3fdfe62756fb',
    messagingSenderId: '517412466082',
    projectId: 'horas-v3-1751f',
    storageBucket: 'horas-v3-1751f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNON92BL_1x8wnRK6LA9C-Snor3BgHGRk',
    appId: '1:517412466082:ios:4fa67dfc40a291372756fb',
    messagingSenderId: '517412466082',
    projectId: 'horas-v3-1751f',
    storageBucket: 'horas-v3-1751f.appspot.com',
    androidClientId: '517412466082-6q2udm0hi3ceiuv7r85aa6vnmou41h6o.apps.googleusercontent.com',
    iosClientId: '517412466082-90n5ub2t8nbjlq4dtehaem3e0nms1en7.apps.googleusercontent.com',
    iosBundleId: 'br.com.horas.v3.horasV3',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCYIRvn6Jklw0DNAeBGtIYgLK5Z2G2kJrk',
    appId: '1:517412466082:web:1935953db8eb93c52756fb',
    messagingSenderId: '517412466082',
    projectId: 'horas-v3-1751f',
    authDomain: 'horas-v3-1751f.firebaseapp.com',
    storageBucket: 'horas-v3-1751f.appspot.com',
    measurementId: 'G-8GW6TBMVPW',
  );

}