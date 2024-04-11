import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/config/storage_keys.dart';

class AppModeProvider implements NyProvider {
  @override
  boot(Nylo nylo) async {
    return nylo;
  }

  @override
  afterBoot(Nylo nylo) async {}

  static bool get isProduction => appFlavor == 'Production';
  static bool get isDevelopment => appFlavor != 'Production';

  static bool get tankwaTownModeMem =>
      Backpack.instance.read(StorageKey.tankwaTownMode) == "false"
          ? false
          : true;

  static Future<bool> get tankwaTownMode async =>
      await NyStorage.read(StorageKey.tankwaTownMode) == "false" ? false : true;

  static Future<void> toggleTankwaTownMode(bool value) async {
    await NyStorage.store(StorageKey.tankwaTownMode, !(await tankwaTownMode),
        inBackpack: true);
  }
}
