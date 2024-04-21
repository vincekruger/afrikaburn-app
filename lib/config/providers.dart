import '/app/providers/geolocator_provider.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/app/providers/app_links_provider.dart';
import '/app/providers/settings_provider.dart';
import '/app/providers/radio_free_tankwa_provider.dart';
import '/app/providers/shared_preferences_provider.dart';
import '/app/providers/system_provider.dart';
import '/app/providers/firebase_provider.dart';
import '/app/providers/auth_provider.dart';
import '/app/providers/app_provider.dart';
import '/app/providers/event_provider.dart';
import '/app/providers/route_provider.dart';
import '/app/providers/app_mode_provider.dart';
import '/app/providers/guide_download_provider.dart';
import '/app/providers/map_data_provider.dart';

/* Providers
|--------------------------------------------------------------------------
| Add your "app/providers" here.
| Providers are booted when your application start.
|
| Learn more: https://nylo.dev/docs/5.20.0/providers
|-------------------------------------------------------------------------- */

final Map<Type, NyProvider> providers = {
  AppProvider: AppProvider(),
  RouteProvider: RouteProvider(),
  EventProvider: EventProvider(),
  AuthProvider: AuthProvider(),
  FirebaseProvider: FirebaseProvider(),
  SystemProvider: SystemProvider(),
  SharedPreferencesProvider: SharedPreferencesProvider(),
  SettingsProvider: SettingsProvider(),
  RadioFreeTankwaProvider: RadioFreeTankwaProvider(),
  AppLinksProvider: AppLinksProvider(),
  AppModeProvider: AppModeProvider(),
  GuideDownloadProvider: GuideDownloadProvider(),
  MapDataProvider: MapDataProvider(),

  GeolocatorProvider: GeolocatorProvider(),
};
