import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/providers/system_provider.dart';
import 'package:afrikaburn/resources/widgets/pdf_viewer_widget.dart';

class WtfGuidePage extends NyStatefulWidget {
  static const path = '/wtf-guide';
  static const name = 'WTF Guide';
  WtfGuidePage() : super(path, child: _WtfGuidePageState());
}

class _WtfGuidePageState extends NyState<WtfGuidePage> {
  @override
  init() async {
    SystemProvider().setPortraitAndLandscapeOrientation();
  }

  @override
  void dispose() {
    SystemProvider().setOnlyPortraitOrientation();
    super.dispose();
  }

  /// Guide URL
  final Uri pdfUri =
      Uri.parse(FirebaseRemoteConfig.instance.getString("pdf_wtf_guide_url"));

  @override
  Widget view(BuildContext context) {
    return PdfViewerWidget(
      uri: pdfUri,
      navigationBarTitle: "screen-name.wtf-guide".tr(),
    );
  }
}
