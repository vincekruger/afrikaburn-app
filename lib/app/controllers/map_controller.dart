import 'dart:convert';

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

  MapIcon({
    required this.artwork,
    required this.artworkBurning,
    required this.clan,
    required this.template,
    required this.bypass,
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

  late MapIcon mapIcons;

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

    mapIcons = MapIcon(
      artwork: artwork,
      artworkBurning: artworkBurning,
      clan: clan,
      template: template,
      bypass: bypass,
    );
  }

  CircleAnnotationOptions createCircleAnnotation(Annotation item) {
    return CircleAnnotationOptions(
      geometry: Point(coordinates: item.location).toJson(),
      circleColor: Colors.transparent.value,
      circleStrokeColor: Colors.black.value,
      circleRadius: 10.0,
      circleStrokeWidth: 3.0,
    );
  }

  PointAnnotationOptions createThemeCampPointAnnotation(Annotation item) {
    return PointAnnotationOptions(
      geometry: Point(coordinates: item.location).toJson(),
      textField: item.label,
      textColor: Colors.white.value,
      textSize: 12.0,
    );
  }

  PointAnnotationOptions createPointAnnotation(Annotation item) {
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

  /// Create Theme Camp Markers
  /// This will create a circle which is tappable, it will also create
  /// a point annotation which will display the id/label of the camp.
  Future<void> createThemeCampMarkers({
    required Future<CircleAnnotationManager> cirleManager,
    required Future<PointAnnotationManager> pointManager,
    required OnCircleAnnotationClickListener listener,
  }) async {
    /// Theme Camp Data
    Iterable<Annotation> data = annotationData
        .where((element) => element.type == AnnotationType.ThemeCamp);

    /// Finalise managers
    final cManager = await cirleManager;
    final pManager = await pointManager;

    /// Add the listener
    cManager.addOnCircleAnnotationClickListener(listener);

    /// Create Annotations
    data.forEach((annotation) async {
      pManager.create(createThemeCampPointAnnotation(annotation));
      CircleAnnotation result =
          await cManager.create(createCircleAnnotation(annotation));
      loadedAnnotations.add({result.id: annotation});
    });
  }

  /// Create the Artwork Markers
  /// This will create a point annotation which will plot the correct image
  /// based on the type of artwork and place the id/label of the artwork.
  Future<void> createArtworkMarkers({
    required Future<PointAnnotationManager> pointManager,
    required OnPointAnnotationClickListener listener,
  }) async {
    /// Artwork Data
    Iterable<Annotation> data = annotationData
        .where((element) => element.type == AnnotationType.Artwork);

    /// Finalise manager
    final manager = await pointManager;

    /// Add the listener
    manager.addOnPointAnnotationClickListener(listener);

    /// Create Annotations
    data.forEach((annotation) async {
      PointAnnotation result =
          await manager.create(createPointAnnotation(annotation));
      loadedAnnotations.add({result.id: annotation});
    });
  }
}
