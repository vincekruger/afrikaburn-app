import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter_app/app/models/ticket.dart';
import 'package:flutter_app/bootstrap/extensions.dart';
import 'package:flutter_app/config/design.dart';
import 'package:flutter_app/resources/widgets/ab_divider_widget.dart';
import 'package:flutter_app/resources/widgets/app_bars/tickets_app_bar.dart';
import 'package:flutter_app/resources/widgets/ticket_item_widget.dart';
import 'package:flutter_app/resources/widgets/ticket_slot_widget.dart';
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
      appBar: TicketsAppBar(scale(144, context)),
      body: ListView(
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
                  child: Text("Everything is stored locally, so you" +
                          " don’t have to worry about an" +
                          " internet connection.")
                      .bodyMedium(context)
                      .setColor(context, (color) => Color(0xFF333333)),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: TicketSlot(
                    type: TicketType.identification,
                    width: 148,
                    height: 215,
                    labelWidth: 123,
                    labelHeight: 76,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AbDivider(
                width: 146,
                padding: const EdgeInsets.symmetric(vertical: 25.0),
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
                iconSpacing: 2,
              ),
              TicketSlot(
                type: TicketType.etoll,
                width: 165,
                height: 126,
                iconSpacing: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  ListView listView(BuildContext context) {
    return ListView(
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
              return Text(snapshot.toString().substring(17)).bodySmall(context);
            },
          ),
        ),
        ListTile(
          title: Text("Camera Permission").bodySmall(context),
          trailing: NyFutureBuilder(
            future: widget.controller.getCameraPermission,
            loading: Text("checking...").bodySmall(context),
            child: (context, snapshot) {
              return Text(snapshot.toString().substring(17)).bodySmall(context);
            },
          ),
        ),
        Divider(color: Colors.grey.shade300),
        TicketItem(type: TicketType.entry, onTap: ticketItemTap),
        TicketItem(type: TicketType.wap, onTap: ticketItemTap),
        TicketItem(type: TicketType.etoll, onTap: ticketItemTap),
        TicketItem(type: TicketType.identification, onTap: ticketItemTap),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Divider(color: Colors.grey.shade300),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.delete, size: 18, color: Colors.white),
              label: Text('Remove Ticket Data'.tr())
                  .bodySmall(context)
                  .fontWeightBold()
                  .setColor(context, (color) => Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
              ),
              onPressed: () {
                widget.controller.clearAllTicketData();
                setState(() {});
              },
            ),
          ],
        )
      ],
    );
  }

  /// Ticket Item Tap Handler
  /// Will either view or add a ticket item.
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
      backgroundDecoration: BoxDecoration(color: Colors.white),
      imageProvider: (Platform.isIOS)
          ? AssetImage(assetPath)
          : Image.file(File(assetPath)).image,
    );

    // Widget modalContent = Material(
    //   child: SafeArea(
    //     top: false,
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             TextButton(
    //               child: Text('Close'),
    //               onPressed: () {},
    //             ),
    //             Text("ticket-type.${type.name}".tr())
    //                 .setColor(context, (color) => Colors.black),
    //             TextButton(
    //               child: Text('Delete'),
    //               onPressed: () {},
    //             )
    //           ],
    //         ),
    //         Container(
    //           margin: const EdgeInsets.symmetric(
    //             vertical: 20.0,
    //             horizontal: 20.0,
    //           ),
    //           height: 200.0,
    //           child: ClipRect(
    //             child: photoView,
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );

    showBarModalBottomSheet(
      expand: false,
      context: this.context,
      backgroundColor: Colors.transparent,
      builder: (context) => photoView,
    );
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
