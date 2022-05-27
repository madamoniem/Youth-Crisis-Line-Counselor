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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfKavV9Hm0DG7Xj-8bXqctCh1wIf3z-eQ',
    appId: '1:582386416006:android:db308ef89fb9252ed39407',
    messagingSenderId: '582386416006',
    projectId: 'yclapp-0',
    databaseURL: 'https://yclapp-0-default-rtdb.firebaseio.com',
    storageBucket: 'yclapp-0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGL9hL2OxZIt8DCxC8ENWwxhBS3A1usqA',
    appId: '1:582386416006:ios:5fd37a3cbcab2dc5d39407',
    messagingSenderId: '582386416006',
    projectId: 'yclapp-0',
    databaseURL: 'https://yclapp-0-default-rtdb.firebaseio.com',
    storageBucket: 'yclapp-0.appspot.com',
    iosClientId: '582386416006-khl3efeks5nispht95j6s08i0kcpc419.apps.googleusercontent.com',
    iosBundleId: 'com.example.yclcounselor',
  );
}
