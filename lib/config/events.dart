import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/models/user.dart';
import 'package:afrikaburn/app/events/analytics_tracking_event.dart';
import 'package:afrikaburn/app/events/notifications_event.dart';
import 'package:afrikaburn/app/events/root_app_lifecycle_event.dart';
import 'package:afrikaburn/app/events/tankwa_mode_event.dart';
import 'package:afrikaburn/app/events/hide_tickets_event.dart';
import 'package:afrikaburn/app/events/remote_config_updates_event.dart';
import 'package:afrikaburn/app/events/prepare_data_event.dart';

/* Events
|--------------------------------------------------------------------------
| Add your "app/events" here.
| Events can be fired using: event<MyEvent>();
|
| Learn more: https://nylo.dev/docs/5.20.0/events
|-------------------------------------------------------------------------- */

final Map<Type, NyEvent> events = {
  AuthUserEvent: AuthUserEvent(),
  SyncAuthToBackpackEvent: SyncAuthToBackpackEvent<User>(),
  RootAppLifecycleEvent: RootAppLifecycleEvent(),
  NotificationsEvent: NotificationsEvent(),
  AnalyticsTrackingEvent: AnalyticsTrackingEvent(),
  TankwaModeEvent: TankwaModeEvent(),
  HideTicketsEvent: HideTicketsEvent(),
  RemoteConfigUpdatesEvent: RemoteConfigUpdatesEvent(),
  PrepareEventDataEvent: PrepareEventDataEvent(),
};
