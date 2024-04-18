import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';
import 'package:afrikaburn/app/providers/guide_download_provider.dart';

class GuideDownload extends StatefulWidget {
  const GuideDownload({
    super.key,
    required this.appBarTitle,
    required this.showAppBarLeading,
    required this.provider,
    required this.onDownloaded,
  });

  final String appBarTitle;
  final bool showAppBarLeading;
  final GuideDownloadProvider provider;
  final void Function(BuildContext context) onDownloaded;
  static String state = "guide_download";

  @override
  createState() => _GuideDownloadState();
}

class _GuideDownloadState extends NyState<GuideDownload> {
  _GuideDownloadState() {
    stateName = GuideDownload.state;
  }

  /// Download Progress
  double _downloadProgress = 0.0;
  bool _downloadComplete = false;

  @override
  init() async {
    await widget.provider
        .downloadGuide(GuideDownload.state)
        .catchError((error) {
      print(error);
    });
    _downloadComplete = false;
  }

  @override
  void dispose() {
    widget.provider.downloadSubscription?.cancel();
    super.dispose();
  }

  @override
  stateUpdated(dynamic data) async {
    if (data == null) return;

    setState(() {
      _downloadProgress = data;
      _downloadComplete = data == 1.0;
    });

    if (_downloadComplete) widget.onDownloaded(context);
  }

  @override
  Widget build(BuildContext context) {
    /// Show the download progress
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        backgroundColor: context.color.appBarBackground,
        leading: widget.showAppBarLeading
            ? IconButton(
                padding: Platform.isIOS
                    ? const EdgeInsets.only(left: 12.0, top: 0, bottom: 10)
                    : null,
                icon: Icon(AB24Icons.close_thick),
                iconSize: 26,
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  backgroundColor: context.color.primaryAlternate,
                  color: context.color.primaryAccent,
                  strokeWidth: 10,
                  value: _downloadProgress,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: Text('guides-content.downloading'.tr())
                    .alignCenter()
                    .bodyMedium(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
