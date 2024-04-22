import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:afrikaburn/app/models/map_annotation.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:afrikaburn/app/providers/system_provider.dart';
import 'package:afrikaburn/app/controllers/map_controller.dart';
import 'package:afrikaburn/resources/themes/extensions/gradient_icon.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:afrikaburn/resources/widgets/map_annotation_widget.dart';

class MapPage extends NyStatefulWidget<MapController> {
  static const path = '/map';
  static const name = 'Map Page';
  MapPage() : super(path, child: _MapPageState());
}

class AnnotationClickListener extends OnPointAnnotationClickListener {
  final MapboxMap mapboxMap;
  final MapController controller;
  final BuildContext context;

  AnnotationClickListener({
    required this.mapboxMap,
    required this.controller,
    required this.context,
  });

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    /// Find the Annotation
    final annotationId = annotation.id;
    final MapAnnotation? annotationData =
        controller.getAnnotationById(annotationId);

    print('Annotation Clicked: $annotationId');

    /// No annotation found - gerrara here
    if (annotationData == null) return;

    updateState(MapAnnotationDetail.state, data: {
      'annotation': annotationData,
    });
  }
}

class CircleAnnotationClickListener extends OnCircleAnnotationClickListener {
  final MapboxMap mapboxMap;
  final MapController controller;
  final BuildContext context;

  CircleAnnotationClickListener({
    required this.mapboxMap,
    required this.controller,
    required this.context,
  });

  @override
  void onCircleAnnotationClick(CircleAnnotation annotation) {
    /// Find the Annotation
    final annotationId = annotation.id;
    final MapAnnotation? annotationData =
        controller.getAnnotationById(annotationId);

    print(annotationData);

    /// No annotation found - gerrara here
    if (annotationData == null) return;

    updateState(MapAnnotationDetail.state, data: {
      'annotation': annotationData,
    });
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

  /// Handle app lifecycle
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) return;

    /// Check if the user has granted location permission and enable
    /// the user location puck
    controller.enableUserLocationPuck();
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
    controller.mapboxMap = mapboxMap; // Set MapController ref
    // controller.isMapLoaded = true; // Set Map Loaded to true

    /// Restrict the map to portrait orientation
    SystemProvider()
        .setOnlyPortraitOrientation(); // Set Orientation to Portrait

    /// Set some default settings
    controller.setDefaultSettings();
    controller.setMapBounds();

    /// Create Annotations
    controller.createMapAnnotations(systemBrightness!);

    /// Enable the user location puck
    controller.enableUserLocationPuck();
  }

  @override
  Widget view(BuildContext context) {
    controller.context = context;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          MapWidget(
            onTapListener: (coordinate) {
              updateState(MapAnnotationDetail.state, data: {'hide': true});
            },
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
          Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                      child: IconButton(
                        onPressed: () =>
                            controller.centerMapOnUserLocation(context),
                        icon: Icon(Icons.my_location_rounded),
                        color: Colors.white,
                      ).withGradient(GradientStyles.appbarIcon),
                    ),
                  ],
                ),
              ),
              MapAnnotationDetail(),
            ],
          )
        ],
      ),
    );
  }
}
