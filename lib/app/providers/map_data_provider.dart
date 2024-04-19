import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';

class MapDataProvider implements NyProvider {
  static const platform = MethodChannel('io.wheresmyshit.afrikaburn/platform');

  @override
  boot(Nylo nylo) async {
    return nylo;
  }

  @override
  afterBoot(Nylo nylo) async {
    _downloadMapTiles();
  }

  Future<void> _downloadMapTiles() async {
    try {
      final result = await platform.invokeMethod<bool>('downloadMapTiles');
      print('Downloaded $result tiles.');
    } on PlatformException catch (e) {
      print('Failed to download map tiles: ${e.message}');
    }
  }
}
