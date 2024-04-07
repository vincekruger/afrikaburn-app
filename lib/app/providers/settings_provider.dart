import 'package:afrikaburn/app/events/analytics_tracking_event.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afrikaburn/config/storage_keys.dart';

class SettingsProvider implements NyProvider {
  Future<Nylo?> boot(Nylo nylo) async => nylo;
  Future<void> afterBoot(Nylo nylo) async {
    compareAppSettings();
  }

  /// Compare the app settings
  /// This is used to compare the app settings if they are changed in the background
  /// It also checks if the app settings are still the same when the app resumes
  Future<void> compareAppSettings() async {
    /// Check the certain shared preferences agains our local storage
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    /// Configure the analytics collection and notification settings
    configureAnalyticsCollection(prefs);
    configureNotificationSettings(prefs);
  }

  /// Configure Firebase Analytics and Firebase Crashlytics collection
  Future<void> configureAnalyticsCollection(SharedPreferences prefs) async {
    /// Check privacy settings
    /// Set the analytics collection enabled status
    /// for Firebase Analytics and Firebase Crashlytics
    String key = SharedPreferenceKey.analyticsAllowed;
    bool? analyticsEnabledPref = prefs.getBool(key);

    /// not default key was found
    if (analyticsEnabledPref == null) {
      await prefs.setBool(key, true);
      analyticsEnabledPref = true;
    }

    /// Trigger the event
    event<AnalyticsTrackingEvent>(data: {
      "enabled": analyticsEnabledPref,
      "update_prefs": false,
    });
  }

  /// Check and configure notification settings
  Future<void> configureNotificationSettings(SharedPreferences prefs) async {
    NotificationSetting(
      prefKey: SharedPreferenceKey.notificationNewsUpdates,
      topicKey: NotificationSubscriptionKey.news,
    ).check();
    NotificationSetting(
      prefKey: SharedPreferenceKey.notificationBurnUpdates,
      topicKey: NotificationSubscriptionKey.burn,
    ).check();
    NotificationSetting(
      prefKey: SharedPreferenceKey.notificationAppUpdates,
      topicKey: NotificationSubscriptionKey.app,
    ).check();
  }
}

/// Notification Setting
class NotificationSetting {
  String prefKey;
  String topicKey;
  NotificationSetting({
    required this.prefKey,
    required this.topicKey,
  }) {
    /// Set the keys
    lastKey = lastKeyPrefix + prefKey;
    statusKey = prefKey;
  }

  String lastKeyPrefix = 'last_state_';

  late String lastKey;
  late String statusKey;

  bool? last;
  bool? status;

  Future<void> check() async {
    /// Fetch the shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    last = await prefs.getBool(lastKey);
    status = await prefs.getBool(statusKey);

    /// Current status is null, set default to false
    if (status == null) {
      await prefs.setBool(statusKey, false);
      await prefs.setBool(lastKey, false);
      last = false;
      status = false;
    }

    /// Check if the status is different from the last status
    /// If it is, update the status and manage the subscription
    if (last != status) manageSubscription(status!);
  }

  /// Manage the subscription status
  manageSubscription(bool subscribed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (subscribed == true) {
      FirebaseMessaging.instance.subscribeToTopic(topicKey);
      prefs.setBool(lastKey, subscribed);
      prefs.setBool(statusKey, subscribed);
    }

    if (subscribed == false) {
      FirebaseMessaging.instance.unsubscribeFromTopic(topicKey);
      prefs.setBool(lastKey, subscribed);
      prefs.setBool(statusKey, subscribed);
    }
  }
}
