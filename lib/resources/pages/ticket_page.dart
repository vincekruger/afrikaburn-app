import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/resources/appbars/tickets_app_bar.dart';
import 'package:afrikaburn/resources/widgets/ab_divider_widget.dart';
import 'package:afrikaburn/app/models/ticket.dart';
import 'package:afrikaburn/app/controllers/ticket_controller.dart';
import 'package:afrikaburn/resources/widgets/ticket_slot_widget.dart';

class TicketPage extends NyStatefulWidget<TicketController> {
  static const path = '/ticket';

  TicketPage() : super(path, child: _TicketPageState());
}

class _TicketPageState extends NyState<TicketPage> {
  /// [TicketController] controller
  TicketController get controller => widget.controller;

  /// Use boot if you need to load data before the view is rendered.
  @override
  boot() async {
    FirebaseProvider().logScreenView(TicketPage.path);
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: TicketsAppBar(scale(144, context)),
      body: ListView(
        physics: ScrollPhysics(),
        padding: EdgeInsets.only(top: 16, bottom: 30),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 5),
                child: InkWell(
                  onTap: () {
                    // Navigator.pop(context);
                  },
                  child: TicketSlot(
                    type: TicketType.entry,
                    width: 176,
                    height: 215,
                    borderColor: Color(0xFF20EDC4),
                    labelWidth: 123,
                    labelHeight: 76,
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: scale(171, context),
                child: Image.asset(
                  'public/assets/images/tickets/tiger_1.png',
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
                  type: TicketType.identification,
                  width: 148,
                  height: 215,
                  borderColor: Color(0xFF9B1EE9),
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
                width: 146,
                padding: const EdgeInsets.only(top: 25.0),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TicketSlot(
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
                  type: TicketType.etoll,
                  width: 165,
                  height: 126,
                  borderColor: Color(0xFF000681),
                  iconSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
