import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:afrikaburn/resources/appbars/sliding_app_bar.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';

class PdfViewerWidget extends StatefulWidget {
  final uri;
  final file;
  final navigationBarTitle;
  final showAppBarLeading;
  final onOrientationChange;
  final bool isProtected;

  const PdfViewerWidget({
    super.key,
    this.uri,
    this.file,
    required this.navigationBarTitle,
    required this.showAppBarLeading,
    this.onOrientationChange,
    this.isProtected = false,
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
      errorBannerBuilder: (context, error, stackTrace, documentRef) {
        print(error);
        print(stackTrace);
        print(documentRef);

        return Center(
          child: Text('Error loading PDF'),
        );
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

              /// Trigger on orientation change callback
              widget.onOrientationChange?.call(orientation);

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
                title: Text(widget.navigationBarTitle),
                backgroundColor: context.color.appBarBackground,
                leading: widget.showAppBarLeading
                    ? IconButton(
                        padding: Platform.isIOS
                            ? const EdgeInsets.only(
                                left: 12.0, top: 0, bottom: 10)
                            : null,
                        icon: Icon(AB24Icons.close_thick),
                        iconSize: 26,
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    : null,
              ),
            ),
            body: SafeArea(
              top: _appBarVisible,
              child: pdfViewerType(orientation),
            ),
          );
        },
      );

  Widget pdfViewerType(Orientation orientation) {
    /// Setup Password Stuff
    FutureOr<String?> Function()? passwordProvider;
    bool? firstAttemptByEmptyPassword = true;
    if (widget.isProtected) {
      firstAttemptByEmptyPassword = false;
      passwordProvider = () => '2024042920240505';
    }

    if (widget.file != null) {
      return PdfViewer.file(
        widget.file!.path,
        controller: _pdfController,
        passwordProvider: passwordProvider,
        firstAttemptByEmptyPassword: firstAttemptByEmptyPassword,
        params: pdfViewerParams(orientation == Orientation.landscape),
      );
    }

    if (widget.uri != null) {
      return PdfViewer.uri(
        widget.uri!,
        controller: _pdfController,
        passwordProvider: passwordProvider,
        firstAttemptByEmptyPassword: firstAttemptByEmptyPassword,
        params: pdfViewerParams(orientation == Orientation.landscape),
      );
    }

    return Center(
      child: Text('No file/pdf for PDF Viewer'),
    );
  }
}
