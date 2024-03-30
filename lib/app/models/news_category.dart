import 'package:nylo_framework/nylo_framework.dart';

/// NewsCategory Model.

class NewsCategory extends Model {
  final String id;
  final String name;

  NewsCategory({
    required this.id,
    required this.name,
  });

  factory NewsCategory.fromJson(data) {
    return NewsCategory(
      id: data['id'].toString(),
      name: data['name'].toString(),
    );
  }
}
