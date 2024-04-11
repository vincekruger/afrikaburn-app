import 'package:afrikaburn/app/models/news_category.dart';
import 'package:afrikaburn/resources/themes/color_helper.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:path/path.dart' as p;

/// News Model.

class News extends Model {
  final String id;
  final Uri url;
  final String title;
  final String content;
  final DateTime timestamp;
  final List<NewsCategory>? categories;
  final String imageName;
  final String? imageCredit;
  final Color? imageOverlayColor;
  final Color? imageOverlayTextColor;

  News({
    required this.id,
    required this.url,
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
      url: Uri.parse(snapshot.get('link')),
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

  String get featuredImageUrl {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    final String baseUrl = remoteConfig.getString('imageKitBaseUrl');
    final String path = remoteConfig.getString('imageKitNewsPath');
    final String modifications = 'tr:h-400';
    return p.join(baseUrl, path, modifications, imageName);
  }
}
