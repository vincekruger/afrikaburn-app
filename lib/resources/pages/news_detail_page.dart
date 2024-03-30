import 'package:afrikaburn/app/controllers/platform_controller.dart';
import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/resources/icons/a_b2024_icons.dart';
import 'package:afrikaburn/resources/widgets/news_item_content_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/controllers/news_controller.dart';
import 'package:afrikaburn/app/models/news.dart';

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
    PlatformController().hideIOSStatusBar();
    return super.init();
  }

  @override
  void dispose() {
    PlatformController().showIOSStatusBar();
    super.dispose();
  }

  /// Use boot if you need to load data before the view is rendered.
  @override
  boot() async {
    FirebaseProvider().logScreenView(NewsDetailPage.path, params: {
      'news_id': newsItem.id,
      'news_title': newsItem.title,
    });

    newsItem = widget.data()['newsItem'] as News;
    heroTag = widget.data()['heroTag'] as String;
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

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Hero(
                tag: heroTag,
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          CachedNetworkImageProvider(newsItem.featuredImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              _imageCredit(),
              SizedBox(height: 10),
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
                    padding.copyWith(top: 10, bottom: 40, left: 0, right: 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: ThemeColor.get(context).surfaceBackground,
                  ),
                  child: InkWell(
                    onTap: () async {
                      // await launchUrl(Uri.parse(url!),
                      // mode: LaunchMode.externalApplication);

                      // https://www.afrikaburn.org/?post_id=36477
                      print(newsItem.id);

                      FirebaseProvider()
                          .logEvent('news_item_join_discussion_tap', {
                        "item_id": newsItem.id,
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        Image.asset(
                          "public/assets/images/pointing-hand.png",
                          width: scale(87, context),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 40,
            right: 40,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  AB2024.close_thick,
                  size: 12,
                  color: Colors.white,
                ),
                // child: IconButton(
                //   onPressed: () => Navigator.pop(context),
                //   icon: Icon(AB2024.close_thick),
                //   iconSize: 12,
                //   padding: EdgeInsets.zero,
                //   color: Colors.white,
                //   visualDensity: VisualDensity.comfortable,
                // ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
