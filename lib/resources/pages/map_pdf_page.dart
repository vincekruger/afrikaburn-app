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

  final Uri pdfUri = Uri.parse(
      "https://www.afrikaburn.org/wp-content/uploads/2023/04/TT-MAP-2023-WEBf.pdf");

  @override
  Widget view(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return PdfViewerWidget(
        uri: pdfUri,
        navigationBarTitle: "screen-name.map-pdf".tr(),
        orientation: orientation,
      );
    });
  }
}
