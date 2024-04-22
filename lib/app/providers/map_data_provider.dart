import 'package:afrikaburn/app/providers/app_mode_provider.dart';
import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/config/storage_keys.dart';
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
    _handlePreDownloadingOfTiles();
  }

  /// Check if map tiles are already downloaded
  void _handlePreDownloadingOfTiles() {
    if (!AppModeProvider.burnIsSoon) return;
    MapDataProvider.checkOfflineMaps().then((result) {
      print('Offline maps: $result');
      if (result.isNotEmpty) return;

      /// Download map tiles
      MapDataProvider.downloadMapTiles().then((value) {
        FirebaseProvider().logEvent('map_tiles_downloaded', {});
      });
    });
  }

  static Future<void> downloadMapTiles() async {
    try {
      await platform.invokeMethod<bool>('downloadMapTiles');
      StorageKey.mapTilesDownloaded.store(true);
    } on PlatformException catch (e) {
      print('Failed to download map tiles: ${e.message}');
    }
  }

  static Future<List<MapBoxOfflineTile>> checkOfflineMaps() async {
    try {
      final result =
          await platform.invokeMethod<List<dynamic>?>('checkOfflineMaps');

      List<MapBoxOfflineTile> offlineTiles = [];
      if (result != null) {
        for (var tile in result) {
          offlineTiles.add(MapBoxOfflineTile(
            id: tile?['id'] as String,
            completedResourceSize: tile['completedResourceSize'] as int,
            completedResourceCount: tile['completedResourceCount'] as int,
          ));
        }
      }
      return offlineTiles;
    } on PlatformException catch (e) {
      print('Failed to download map tiles: ${e.message}');
      return [];
    }
  }
}

// TODO Cleanup
class MapBoxOfflineTile {
  final String id;
  final int completedResourceSize;
  final int completedResourceCount;

  MapBoxOfflineTile({
    required this.id,
    required this.completedResourceSize,
    required this.completedResourceCount,
  });
}
