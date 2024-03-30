import 'package:nylo_framework/nylo_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider implements NyProvider {
  /// Shared Preferences
  late final SharedPreferences prefs;

  /// Boot Preferences
  boot(Nylo nylo) async {
    prefs = await SharedPreferences.getInstance();

    return nylo;
  }

  /// Ger Preferences
  afterBoot(Nylo nylo) async {
    /// Get Preferences
    _analyticsCollectionEnabled =
        prefs.getBool(_analyticsCollectionEnabledKey) ?? true;
  }

  /// Analytics Collection Enabled
  /// Config and defaults
  String _analyticsCollectionEnabledKey = 'analyticsCollectionEnabled';
  bool _analyticsCollectionEnabled = true;

  /// Analytics Collection Enabled
  /// Getters and Setters
  bool get analyticsCollectionEnabled => _analyticsCollectionEnabled;
  void set analyticsCollectionEnabled(bool value) {
    _analyticsCollectionEnabled = value;
    prefs.setBool(_analyticsCollectionEnabledKey, value);
  }
}
