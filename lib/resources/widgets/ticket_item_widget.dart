import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/ticket.dart';
import 'package:flutter_app/bootstrap/extensions.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter_app/app/controllers/ticket_controller.dart';

/// Generate a state key
String stateKey(TicketType type) => "ticket_item:" + type.name;

class TicketItem extends StatefulWidget {
  TicketItem({
    Key? key,
    required TicketType this.type,
    required Function this.onTap,
  }) : super(key: key);

  final Function onTap;
  final TicketType type;
  static String state(TicketType type) => stateKey(type);

  final TicketController controller = new TicketController();

  @override
  createState() => _TicketItemState(type);
}

class _TicketItemState extends NyState<TicketItem> {
  _TicketItemState(TicketType type) {
    stateName = stateKey(type);
  }

  bool localFileExists = false;

  @override
  init() async {
    localFileExists = await widget.controller
        .exists(widget.type)
        .catchError((error) => false);
  }

  @override
  stateUpdated(dynamic data) async {
    // e.g. to update this state from another class
    // updateState(TicketItem.state, data: "example payload");

    print("${widget.type.name} State updated");
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("ticket-type.${widget.type.name}".tr()).bodyMedium(context),
      subtitle: Text("key: ${widget.type.name}")
          .bodySmall(context)
          .setColor(context, (color) => Colors.grey.shade500),
      leading: Icon(
        localFileExists ? Icons.check : Icons.close,
        color: localFileExists ? Colors.greenAccent : Colors.red,
        size: 16,
      ),
      trailing: Icon(
        localFileExists ? Icons.remove_red_eye : Icons.add,
        color: Colors.blue,
      ),
      onTap: () => widget.onTap(localFileExists, widget.type),
    );
  }
}
