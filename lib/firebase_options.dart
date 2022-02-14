// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCMd-Cf4QLyrp993-NbZHfEZgth-hoxdk0',
    appId: '1:950149484109:web:64d10d2805d1205bd89604',
    messagingSenderId: '950149484109',
    projectId: 'student-attendance-manag-22782',
    authDomain: 'student-attendance-manag-22782.firebaseapp.com',
    databaseURL: 'https://student-attendance-manag-22782-default-rtdb.firebaseio.com',
    storageBucket: 'student-attendance-manag-22782.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAplLIo1yEds5cw4l235edpF-taOvqw-u8',
    appId: '1:950149484109:android:53604cb5ddf7071cd89604',
    messagingSenderId: '950149484109',
    projectId: 'student-attendance-manag-22782',
    databaseURL: 'https://student-attendance-manag-22782-default-rtdb.firebaseio.com',
    storageBucket: 'student-attendance-manag-22782.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCsiGllmhU-pwB9xrLBLtthYj_3ul9pnbk',
    appId: '1:950149484109:ios:178b1e74f9d34cfad89604',
    messagingSenderId: '950149484109',
    projectId: 'student-attendance-manag-22782',
    databaseURL: 'https://student-attendance-manag-22782-default-rtdb.firebaseio.com',
    storageBucket: 'student-attendance-manag-22782.appspot.com',
    iosClientId: '950149484109-gkdhtjdv73gmok2ogtv8l24p74mlg359.apps.googleusercontent.com',
    iosBundleId: 'com.example.attendancManagementApp',
  );
}