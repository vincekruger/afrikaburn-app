import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

class MapController extends Controller {
  final remoteConfig = FirebaseRemoteConfig.instance;

  construct(BuildContext context) {
    super.construct(context);
  }

  setMapboxAccessToken() async {
    /// Set the Mapbox Access Token
    String accessToken =
        await remoteConfig.getString("mapbox_public_access_token");
    MapboxOptions.setAccessToken(accessToken);
  }

  // OCC Testing
  //lat -32.51398687810705, lng 19.952834839748327
  get occLocation =>
      Point(coordinates: Position(19.952834839748327, -32.51398687810705))
          .toJson();

  addSupportCamps() {}
}
