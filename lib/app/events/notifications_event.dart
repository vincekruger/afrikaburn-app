import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/providers/settings_provider.dart';
import 'package:afrikaburn/config/storage_keys.dart';

class NotificationsEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    /// Check we have all the correct data
    if (event['topic'] == null || event['subscription_status'] == null) return;
    String topic = event['topic'] as String;
    bool subscriptionStatus = event['subscription_status'] as bool;

    /// Set the correct prefKey based on the topic
    late String prefKey;
    if (topic == NotificationSubscriptionKey.news) {
      prefKey = SharedPreferenceKey.notificationNewsUpdates;
    } else if (topic == NotificationSubscriptionKey.burn) {
      prefKey = SharedPreferenceKey.notificationBurnUpdates;
    } else if (topic == NotificationSubscriptionKey.app) {
      prefKey = SharedPreferenceKey.notificationAppUpdates;
    }

    /// Run the check
    NotificationSetting(
      prefKey: prefKey,
      topicKey: topic,
    ).manageSubscription(subscriptionStatus);
  }
}
