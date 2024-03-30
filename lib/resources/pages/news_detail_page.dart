import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/resources/icons/a_b2024_icons.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:afrikaburn/resources/widgets/news_item_content_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/controllers/news_controller.dart';
import 'package:afrikaburn/app/models/news.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends NyStatefulWidget<NewsController> {
  static const path = '/news-detail';
  NewsDetailPage() : super(path, child: _NewsDetailPageState());
}

class _NewsDetailPageState extends NyState<NewsDetailPage> {
  /// [NewsController] controller
  NewsController get controller => widget.controller;

  /// Widget Data
  late News newsItem;
  late String heroTag;

  /// Layout Constants
  final EdgeInsets padding = const EdgeInsets.symmetric(
    vertical: 10.0,
    horizontal: 20.0,
  );

  @override
  init() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return super.init();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  /// Use boot if you need to load data before the view is rendered.
  @override
  boot() async {
    newsItem = widget.data()['newsItem'] as News;
    heroTag = widget.data()['heroTag'] as String;

    /// Log Screen View
    FirebaseProvider().logScreenView(NewsDetailPage.path, params: {
      'news_id': newsItem.id,
      'news_title': newsItem.title,
    });
  }

  /// Image Credit
  Widget _imageCredit() {
    if (newsItem.imageCredit == null) return Container();

    return Padding(
      padding: padding.copyWith(top: 5, bottom: 0),
      child: Text("Image Credit".tr() + ": " + newsItem.imageCredit!.tr())
          .bodySmall(context)
          .setColor(
              context, (color) => ThemeColor.get(context).primaryAlternate),
    );
  }

  /// Formatted Display Date
  /// - If the date is less than a week then display the date in relative format
  /// - If the date is older than a week then display the date in local format
  Widget formatedDate() {
    Moment ts = newsItem.timestamp.toMoment();
    Moment tsLastWeek = Moment.now().subtract(Duration(days: 7));

    String displayDate = ts.fromNow();
    if (ts.isBefore(tsLastWeek)) {
      displayDate = ts.format('ll');
    }

    return Text(displayDate)
        .bodySmall(context)
        .setColor(context, (color) => ThemeColor.get(context).primaryAlternate);
  }

  /// Categories List
  List<Widget> catgoriesList() {
    if (newsItem.categories == null) return [];
    if (newsItem.categories!.isEmpty) return [];

    /// Configure text color and spacer
    Color primaryAlternate = ThemeColor.get(context).primaryAlternate;
    List<Widget> widgetList = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text("|")
            .bodySmall(this.context)
            .setColor(context, (color) => primaryAlternate),
      ),
    ];

    /// Add categories to the list
    newsItem.categories!.forEach((category) {
      print(category.name.tr());
      widgetList.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(category.name.tr())
              .bodySmall(this.context)
              .setColor(context, (color) => primaryAlternate),
        ),
      );
    });

    return widgetList;
  }

  /// Open Post URL on the Afrikaburn website
  void openPostUrl() async {
    await launchUrl(
      newsItem.url,
      mode: LaunchMode.externalApplication,
    );

    /// Log Event
    FirebaseProvider().logEvent(
      'news_item_join_discussion_tap',
      {
        "item_id": newsItem.id,
        "item_title": newsItem.title,
        "item_url": newsItem.url.toString(),
      },
    );
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: scale(82, context),
              height: scale(372, context),
              child: Image.asset(
                context.isDarkMode
                    ? "public/assets/images/dark-mode/fish-1-20op.png"
                    : "public/assets/images/fish-1-20op.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Hero(
                tag: heroTag,
                child: Container(
                  height: 330,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      canvasGradientLinesCrisCross(context, top: 255),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 300,
                            child: CachedNetworkImage(
                              imageUrl: newsItem.featuredImageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          _imageCredit(),
                        ],
                      ),
                      Positioned(
                        top: 300 - 60,
                        right: 20,
                        child: InkWell(
                          onTap: () => {Navigator.pop(context)},
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: ThemeColor.get(context)
                                  .black
                                  .withOpacity(0.85),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              AB2024.close_thick,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: padding,
                child: Text(newsItem.title).titleLarge(context),
              ),
              Padding(
                padding: padding,
                child: Row(
                  children: [
                    formatedDate(),
                    // ...catgoriesList(),
                  ],
                ),
              ),
              Padding(
                padding: padding,
                child: NewsContent(newsItem.id, newsItem.content),
              ),
              Padding(
                padding:
                    padding.copyWith(top: 20, bottom: 60, left: 0, right: 0),
                child: OutlineGradientButton(
                  onTap: openPostUrl,
                  padding: EdgeInsets.all(2),
                  strokeWidth: 2,
                  gradient: GradientStyles().canvasLine,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: ThemeColor.get(context).surfaceBackground,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0)
                              ..rotateZ(-0.05),
                            child: Container(
                              width: scale(215, context),
                              child: Text(
                                "Join the discussion on the burn site".tr(),
                                softWrap: true,
                              ).titleLarge(context).setColor(context,
                                  (color) => ThemeColor.get(context).blue),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Image.asset(
                            "public/assets/images/pointing-hand.png",
                            width: scale(87, context),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Stack canvasGradientLinesCrisCross(BuildContext context,
      {required double top}) {
    return Stack(
      children: [
        Positioned(
          top: scale(top, context),
          right: scale(32.71, context) * -1,
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()..rotateZ(0.0783),
            child: Container(
              width: scale(403.86, context),
              height: scale(46, context),
              decoration: BoxDecoration(
                gradient: GradientStyles().canvasLine,
              ),
            ),
          ),
        ),
        Positioned(
          top: scale(top, context),
          left: scale(32.71, context) * -1,
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()..rotateZ(0.0671 * -1),
            child: Container(
              width: scale(403.86, context),
              height: scale(46, context),
              decoration: BoxDecoration(
                gradient: GradientStyles().canvasLine,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
