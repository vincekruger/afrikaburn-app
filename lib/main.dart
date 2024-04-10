import 'package:afrikaburn/app/providers/app_links_provider.dart';
import 'package:afrikaburn/resources/pages/radio_free_tankwa_page.dart';
import 'package:afrikaburn/resources/pages/root.dart';
import 'package:afrikaburn/resources/widgets/default_world_navigation_bar_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/bootstrap/app.dart';
import 'bootstrap/boot.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Nylo nylo = await Nylo.init(setup: Boot.nylo, setupFinished: Boot.finished);

  // Run the app
  runApp(
    AppBuild(
      navigatorKey: NyNavigator.instance.router.navigatorKey,
      onGenerateRoute: nylo.router!.generator(),
      onUnknownRoute: AppLinksProvider.handleDeepLink,
      debugShowCheckedModeBanner: kDebugMode || appFlavor != 'Production',
      initialRoute: nylo.getInitialRoute(),
      navigatorObservers: nylo.getNavigatorObservers(),
    ),
  );
}
