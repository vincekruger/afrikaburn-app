import 'package:nylo_framework/nylo_framework.dart';

/* Storage Keys
|--------------------------------------------------------------------------
| Storage keys are used to read and write to local storage.
| E.g. static String userCoins = "USER_COINS";
| String coins = NyStorage.read( StorageKey.userCoins );
|
| Learn more: https://nylo.dev/docs/5.20.0/storage#storage-keys
|-------------------------------------------------------------------------- */

class StorageKey {
  static String userToken = "USER_TOKEN";
  static String authUser = getEnv('AUTH_USER_KEY', defaultValue: 'AUTH_USER');
  static String radioFreeTankwasPlaying = 'RADIO_FREE_TANKWA_PLAYING';
}

class SharedPreferenceKey {
  static String analyticsAllowed = 'analytics_collection_enabled';
  static String notificationNewsUpdates = 'subscribed_news_updates';
  static String notificationBurnUpdates = 'subscribed_burn_updates';
  static String notificationAppUpdates = 'subscribed_app_updates';
}

class NotificationSubscriptionKey {
  static String news = 'news';
  static String burn = 'burn';
  static String app = 'app';
}
