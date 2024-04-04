import 'dart:io';

import 'package:afrikaburn/resources/popups/confirm.dart';
import 'package:afrikaburn/resources/popups/error.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:nylo_framework/nylo_framework.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:photo_view/photo_view.dart';
import 'package:afrikaburn/app/models/ticket_action_sheet_action.dart';
import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/app/providers/system_provider.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';

import 'package:afrikaburn/app/models/ticket.dart';
import 'package:afrikaburn/app/controllers/ticket_controller.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';

/// Generate a state key
String stateKey(TicketType type) => "ticket-slot:" + type.name;

/// Ticket Slot Widget
class TicketSlot extends StatefulWidget {
  TicketSlot({
    super.key,
    required this.controller,
    required this.type,
    required this.width,
    required this.height,
    required this.borderColor,
    this.iconSpacing = 8,
    this.quarterTurns = 0,
    this.labelWidth = 0,
    this.labelHeight = 0,
  });

  final TicketController controller;
  final TicketType type;
  final double width;
  final double height;
  final Color borderColor;
  final double iconSpacing;
  final int quarterTurns;
  final double? labelWidth;
  final double? labelHeight;

  /// State Key
  static String state(TicketType type) => stateKey(type);

  @override
  createState() => _TicketSlotState(type);
}

class _TicketSlotState extends NyState<TicketSlot> with WidgetsBindingObserver {
  _TicketSlotState(TicketType type) {
    stateName = stateKey(type);
  }

  /// Local state variables
  /// localExists: Check if the ticket item exists
  /// assetPath: The path to the ticket item
  bool localExists = false;
  bool isPdf = false;
  String assetPath = '';
  String _thumbnailPath = '';

  /// Initialize the state
  @override
  init() async {
    await widget.controller.exists();
    WidgetsBinding.instance.addObserver(this);
    return super.init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    /// Check the tickets folder again when the app resumes
    if (state == AppLifecycleState.resumed) await widget.controller.exists();
  }

