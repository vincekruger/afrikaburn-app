import 'package:nylo_framework/nylo_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider implements NyProvider {
  /// Shared Preferences
  late final SharedPreferences prefs;

  /// Flag to check if prefs is initialized
  bool _prefsInitialized = false;

  Future<SharedPreferencesProvider> init() async {
    if (!_prefsInitialized) {
      prefs = await SharedPreferences.getInstance();
      await _preloadPrefs();
      _prefsInitialized = true; // Mark initialization complete
    }

    return this;
  }

  /// Preload Preferences
  _preloadPrefs() async {
    _analyticsCollectionEnabled =
        await prefs.getBool(analyticsCollectionEnabledKey) ?? true;
    _newsTopicSubscribed = await prefs.getBool(newsTopicSubscribedKey) ?? false;
  }

  /// Boot Preferences
  boot(Nylo nylo) async {
    if (!_prefsInitialized) {
      prefs = await SharedPreferences.getInstance();
      _prefsInitialized = true; // Mark initialization complete
    }
    return nylo;
  }

  /// Ger Preferences
  afterBoot(Nylo nylo) async {
    await _preloadPrefs();
  }

  /// Analytics Collection Enabled
  /// Config and defaults
  static String analyticsCollectionEnabledKey =
      'flutter.analyticsCollectionEnabled';
  bool _analyticsCollectionEnabled = true;

  /// Analytics Collection Enabled
  /// Getters and Setters
  bool get analyticsCollectionEnabled => _analyticsCollectionEnabled;
  void set analyticsCollectionEnabled(bool value) {
    _analyticsCollectionEnabled = value;
    prefs.setBool(analyticsCollectionEnabledKey, value);
  }

  /// News Topic Notification Subscription
  static String newsTopicSubscribedKey = 'flutter.newsTopicSubscribed';
  bool _newsTopicSubscribed = false;
  bool get newsTopicSubscribed => _newsTopicSubscribed;
  void set newsTopicSubscribed(bool value) {
    _newsTopicSubscribed = value;
    prefs.setBool(newsTopicSubscribedKey, value);
  }
}
