import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:afrikaburn/config/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afrikaburn/config/default_remote_config.dart';
import 'package:afrikaburn/config/storage_keys.dart';

class FirebaseProvider implements NyProvider {
  /// Run before boot
  /// Initialize Firebase
  /// Setup Firebase Crashlytics
  boot(Nylo nylo) async {
    /// I don't know why ios has such an issue with this
    /// but it does.  This is a workaround for now.
    if (Firebase.apps.isEmpty) {
      if (Platform.isIOS) {
        await Firebase.initializeApp(
          name: getEnv('APP_NAME'),
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } else
        await Firebase.initializeApp(
          // name: getEnv('APP_NAME'),
          options: DefaultFirebaseOptions.currentPlatform,
        );
    }

    /// Pass all uncaught "fatal" errors from the framework to Crashlytics
    if (!kDebugMode) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
    }

    return nylo;
  }

  /// Run after boot
  /// Configure Firebase Remote Config
  /// Configure Firebase Analytics
  afterBoot(Nylo nylo) async {
    await _configureAppCheck();
    await _configureRemoteConfig();
    await _configureAnalyticsCollection(nylo);

    /// Configure Firestore offline persistence
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  /// Configure Firebase App Check
  Future<void> _configureAppCheck() async {
    /// Defaults to debug mode
    AndroidProvider androidProvider = AndroidProvider.debug;
    AppleProvider appleProvider = AppleProvider.debug;

    /// Release Release Mode
    /// ---
    /// This is set in the .env file and used to determine the provider to use
    /// for Firebase App Check.  If using Firebase App Distribution, remove
    /// the variable from the .env file to use production providers.
    if (getEnv('PRODUCTION_APPCHECK', defaultValue: false) == true) {
      print('Using production Firebase App Check providers');
      androidProvider = AndroidProvider.playIntegrity;
      appleProvider = AppleProvider.appAttest;
    }

    /// Activate Firebase App Check
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: androidProvider,
        appleProvider: appleProvider,
      );
    } on FirebaseException catch (error) {
      print('FirebaseAppCheck error: $error.toString()');
    }
  }

  /// Configure Firebase Remote Config
  Future<void> _configureRemoteConfig() async {
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

    /// Set default remote config values
    await remoteConfig.setDefaults(DefaultRemoteConfig.defaultConfig);

    /// Fetch remote config
    await remoteConfig.fetchAndActivate().catchError((error) {
      print("Error fetching remote config: $error");
      return false;
    });
  }

  /// Configure Firebase Analytics
  Future<void> _configureAnalyticsCollection(Nylo nylo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool collectionEnabled =
        await prefs.getBool(SharedPreferenceKey.analyticsAllowed) ?? true;

    /// Set Analytics Collection Enabled state
    /// Set Crashlytics Collection Enabled state
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(collectionEnabled);
    FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(collectionEnabled);

    /// Add Firebase Analytics Observer
    nylo.addNavigatorObserver(
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance));
  }

  /// Log a screen view
  void logScreenView(String screenName, {Map<String, dynamic>? params}) {
    FirebaseAnalytics.instance.logScreenView(
      screenName: screenName,
      parameters: params,
    );
  }

  /// Log a custom event
  void logEvent(String eventName, Map<String, dynamic>? eventParams) {
    FirebaseAnalytics.instance.logEvent(
      name: eventName,
      parameters: eventParams ?? {},
    );
  }
}
