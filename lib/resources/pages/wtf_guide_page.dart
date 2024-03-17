import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/wtf_guide_controller.dart';

class WtfGuidePage extends NyStatefulWidget<WtfGuideController> {
  static const path = '/wtf-guide';

  WtfGuidePage() : super(path, child: _WtfGuidePageState());
}

class _WtfGuidePageState extends NyState<WtfGuidePage> {
  /// [WtfGuideController] controller
  WtfGuideController get controller => widget.controller;

  @override
  init() async {}

  /// Use boot if you need to load data before the view is rendered.
  // @override
  // boot() async {
  //
  // }

  String guideUrl =
      "https://www.afrikaburn.org/wp-content/uploads/2023/04/WTF2023-FA-web2.pdf";

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WTF Guide")),
      body: SafeArea(
        child: PDF(
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: true,
          pageSnap: true,
        ).fromUrl(
          guideUrl,
          errorWidget: (dynamic error) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}
