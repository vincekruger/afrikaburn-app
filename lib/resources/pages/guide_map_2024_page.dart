import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/controllers/guide_wtf_2024_controller.dart';
import 'package:afrikaburn/app/models/guide.dart';
import 'package:afrikaburn/resources/widgets/guide_viewer_widget.dart';

class GuideMap2024Page extends NyStatefulWidget<GuideWtf2024Controller> {
  static const path = '/guide-map-2024';
  static const name = 'Guide Map 2024';
  GuideMap2024Page({super.key}) : super(path, child: _GuideWtf2024PageState());
}

class _GuideWtf2024PageState extends NyState<GuideMap2024Page> {
  /// [GuideWtf2024Controller] controller
  GuideWtf2024Controller get controller => widget.controller;

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: GuideViewer(
        guide: Guide(GuideType.MAP, 2024, protected: true),
        appBarTitle: "screen-name.map-pdf-2024".tr(),
      ),
    );
  }
}
