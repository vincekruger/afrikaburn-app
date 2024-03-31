import 'dart:io';
import 'dart:ui' as ui;

import 'package:afrikaburn/app/controllers/controller.dart';
import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/resources/widgets/ticket_slot_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/widgets.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:afrikaburn/app/models/ticket.dart';

class TicketController extends Controller {
  construct(BuildContext context) {
    super.construct(context);
  }

  /// Allow as a singleton
  bool get singleton => true;

  /// The Ticket Type
  late final TicketType _ticketType;

  /// Ticket item folder name
  final String ticketPath = 'tickets';

  /// Set the ticket type
  void set ticketType(TicketType type) {
    this._ticketType = type;
  }

  /// Permission status for Photos
  Future<PermissionStatus> get getPhotosPermission async {
    return await Permission.photos.status;
  }

  /// Permission status for Camera
  Future<PermissionStatus> get getCameraPermission async {
    return await Permission.camera.status;
  }

  /// Get the path to the ticket item in the documents directory
  Future<String> getAssetPath({bool isPdf = false}) async {
    // Get the documents directory
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    // Create a folder for the ticket items
    final String assetFolder = p.join(appDocumentsDir.path, ticketPath);
    if (!Directory(assetFolder).existsSync())
      Directory(assetFolder).createSync();

    // Return the path to the ticket item
    return p.join(
      assetFolder,
      this._ticketType.name + (isPdf ? '.pdf' : '.png'),
    );
  }

  /// Update the ticket item state
  Future<void> notifiyTicketSlot(bool exists, {bool isPdf = false}) async {
    updateState(stateKey(this._ticketType), data: {
      "exists": exists,
      "isPdf": isPdf,
      "assetPath": await getAssetPath(isPdf: isPdf),
    });
  }

  /// Check if a ticket item file exists in the documents directory
  Future<void> exists() async {
    /// Check if image exists
    final String imageAssetPath = await getAssetPath();
    final bool imageExists = File(imageAssetPath).existsSync();

    /// check if pdf exists
    final String pdfAssetPath = await getAssetPath(isPdf: true);
    final bool pdfExists = File(pdfAssetPath).existsSync();

    /// Update the ticket item state
    notifiyTicketSlot(imageExists || pdfExists, isPdf: pdfExists);
  }

  /// Initialize an ImagePicker instance
  final ImagePicker picker = ImagePicker();

  /// Open the photo gallery to select a photo
  /// and save it to the documents directory
  Future<bool> choosePhoto() => _launchImagePicker(ImageSource.gallery);

  /// Open the camera to take a photo
  /// and save it to the documents directory
  Future<bool> takePhoto() async => _launchImagePicker(ImageSource.camera);

  /// Launch the image picker
  Future<bool> _launchImagePicker(ImageSource imageSource) async {
    final XFile? image = await picker.pickImage(
      source: imageSource,
      requestFullMetadata: false,
    );

    return saveFile(image);
  }

  /// Select a File from the Phone
  Future<bool> selectFile() async {
    /// Open the file picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    /// Nothing was selected or pushed back
    if (result == null) return false;

    try {
      /// Save the file
      File pdf = File(result.files.first.path!);
      String pdfPath = await getAssetPath(isPdf: true);

      /// move to correct location & delete cached file
      pdf.copySync(pdfPath);
      pdf.deleteSync();

      /// Generate and image from the pdf
      final PDF = await PdfDocumentFactory.instance.openFile(pdfPath);
      final PdfImage? pdfImage = await PDF.pages.first.render();
      final ui.Image uiImage = await pdfImage!.createImage();
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List bytes = Uint8List.view(byteData!.buffer);
      File(pdfPath.replaceAll('.pdf', '-thumb.png')).writeAsBytesSync(bytes);

      /// Update the state
      notifiyTicketSlot(true, isPdf: true);
      return true;
    } catch (e) {
      // TODO Add some error handling here
      print(e);
      print("____FAILED____");

      return false;
    }
  }

  /// Save the selected image to the documents directory
  Future<bool> saveFile(XFile? file, {bool isPdf = false}) async {
    // Check if an image exists
    if (file == null) return false;

    // Save image to documents directory
    final String assetPath = await getAssetPath(isPdf: isPdf);
    await file.saveTo(assetPath).catchError((error) => print(error));

    // Check again if the file exists
    final bool exists = await File(assetPath).existsSync();

    // Update the satet of the ticket item and return the result
    notifiyTicketSlot(exists, isPdf: isPdf);
    return exists;
  }

  /// Delete the ticket item file from the documents directory
  void deleteTicket({bool isPdf = false}) async {
    try {
      /// Rmove the asset
      final String assetPath = await getAssetPath(isPdf: isPdf);
      File(assetPath).deleteSync();

      /// Update the ticket item state
      notifiyTicketSlot(false);

      /// Log the event
      FirebaseProvider().logEvent(
        'ticket_delete',
        {"ticket_type": this._ticketType.name},
      );
    } catch (e) {
      // TODO Add some error handling here
      print(e);
    }
  }

  /// Delete all ticket item files from the documents directory
  void clearAllTicketData() async {
    try {
      /// Get the tickets directory in the documents directory
      final Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();
      final String assetFolder = p.join(appDocumentsDir.path, ticketPath);

      /// Check if the ticket items folder exists
      if (!Directory(assetFolder).existsSync()) {
        print('Ticket items folder does not exist');
        return;
      }

      /// Delete the ticket item files
      Directory(assetFolder).deleteSync(recursive: true);

      /// Update all the ticket item states
      TicketType.values.forEach((type) => notifiyTicketSlot(false));

      /// Log the event
      FirebaseProvider().logEvent('ticket_clear_all', {});
    } catch (e) {
      // TODO Add some error handling here
      print(e);
    }
  }
}
