import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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

  String guideUrl =
      "https://www.afrikaburn.org/wp-content/uploads/2023/04/WTF2023-FA-web2.pdf";

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WTF Guide")),
      body: PDFView(),
      // body: Container(height: 300, color: Colors.blue),
    );
  }

  Widget PDFView() {
    return PDF(
      // onViewCreated,
      // onRender,
      // onPageChanged,
      // onError,
      // onPageError,
      // onLinkHandler,
      // gestureRecognizers,
      // enableSwipe = true,
      // swipeHorizontal = false,
      // password,
      // nightMode = false,
      // autoSpacing = true,
      // pageFling = true,
      // pageSnap = true,
      // fitEachPage = true,
      // defaultPage = 0,
      // fitPolicy = FitPolicy.WIDTH,
      // preventLinkNavigation = false,

      swipeHorizontal: false,
      fitPolicy: FitPolicy.HEIGHT,
      preventLinkNavigation: true,
    ).fromUrl(
      guideUrl,
      errorWidget: (dynamic error) => Center(child: Text(error.toString())),
    );
  }
}
