import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/models/guide.dart';
import 'package:afrikaburn/resources/widgets/guide_viewer_widget.dart';

class MapPdfPage extends NyStatefulWidget {
  static const path = '/map-pdf';
  static const name = '2023 Map PDF';
  MapPdfPage() : super(path, child: _MapPdfPageState());
}

class _MapPdfPageState extends NyState<MapPdfPage> {
  @override
  Widget view(BuildContext context) {
    return GuideViewer(
      guide: Guide(GuideType.MAP, 2023),
      appBarTitle: "screen-name.map-pdf-2023".tr(),
    );
  }
}
