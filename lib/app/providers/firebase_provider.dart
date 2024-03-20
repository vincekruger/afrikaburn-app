import 'package:flutter/foundation.dart';
import 'package:nylo_framework/nylo_framework.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_app/config/firebase_options.dart';

class FirebaseProvider implements NyProvider {
  boot(Nylo nylo) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    return nylo;
  }

  afterBoot(Nylo nylo) async {
    // Setup Remote Config
    // final remoteConfig = FirebaseRemoteConfig.instance;
    // await remoteConfig.setConfigSettings(RemoteConfigSettings(
    //   fetchTimeout: const Duration(minutes: 1),
    //   minimumFetchInterval: const Duration(minutes: 5),
    // ));

    // // Setup Remote Config Listener
    // remoteConfig.onConfigUpdated.listen((event) async {
    //   await remoteConfig.activate();
    // });

    // // Fetch remote config
    // await remoteConfig.fetchAndActivate();
  }
}
