import 'dart:io';

import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';
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
    with SingleTickerProviderStateMixin {
  /// PDF Controller
  final PdfViewerController _pdfController = PdfViewerController();
  late double _initialZoom;
  late Offset _initialCenterPosition;

  /// Animated App Bar & Visibility
  late final AnimationController _appBarController;
  bool _appBarVisible = true;

  @override
  void initState() {
    super.initState();

    /// Configure the app bar controller
    _appBarController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Set the system UI mode
  void setSystemUIMode(bool _appBarVisible) {
    SystemChrome.setEnabledSystemUIMode(_appBarVisible
        ? SystemUiMode.edgeToEdge
        : SystemUiMode.immersiveSticky);
  }

  /// PDF Viewer Params
  PdfViewerParams pdfViewerParams(bool isLandscape) {
    return PdfViewerParams(
      backgroundColor: context.color.background,
      layoutPages: isLandscape ? pdfHorizonalPageLayout : null,
      loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
        return Center(
          child: CircularProgressIndicator(
            // totalBytes may not be available on certain case
            value: totalBytes != null ? bytesDownloaded / totalBytes : null,
            backgroundColor: context.color.black,
          ),
        );
      },
      onViewerReady: (_, __) {
        _initialZoom = _pdfController.currentZoom;
        _initialCenterPosition = _pdfController.centerPosition;
      },
    );
  }

  @override
  Widget build(BuildContext context) => OrientationBuilder(
        builder: (context, orientation) {
          /// Set the app bar visibility based on the orientation
          _appBarVisible = (orientation == Orientation.portrait);
          setSystemUIMode(_appBarVisible);

          if (_pdfController.isReady) {
            Future.delayed(Duration(seconds: 0), () {
              /// Set the zoom and center position based on the orientation
              if (orientation == Orientation.landscape) {
                _pdfController.setZoom(Offset.zero, 0.5);
              } else {
                _pdfController.setZoom(_initialCenterPosition, _initialZoom);
              }

              /// Relayout the PDF
              _pdfController.relayout();
            });
          }

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: SlidingAppBar(
              controller: _appBarController,
              visible: _appBarVisible,
              child: AppBar(
                title: Text(widget.navigationBarTitle.tr()),
                backgroundColor: context.color.appBarBackground,
                leading: IconButton(
                  padding: Platform.isIOS
                      ? const EdgeInsets.only(left: 12.0, top: 0, bottom: 10)
                      : null,
                  icon: Icon(AB24Icons.close_thick),
                  iconSize: 26,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            body: SafeArea(
              top: _appBarVisible,
              child: PdfViewer.uri(
                widget.uri,
                controller: _pdfController,
                params: pdfViewerParams(orientation == Orientation.landscape),
              ),
            ),
          );
        },
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
