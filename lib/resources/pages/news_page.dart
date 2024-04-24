import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/app/controllers/news_controller.dart';
import 'package:afrikaburn/resources/widgets/news_list_widget.dart';

class NewsPage extends NyStatefulWidget<NewsController> {
  static const path = '/news';
  static const name = 'News Page';
  NewsPage() : super(path, child: _NewsPageState());
}

class _NewsPageState extends NyState<NewsPage> {
  /// [NewsController] controller
  NewsController get controller => widget.controller;

  @override
  init() async {
    /// Fetch news
    controller.pagingController.addPageRequestListener((pageKey) {
      controller.fetchNews(pageKey);
    });
  }

  @override
  void dispose() {
    // TODO Find a way to dispose of this controller
    // controller.pagingController.dispose();

    super.dispose();
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
            NewsList(controller: controller),
          ],
        ),
      ),
    );
  }
}
