import 'package:afrikaburn/app/controllers/ticket_controller.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:afrikaburn/resources/widgets/buy_ticket_widget.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/resources/appbars/tickets_app_bar.dart';
import 'package:afrikaburn/resources/widgets/ab_divider_widget.dart';
import 'package:afrikaburn/app/models/ticket.dart';
import 'package:afrikaburn/resources/widgets/ticket_slot_widget.dart';
import 'package:shake_detector/shake_detector.dart';

class TicketPage extends NyStatefulWidget {
  static const path = '/ticket';
  static const name = 'Ticket Page';
  TicketPage() : super(path, child: _TicketPageState());
}

class _TicketPageState extends NyState<TicketPage> {
  @override
  Widget view(BuildContext context) {
    return ShakeDetectWrap(
      enabled: false,
      minimumShakeCount: 10,
      onShake: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shake!')),
        );
      },
      child: Scaffold(
        body: ListView(
          physics: ScrollPhysics(),
          padding: EdgeInsets.only(top: 16, bottom: 30),
          children: [
            ...appBar(context),
            BuyTicketContent(),
            ...ticketSlots(context),
          ],
        ),
      ),
    );
  }

  /// App Bar Section
  List<Widget> appBar(BuildContext context) {
    return [
      TicketsAppBar(scale(130, context)),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AbDivider(
            width: scale(200, context),
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          ),
        ],
      ),
    ];
  }

  /// Ticket Slots Section
  List<Widget> ticketSlots(BuildContext context) {
    return [
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 5),
            child: TicketSlot(
              controller: new TicketController(TicketType.entry),
              type: TicketType.entry,
              width: 176,
              height: 215,
              borderColor: Color(0xFF20EDC4),
              labelWidth: 123,
              labelHeight: 76,
            ),
          ),
          Spacer(),
          Container(
            width: scale(171, context),
            child: Image.asset(
              context.isDarkMode
                  ? 'public/assets/images/tickets/tiger-dark.png'
                  : 'public/assets/images/tickets/tiger-light.png',
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
      SizedBox(height: 25),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 18.0),
        child: Row(
          children: [
            Container(
              width: scale(138, context),
              padding: EdgeInsets.only(right: 14),
              child: Text("ticket-content.available-offline".tr())
                  .bodyMedium(context)
                  .setColor(context,
                      (color) => ThemeColor.get(context).primaryContent),
            ),
            TicketSlot(
              controller: new TicketController(TicketType.identification),
              type: TicketType.identification,
              width: 148,
              height: 215,
              borderColor: Color(0xFF9B1EE9), // TODO use theme color
              labelWidth: 123,
              labelHeight: 76,
              quarterTurns: 1,
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AbDivider(
            width: scale(146, context),
            padding: const EdgeInsets.only(top: 25.0),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TicketSlot(
            controller: new TicketController(TicketType.wap),
            type: TicketType.wap,
            width: 165,
            height: 126,
            borderColor: Color(0xFFD1D346),
            iconSpacing: 2,
            quarterTurns: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 49.0),
            child: TicketSlot(
              controller: new TicketController(TicketType.etoll),
              type: TicketType.etoll,
              width: 165,
              height: 126,
              borderColor: Color(0xFF000681),
              iconSpacing: 2,
            ),
          ),
        ],
      ),
    ];
  }
}
