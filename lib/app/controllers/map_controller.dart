import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:afrikaburn/app/models/map_annotation.dart';
import 'package:afrikaburn/app/models/map_icon.dart';
import 'package:afrikaburn/resources/pages/map_page.dart';
import 'package:afrikaburn/app/controllers/controller.dart';
import 'package:afrikaburn/app/providers/geolocator_provider.dart';
import 'package:afrikaburn/resources/popups/error.dart';

class MapController extends Controller {
  final remoteConfig = FirebaseRemoteConfig.instance;

  construct(BuildContext context) {
    super.construct(context);
  }

  /// Set the Mapbox Access Token
  setMapboxAccessToken() async {
    /// Set the Mapbox Access Token
    String accessToken =
        await remoteConfig.getString("mapbox_public_access_token");
    MapboxOptions.setAccessToken(accessToken);
  }

  List<MapAnnotation> loadedAnnotations = [];
  List<MapAnnotation> annotationData = [];

  /// Load the Map Data JSON
  Future<void> loadMapDataJson() async {
    String data = await rootBundle.loadString("public/assets/map-data.json");
    final result = jsonDecode(data) as Map<String, dynamic>;

    /// Theme Camps
    annotationData.addAll(result['themeCamps']
        .map<MapAnnotation>(
            (e) => MapAnnotation.fromJson(e, AnnotationType.ThemeCamp))
        .toList());

    /// Artwork
    annotationData.addAll(result['artwork']
        .map<MapAnnotation>(
            (e) => MapAnnotation.fromJson(e, AnnotationType.Artwork))
        .toList());
  }

  /// Map Icons
  late MapIcon mapIcons;

  @override
  bool get singleton => true;

  /// Annotation Managers
  late CircleAnnotationManager themeCampCircleAnnotationManager;
  late PointAnnotationManager themeCampLabelAnnotationManager;
  late PointAnnotationManager artworkAnnotationManager;
  late PointAnnotationManager generalAnnotationManager;

  /// Contexts & Initialisation Vars
  late MapboxMap _mapboxMap;
  bool _annotationmanagersCreated = false;

  /// Set the Mapbox Map
  void set mapboxMap(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
  }

  /// Set the Map Bounds
  Future<void> setMapBounds() async {
    /// Build the location gps bounds
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

    /// Set the map bounds
    _mapboxMap.setBounds(CameraBoundsOptions(
      bounds: mapBounds,
      minZoom: FirebaseRemoteConfig.instance.getDouble('map_min_zoom'),
      maxZoom: FirebaseRemoteConfig.instance.getDouble('map_max_zoom'),
    ));
  }

