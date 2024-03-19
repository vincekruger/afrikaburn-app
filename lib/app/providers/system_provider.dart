import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';

class SystemProvider implements NyProvider {
  boot(Nylo nylo) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return nylo;
  }

  afterBoot(Nylo nylo) async {}
}
