import 'package:afrikaburn/app/controllers/news_controller.dart';
import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';
import 'package:afrikaburn/resources/themes/extensions/gradient_icon.dart';
import 'package:afrikaburn/resources/themes/extensions/outlined_button.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsListActions extends StatefulWidget {
  NewsListActions({Key? key}) : super(key: key);
  static String state = "news_list_actions";

  @override
  createState() => _NewsListActionsState();
}

class _NewsListActionsState extends NyState<NewsListActions> {
  _NewsListActionsState() {
    stateName = NewsListActions.state;
  }

  /// News Controller
  NewsController _newsController = NewsController();

  /// Whether the user is subscribed to the news topic
  bool _newsTopicSubscribed = false;

  @override
  init() async {
    _newsTopicSubscribed = await _newsController.isSubscribedToNewsTopics();
  }

  @override
  stateUpdated(dynamic data) async {
    setState(() {
      if (data['newsTopicSubscribed'] != null) {
        _newsTopicSubscribed = data['newsTopicSubscribed'];
      }
    });
    ;
  }

  /// Open the submit article page
  /// on the afirkaburn website
  Future<void> openSubmitArticlePage() async {
    // TODO add this to remove config
    await launchUrl(
      Uri.parse("https://www.afrikaburn.com/news/submit-an-article"),
      mode: LaunchMode.externalApplication,
    );

    /// Log Event
    FirebaseProvider().logEvent('submit_article', {});
  }

  /// Notifications Icon Button
  Widget notificationsIconButton() {
    IconButton iconButton = IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        AB24Icons.notification,
        size: 18.5,
        color: ThemeColor.get(this.context).background,
      ),
      onPressed:
          _newsTopicSubscribed ? _newsController.unsubscribeNewsTopic : () {},
    );

    if (!_newsTopicSubscribed)
      return InkWell(
        onTap: _newsController.subscribeNewsTopic,
        borderRadius: BorderRadius.circular(50.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: GradientStyles.appbarIcon,
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: EdgeInsets.zero,
              child: iconButton,
            ),
            Positioned(
              top: 5,
              left: 5,
              child: Icon(
                AB24Icons.off_slash,
                size: 40,
                color: ThemeColor.get(context).background,
              ),
            ),
          ],
        ),
      );

    /// Return an active state
    return Container(
      decoration: BoxDecoration(
        gradient: GradientStyles.appbarIcon,
        borderRadius: BorderRadius.circular(50.0),
      ),
      padding: EdgeInsets.zero,
      child: iconButton,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0).copyWith(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: openSubmitArticlePage,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(AB24Icons.contribute, size: 16).withGradeint(
                    GradientStyles.appbarIcon,
                  ),
                  SizedBox(width: 10),
                  Text("news.cta.submit-an-article".tr()),
                ],
              ),
            ).withGradient(
              strokeWidth: 2,
              gradient: GradientStyles.outlinedButtonBorder,
            ),
          ),
          SizedBox(width: 18),
          notificationsIconButton(),
        ],
      ),
    );
  }
}
