import 'package:nylo_framework/nylo_framework.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

export 'package:geolocator/geolocator.dart' show PermissionDeniedException;

class GeolocatorProvider implements NyProvider {
  @override
  boot(Nylo nylo) async {
    return nylo;
  }

  @override
  afterBoot(Nylo nylo) async {}

  static Future<Position> currentLocationForMapBox() async {
    // Get the current location
    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition(
      desiredAccuracy: geolocator.LocationAccuracy.best,
    );

    return Position(position.longitude, position.latitude);
  }
}
