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
    apiKey: 'AIzaSyD3QgyrKjW-u2-r7n5-UcZU4JIXsWdLhEo',
    appId: '1:737239123363:web:0c533cf4441c50decc0616',
    messagingSenderId: '737239123363',
    projectId: 'manabisnis-78e16',
    authDomain: 'manabisnis-78e16.firebaseapp.com',
    databaseURL: 'https://manabisnis-78e16-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'manabisnis-78e16.appspot.com',
    measurementId: 'G-FPMZQKCEL9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCO-0si-KGuZzSmvVMJrPjI42iEBRBeAA0',
    appId: '1:737239123363:android:7949b4e79655dba9cc0616',
    messagingSenderId: '737239123363',
    projectId: 'manabisnis-78e16',
    databaseURL: 'https://manabisnis-78e16-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'manabisnis-78e16.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZO8xt1RxPZ8OjEnq2abYS6mfGLaojef8',
    appId: '1:737239123363:ios:da73400143a1816ccc0616',
    messagingSenderId: '737239123363',
    projectId: 'manabisnis-78e16',
    databaseURL: 'https://manabisnis-78e16-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'manabisnis-78e16.appspot.com',
    iosClientId: '737239123363-nho3o2638n5jeasvvf7ktm8o8uucjb0n.apps.googleusercontent.com',
    iosBundleId: 'com.manabisnis.manabisnis',
  );
}
