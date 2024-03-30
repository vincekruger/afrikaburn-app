import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:nylo_framework/nylo_framework.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:afrikaburn/config/firebase_options.dart';
import 'package:afrikaburn/app/providers/shared_preferences_provider.dart';

class FirebaseProvider implements NyProvider {
  /// Run before boot
  /// Initialize Firebase
  /// Setup Firebase Crashlytics
  boot(Nylo nylo) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    return nylo;
  }

  /// Run after boot
  /// Configure Firebase Remote Config
  /// Configure Firebase Analytics
  afterBoot(Nylo nylo) async {
    await _configureRemoteConfig();
    await _configureAnalyticsCollection();

    /// Configure Firestore offline persistence
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    /// Set Crashlytics Collection Enabled state
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      SharedPreferencesProvider().analyticsCollectionEnabled,
    );
  }

  /// Configure Firebase Remote Config
  _configureRemoteConfig() async {
    /// Setup Remote Config
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 5),
    ));

    /// Setup Remote Config Listener
    remoteConfig.onConfigUpdated.listen((event) async {
      print("Remote config updated: $event");
      await remoteConfig.activate();
    });

    /// Fetch remote config
    await remoteConfig.fetchAndActivate().catchError((error) {
      print("Error fetching remote config: $error");
    });
  }

  /// Configure Firebase Analytics
  _configureAnalyticsCollection() async {
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
      SharedPreferencesProvider().analyticsCollectionEnabled,
    );
    print(
        "Analytics Collection Enabled set to ${SharedPreferencesProvider().analyticsCollectionEnabled}");
  }

  /// Log a screen view
  logScreenView(String screenName, {Map<String, dynamic>? params}) {
    FirebaseAnalytics.instance.logScreenView(
      screenName: screenName,
      parameters: params,
    );
  }

  /// Log a custom event
  logEvent(String eventName, Map<String, dynamic> eventParams) {
    FirebaseAnalytics.instance.logEvent(
      name: eventName,
      parameters: eventParams,
    );
  }
}
