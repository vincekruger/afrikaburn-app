import 'dart:convert';

import 'package:afrikaburn/resources/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:afrikaburn/app/controllers/controller.dart';

enum AnnotationType {
  ThemeCamp,
  SupportCamp,
  Artwork,
  Clan,
  Temple,
  Bypass,
}

class Annotation {
  final AnnotationType type;
  final String label;
  final String name;
  final String? collective;
  final String description;
  final Position location;
  final String? openTimes;
  final bool adultsOnly;
  final bool burning;
  final int burningDay;
  final bool sound;

  final double? artworkHeight;
  final double? artworkWidth;
  final double? artworkDepth;

  Annotation({
    required this.type,
    required this.label,
    required this.name,
    this.collective,
    required this.description,
    required this.location,
    this.openTimes,
    this.adultsOnly = false,
    this.burning = false,
    this.burningDay = 0,
    this.sound = false,
    this.artworkHeight,
    this.artworkWidth,
    this.artworkDepth,
  });

  factory Annotation.fromJson(Map<String, dynamic> json, AnnotationType type) {
    return Annotation(
      type: type,
      label: json['label'],
      name: json['name'],
      collective: json['collective'] ?? null,
      description: json['description'],
      location: Position(
        json['location']['lng'],
        json['location']['lat'],
      ),
      openTimes: json['open-times'] ?? null,
      adultsOnly: json['adults-only'] ?? false,
      burning: json['burning'] ?? false,
      burningDay: json['burningDay'] ?? 0,
      sound: json['sound'] ?? false,
      artworkHeight: json['artwork-height'] ?? null,
      artworkWidth: json['artwork-width'] ?? null,
      artworkDepth: json['artwork-depth'] ?? null,
    );
  }
}

class MapIcon {
  final Uint8List artwork;
  final Uint8List artworkBurning;
  final Uint8List clan;
  final Uint8List template;
  final Uint8List bypass;
  final Uint8List greeters;

