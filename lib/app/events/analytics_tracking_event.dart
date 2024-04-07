import 'package:afrikaburn/config/storage_keys.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsTrackingEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    /// Set the analytics collection status
    bool analyticsEnabled = event['enabled'] ?? true;
    bool updatePrefs = event['update_prefs'] ?? true;

    /// Update the shared preferences
    if (updatePrefs) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(SharedPreferenceKey.analyticsAllowed, analyticsEnabled);
    }

    /// Set the firebase components
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(analyticsEnabled);
    FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(analyticsEnabled);
  }
}
