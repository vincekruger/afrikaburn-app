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

class _NewsPageState extends NyState<NewsPage> {
  /// [NewsController] controller
  NewsController get controller => widget.controller;

  /// Widget init
  @override
  init() {
    widget.controller.pagingController.addPageRequestListener((pageKey) {
      widget.controller.fetchNews(pageKey);
    });
    return super.init();
  }

  /// Widget dispose
  @override
  void dispose() {
    widget.controller.pagingController.dispose();
    super.dispose();
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
          pagingController: widget.controller.pagingController,
          builderDelegate: PagedChildBuilderDelegate<News>(
            itemBuilder: (context, item, index) => NewsItem(item, index: index),
            // firstPageErrorIndicatorBuilder: (context) => Container(
            //   height: scale(200, context),
            //   child: Center(
            //     child: Text(
            //       'Error loading news',
            //       style: TextStyle(
            //         color: Colors.red,
            //         fontSize: 20,
            //       ),
            //     ),
            //   ),
            // ),
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
