import 'package:afrikaburn/app/events/analytics_tracking_event.dart';
import 'package:afrikaburn/app/events/notifications_event.dart';
import 'package:flutter/widgets.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afrikaburn/app/controllers/ticket_controller.dart';
import 'package:afrikaburn/app/models/file_size.dart';
import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/config/storage_keys.dart';
import 'package:afrikaburn/app/controllers/controller.dart';

class SettingsController extends Controller {
  @override
  construct(BuildContext context) {
    super.construct(context);
  }

  ///
  /// Notifications
  ///
  bool notificationsAllowed = false;
  bool notificationsPermanentlyDenied = false;
  bool notificationNewsUpdates = false;
  bool notificationBurnUpdates = false;
  bool notificationAppUpdates = false;

  /// Request notifications permission
  Future<void> requestNotificationsPermission() async {
    await Permission.notification.request();
    updatePageState('requested-notifications-permission', {});
  }

  /// Check notification subscriptions
  Future<void> checkNotificationSubscriptions() async {
    /// Check the permission status
    PermissionStatus status = await Permission.notification.status;
    notificationsAllowed = status == PermissionStatus.granted ||
        status == PermissionStatus.limited ||
        status == PermissionStatus.restricted ||
        status == PermissionStatus.provisional;
    notificationsPermanentlyDenied =
        status == PermissionStatus.permanentlyDenied;

    /// Get notification subscription settings
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notificationNewsUpdates =
        prefs.getBool(SharedPreferenceKey.notificationNewsUpdates) ?? false;
    notificationBurnUpdates =
        prefs.getBool(SharedPreferenceKey.notificationBurnUpdates) ?? false;
    notificationAppUpdates =
        prefs.getBool(SharedPreferenceKey.notificationAppUpdates) ?? false;

    /// update the page state
    updatePageState('notifications-permissions-checked', {});
  }

  /// Set notification
  Future<void> setNotification(String type, bool value) async {
    /// Set notification settings
    switch (type) {
      case 'news':
        notificationNewsUpdates = value;
        event<NotificationsEvent>(data: {
          "topic": NotificationSubscriptionKey.news,
          "subscription_status": value,
        });
        break;
      case 'burn':
        notificationBurnUpdates = value;
        event<NotificationsEvent>(data: {
          "topic": NotificationSubscriptionKey.burn,
          "subscription_status": value,
        });
        break;
      case 'app':
        notificationAppUpdates = value;
        event<NotificationsEvent>(data: {
          "topic": NotificationSubscriptionKey.app,
          "subscription_status": value,
        });
        break;
    }

    /// Update the page state
    updatePageState('notifcation', {});
  }

  ///
  /// Local Storage
  ///

  /// Get ticket data size
  Future<FileSize> calculateTicketDataSize() async {
    int size = await TicketController.getDataSize();
    return FileSize.size(size);
  }

  /// Delete ticket data
  Future<void> deleteTicketData() async {
    /// Show a busy indicator
    updatePageState('ticket-data-deleting', {state: true});

    ///  Delete the ticket data && update the page state
    await TicketController.clearAllTicketData();

    /// Hide the busy indicator
    updatePageState('ticket-data-deleted', null);
  }

  ///
  /// Privary
  ///
  bool analyticsAllowed = false;

  /// Check privacy settings
  Future<void> checkPrivacySettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    analyticsAllowed =
        await prefs.getBool(SharedPreferenceKey.analyticsAllowed) ?? true;
  }

  /// Set privacy settings
  Future<void> setPrivacySettings(bool value) async {
    analyticsAllowed = value;
    event<AnalyticsTrackingEvent>(data: {"enabled": value});
    updatePageState('privacy-settings', {});
  }
}
