import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/config/storage_keys.dart';

class AppModeProvider implements NyProvider {
  @override
  boot(Nylo nylo) async {
    return nylo;
  }

  @override
  afterBoot(Nylo nylo) async {
    /// Set the app mode in the backpack
    if (Backpack.instance.read(StorageKey.tankwaTownMode) == null)
      Backpack.instance.set(StorageKey.tankwaTownMode, (await tankwaTownMode));
  }

  /// Get the current mode from the backpack
  static bool get tankwaTownModeBackpack => Backpack.instance
      .read<bool>(StorageKey.tankwaTownMode, defaultValue: false)!;

  /// Get the current Tankwa Town Mode from Storage
  static Future<bool> get tankwaTownMode async =>
      await NyStorage.read(StorageKey.tankwaTownMode, defaultValue: "false") ==
              "false"
          ? false
          : true;

  /// Set a new Tankwa Town Mode
  static Future<void> setTankwaTownMode(bool value) async =>
      await NyStorage.store(StorageKey.tankwaTownMode, value, inBackpack: true);

  /// Toggle the current Tankwa Town Mode
  static Future<void> toggleTankwaTownMode() async =>
      await NyStorage.store(StorageKey.tankwaTownMode, !(await tankwaTownMode),
          inBackpack: true);
}
