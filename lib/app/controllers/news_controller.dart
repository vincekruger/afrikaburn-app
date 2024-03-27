import 'package:afrikaburn/app/controllers/controller.dart';
import 'package:afrikaburn/app/models/news.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class NewsController extends Controller {
  construct(BuildContext context) {
    super.construct(context);
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<News>> getNewsPosts() async {
    final snapshot = await db.collection('news').limit(10).get();
    return snapshot.docs.map((doc) => News.fromSnapshot(doc)).toList();
  }
}
