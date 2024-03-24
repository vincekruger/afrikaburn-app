import 'package:firebase_remote_config/firebase_remote_config.dart';

import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

class MapController extends Controller {
  final remoteConfig = FirebaseRemoteConfig.instance;

  construct(BuildContext context) {
    super.construct(context);
  }

  get mapboxAccessToken async =>
      await remoteConfig.getString("mapbox_public_access_token");
}
