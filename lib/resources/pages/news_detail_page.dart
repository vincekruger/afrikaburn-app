import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/news_detail_controller.dart';

class NewsDetailPage extends NyStatefulWidget<NewsDetailController> {
  static const path = '/news-detail';

  NewsDetailPage() : super(path, child: _NewsDetailPageState());
}

class _NewsDetailPageState extends NyState<NewsDetailPage> {

  /// [NewsDetailController] controller
  NewsDetailController get controller => widget.controller;

  @override
  init() async {

  }
  
  /// Use boot if you need to load data before the view is rendered.
  // @override
  // boot() async {
  //
  // }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Detail")
      ),
      body: SafeArea(
         child: Container(),
      ),
    );
  }
}
