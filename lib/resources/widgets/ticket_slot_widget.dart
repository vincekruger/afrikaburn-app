import 'dart:io';

import 'package:afrikaburn/app/providers/system_provider.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/models/ticket.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/resources/icons/a_b2024_icons.dart';
import 'package:afrikaburn/app/controllers/ticket_controller.dart';
import 'package:photo_view/photo_view.dart';

/// Generate a state key
String stateKey(TicketType type) => "ticket-slot:" + type.name;

class TicketSlot extends StatefulWidget {
  TicketSlot({
    Key? key,
    required TicketType this.type,
    required double this.width,
    required double this.height,
    required Color this.borderColor,
    double this.iconSpacing = 8,
    int this.quarterTurns = 0,
    double this.labelWidth = 0,
    double this.labelHeight = 0,
  }) : super(key: key);

  final TicketType type;
  final double width;
  final double height;
  final Color borderColor;
  final double iconSpacing;
  final int quarterTurns;
  final double? labelWidth;
  final double? labelHeight;

  final TicketController controller = new TicketController();
  static String state(TicketType type) => stateKey(type);

  @override
  createState() => _TicketSlotState(type);
}

class _TicketSlotState extends NyState<TicketSlot> {
  _TicketSlotState(TicketType type) {
    stateName = stateKey(type);
  }

  /// Local state variables
  /// localExists: Check if the ticket item exists
  /// assetPath: The path to the ticket item
  bool localExists = false;
  String assetPath = '';

  /// Initialize the state
  @override
  init() async {
    localExists = await widget.controller
        .exists(widget.type)
        .catchError((error) => false);
    assetPath = await widget.controller.getAssetPath(widget.type);
  }

  /// State Updated
  @override
  stateUpdated(dynamic data) async {
    setState(() {
      localExists = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: RotatedBox(
        quarterTurns: widget.quarterTurns,
        child: Stack(
          children: [
            Container(
              width: scale(widget.width, context),
              height: scale(widget.height, context),
              decoration: slotDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextLabelContainer(),
                  SizedBox(height: widget.iconSpacing),
                  if (localExists)
                    Padding(
                      padding: const EdgeInsets.only(right: 14.0),
                      child: Icon(
                        AB2024.ticket_view_entry,
                        size: 30,
                        color: ThemeColor.get(context).ticketSlotIcon,
                      ),
                    ),
                  if (!localExists)
                    Icon(
                      AB2024.ticket_add_entry_2,
                      size: 30,
                      color: ThemeColor.get(context).ticketSlotIcon,
                    ),
                ],
              ),
            ),
            if (localExists)
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(
                    AB2024.ticket_remove_entry,
                    size: 20,
                    color: ThemeColor.get(context).ticketSlotIcon,
                  ),
                  onPressed: confirmDelete,
                ),
              ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  /// Configure the slot decoration
  /// The slot decoration is a container that wraps the ticket slot
  /// There is a gradient background if the ticket item exists
  BoxDecoration slotDecoration() {
    BoxDecoration slotBoxDecoration = BoxDecoration(
      color: ThemeColor.get(context).ticketSlotBackground,
      border: Border.all(color: widget.borderColor, width: 1),
    );

    // Ticket item exists
    if (localExists) {
      slotBoxDecoration = slotBoxDecoration.copyWith(
        gradient: GradientStyles.ticketSlotGradient,
        image: DecorationImage(
          image: Image.asset(assetPath).image,
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      );
    }

    return slotBoxDecoration;
  }

  /// Translated Ticket Label
  String get ticketLabel => "ticket-type.${widget.type.name}".tr();

  /// The Text Label
  /// The TextLabel is the name of the ticket type
  /// The TextLabel is styled with the Staatliches font
  Text TextLabel() => Text(ticketLabel)
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

  /// On Tap Handler for the slot ink well
  void onTap() {
    if (localExists)
      viewTicket();
    else
      addTicket();
  }

  /// View Ticket Item
  viewTicket() {
    SystemProvider().setPortraitAndLandscapeOrientation();

    /// Show the photo view modal
    showBarModalBottomSheet(
      expand: false,
      context: this.context,
      builder: (context) => PhotoView(
        minScale: PhotoViewComputedScale.contained * 0.8,
        backgroundDecoration: BoxDecoration(
          color: ThemeColor.get(context).surfaceBackground,
        ),
        imageProvider: (Platform.isIOS)
            ? AssetImage(assetPath)
            : Image.file(File(assetPath)).image,
      ),
    ).then((value) {
      /// Reset the orientation to portrait
      SystemProvider().setOnlyPortraitOrientation();
    });
  }

  /// Add Ticket Item
  /// iOS and android have different ways of adding a ticket item.
  void addTicket() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        print("Add ${widget.type.name} Ticket for Android");
        // _showMaterialActionSheet(type);
        break;
      case TargetPlatform.iOS:
        _showIOSActionSheet();
        break;
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  /// Confirm Delete Action
  /// Show an alert dialog to confirm the delete action
  void confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("😱 Delete ${ticketLabel}?")
              .headingSmall(context)
              .fontWeightBold(),
          content: Text(
              "Are you sure you wanna do this because it will be gone off your phone foreva."),
          actions: [
            TextButton(
              child: Text("Ja, Delete it!")
                  .setColor(context, (color) => Colors.red.shade600)
                  .fontWeightBold(),
              onPressed: () {
                widget.controller.deleteTicket(widget.type);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Oops No!").fontWeightBold(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows an iOS action sheet to ask what action is needed.
  /// https://api.flutter.dev/flutter/cupertino/CupertinoActionSheet-class.html
  void _showIOSActionSheet() {
    showCupertinoModalPopup<void>(
      context: this.context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text("ticket-action.take-photo".tr()),
            onPressed: () async {
              /// Open the camera to take a photo
              await widget.controller.takePhoto(widget.type).catchError((e) {
                // TODO Error Handling
                print("takePhoto error" + e.toString());
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
              await widget.controller.choosePhoto(widget.type).catchError((e) {
                // TODO Error Handling
                print("choosePhoto" + e.toString());
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
