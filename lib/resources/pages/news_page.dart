import 'package:afrikaburn/app/models/news.dart';
import 'package:afrikaburn/resources/widgets/news_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/resources/appbars/news_app_bar.dart';
import 'package:afrikaburn/resources/widgets/ab_divider_widget.dart';
import 'package:afrikaburn/app/controllers/news_controller.dart';

class NewsPage extends NyStatefulWidget<NewsController> {
  static const path = '/news';

  NewsPage() : super(path, child: _NewsPageState());
}

class _NewsPageState extends NyState<NewsPage> {
  /// [NewsController] controller
  NewsController get controller => widget.controller;

  List<News> newsList = [];

  @override
  init() async {}

  @override
  boot() async {
    newsList = await widget.controller.getNewsPosts();
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 147,
            left: 0,
            child: AbDivider(width: scale(190, context)),
          ),
          Positioned(
            top: scale(501, context),
            left: 0,
            child: Image.asset(
              'public/assets/images/canvas-bg-afrikaburn-24-v1-1.png',
              width: scale(154, context),
            ),
          ),
          Positioned(
            top: scale(135, context),
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
          Container(
            child: NewList(context),
          ),
        ],
      ),
    );
  }

  NewList(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 20),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        bool inverted = index % 2 == 0;

        if (index == 0)
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewsAppBar(scale(100, context)),
                SizedBox(height: 57),
                NewsItem(newsList[index], inverted: inverted),
              ],
            ),
          );
        return NewsItem(newsList[index], inverted: inverted);
      },
    );
  }
}
