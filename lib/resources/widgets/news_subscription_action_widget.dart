import 'dart:io';

import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/controllers/news_controller.dart';
import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';
import 'package:afrikaburn/resources/themes/extensions/gradient_icon.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:afrikaburn/resources/popups/succcess.dart';
import 'package:afrikaburn/resources/popups/confirm.dart';
import 'package:afrikaburn/resources/popups/error.dart';

class NewsSubscriptionAction extends StatefulWidget {
  NewsSubscriptionAction({Key? key}) : super(key: key);
  static String state = "news_list_actions";

  @override
  createState() => _NewsSubscriptionActionState();
}

class _NewsSubscriptionActionState extends NyState<NewsSubscriptionAction> {
  _NewsSubscriptionActionState() {
    stateName = NewsSubscriptionAction.state;
  }

  /// News Controller
  NewsController _newsController = NewsController();

  /// Whether the user is subscribed to the news topic
  bool _newsTopicSubscribed = true;

  /// Initialize the state
  @override
  init() async {
    _newsTopicSubscribed = await _newsController.isSubscribedToNewsTopics();
  }

  /// Update the state
  @override
  stateUpdated(dynamic data) async {
    setState(() {
      _newsTopicSubscribed = data['newsTopicSubscribed'] ?? false;
    });
  }

  /// Subscribe to the news topic
  /// Show the confirmation dialog
  Future<void> subscribe() async {
    try {
      /// Subscribe to the news topic
      await _newsController.subscribeNewsTopic();

      /// Log the event
      FirebaseProvider().logEvent('news-subscribed', {});

      /// Show the confirmation dialog
      successDialogBuilder(this.context, "news-content.subscribe-confirmed");
    } catch (e) {
      if (e == 'notifications_permanently_denied')
        return notifcationSettingsErrorDialogBuilder(
            this.context, "settings.notifications-denied");

      /// General error
      generalErrorDialogBuilder(context, "news-content.subscribe-error");
    }
  }

  /// Unsubscribe from the news topic
  /// Show the confirmation dialog
  Future<void> unsubscribe() async {
    try {
      /// Show the confirmation dialog
      bool? result = await confirmDialogBuilder(
        this.context,
        "news-content.unsubscribe-confirm",
      );

      // User Cancelled the dialog
      if (result == null || !result) return;

      /// Unsubscribe from the news topic
      await _newsController.unsubscribeNewsTopic();

      /// Show the confirmation dialog
      successDialogBuilder(this.context, "news-content.unsubscribe-confirmed");

      /// Log the event
      FirebaseProvider().logEvent('news-unsubscribed', {});
    } catch (e) {
      /// General error
      generalErrorDialogBuilder(context, "news-content.subscribe-error");
    }
  }

  /// Notifications Icon Button
  Widget notificationsIconButton() {
    IconButton iconButton = IconButton(
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      icon: Icon(
        AB24Icons.notification,
        size: 18,
        color: context.color.background,
      ),
      onPressed: _newsTopicSubscribed ? unsubscribe : subscribe,
    );

    return _newsTopicSubscribed
        ? iconButton.withGradientAndIconOverlay(
            GradientStyles.appbarIcon,
            overlayIcon: Icon(
              AB24Icons.off_slash,
              size: 40,
              color: context.color.background,
            ),
          )
        : iconButton.withGradient(GradientStyles.appbarIcon);
  }

  /// Build
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 10,
            color: context.color.shadowColor.withOpacity(0.5),
          ),
        ],
      ),
      child: notificationsIconButton(),
    );
  }
}
