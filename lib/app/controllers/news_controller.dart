import 'package:afrikaburn/app/controllers/controller.dart';
import 'package:afrikaburn/app/models/news.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class NewsController extends Controller {
  construct(BuildContext context) {
    super.construct(context);
  }

  /// Firebase Firestore instance
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /// Get News Posts
  Future<List<News>> getNewsPosts() async {
    final snapshot = await db
        .collection('news')
        .where('public', isEqualTo: true)
        .limit(2)
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs.map((doc) => News.fromSnapshot(doc)).toList();
  }
}
