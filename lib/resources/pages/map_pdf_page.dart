import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/providers/system_provider.dart';
import 'package:afrikaburn/resources/widgets/pdf_viewer_widget.dart';

class MapPdfPage extends NyStatefulWidget {
  static const path = '/map-pdf';
  static const name = 'Map Pdf';
  MapPdfPage() : super(path, child: _MapPdfPageState());
}

class _MapPdfPageState extends NyState<MapPdfPage> {
  @override
  init() async {
    SystemProvider().setPortraitAndLandscapeOrientation();
  }

  @override
  void dispose() {
    SystemProvider().setOnlyPortraitOrientation();
    super.dispose();
  }

  /// Map URL
  final Uri pdfUri =
      Uri.parse(FirebaseRemoteConfig.instance.getString("pdf_map_url"));

  @override
  Widget view(BuildContext context) {
    return PdfViewerWidget(
      uri: pdfUri,
      navigationBarTitle: "screen-name.map-pdf".tr(),
    );
  }
}
