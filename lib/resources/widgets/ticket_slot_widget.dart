import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/ticket.dart';
import 'package:flutter_app/bootstrap/extensions.dart';
import 'package:flutter_app/config/design.dart';
import 'package:flutter_app/resources/icons/a_b2024_icons.dart';
import 'package:nylo_framework/nylo_framework.dart';

class TicketSlot extends StatefulWidget {
  TicketSlot({
    Key? key,
    required TicketType this.type,
    required double this.width,
    required double this.height,
    double this.iconSpacing = 10,
    double this.labelWidth = 0,
    double this.labelHeight = 0,
  }) : super(key: key);

  final TicketType type;
  final double width;
  final double height;
  final double iconSpacing;
  final double? labelWidth;
  final double? labelHeight;

  static String state = "ticket_slot";

  @override
  createState() => _TicketSlotState();
}

class _TicketSlotState extends NyState<TicketSlot> {
  _TicketSlotState() {
    stateName = TicketSlot.state;
  }

  @override
  init() async {}

  @override
  stateUpdated(dynamic data) async {
    // e.g. to update this state from another class
    // updateState(TicketSlot.state, data: "example payload");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: scale(widget.width, context),
      height: scale(widget.height, context),
      decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextLabelContainer(),
          SizedBox(height: widget.iconSpacing),
          Icon(
            AB2024.ticket_add_entry,
            size: 30,
            color: Color(0xFF000681),
          )
        ],
      ),
    );
  }

  /// The Text Label
  /// The TextLabel is the name of the ticket type
  /// The TextLabel is styled with the Staatliches font
  Text TextLabel() => Text("ticket-type.${widget.type.name}".tr())
      .alignCenter()
      .titleLarge(this.context)
      .setFontFamily('Staatliches')
      .setColor(context, (color) => Color(0xFF000681));

  /// The Text Label Container
  /// If the labelWidth and labelHeight are not specified,
  /// the TextLabel will be displayed without a container
  /// otherwise, the TextLabel will be displayed within a container
  Widget TextLabelContainer() {
    /// No Text Label Container size specified
    if (widget.labelHeight == 0 || widget.labelWidth == 0) return TextLabel();

    /// Text Label Container size specified
    return SizedBox(
      width: scale(widget.labelWidth!, context),
      height: scale(widget.labelHeight!, context),
      child: TextLabel(),
    );
  }
}
