import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';

class SystemProvider implements NyProvider {
  boot(Nylo nylo) async {
    setOnlyPortraitOrientation();
    return nylo;
  }

  afterBoot(Nylo nylo) async {}

  /// Set only portrait orientation
  setOnlyPortraitOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  /// Set portrait & landscape orientation
  setPortraitAndLandscapeOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
