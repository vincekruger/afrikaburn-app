import 'dart:io';
import 'dart:math';

import 'package:afrikaburn/app/providers/system_provider.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/controllers/wtf_guide_controller.dart';
import 'package:pdfrx/pdfrx.dart';

class WtfGuidePage extends NyStatefulWidget<WtfGuideController> {
  static const path = '/wtf-guide';
  static const name = 'WTF Guide';
  WtfGuidePage() : super(path, child: _WtfGuidePageState());
}

class _WtfGuidePageState extends NyState<WtfGuidePage> {
  /// [WtfGuideController] controller
  WtfGuideController get controller => widget.controller;

  @override
  init() async {
    SystemProvider().setPortraitAndLandscapeOrientation();
  }

  @override
  void dispose() {
    SystemProvider().setOnlyPortraitOrientation();
    super.dispose();
  }

  /// Guide URL
  String guideUrl =
      "https://www.afrikaburn.org/wp-content/uploads/2023/04/WTF2023-FA-web2.pdf";

  @override
  Widget view(BuildContext context) {
    /// IOS Scaffold
    if (Platform.isIOS) {
      return CupertinoScaffold(
        transitionBackgroundColor: context.color.background,
        body: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text("screen-name.wtf-guide".tr()),
          ),
          child: SafeArea(child: PDFView()),
        ),
      );
    }

    /// everyting else
    return Scaffold(
      appBar: AppBar(title: Text("screen-name.wtf-guide".tr())),
      body: SafeArea(child: PDFView()),
    );
  }

  /// PDF Viewer
  Widget PDFView() {
    return PdfViewer.uri(
      Uri.parse(guideUrl),
      params: PdfViewerParams(
        backgroundColor: context.color.background,
        // Todo - remove this eventually because we will be caching this locally.
        loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
          return Center(
            child: CircularProgressIndicator(
              // totalBytes may not be available on certain case
              value: totalBytes != null ? bytesDownloaded / totalBytes : null,
              backgroundColor: context.color.black,
            ),
          );
        },

        /// To make the scrolling horizontal
        layoutPages: (pages, params) {
          final height =
              pages.fold(0.0, (prev, page) => max(prev, page.height)) +
                  params.margin * 2;
          final pageLayouts = <Rect>[];
          double x = params.margin;
          for (var page in pages) {
            pageLayouts.add(
              Rect.fromLTWH(
                x,
                (height - page.height) / 2, // center vertically
                page.width,
                page.height,
              ),
            );
            x += page.width + params.margin;
          }
          return PdfPageLayout(
            pageLayouts: pageLayouts,
            documentSize: Size(x, height),
          );
        },
      ),
    );
  }
}
