import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/models/user.dart';
import 'package:afrikaburn/app/events/login_event.dart';
import 'package:afrikaburn/app/events/logout_event.dart';
import 'package:afrikaburn/app/events/analytics_tracking_event.dart';
import 'package:afrikaburn/app/events/notifications_event.dart';
import 'package:afrikaburn/app/events/root_app_lifecycle_event.dart';

/* Events
|--------------------------------------------------------------------------
| Add your "app/events" here.
| Events can be fired using: event<MyEvent>();
|
| Learn more: https://nylo.dev/docs/5.20.0/events
|-------------------------------------------------------------------------- */

final Map<Type, NyEvent> events = {
  LoginEvent: LoginEvent(),
  LogoutEvent: LogoutEvent(),
  AuthUserEvent: AuthUserEvent(),
  SyncAuthToBackpackEvent: SyncAuthToBackpackEvent<User>(),
  RootAppLifecycleEvent: RootAppLifecycleEvent(),
  NotificationsEvent: NotificationsEvent(),
  AnalyticsTrackingEvent: AnalyticsTrackingEvent(),
};
