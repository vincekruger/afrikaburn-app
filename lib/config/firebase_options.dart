// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/services.dart';

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidDebug; // need to setup a flavor
      // return kReleaseMode ? androidRelease : androidDebug;
      case TargetPlatform.iOS:
        switch (appFlavor) {
          case 'Production':
            return iosProdution;
          default:
            return iosDebug;
        }
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions androidDebug = FirebaseOptions(
    apiKey: 'AIzaSyDPiW4KupYTBf8NTiDeGO3QcpxVBLRS7q0',
    appId: '1:700936341717:android:21b26910263a4daedc7a5c',
    messagingSenderId: '700936341717',
    projectId: 'afrikaburn-dev',
    databaseURL: 'https://afrikaburn-dev.firebaseio.com',
    storageBucket: 'afrikaburn-dev.appspot.com',
    iosBundleId: 'io.wheresmyshit.afrikaburn.debug',
  );

  static const FirebaseOptions androidRelease = FirebaseOptions(
    apiKey: 'AIzaSyCXUUuT4UNKIqXmFwpYFrWE7BFZCy0nS0M',
    appId: '1:1070999950214:android:c5a0bf87eb561a4d369207',
    messagingSenderId: '1070999950214',
    projectId: 'afrikaburn-35158',
    databaseURL: 'https://afrikaburn-35158.firebaseio.com',
    storageBucket: 'afrikaburn-35158.appspot.com',
    iosBundleId: 'io.wheresmyshit.afrikaburn',
  );

  static const FirebaseOptions iosDebug = FirebaseOptions(
    apiKey: 'AIzaSyDqmzd1DXLHyWzgrw_3ue8EJ-X8qNg8ot4',
    appId: '1:700936341717:ios:279c7d73b35ab765dc7a5c',
    messagingSenderId: '700936341717',
    projectId: 'afrikaburn-dev',
    databaseURL: 'https://afrikaburn-dev.firebaseio.com',
    storageBucket: 'afrikaburn-dev.appspot.com',
    iosBundleId: 'io.wheresmyshit.afrikaburn.debug',
  );

  static const FirebaseOptions iosProdution = FirebaseOptions(
    apiKey: 'AIzaSyAiCwczgOo37F2irJnuMEyYeZ_xMFcQm28',
    appId: '1:1070999950214:ios:cf2bb9076565c3c0369207',
    messagingSenderId: '1070999950214',
    projectId: 'afrikaburn-35158',
    databaseURL: 'https://afrikaburn-35158.firebaseio.com',
    storageBucket: 'afrikaburn-35158.appspot.com',
    iosBundleId: 'za.co.wheresmyshit.ios.afrikaburn',
  );

  // static const FirebaseOptions iosProdutionNewBundleId = FirebaseOptions(
  //   apiKey: 'AIzaSyAiCwczgOo37F2irJnuMEyYeZ_xMFcQm28',
  //   appId: '1:1070999950214:ios:fbb43063c274316e369207',
  //   messagingSenderId: '1070999950214',
  //   projectId: 'afrikaburn-35158',
  //   databaseURL: 'https://afrikaburn-35158.firebaseio.com',
  //   storageBucket: 'afrikaburn-35158.appspot.com',
  //   iosBundleId: 'io.wheresmyshit.afrikaburn',
  // );
}
