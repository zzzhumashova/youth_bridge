// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

void initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

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
    apiKey: 'AIzaSyDED5dDu3gs_LL5TRZcV-p0GTzOBsdRuvE',
    appId: '1:834743475191:web:9a3f5c3ab7918d9187ecf2',
    messagingSenderId: '834743475191',
    projectId: 'youth-bridge',
    authDomain: 'youth-bridge.firebaseapp.com',
    storageBucket: 'youth-bridge.appspot.com',
    measurementId: 'G-5XVKMX43VR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAveK0JapWk-r-QU7T8WwusT064pOVaiu4',
    appId: '1:834743475191:android:23f0c82e687c61e287ecf2',
    messagingSenderId: '834743475191',
    projectId: 'youth-bridge',
    storageBucket: 'youth-bridge.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDseLUrrgEoLJocawCzw1exQOIqcgLvjEU',
    appId: '1:834743475191:ios:84bc35a22e7b07cf87ecf2',
    messagingSenderId: '834743475191',
    projectId: 'youth-bridge',
    storageBucket: 'youth-bridge.appspot.com',
    iosBundleId: 'com.example.youthBridge',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDseLUrrgEoLJocawCzw1exQOIqcgLvjEU',
    appId: '1:834743475191:ios:84bc35a22e7b07cf87ecf2',
    messagingSenderId: '834743475191',
    projectId: 'youth-bridge',
    storageBucket: 'youth-bridge.appspot.com',
    iosBundleId: 'com.example.youthBridge',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDED5dDu3gs_LL5TRZcV-p0GTzOBsdRuvE',
    appId: '1:834743475191:web:51fa3e9f3d15efd387ecf2',
    messagingSenderId: '834743475191',
    projectId: 'youth-bridge',
    authDomain: 'youth-bridge.firebaseapp.com',
    storageBucket: 'youth-bridge.appspot.com',
    measurementId: 'G-CWJFLHJM81',
  );
}
