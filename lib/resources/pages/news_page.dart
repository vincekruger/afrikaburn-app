import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/resources/themes/extensions/outlined_button.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/models/news.dart';
import 'package:afrikaburn/resources/widgets/news_item_widget.dart';
import 'package:afrikaburn/resources/widgets/news_subscription_action_widget.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/resources/appbars/news_app_bar.dart';
import 'package:afrikaburn/resources/widgets/ab_divider_widget.dart';
import 'package:afrikaburn/app/controllers/news_controller.dart';

class NewsPage extends NyStatefulWidget<NewsController> {
  static const path = '/news';
  static const name = 'News Page';
  NewsPage() : super(path, child: _NewsPageState());
}

class _NewsPageState extends NyState<NewsPage> with WidgetsBindingObserver {
  /// [NewsController] controller
  NewsController get controller => widget.controller;

  /// Widget init
  @override
  init() {
    WidgetsBinding.instance.addObserver(this);
    controller.pagingController.addPageRequestListener((pageKey) {
      controller.fetchNews(pageKey);
    });
  }

  /// Widget dispose
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.cancelNewsSubscriptions();

    // TODO Find a way to dispose of this controller
    // controller.pagingController.dispose();

    super.dispose();
  }

  /// Handle app lifecycle
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) return;
    controller.getNewPosts();
  }

  /// ListView Header
  Widget header(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NewsAppBar(
          scale(90 - MediaQuery.of(context).padding.top, context),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: AbDivider(width: scale(190, context)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: NewsSubscriptionAction(),
            ),
          ],
        ),
      ],
    );
  }

  /// News List View
  Widget NewList(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: header(context),
        ),
        PagedSliverList<int, News>(
          pagingController: controller.pagingController,
          builderDelegate: PagedChildBuilderDelegate<News>(
            itemBuilder: (context, item, index) => NewsItem(item, index: index),
            firstPageErrorIndicatorBuilder: (context) => Container(
              height: scale(200, context),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: context.color.surfaceBackground,
                    border:
                        Border.all(color: context.color.fourthAccent, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('news-content.error-loading.title'.tr())
                          .titleLarge(context)
                          .setColor(
                              context, (color) => context.color.surfaceContent),
                      SizedBox(height: 10),
                      Text('news-content.error-loading.message'.tr())
                          .alignCenter()
                          .bodyMedium(context)
                          .setColor(
                              context, (color) => context.color.surfaceContent),
                      SizedBox(height: 14),
                      OutlinedButton(
                        onPressed:
                            controller.pagingController.retryLastFailedRequest,
                        child: Text('news-content.error-loading.retry'.tr()),
                      ).withGradient(
                        strokeWidth: 2,
                        gradient: GradientStyles.outlinedButtonBorder,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Widget view
  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Stack(
          children: [
            Positioned(
              top: scale(501, context),
              left: 0,
              child: Image.asset(
                'public/assets/images/canvas-bg-afrikaburn-24-v1-1.png',
                width: scale(154, context),
              ),
            ),
            Positioned(
              top: scale(145, context),
              left: scale(93, context),
              child: Container(
                height: scale(310, context),
                width: scale(154, context),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.asset(
                            'public/assets/images/canvas-bg-afrikaburn-24-v1-1.png')
                        .image,
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              top: scale(148, context),
              right: scale(20, context),
              child: Image.asset(
                'public/assets/images/canvas-bg-afrikaburn-24-v1-1.png',
                width: scale(154, context),
              ),
            ),
            NewList(context),
          ],
        ),
      ),
    );
  }
}