  /// Set Logo and Attribution Settings
  Future<void> setDefaultSettings() async {
    /// Hide Scale Bar
    _mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));

    if (Platform.isIOS) {
      /// Hide Logo
      _mapboxMap.logo.updateSettings(LogoSettings(
        marginLeft: -100,
        marginBottom: -50,
      ));

      /// Hide Attribution
      _mapboxMap.attribution.updateSettings(
          AttributionSettings(marginBottom: 20, marginRight: 10));
    }

    if (Platform.isAndroid) {
      /// Hide Logo
      _mapboxMap.logo.updateSettings(LogoSettings(
        marginLeft: -100,
        marginBottom: -50,
      ));

      /// Hide Attribution
      _mapboxMap.attribution.updateSettings(AttributionSettings(
        marginLeft: -100,
        marginBottom: -50,
      ));
    }
  }

  /// Load Map Icons
  Future<void> loadMapIcons() async {
    /// Artwork
    Uint8List artwork = (await rootBundle.load('public/assets/map/artwork.png'))
        .buffer
        .asUint8List();

    /// Artwork Burning
    Uint8List artworkBurning =
        (await rootBundle.load('public/assets/map/artwork-burning.png'))
            .buffer
            .asUint8List();

    /// Clan
    Uint8List clan = (await rootBundle.load('public/assets/map/clan.png'))
        .buffer
        .asUint8List();

    /// Template
    Uint8List template = (await rootBundle.load('public/assets/map/temple.png'))
        .buffer
        .asUint8List();

    /// Template
    Uint8List bypass = (await rootBundle.load('public/assets/map/bypass.png'))
        .buffer
        .asUint8List();

    /// Greeters
    Uint8List greeters =
        (await rootBundle.load('public/assets/map/greeters.png'))
            .buffer
            .asUint8List();

    mapIcons = MapIcon(
      artwork: artwork,
      artworkBurning: artworkBurning,
      clan: clan,
      template: template,
      bypass: bypass,
      greeters: greeters,
    );
  }

  /// Tooggle Annotation Brightness
  Future<void> toggleAnnotationBrightness({
    required Brightness brightness,
  }) async {
    await themeCampLabelAnnotationManager.deleteAll();
    await _createThemeCampLabelMarkers(brightness: brightness);
  }

  MapAnnotation? getAnnotationById(String id) =>
      loadedAnnotations.firstWhere((element) => element.annotationId == id);

  /// Create Annotation Managers
  Future<void> _createAnnotationManagers() async {
    // Create Annotation Managers
    themeCampCircleAnnotationManager =
        await _mapboxMap.annotations.createCircleAnnotationManager();
    themeCampLabelAnnotationManager =
        await _mapboxMap.annotations.createPointAnnotationManager();
    artworkAnnotationManager =
        await _mapboxMap.annotations.createPointAnnotationManager();
    generalAnnotationManager =
        await _mapboxMap.annotations.createPointAnnotationManager();

    /// Add a lister for annotation clicks
    themeCampCircleAnnotationManager
        .addOnCircleAnnotationClickListener(CircleAnnotationClickListener(
      mapboxMap: _mapboxMap,
      controller: this,
      context: this.context!,
    ));

    artworkAnnotationManager
        .addOnPointAnnotationClickListener(AnnotationClickListener(
      mapboxMap: _mapboxMap,
      controller: this,
      context: this.context!,
    ));

    /// Map is loaded
    _annotationmanagersCreated = true;
  }

  /// Create the Map Annotations
  Future<void> createMapAnnotations(
    Brightness brightness,
  ) async {
    /// If the map is not loaded, create the annotation managers
    if (!_annotationmanagersCreated) await _createAnnotationManagers();

    _createGreetersStation();

    /// Create Theme Camp Markers
    _createThemeCampCircles();
    _createThemeCampLabelMarkers(brightness: brightness);

    /// Create Artwork Markets
    /// Android doesn't seem to handle this very well, so we delay it
    if (Platform.isAndroid) await Future.delayed(Duration(seconds: 1));
    _createArtworkMarkers();
  }

  /// Create the Greeters Station Icon
  _createGreetersStation() async {
    PointAnnotationOptions ticketBoothAnnotation = PointAnnotationOptions(
      geometry: Point(coordinates: Position(19.94096, -32.50963)).toJson(),
      image: mapIcons.greeters,
      iconSize: 1.2,
    );
    await generalAnnotationManager.create(ticketBoothAnnotation);
  }

  /// Create Theme Camp Markers
  /// This will create a circle which is tappable, it will also create
  /// a point annotation which will display the id/label of the camp.
  Future<void> _createThemeCampCircles() async {
    /// Theme Camp Data
    Iterable<MapAnnotation> data = annotationData
        .where((element) => element.type == AnnotationType.ThemeCamp);

    /// Create Annotations
    data.forEach((annotation) async {
      CircleAnnotation result = await themeCampCircleAnnotationManager
          .create(_createCircleAnnotation(annotation));
      annotation.annotationId = result.id;
      loadedAnnotations.add(annotation);
    });
  }

  /// Create Theme Camp Label Markers
  /// This will create a the id/label of the camp.
  Future<void> _createThemeCampLabelMarkers({
    Brightness brightness = Brightness.light,
  }) async {
    /// Theme Camp Data
    Iterable<MapAnnotation> data = annotationData
        .where((element) => element.type == AnnotationType.ThemeCamp);

    /// Create Annotations
    data.forEach((annotation) async {
      await themeCampLabelAnnotationManager
          .create(_createThemeCampPointAnnotation(annotation, brightness));
    });
  }

  /// Create the Artwork Markers
  /// This will create a point annotation which will plot the correct image
  /// based on the type of artwork and place the id/label of the artwork.
  Future<void> _createArtworkMarkers() async {
    /// Artwork Data
    Iterable<MapAnnotation> data = annotationData
        .where((element) => element.type == AnnotationType.Artwork);

    /// Create Annotations
    data.forEach((annotation) async {
      PointAnnotation result = await artworkAnnotationManager
          .create(_createPointAnnotation(annotation));
      annotation.annotationId = result.id;
      loadedAnnotations.add(annotation);
    });
  }

  CircleAnnotationOptions _createCircleAnnotation(MapAnnotation item) {
    return CircleAnnotationOptions(
      geometry: Point(coordinates: item.location).toJson(),
      circleColor: Colors.transparent.value,
      circleStrokeColor: Colors.black.value,
      circleRadius: 10.0,
      circleStrokeWidth: 3.0,
    );
  }

  PointAnnotationOptions _createThemeCampPointAnnotation(
      MapAnnotation item, Brightness brightness) {
    return PointAnnotationOptions(
      geometry: Point(coordinates: item.location).toJson(),
      textField: item.label,
      textColor: brightness == Brightness.light
          ? Colors.black.value
          : Colors.white.value,
      textSize: 10.0,
    );
  }

  PointAnnotationOptions _createPointAnnotation(MapAnnotation item) {
    PointAnnotationOptions point = PointAnnotationOptions(
      geometry: Point(coordinates: item.location).toJson(),
    );

    switch (item.label) {
      case 'clan':
        point.image = mapIcons.clan;
        point.iconSize = Platform.isAndroid ? 1 : 1.2;
        break;
      case 'bypass':
        point.image = mapIcons.bypass;
        point.iconSize = Platform.isAndroid ? 0.5 : 0.8;
        break;
      case 'temple':
        point.image = mapIcons.template;
        point.iconSize = Platform.isAndroid ? 0.5 : 0.8;
        break;
      default:
        point.textField = item.label;
        point.textColor = Colors.white.value;
        point.textSize = 12.0;

        if (item.burning) {
          point.image = mapIcons.artworkBurning;
          point.iconSize = Platform.isAndroid ? 0.7 : 1;
          point.textAnchor = TextAnchor.TOP;
          point.textOffset = [-0.02, 0.1];
        } else {
          point.image = mapIcons.artwork;
          point.iconSize = Platform.isAndroid ? 0.5 : 0.8;
          point.textAnchor = TextAnchor.BOTTOM;
          point.textOffset = [-0.02, 0.25];
        }

        break;
    }

    return point;
  }

  /// Toggle Location Puck
  Future<void> enableUserLocationPuck() async {
    /// Check if the user has granted location permission
    if (await Permission.location.isPermanentlyDenied) return;

    /// Localation and Puck Settings
    _mapboxMap.location.updateSettings(LocationComponentSettings(
      enabled: true,
      pulsingEnabled: false,
      puckBearingEnabled: true,
      puckBearing: PuckBearing.COURSE,
    ));
  }

  /// Center the map on the user location
  Future<void> centerMapOnUserLocation(BuildContext context) async {
    try {
      /// Get the current user location
      Position userLocation =
          await GeolocatorProvider.currentLocationForMapBox();

      /// East to the current user location
      _mapboxMap.easeTo(
        CameraOptions(center: Point(coordinates: userLocation).toJson()),
        MapAnimationOptions(duration: 1000),
      );
    } on PermissionDeniedException catch (_) {
      notifcationSettingsErrorDialogBuilder(
        context,
        "settings.location-denied",
      );
    }
  }
}
