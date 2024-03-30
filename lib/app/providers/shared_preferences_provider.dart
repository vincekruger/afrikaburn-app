import 'package:nylo_framework/nylo_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider implements NyProvider {
  late final SharedPreferences prefs;
  boot(Nylo nylo) async {
    return nylo;
  }

  afterBoot(Nylo nylo) async {
    prefs = await SharedPreferences.getInstance();

    /// Get Preferences
    _analyticsCollectionEnabled =
        prefs.getBool(_analyticsCollectionEnabledKey) ?? true;
  }

  String _analyticsCollectionEnabledKey = 'analyticsCollectionEnabled';
  bool _analyticsCollectionEnabled = true;
  bool get analyticsCollectionEnabled => _analyticsCollectionEnabled;
  void set analyticsCollectionEnabled(bool value) {
    _analyticsCollectionEnabled = value;
    prefs.setBool(_analyticsCollectionEnabledKey, value);
  }
}
