import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';

class PdfViewerWidget extends StatefulWidget {
  final Uri uri;
  final String navigationBarTitle;
  final Orientation orientation;

  const PdfViewerWidget({
    super.key,
    required this.uri,
    required this.navigationBarTitle,
    required this.orientation,
  });

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  @override
  Widget build(BuildContext context) {
    /// IOS Scaffold
    if (Platform.isIOS) {
      return Scaffold(
        body: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(widget.navigationBarTitle.tr()),
          ),
          child: SafeArea(child: PDFView()),
        ),
      );
    }

    /// everyting else
    return Scaffold(
      appBar: AppBar(title: Text(widget.navigationBarTitle.tr())),
      body: SafeArea(child: PDFView()),
    );
  }

  /// PDF Viewer Params
  PdfViewerParams get pdfViewerParams => PdfViewerParams(
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
        layoutPages: widget.orientation == Orientation.landscape
            ? (pages, params) {
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
              }
            : null,
      );

  /// PDF Viewer
  Widget PDFView() {
    return PdfViewer.uri(widget.uri, params: pdfViewerParams);
  }
}
