import 'package:afrikaburn/app/events/tankwa_mode_event.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/config/storage_keys.dart';
import 'package:afrikaburn/app/events/prepare_data_event.dart';

class AppModeProvider implements NyProvider {
  @override
  boot(Nylo nylo) async {
    /// Get Stroage Values
    Backpack.instance.set(StorageKey.tankwaTownMode, (await tankwaTownMode));
    Backpack.instance
        .set(StorageKey.ticketsPageHidden, (await ticketsPageHidden));

    return nylo;
  }

  @override
  afterBoot(Nylo nylo) async {
    if (burnIsSoon) {
      print('Burn is coming soon');
      preDownloadGuides();
      return;
    }

    /// Check if it's burn time
    if (burnHasBegun) {
      print('Burn has begun');
      event<TankwaModeEvent>(data: {'state': true});
      return;
    }

    if (burnHasEnded) {
      print('Burn has ended');
      event<TankwaModeEvent>(data: {'state': false});
    }
  }

  /// PreDownload Guides
  static Future<void> preDownloadGuides() async {
    /// not yet
    if (!burnIsSoon) return;
    if (FirebaseRemoteConfig.instance.getBool('guides_predownload_available') !=
        true) return;

    /// Call the event
    event<PrepareEventDataEvent>();
  }

  /// Burn has started
  static bool get burnHasBegun {
    Moment today = Moment.now();
    Moment burnStartDate =
        Moment.parse(FirebaseRemoteConfig.instance.getString('burn_start_date'))
            .startOfDay();
    Moment burnEndDate =
        Moment.parse(FirebaseRemoteConfig.instance.getString('burn_end_date'))
            .startOfDay();
    return today.isAfter(burnStartDate) && today.isBefore(burnEndDate);
  }

  /// Burn has ended
  static bool get burnHasEnded {
    Moment today = Moment.now();
    Moment burnEndDate =
        Moment.parse(FirebaseRemoteConfig.instance.getString('burn_end_date'))
            .endOfDay()
            .add(Duration(days: 1));
    return today.isAfter(burnEndDate);
  }

  static bool get burnIsSoon {
    Moment today = Moment.now().startOfDay();
    Moment burnStartDate =
        Moment.parse(FirebaseRemoteConfig.instance.getString('burn_start_date'))
            .startOfDay();
    int soonDays = 15;

    return today.isBefore(burnStartDate) &&
        today.isAfter(burnStartDate.subtract(Duration(days: soonDays)));
  }

  /// Tickets Page Hidden
  static Future<bool> get ticketsPageHidden async =>
      await NyStorage.read(StorageKey.ticketsPageHidden,
                  defaultValue: "false") ==
              "false"
          ? false
          : true;

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
