import 'package:afrikaburn/resources/themes/color_helper.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:path/path.dart' as p;

/// News Model.

class News extends Model {
  final String id;
  final String title;
  final String imageBaseUrl = 'https://ik.imagekit.io/n1ly84zxr';
  final String imageName;
  final Color? imageOverlayColor;
  final Color? imageOverlayTextColor;

  News({
    required this.id,
    required this.title,
    required this.imageName,
    this.imageOverlayColor,
    this.imageOverlayTextColor,
  });

  factory News.fromSnapshot(snapshot) {
    return News(
      id: snapshot.id,
      title: snapshot.get('title'),
      imageName: snapshot.get('featuredImage.name'),
      imageOverlayColor:
          colorFromValue(snapshot.get('featuredImageConfig.overlayColor')),
      imageOverlayTextColor:
          colorFromValue(snapshot.get('featuredImageConfig.overlayTextColor')),
    );
  }

  get featuredImageUrl {
    const modifications = 'tr:h-400';
    return p.join(imageBaseUrl, modifications, imageName);
  }
}