  MapIcon({
    required this.artwork,
    required this.artworkBurning,
    required this.clan,
    required this.template,
    required this.bypass,
    required this.greeters,
  });
}

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

  List<Map<String, Annotation>> loadedAnnotations = [];
  List<Annotation> annotationData = [];

  /// Load the Map Data JSON
  Future<void> loadMapDataJson() async {
    String data = await rootBundle.loadString("public/assets/map-data.json");
    final result = jsonDecode(data) as Map<String, dynamic>;

    /// Theme Camps
    annotationData.addAll(result['themeCamps']
        .map<Annotation>(
            (e) => Annotation.fromJson(e, AnnotationType.ThemeCamp))
        .toList());

    /// Artwork
    annotationData.addAll(result['artwork']
        .map<Annotation>((e) => Annotation.fromJson(e, AnnotationType.Artwork))
        .toList());
  }

  /// Map Icons
  late MapIcon mapIcons;

  /// Annotation Managers
  late CircleAnnotationManager themeCampCircleAnnotationManager;
  late PointAnnotationManager themeCampLabelAnnotationManager;
  late PointAnnotationManager artworkAnnotationManager;
  late PointAnnotationManager generalAnnotationManager;

  /// Map is loaded
  late MapboxMap mapboxMap;
  bool isMapLoaded = false;

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

  /// Create Annotation Managers
  Future<void> _createAnnotationManagers({required MapboxMap mapboxMap}) async {
    // Create Annotation Managers
    themeCampCircleAnnotationManager =
        await mapboxMap.annotations.createCircleAnnotationManager();
    themeCampLabelAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();
    artworkAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();
    generalAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();

    /// Add a lister for annotation clicks
    artworkAnnotationManager.addOnPointAnnotationClickListener(
        ArtworkAnnotationClickListener(controller: mapboxMap));

    /// Map is loaded
    isMapLoaded = true;
    mapboxMap = mapboxMap;
  }

  /// Create the Map Annotations
  Future<void> createMapAnnotations(
    MapboxMap mapboxMap,
    Brightness brightness,
  ) async {
    /// If the map is not loaded, create the annotation managers
    if (!isMapLoaded) await _createAnnotationManagers(mapboxMap: mapboxMap);

    _createGreetersStation();

    /// Create Theme Camp Markers
    _createThemeCampCircles();
    _createThemeCampLabelMarkers(brightness: brightness);

    /// Create Artwork Markets
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
    Iterable<Annotation> data = annotationData
        .where((element) => element.type == AnnotationType.ThemeCamp);

    /// Create Annotations
    data.forEach((annotation) async {
      await themeCampCircleAnnotationManager
          .create(_createCircleAnnotation(annotation));
    });
  }

  /// Create Theme Camp Label Markers
  /// This will create a the id/label of the camp.
  Future<void> _createThemeCampLabelMarkers({
    Brightness brightness = Brightness.light,
  }) async {
    /// Theme Camp Data
    Iterable<Annotation> data = annotationData
        .where((element) => element.type == AnnotationType.ThemeCamp);

    /// Create Annotations
    data.forEach((annotation) async {
      PointAnnotation result = await themeCampLabelAnnotationManager
          .create(_createThemeCampPointAnnotation(annotation, brightness));
      loadedAnnotations.add({result.id: annotation});
    });
  }

  /// Create the Artwork Markers
  /// This will create a point annotation which will plot the correct image
  /// based on the type of artwork and place the id/label of the artwork.
  Future<void> _createArtworkMarkers() async {
    /// Artwork Data
    Iterable<Annotation> data = annotationData
        .where((element) => element.type == AnnotationType.Artwork);

    /// Create Annotations
    data.forEach((annotation) async {
      PointAnnotation result = await artworkAnnotationManager
          .create(_createPointAnnotation(annotation));
      loadedAnnotations.add({result.id: annotation});
    });
  }

  CircleAnnotationOptions _createCircleAnnotation(Annotation item) {
    return CircleAnnotationOptions(
      geometry: Point(coordinates: item.location).toJson(),
      circleColor: Colors.transparent.value,
      circleStrokeColor: Colors.black.value,
      circleRadius: 10.0,
      circleStrokeWidth: 3.0,
    );
  }

  PointAnnotationOptions _createThemeCampPointAnnotation(
      Annotation item, Brightness brightness) {
    return PointAnnotationOptions(
      geometry: Point(coordinates: item.location).toJson(),
      textField: item.label,
      textColor: brightness == Brightness.light
          ? Colors.black.value
          : Colors.white.value,
      textSize: 12.0,
    );
  }

  PointAnnotationOptions _createPointAnnotation(Annotation item) {
    PointAnnotationOptions point = PointAnnotationOptions(
      geometry: Point(coordinates: item.location).toJson(),
    );

    switch (item.label) {
      case 'clan':
        point.image = mapIcons.clan;
        point.iconSize = 1.2;
        break;
      case 'bypass':
        point.image = mapIcons.bypass;
        point.iconSize = 0.8;
        break;
      case 'temple':
        point.image = mapIcons.template;
        point.iconSize = 0.8;
        break;
      default:
        point.textField = item.label;
        point.textColor = Colors.white.value;
        point.textSize = 12.0;

        if (item.burning) {
          point.image = mapIcons.artworkBurning;
          point.iconSize = 1;
          point.textAnchor = TextAnchor.TOP;
          point.textOffset = [-0.02, 0.1];
        } else {
          point.image = mapIcons.artwork;
          point.iconSize = 0.8;
          point.textAnchor = TextAnchor.BOTTOM;
          point.textOffset = [-0.02, 0.25];
        }

        break;
    }

    return point;
  }

  /// Toggle Location Puck
  Future<void> toggleLocationPuck({required MapboxMap mapboxMap}) async {
    LocationComponentSettings currentSettings =
        await mapboxMap.location.getSettings();
    bool enabled = currentSettings.enabled ?? false;

    /// Localation and Puck Settings
    mapboxMap.location.updateSettings(LocationComponentSettings(
      enabled: !enabled,
      pulsingEnabled: false,
      puckBearingEnabled: true,
      puckBearing: PuckBearing.COURSE,
    ));

    // return await Geolocator.getCurrentPosition();
  }
}
