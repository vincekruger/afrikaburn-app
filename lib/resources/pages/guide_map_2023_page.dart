import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/models/guide.dart';
import 'package:afrikaburn/resources/widgets/guide_viewer_widget.dart';

class GuideMap2023Page extends NyStatefulWidget {
  static const path = '/guide-map-2023';
  static const name = 'Guide Map 2024';
  GuideMap2023Page() : super(path, child: _MapPdfPageState());
}

class _MapPdfPageState extends NyState<GuideMap2023Page> {
  @override
  Widget view(BuildContext context) {
    return GuideViewer(
      guide: Guide(GuideType.MAP, 2023),
      appBarTitle: "screen-name.map-pdf-2023".tr(),
    );
  }
}
