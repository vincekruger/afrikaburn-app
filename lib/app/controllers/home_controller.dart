import 'package:flutter/material.dart';
import 'package:afrikaburn/resources/pages/map_page.dart';
import 'package:afrikaburn/resources/pages/my_contact_page.dart';
import 'package:afrikaburn/resources/pages/wtf_guide_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '/resources/widgets/logo_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'controller.dart';

class HomeController extends Controller {
  @override
  construct(BuildContext context) {
    super.construct(context);
  }

  openBottomSheet(BuildContext context, String path) async {
    showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => WtfGuidePage(),
    );
  }

  void openWTFGuide() {
    routeTo(WtfGuidePage.path);
  }

  void openMyContact() {
    routeTo(MyContactPage.path);
  }

  void openMap() {
    routeTo(MapPage.path);
  }

  showAbout() {
    showAboutDialog(
      context: context!,
      applicationName: getEnv('APP_NAME'),
      applicationIcon: Logo(),
      applicationVersion: nyloVersion,
    );
  }
}
