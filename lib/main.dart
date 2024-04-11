import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/bootstrap/boot.dart';
import 'package:afrikaburn/bootstrap/app.dart';
import 'package:afrikaburn/app/providers/app_links_provider.dart';

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
