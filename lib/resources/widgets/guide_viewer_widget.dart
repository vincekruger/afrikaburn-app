import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/models/guide.dart';
import 'package:afrikaburn/app/providers/system_provider.dart';
import 'package:afrikaburn/app/providers/guide_download_provider.dart';
import 'package:afrikaburn/resources/widgets/guide_download_widget.dart';
import 'package:afrikaburn/resources/widgets/pdf_viewer_widget.dart';

class GuideViewer extends StatefulWidget {
  const GuideViewer({
    super.key,
    required this.guide,
    required this.appBarTitle,
  });

  final Guide guide;
  final String appBarTitle;
  static String state = "guide-viewer";

  @override
  createState() => _GuideViewerState(this.guide);
}

class _GuideViewerState extends NyState<GuideViewer>
    with WidgetsBindingObserver {
  _GuideViewerState(Guide guide) {
    stateName = GuideViewer.state;
    _provider = GuideDownloadProvider.instance(guide);
  }

  /// Local File State & Provider
  bool _localFileExists = false;
  late final GuideDownloadProvider _provider;

  @override
  init() async {
    SystemProvider().setPortraitAndLandscapeOrientation();
    WidgetsBinding.instance.addObserver(this);

    /// Check if the local file exists
    _localFileExists = await _provider.existsLocal();
  }

  @override
  void dispose() {
    SystemProvider().setOnlyPortraitOrientation();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Handle app lifecycle
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      var newState = _localFileExists = await _provider.existsLocal();
      setState(() {
        _localFileExists = newState;
      });
    }
  }

  @override
  stateUpdated(dynamic data) async {
    // e.g. to update this state from another class
    // updateState(Guide.state, data: "example payload");
  }

  @override
  Widget build(BuildContext context) {
    /// Display PDF Viewer
    if (_localFileExists) {
      return FutureBuilder(
          future: _provider.guide.file,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return PdfViewerWidget(
              file: snapshot.data,
              navigationBarTitle: widget.appBarTitle,
            );
          });
    }

    /// Download the Guide
    return GuideDownload(
      appBarTitle: widget.appBarTitle,
      provider: _provider,
      onDownloaded: (context) {
        setState(() {
          _localFileExists = true;
        });
      },
    );
  }
}
