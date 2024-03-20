import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter_app/app/models/ticket.dart';
import 'package:flutter_app/resources/widgets/ticket_item_widget.dart';
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
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Ticket".tr()),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                "Everything is stored local, so you don't have to worry about an internet connection."
                    .tr(),
              ).bodyMedium(context),
            ),
            Divider(color: Colors.grey.shade300),
            ListTile(
              title: Text("Photos Permission").bodySmall(context),
              trailing: NyFutureBuilder(
                future: widget.controller.getPhotosPermission,
                loading: Text("checking...").bodySmall(context),
                child: (context, snapshot) {
                  return Text(snapshot.toString().substring(17))
                      .bodySmall(context);
                },
              ),
            ),
            ListTile(
              title: Text("Camera Permission").bodySmall(context),
              trailing: NyFutureBuilder(
                future: widget.controller.getCameraPermission,
                loading: Text("checking...").bodySmall(context),
                child: (context, snapshot) {
                  return Text(snapshot.toString().substring(17))
                      .bodySmall(context);
                },
              ),
            ),
            Divider(color: Colors.grey.shade300),
            TicketItem(type: TicketType.entry, onTap: ticketItemTap),
            TicketItem(type: TicketType.wap, onTap: ticketItemTap),
            TicketItem(type: TicketType.etoll, onTap: ticketItemTap),
            TicketItem(type: TicketType.identification, onTap: ticketItemTap),
          ],
        ),
      ),
    );
  }

  void ticketItemTap(bool viewItem, TicketType type) {
    if (viewItem)
      viewTicketItem(type);
    else
      addTicketItem(type);
  }

  /// View Ticket Item
  /// Will show a modal with the picture that is stored.
  ///
  /// @param type [TicketType]
  void viewTicketItem(TicketType type) async {
    final bool exists = await widget.controller.exists(type);
    final String assetPath = await widget.controller.getAssetPath(type);
    if (!exists) throw ErrorDescription("Ticket item file does not exist");

    // TODO: Show the ticket item in a modal
    // TODO: Make modal height the same as the image, make it fit.
    // TODO: Turn up the screen brightness
    // TODO: Reset the screen brightness when closed

    Widget photoView = PhotoView(
      minScale: PhotoViewComputedScale.contained * 1,
      imageProvider: (Platform.isIOS)
          ? AssetImage(assetPath)
          : Image.file(File(assetPath)).image,
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
        _showMaterialActionSheet(type);
        break;
      case TargetPlatform.iOS:
        _showIOSActionSheet(type);
        break;
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  /// Shows a material action sheet to ask what action is needed.
  /// https://jamesblasco.github.io/modal_bottom_sheet/#/
  void _showMaterialActionSheet(TicketType type) {
    showMaterialModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Material(
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text("ticket-action.take-photo".tr()),
                leading: Icon(Icons.photo),
                onTap: () async {
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
              ListTile(
                title: Text("ticket-action.choose-photo".tr()),
                leading: Icon(Icons.photo_camera),
                onTap: () async {
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
        ),
      ),
    );
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