  /// State Updated
  @override
  stateUpdated(dynamic data) async {
    setState(() {
      localExists = data['exists'];
      isPdf = data['isPdf'];
      assetPath = data['assetPath'];
      _thumbnailPath = data['thumbnailPath'];
    });
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
      /// Final background image
      slotBoxDecoration = slotBoxDecoration.copyWith(
        gradient: GradientStyles.ticketSlotGradient,
        image: DecorationImage(
          image: (Platform.isIOS)
              ? Image.asset(_thumbnailPath).image
              : Image.file(File(_thumbnailPath)).image,
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

  /// Render a Photo Viewer for Image Tickets
  Widget _photoViewer() {
    return PhotoView(
      minScale: PhotoViewComputedScale.contained * 0.8,
      backgroundDecoration: BoxDecoration(
        color: ThemeColor.get(context).surfaceBackground,
      ),
      imageProvider: (Platform.isIOS)
          ? AssetImage(assetPath)
          : Image.file(File(assetPath)).image,
    );
  }

  /// Render a PDF Viewer for PDF Tickets
  _pdfViewer() {
    return PdfViewer.file(assetPath);
  }

  /// View Ticket Item
  void viewTicket() {
    /// Set the orientation to portrait and landscape
    SystemProvider().setPortraitAndLandscapeOrientation();

    /// Show the photo view modal
    showBarModalBottomSheet(
      expand: false,
      context: this.context,
      builder: (context) => isPdf ? _pdfViewer() : _photoViewer(),
    ).then((value) {
      /// Reset the orientation to portrait
      SystemProvider().setOnlyPortraitOrientation();
    });

    /// Log the event
    FirebaseProvider().logEvent('ticket_view', {
      "ticket_type": widget.type.name,
      "ticket_format": isPdf ? "pdf" : "image",
    });
  }

  /// Add Ticket Item
  /// iOS and android have different ways of adding a ticket item.
  void addTicket() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        _showIOSActionSheet();
        break;
      default:
        _showMaterialActionSheet();
    }
  }

  /// Confirm Delete Action
  /// Show an alert dialog to confirm the delete action
  Future<void> confirmDelete() async {
    try {
      bool? result = await confirmDialogBuilder(
        context,
        "ticket-content.delete-confirm",
        title: "ticket-content.delete-confirm.title".tr(arguments: {
          "ticket_type": ticketLabel,
        }),
        isDestructive: true,
      );

      // User Cancelled the dialog
      if (result == null || !result) return;

      /// Delete the ticket item and close the dialog
      await widget.controller.deleteTicket(assetPath);
    } catch (e) {
      generalErrorDialogBuilder(context, 'ticket-content.delete-error');
      print('delete ticket error: $e.toString()');
    }
  }

  /// Get Available Action Sheet Actions
  List<TicketActionSheetAction> getActionSheetActions() => [
        TicketActionSheetAction(
          action: TicketActionSheetActionType.TAKE_PHOTO,
          title: "ticket-action.take-photo".tr(),
          icon: AB24Icons.camera,
        ),
        TicketActionSheetAction(
          action: TicketActionSheetActionType.CHOOSE_PHOTO,
          title: "ticket-action.choose-photo".tr(),
          icon: AB24Icons.photo,
        ),
        TicketActionSheetAction(
          action: TicketActionSheetActionType.SELECT_FILE,
          title: "ticket-action.select-file".tr(),
          icon: AB24Icons.file,
        ),
      ];

  /// Ticket Action On Tap
  void _ticketActionOnTap(TicketActionSheetActionType action) async {
    switch (action) {
      /// Open the camera to take a photo
      case TicketActionSheetActionType.TAKE_PHOTO:
        widget.controller.takePhoto().then((_) {
          /// Log the event
          FirebaseProvider().logEvent(
            'ticket_photo_taken',
            {"ticket_type": widget.type.name},
          );

          // Close the action sheet
          if (Navigator.canPop(context)) Navigator.pop(context);
        }).catchError((e) {
          // TODO Error Handling
          print("takePhoto error" + e.toString());
          return;
        });
        break;

      /// Open the gallery to choose a photo
      case TicketActionSheetActionType.CHOOSE_PHOTO:
        widget.controller.choosePhoto().then((_) {
          /// Log the event
          FirebaseProvider().logEvent(
            'ticket_photo_selected',
            {"ticket_type": widget.type.name},
          );

          // Close the action sheet
          if (Navigator.canPop(context)) Navigator.pop(context);
        }).catchError((e) {
          // TODO Error Handling
          print("choosePhoto" + e.toString());
          return;
        });
        break;

      /// Select a file from the phone
      case TicketActionSheetActionType.SELECT_FILE:
        widget.controller.selectFile().then((_) {
          /// Log the event
          FirebaseProvider().logEvent(
            'ticket_file_selected',
            {"ticket_type": widget.type.name},
          );

          // Close the action sheet
          if (Navigator.canPop(context)) Navigator.pop(context);
        }).catchError((e) {
          // TODO Error Handling
          print("choosePhoto" + e.toString());
          return;
        });
        break;
    }
  }

  /// Shows an iOS action sheet to ask what action is needed.
  /// https://api.flutter.dev/flutter/cupertino/CupertinoActionSheet-class.html
  void _showIOSActionSheet() {
    showCupertinoModalPopup<void>(
      context: this.context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: getActionSheetActions().map<Widget>((action) {
          return CupertinoActionSheetAction(
            child: Text(action.title).setColor(
                context, (color) => context.color.cupertinoDialogActionColor),
            onPressed: () => _ticketActionOnTap(action.action),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel').setColor(
              context, (color) => context.color.cupertinoDialogActionColor),
          onPressed: () =>
              (Navigator.canPop(context)) ? Navigator.pop(context) : null,
        ),
      ),
    );
  }

  /// Shows a material action sheet to ask what action is needed.
  /// https://jamesblasco.github.io/modal_bottom_sheet/#/
  void _showMaterialActionSheet() {
    showMaterialModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: ThemeColor.get(context).surfaceBackground,
      builder: (context) => Material(
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: getActionSheetActions().map<Widget>((action) {
              return ListTile(
                title: Text(action.title).titleSmall(context),
                leading: Icon(action.icon, size: 22),
                onTap: () => _ticketActionOnTap(action.action),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Build the widget
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
                        AB24Icons.plus_think,
                        size: 30,
                        color: ThemeColor.get(context).ticketSlotIcon,
                      ),
                    ),
                  if (!localExists)
                    Icon(
                      AB24Icons.plus_think,
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
                    AB24Icons.ticket_remove_entry,
                    size: 20,
                    color: ThemeColor.get(context).ticketSlotIcon,
                  ),
                  onPressed: confirmDelete,
                ),
              ),
          ],
        ),
      ),
      onTap: () => localExists ? viewTicket() : addTicket(),
    );
  }
}
