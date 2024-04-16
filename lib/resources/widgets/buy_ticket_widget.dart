import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/app/controllers/ticket_controller.dart';
import 'package:afrikaburn/resources/artworks/pointing_hand.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';
import 'package:afrikaburn/resources/themes/extensions/outlined_button.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:afrikaburn/resources/widgets/ab_divider_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyTicketContent extends StatefulWidget {
  BuyTicketContent({Key? key}) : super(key: key);
  static String state = "buy_ticket";

  @override
  createState() => _BuyTicketContentState();
}

class _BuyTicketContentState extends NyState<BuyTicketContent>
    with WidgetsBindingObserver {
  _BuyTicketContentState() {
    stateName = BuyTicketContent.state;
  }

  /// Check if tickets exist in the tickets folder
  Future<void> screenTicketsFolder() async {
    // Get the documents directory
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final String assetFolder =
        p.join(appDocumentsDir.path, TicketController.ticketPath);
    final Directory dir = Directory(assetFolder);

    /// Check if there are any files
    setState(() {
      _ticketsExist = dir.existsSync() && dir.listSync().length > 0;
    });
  }

  Future<void> openTicketPage() async {
    final String ticketUrl =
        FirebaseRemoteConfig.instance.getString("tickets_url");

    /// Check if the ticket url is not empty
    if (ticketUrl.isEmpty) {
      FirebaseCrashlytics.instance.log("Ticket URL is empty");
      return;
    }

    /// Open the ticket page
    await launchUrl(Uri.parse(ticketUrl), mode: LaunchMode.externalApplication);
  }

  /// if tickets exist
  bool _ticketsExist = false;

  /// Initialize the state
  @override
  init() async {
    await screenTicketsFolder();
    WidgetsBinding.instance.addObserver(this);
    return super.init();
  }

  /// Dispose the state
  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Update the state
  @override
  stateUpdated(dynamic data) async {
    await screenTicketsFolder();
  }

  @override
  Widget build(BuildContext context) {
    /// If tickets exist, don't show this content
    if (_ticketsExist == true) return Container();

    /// No tickets exist, show the buy tickets content
    return Column(
      children: [
        Container(
          height: 180,
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  width: 240,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("ticket-content.buy.got-your-ticket".tr())
                          .titleLarge(context)
                          .alignLeft(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 6.0,
                          right: 30,
                        ),
                        child: Text("ticket-content.buy.save-the-planet".tr())
                            .bodySmall(context)
                            .alignLeft(),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 50,
                top: -14,
                child: pointingHand(context, width: scale(60, context)),
              ),
              Positioned(
                top: 105,
                left: 27,
                child: Image.asset(
                  context.isDarkMode
                      ? "public/assets/images/heart-hands-dark.png"
                      : "public/assets/images/heart-hands-light.png",
                  width: scale(96, context),
                ),
              ),
              Positioned(
                top: 90,
                right: 20,
                child: Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  width: scale(239, context),
                  child: Text("ticket-content.buy.no-ticket".tr())
                      .titleSmall(context)
                      .alignRight(),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(AB24Icons.ticket, size: 16),
                  SizedBox(width: 10),
                  Text("ticket-action.buy-ticket".tr().toUpperCase()),
                ],
              ),
              onPressed: openTicketPage,
            ).withGradient(
              strokeWidth: 2,
              gradient: GradientStyles.outlinedButtonBorder,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AbDivider(
              width: scale(200, context),
              padding: const EdgeInsets.only(top: 25.0),
            ),
          ],
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
