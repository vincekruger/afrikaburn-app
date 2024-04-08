import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';

class PdfViewerWidget extends StatefulWidget {
  final Uri uri;
  final String navigationBarTitle;

  const PdfViewerWidget({
    super.key,
    required this.uri,
    required this.navigationBarTitle,
  });

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  /// App Bar Visibility & Orientation variables
  bool _appBarVisible = true;
  late final AnimationController _appBarController;
  Orientation? _orientation;
  late final PdfViewerController? _pdfController;

  /// Toggle the app bar visibility
  Future<void> _toggleAppBarVisibility({bool? visible}) async {
    setState(() {
      _appBarVisible = visible ?? !_appBarVisible;
    });

    /// Toogle the toolbar
    SystemChrome.setEnabledSystemUIMode(
      _appBarVisible ? SystemUiMode.edgeToEdge : SystemUiMode.immersiveSticky,
    );
  }

  @override
  void initState() {
    super.initState();

    /// Add observer
    WidgetsBinding.instance.addObserver(this);

    /// Configure the PDF controller
    _pdfController = PdfViewerController();

    /// Configure the app bar controller
    _appBarController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    /// Remove observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _orientation = MediaQuery.of(context).orientation;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _orientation = MediaQuery.of(context).orientation;
      });

      /// Relayout the PDF
      _pdfController!.setZoom(_pdfController!.centerPosition, 0.5);
      _pdfController!.relayout();

      /// Toggle the app bar visibility
      _toggleAppBarVisibility(visible: (_orientation == Orientation.portrait));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: SlidingAppBar(
        controller: _appBarController,
        visible: _appBarVisible,
        child: AppBar(
          title: Text(widget.navigationBarTitle.tr()),
          backgroundColor: context.color.appBarBackground,
        ),
      ),
      body: GestureDetector(
        onTap: _toggleAppBarVisibility,
        child: SafeArea(child: PDFView(), top: _appBarVisible),
      ),
    );
  }

  PdfPageLayout Function(List<PdfPage>, PdfViewerParams)?
      layoutPagesHorizontal = (pages, params) {
    final height = pages.fold(0.0, (prev, page) => max(prev, page.height)) +
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
  };

  /// PDF Viewer Params
  PdfViewerParams get pdfViewerParams {
    return PdfViewerParams(
      backgroundColor: context.color.background,
      loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
        return Center(
          child: CircularProgressIndicator(
            // totalBytes may not be available on certain case
            value: totalBytes != null ? bytesDownloaded / totalBytes : null,
            backgroundColor: context.color.black,
          ),
        );
      },
      layoutPages:
          _orientation == Orientation.portrait ? layoutPagesHorizontal : null,
    );
  }

  /// PDF Viewer
  Widget PDFView() => PdfViewer.uri(
        widget.uri,
        params: pdfViewerParams,
        controller: _pdfController,
      );
}

/// Sliding App Bar
class SlidingAppBar extends StatelessWidget implements PreferredSizeWidget {
  SlidingAppBar({
    required this.child,
    required this.controller,
    required this.visible,
  });

  final PreferredSizeWidget child;
  final AnimationController controller;
  final bool visible;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward();
    return SlideTransition(
      position: Tween<Offset>(begin: Offset.zero, end: Offset(0, -1)).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      child: child,
    );
  }
}
