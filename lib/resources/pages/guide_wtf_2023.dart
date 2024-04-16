import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/models/guide.dart';
import 'package:afrikaburn/resources/widgets/guide_viewer_widget.dart';

class WtfGuidePage extends NyStatefulWidget {
  static const path = '/wtf-guide';
  static const name = '2023 WTF Guide';
  WtfGuidePage() : super(path, child: _WtfGuidePageState());
}

class _WtfGuidePageState extends NyState<WtfGuidePage> {
  /// Local File State

  @override
  Widget view(BuildContext context) {
    return GuideViewer(
      guide: Guide(GuideType.WTF, 2023),
      appBarTitle: "screen-name.wtf-guide-2023".tr(),
    );
  }
}
