import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter_app/app/models/ticket.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:photo_view/photo_view.dart';
import '/app/controllers/ticket_controller.dart';

class TicketPage extends NyStatefulWidget<TicketController> {
  static const path = '/ticket';

  TicketPage() : super(path, child: _TicketPageState());
}

class _TicketPageState extends NyState<TicketPage> {
  /// [TicketController] controller
  TicketController get controller => widget.controller;

  @override
  init() async {}

  /// Use boot if you need to load data before the view is rendered.
  // @override
  // boot() async {
  //
  // }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ticket")),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                "Everything is stored local, so you don't have to worry about an internet connection.",
              ).bodyMedium(context),
            ),
            Divider(color: Colors.grey.shade300),
            ListTile(
              title: Text("Photos Permission").bodySmall(context),
              trailing: NyFutureBuilder(
                future: widget.controller.getPhotosPermission,
                loading: Text("checking...").bodySmall(context),
                child: (context, snapshot) {
                  return Text(snapshot.toString()).bodySmall(context);
                },
              ),
            ),
            ListTile(
              title: Text("Camera Permission").bodySmall(context),
              trailing: NyFutureBuilder(
                future: widget.controller.getCameraPermission,
                loading: Text("checking...").bodySmall(context),
                child: (context, snapshot) {
                  return Text(snapshot.toString()).bodySmall(context);
                },
              ),
            ),
            Divider(color: Colors.grey.shade300),
            ticketItem(TicketType.entry),
            ticketItem(TicketType.wap),
            ticketItem(TicketType.etoll),
            ticketItem(TicketType.identification),
          ],
        ),
      ),
    );
  }

  String ticketTypeTitle(TicketType type) {
    switch (type) {
      case TicketType.entry:
        return "Entry Ticket".tr();
      case TicketType.wap:
        return "WAP".tr();
      case TicketType.etoll:
        return "E-TOLL".tr();
      case TicketType.identification:
        return "Identification".tr();
    }
  }

  Widget ticketItem(TicketType type) {
    return NyFutureBuilder(
      future: widget.controller.exists(type),
      child: (context, snapshot) {
        bool exists = snapshot ?? false;

        return ListTile(
          title: Text(ticketTypeTitle(type)).bodyMedium(context),
          leading: Icon(
            exists ? Icons.check : Icons.close,
            color: exists ? Colors.greenAccent : Colors.red,
            size: 16,
          ),
          trailing: Icon(
            exists ? Icons.remove_red_eye : Icons.add,
            color: Colors.blue,
          ),
          // onTap: widget.controller.chooseImage,
          onTap: () {
            if (exists)
              viewTicketItem(type);
            else
              addTicketItem(type);
          },
        );
      },
    );
  }

  /// View Ticket Item
  /// Will show a modal with the picture that is stored.
  ///
  /// @param type [TicketType]
  void viewTicketItem(TicketType type) async {
    final String assetPath = await widget.controller.getAssetPath(type);

    // TODO: Show the ticket item in a modal
    // TODO: Make modal height the same as the image, make it fit.
    // TODO: Turn up the screen brightness
    // TODO: Reset the screen brightness when closed

    Widget photoView = PhotoView(
      minScale: PhotoViewComputedScale.contained * 1,
      imageProvider: AssetImage(assetPath),
    );

    showBarModalBottomSheet(
      expand: true,
      context: this.context,
      backgroundColor: Colors.transparent,
      builder: (context) => photoView,
    );

    // showCupertinoModalBottomSheet(
    //   expand: false,
    //   context: this.context,
    //   backgroundColor: Colors.transparent,
    //   builder: (context) => Container(
    //     child: photoView,
    //   ),
    // );
  }

  /// Add Ticket Item
  /// iOS and android have different ways of adding a ticket item.
  ///
  /// @param type [TicketType]
  void addTicketItem(TicketType type) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError('Unsupported platform');
      case TargetPlatform.iOS:
        _showIOSActionSheet(type);
        break;
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  /// Shows an iOS action sheet to ask what action is needed.
  /// https://api.flutter.dev/flutter/cupertino/CupertinoActionSheet-class.html
  void _showIOSActionSheet(TicketType type) {
    showCupertinoModalPopup<void>(
      context: this.context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text("ticket-action.take-photo".tr()),
            onPressed: () async {
              /// Open the camera to take a photo
              await widget.controller.takePhoto(type).catchError((e) {
                // TODO Error Handling
                print(e);
                return false;
              });

              // Close the action sheet
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text("ticket-action.choose-photo".tr()),
            onPressed: () async {
              /// Open the gallery to choose a photo
              await widget.controller.choosePhoto(type).catchError((e) {
                // TODO Error Handling
                print(e);
                return false;
              });

              // Close the action sheet
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
