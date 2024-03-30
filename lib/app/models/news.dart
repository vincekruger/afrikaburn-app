import 'package:afrikaburn/app/models/news_category.dart';
import 'package:afrikaburn/resources/themes/color_helper.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:path/path.dart' as p;

/// News Model.

class News extends Model {
  final String id;
  final String title;
  final String content;
  final DateTime timestamp;
  final List<NewsCategory>? categories;
  final String imageBaseUrl = 'https://ik.imagekit.io/n1ly84zxr';
  final String imageName;
  final String? imageCredit;
  final Color? imageOverlayColor;
  final Color? imageOverlayTextColor;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.categories,
    required this.imageName,
    this.imageCredit,
    this.imageOverlayColor,
    this.imageOverlayTextColor,
  });

  factory News.fromSnapshot(snapshot) {
    List<NewsCategory>? categories;
    if (snapshot.get('categories') != null)
      categories = snapshot
          .get('categories')
          .map<NewsCategory>((category) => NewsCategory.fromJson(category))
          .toList();

    return News(
      id: snapshot.id,
      title: snapshot.get('title'),
      content: snapshot.get('content'),
      timestamp: snapshot.get('date').toDate(),
      categories: categories,
      imageName: snapshot.get('featuredImage.name'),
      imageCredit: snapshot.get('featuredImage')['imageCredit'] ?? null,
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
