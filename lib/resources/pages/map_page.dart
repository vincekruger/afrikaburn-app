import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:afrikaburn/app/providers/map_data_provider.dart';
import 'package:afrikaburn/app/providers/system_provider.dart';
import 'package:afrikaburn/app/controllers/map_controller.dart';
import 'package:afrikaburn/resources/themes/extensions/gradient_icon.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends NyStatefulWidget<MapController> {
  static const path = '/map';
  static const name = 'Map Page';
  MapPage() : super(path, child: _MapPageState());
}

class ArtworkAnnotationClickListener extends OnPointAnnotationClickListener {
  final MapboxMap controller;
  ArtworkAnnotationClickListener({required this.controller});

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    print("on Artwork Annotation Click, id: ${annotation.id}");

    /// Not likely but checking anyways
    if (!annotation.geometry!.containsKey('coordinates')) return;

    /// Get the coordinates
    // final coordinates = annotation.geometry!['coordinates'] as dynamic;
    // controller
    //     .setCamera(CameraOptions(
    //       center: Point(
    //           coordinates: Position(
    //         coordinates[0],
    //         coordinates[1],
    //       )).toJson(),
    //     ))
    //     .then((_) => print("Camera Set"));

    // annotation.geometry!.entries.forEach((element) {
    //   print("Key: ${element.key}, Value: ${element.value}");
    // });
  }
}

class ThemeCampAnnotationClickListener extends OnCircleAnnotationClickListener {
  final MapboxMap controller;
  ThemeCampAnnotationClickListener({required this.controller});
  @override
  void onCircleAnnotationClick(CircleAnnotation annotation) {
    print("on Theme Camp Annotation Click, id: ${annotation.id}");
  }
}

class _MapPageState extends NyState<MapPage> with WidgetsBindingObserver {
  /// [MapController] controller
  MapController get controller => widget.controller;

  /// MapBoxMap Controllers
  MapboxMap? mapboxMap;
  Brightness? systemBrightness;

  /// Use boot if you need to load data before the view is rendered.
  @override
  boot() async {
    await widget.controller.setMapboxAccessToken();
    systemBrightness = MediaQuery.of(context).platformBrightness;
  }

  @override
  init() async {
    await controller.loadMapIcons();
    await controller.loadMapDataJson();
    SystemProvider().setOnlyPortraitOrientation();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    var brightness = View.of(context).platformDispatcher.platformBrightness;

    /// Ignore this when the app is pauased
    /// This is a workaround for the issue where the app crashes when the app is paused
    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.paused)
      return;

    /// this breaks when the app is paused
    if (mapboxMap != null) {
      String style = brightness == Brightness.light
          ? MapboxStyles.LIGHT
          : MapboxStyles.DARK;

      mapboxMap!.loadStyleURI(style);
      controller.toggleAnnotationBrightness(brightness: brightness);
    }
  }

  /// Register mechanics for the map
  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap; // Set MapBoxMap controller ref
    SystemProvider()
        .setOnlyPortraitOrientation(); // Set Orientation to Portrait
    MapDataProvider.downloadMapTiles(); // Download Map Tiles

    /// Disable the scale bar
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));

    /// Set the Bounds
    CoordinateBounds mapBounds = CoordinateBounds(
      northeast: Point(
          coordinates: Position(
        FirebaseRemoteConfig.instance.getDouble('map_bounds_ne_lng'),
        FirebaseRemoteConfig.instance.getDouble('map_bounds_ne_lat'),
      )).toJson(),
      southwest: Point(
          coordinates: Position(
        FirebaseRemoteConfig.instance.getDouble('map_bounds_sw_lng'),
        FirebaseRemoteConfig.instance.getDouble('map_bounds_sw_lat'),
      )).toJson(),
      infiniteBounds: false,
    );
    mapboxMap.setBounds(CameraBoundsOptions(
      bounds: mapBounds,
      maxZoom: 18,
      minZoom: 14,
    ));

    /// Hide the mapbox logo
    mapboxMap.logo.updateSettings(LogoSettings(
      marginLeft: -100,
      marginBottom: -50,
    ));
    mapboxMap.attribution
        .updateSettings(AttributionSettings(marginBottom: 20, marginRight: 10));

    /// Create Annotations
    controller.createMapAnnotations(mapboxMap, systemBrightness!);
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: IconButton(
        onPressed: () async {
          if (await Permission.location.isPermanentlyDenied) {
            // TODO Show popup here to enable in settings
            return;
          }

          /// Toggle Location Puck
          controller.toggleLocationPuck(mapboxMap: mapboxMap!);
        },
        icon: Icon(Icons.my_location_rounded),
        color: Colors.white,
      ).withGradient(GradientStyles.appbarIcon),
      body: MapWidget(
        cameraOptions: CameraOptions(
          center: Point(
              coordinates: Position(
            FirebaseRemoteConfig.instance.getDouble('map_center_lng'),
            FirebaseRemoteConfig.instance.getDouble('map_center_lat'),
          )).toJson(),
          zoom: FirebaseRemoteConfig.instance.getDouble('map_default_zoom'),
        ),
        styleUri: systemBrightness == Brightness.light
            ? MapboxStyles.LIGHT
            : MapboxStyles.DARK,
        onMapCreated: _onMapCreated,
        mapOptions: MapOptions(
          pixelRatio: MediaQuery.of(context).devicePixelRatio,
        ),
      ),
    );
  }
}
