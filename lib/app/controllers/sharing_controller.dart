import 'dart:math';

import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/widgets.dart';
import 'package:afrikaburn/app/controllers/controller.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:share_plus/share_plus.dart';

class SharingController extends Controller {
  construct(BuildContext context) {
    super.construct(context);
  }

  /// Singleton Factory
  @override
  bool get singleton => true;

  /// Get the share app text
  String get getShareAppText {
    int stringNumber = Random().nextInt(10) + 1;
    return "share-content.$stringNumber".tr();
  }

  /// Open the native share sheet
  void shareApp() async {
    String shareText = getShareAppText;
    String shareUrl =
        await FirebaseRemoteConfig.instance.getString('app_share_url');
    await Share.share('$shareText $shareUrl');
    FirebaseProvider().logEvent('share_app', {
      "text": shareText,
      "url": shareUrl,
    });
  }

  void shareRadioFreeTankwa() async {
    String shareText = "Check out Radio Free Tankwa";
    String shareUrl =
        await FirebaseRemoteConfig.instance.getString('rft_share_url');
    Share.share('$shareText $shareUrl');
    FirebaseProvider().logEvent('share_rft', {
      "text": shareText,
      "url": shareUrl,
    });
  }
}
