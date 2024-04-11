import 'package:flutter/widgets.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/app/controllers/controller.dart';

enum SupporterType {
  SNAPSCAN,
  GITHUB,
  KOFI,
  PLAY_STORE,
  APPLE_STORE,
}

class SupportController extends Controller {
  @override
  construct(BuildContext context) {
    super.construct(context);
  }

  final String snapscanUrl =
      FirebaseRemoteConfig.instance.getString('snapscan_sponsor_url');
  final String githubUrl =
      FirebaseRemoteConfig.instance.getString('github_sponsor_url');
  final String kofiUrl =
      FirebaseRemoteConfig.instance.getString('kofi_sponsor_url');

  /// Open the sponsor URL
  Future<void> openSponsorUrl(SupporterType type) async {
    Uri url = Uri.parse(supportUrl(type));

    /// Launch the URL
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    /// Log Event
    FirebaseProvider().logEvent(
      'sponsor_url_opened',
      {'sponsor_url': url.toString()},
    );
  }

  /// Get the sponsor URL
  String supportUrl(SupporterType type) {
    switch (type) {
      case SupporterType.SNAPSCAN:
        return snapscanUrl;
      case SupporterType.GITHUB:
        return githubUrl;
      case SupporterType.KOFI:
        return kofiUrl;
      default:
        throw UnsupportedError('SupporterType $type is not supported');
    }
  }

  /// Get the support button image
  String supportButtonImage(BuildContext context, SupporterType type) {
    switch (type) {
      case SupporterType.SNAPSCAN:
        return context.isDarkMode
            ? "public/assets/images/support/support-snapscan-dark.png"
            : "public/assets/images/support/support-snapscan-light.png";
      case SupporterType.GITHUB:
        return context.isDarkMode
            ? "public/assets/images/support/support-github-dark.png"
            : "public/assets/images/support/support-github-light.png";
      case SupporterType.KOFI:
        return context.isDarkMode
            ? "public/assets/images/support/support-kofi-dark.png"
            : "public/assets/images/support/support-kofi-light.png";
      default:
        throw UnsupportedError('SupporterType $type is not supported');
    }
  }
}
