import 'package:afrikaburn/app/controllers/controller.dart';
import 'package:afrikaburn/app/models/news.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NewsController extends Controller {
  construct(BuildContext context) {
    super.construct(context);
  }

  /// Page Size
  static const pageSize = 20;

  /// Scroll Page Controller
  final PagingController<int, News> pagingController =
      PagingController(firstPageKey: 0);

  /// Firebase Firestore instance
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /// Collection Ref
  final _collection = 'news';
  CollectionReference? _collectionRef;

  /// Get News Posts
  Future<void> fetchNews(int pageKey) async {
    try {
      /// Setup collection reference
      if (_collectionRef == null) {
        _collectionRef = db.collection(_collection);
      }

      /// Configure query
      var query = _collectionRef!
          .where('public', isEqualTo: true)
          .orderBy('date', descending: true)
          .limit(pageSize);

      /// Not the first page so add a startAfterDocument
      if (pageKey > 0 && pagingController.itemList!.isNotEmpty) {
        query = query.startAfter([pagingController.itemList!.last.timestamp]);
      }

      /// Fetch data
      final snapshot = await query.get();
      final newItems =
          snapshot.docs.map((doc) => News.fromSnapshot(doc)).toList();

      /// If last page, append all items
      if (newItems.length < pageSize) {
        pagingController.appendLastPage(newItems);
        return;
      }

      /// Append page
      final nextPageKey = pageKey + newItems.length;
      pagingController.appendPage(newItems, nextPageKey);
    } catch (error) {
      pagingController.error = error;
    }
  }
}
