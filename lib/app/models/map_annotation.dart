import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

enum AnnotationType {
  ThemeCamp,
  SupportCamp,
  Artwork,
  Clan,
  Temple,
  Bypass,
}

class MapAnnotation {
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

  String? annotationId;

  MapAnnotation({
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

  factory MapAnnotation.fromJson(
      Map<String, dynamic> json, AnnotationType type) {
    return MapAnnotation(
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

  @override
  String toString() {
    return 'MapAnnotation: $name';
  }
}
