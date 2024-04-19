import 'package:afrikaburn/app/providers/system_provider.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/map_controller.dart';

class MapPage extends NyStatefulWidget<MapController> {
  static const path = '/map';
  static const name = 'Map Page';
  MapPage() : super(path, child: _MapPageState());
}

class ArtworkAnnotationClickListener extends OnPointAnnotationClickListener {
  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    print("on Artwork Annotation Click, id: ${annotation.id}");
  }
}

class ThemeCampAnnotationClickListener extends OnCircleAnnotationClickListener {
  @override
  void onCircleAnnotationClick(CircleAnnotation annotation) {
    print("on Theme Camp Annotation Click, id: ${annotation.id}");
  }
}

class _MapPageState extends NyState<MapPage> {
  /// [MapController] controller
  MapController get controller => widget.controller;

  /// MapBoxMap Controllers
  MapboxMap? mapboxMap;
  CircleAnnotationManager? circleAnnotationManager;
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
  }

  /// Register mechanics for the map
  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    SystemProvider().setOnlyPortraitOrientation();

    // Create Annotation Managers
    Future<CircleAnnotationManager> circleAnnotationManager =
        mapboxMap.annotations.createCircleAnnotationManager();
    Future<PointAnnotationManager> pointAnnotationManager =
        mapboxMap.annotations.createPointAnnotationManager();

    /// Create Theme Camp Markers
    controller.createThemeCampMarkers(
      cirleManager: circleAnnotationManager,
      pointManager: pointAnnotationManager,
      listener: ThemeCampAnnotationClickListener(),
    );

    /// Create Artwork Markets
    controller.createArtworkMarkers(
      pointManager: pointAnnotationManager,
      listener: ArtworkAnnotationClickListener(),
    );
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: MapWidget(
        cameraOptions: CameraOptions(
          center: Point(
              coordinates: Position(
            FirebaseRemoteConfig.instance.getDouble('map_center_lng'),
            FirebaseRemoteConfig.instance.getDouble('map_center_lat'),
          )).toJson(),
          zoom: FirebaseRemoteConfig.instance.getDouble('map_default_zoom'),
        ),
        styleUri: MapboxStyles.DARK,
        // styleUri: systemBrightness == Brightness.light
        //     ? MapboxStyles.LIGHT
        //     : MapboxStyles.DARK,
        onMapCreated: _onMapCreated,
        mapOptions: MapOptions(
          pixelRatio: MediaQuery.of(context).devicePixelRatio,
        ),
      ),
    );
  }
}
