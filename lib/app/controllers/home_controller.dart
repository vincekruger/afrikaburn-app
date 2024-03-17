import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/home_page.dart';
import 'package:flutter_app/resources/pages/wtf_guide_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '/resources/widgets/logo_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'controller.dart';

class HomeController extends Controller {
  @override
  construct(BuildContext context) {
    super.construct(context);
  }

  openBottomSheet(BuildContext context, String path) async {
    showBarModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => WtfGuidePage(),
    );
  }

  onTapGithub() async {
    await launchUrl(Uri.parse("https://github.com/nylo-core/nylo"));
  }

  onTapChangeLog() async {
    await launchUrl(Uri.parse("https://github.com/nylo-core/nylo/releases"));
  }

  onTapYouTube() async {
    await launchUrl(Uri.parse("https://m.youtube.com/@nylo_dev"));
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
