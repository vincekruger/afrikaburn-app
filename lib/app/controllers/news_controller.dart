import 'package:afrikaburn/app/controllers/controller.dart';
import 'package:afrikaburn/app/models/news.dart';
import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/app/providers/shared_preferences_provider.dart';
import 'package:afrikaburn/resources/widgets/news_subscription_action_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsController extends Controller {
  construct(BuildContext context) {
    super.construct(context);
  }

  final String notificationTopic = 'news';

  /// Allow as a singleton
  bool get singleton => true;

  /// Shared Preferences
  SharedPreferencesProvider prefs = SharedPreferencesProvider();

  /// Notifications are Permanently Denied
  bool notificationStatusPermantelyDenied = false;

  /// Get Notification Permission
  Future<void> _validateNotificationPermission() async {
    await Permission.notification.onPermanentlyDeniedCallback(() {
      print("Notification Permission Permanently Denied");
      notificationStatusPermantelyDenied = true;
      throw 'notifications_permanently_denied';
    }).onDeniedCallback(() {
      print("Notification Permission Denied");
    }).request();

    /// Happy, user has granted a form of permission
    notificationStatusPermantelyDenied = false;
  }

  /// Check if the user is subscribed to the news topic
  Future<bool> isSubscribedToNewsTopics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs
            .getBool(SharedPreferencesProvider.newsTopicSubscribedKey) ??
        false;
  }

  /// Subscribe to the news topic
  Future<void> subscribeNewsTopic() async {
    await _validateNotificationPermission();

    /// Show a dialog if notifications are permanently denied
    if (notificationStatusPermantelyDenied)
      throw 'notifications_permanently_denied';

    /// Granted: subscribe to the topic
    /// Set the shared preferences
    /// Log analytics event
    await FirebaseMessaging.instance.subscribeToTopic(notificationTopic);
    (await SharedPreferencesProvider().init()).newsTopicSubscribed = true;

    /// Update the state now so the UI can update
    updateState(NewsSubscriptionAction.state, data: {
      "newsTopicSubscribed": true,
    });

    /// Log analytics event
    FirebaseProvider().logEvent('news_topic_subscribe', {});
  }

  /// Unsubscribe to the news topic
  Future<void> unsubscribeNewsTopic() async {
    /// Update the state now so the UI can update
    updateState(NewsSubscriptionAction.state,
        data: {"newsTopicSubscribed": false});

    /// Unsubscribe from the topic
    /// Set the shared preferences
    /// Log analytics event
    await FirebaseMessaging.instance.unsubscribeFromTopic(notificationTopic);
    (await SharedPreferencesProvider().init()).newsTopicSubscribed = false;
    FirebaseProvider().logEvent('news_topic_unsubscribe', {});
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
      print(error);
    }
  }
}
