import 'dart:io';

import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';
import 'package:afrikaburn/resources/themes/extensions/gradient_icon.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:afrikaburn/resources/widgets/news_item_content_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
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
  static const name = 'News Detail Page';
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
    SystemChrome.setEnabledSystemUIMode(
      Platform.isIOS ? SystemUiMode.immersive : SystemUiMode.immersiveSticky,
    );
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
  }

  /// Image Credit
  Widget formatImageCredit() {
    if (newsItem.imageCredit == null) return Container();

    return Padding(
      padding: padding.copyWith(top: 5, bottom: 0, left: 5),
      child: Container(
        width: 186,
        child: Text(
          "Image Credit".tr() + ": " + newsItem.imageCredit!.tr(),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ).bodySmall(context).setColor(
            context, (color) => ThemeColor.get(context).primaryContent),
      ),
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
  List<Widget> formatCategoryList() {
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
    /// Add the #respond to the URL to scroll to the comments section
    Uri discussionUri = Uri.parse(newsItem.url.toString() + "#respond");

    /// Launch the URL
    await launchUrl(
      discussionUri,
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

  /// The View
  @override
  Widget view(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: DismissiblePage(
        backgroundColor: context.color.background,
        direction: DismissiblePageDismissDirection.down,
        isFullScreen: true,
        onDismissed: () => Navigator.pop(context),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.2,
                child: Container(
                  width: scale(82, context),
                  height: scale(372, context),
                  child: Image.asset(
                    context.isDarkMode
                        ? "public/assets/images/fish-1-20op-dark.png"
                        : "public/assets/images/fish-1-20op-light.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            articleConent(context),
          ],
        ),
      ),
    );
  }

  /// Article Content
  Widget articleConent(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        articleArtwork(context),
        Padding(
          padding: padding,
          child: Text(newsItem.title).titleLarge(context),
        ),
        Padding(
          padding: padding,
          child: Row(
            children: [
              formatedDate(),
            ],
          ),
        ),
        Padding(
          padding: padding,
          child: NewsContent(newsItem.id, newsItem.content),
        ),
        Padding(
          padding: padding.copyWith(top: 20, left: 0, right: 0),
          child: OutlineGradientButton(
            onTap: openPostUrl,
            padding: EdgeInsets.all(2),
            strokeWidth: 2,
            gradient: GradientStyles.canvasLine,
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
                          "news.cta.join-disccussion".tr(),
                          softWrap: true,
                        ).titleLarge(context).setColor(
                            context, (color) => ThemeColor.get(context).blue),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Image.asset(
                      "public/assets/images/pointing-hand.png",
                      width: scale(87, context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        // Padding(
        //   padding: padding.copyWith(top: 40, bottom: 60, left: 0, right: 0),
        //   child: Center(
        //     child: OutlinedButton(
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Icon(AB24Icons.share, size: 16),
        //           SizedBox(width: 10),
        //           Text("news.cta.share-story".tr().toUpperCase()),
        //         ],
        //       ),
        //       onPressed: () {},
        //     ).withGradient(
        //       strokeWidth: 2,
        //       gradient: GradientStyles.outlinedButtonBorder,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  /// Article Artwork
  Widget articleArtwork(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Container(
        height: 320,
        child: Stack(
          children: [
            canvasGradientLinesCrisCross(
              context,
              top: 245,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 290,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      color: ThemeColor.get(context).surfaceBackground,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: ThemeColor.get(context).surfaceBackground,
                    ),
                    imageUrl: newsItem.featuredImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()..rotateZ(-0.07),
                  child: formatImageCredit(),
                ),
              ],
            ),
            Positioned(
              right: 15,
              top: Platform.isIOS ? 238 : 15,
              child: closeIconButton(context),
            ),
          ],
        ),
      ),
    );
  }

  /// The Fancy close button
  Container closeIconButton(BuildContext context) {
    final double buttonSize = 40;

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 8,
            color: context.color.shadowColor.withOpacity(0.5),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        icon: Icon(
          AB24Icons.close_thick,
          size: 20,
          color: context.color.background,
        ),
      ).withGradient(GradientStyles.appbarIcon),
    );
  }

  /// Canvas Gradient Lines Cris Cross
  Stack canvasGradientLinesCrisCross(BuildContext context,
      {required double top}) {
    return Stack(
      children: [
        Positioned(
          top: top,
          right: scale(32.71, context) * -1,
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()..rotateZ(0.0783),
            child: Container(
              width: scale(403.86, context),
              // height: scale(46, context),
              height: 46,
              decoration: BoxDecoration(
                gradient: GradientStyles.canvasLine,
              ),
            ),
          ),
        ),
        Positioned(
          top: top,
          left: scale(32.71, context) * -1,
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()..rotateZ(0.0671 * -1),
            child: Container(
              width: scale(403.86, context),
              // height: scale(46, context),
              height: 46,
              decoration: BoxDecoration(
                gradient: GradientStyles.canvasLine,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
