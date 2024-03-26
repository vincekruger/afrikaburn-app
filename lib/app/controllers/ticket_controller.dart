import 'dart:io';

import 'package:afrikaburn/app/controllers/controller.dart';
import 'package:afrikaburn/resources/widgets/ticket_slot_widget.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/widgets.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:afrikaburn/app/models/ticket.dart';

class TicketController extends Controller {
  construct(BuildContext context) {
    super.construct(context);
  }

  /// Allow as a singleton
  bool get singleton => true;

  /// Ticket item folder name
  final String ticketPath = 'tickets';

  /// Permission status for Photos
  Future<PermissionStatus> get getPhotosPermission async {
    return await Permission.photos.status;
  }

  /// Permission status for Camera
  Future<PermissionStatus> get getCameraPermission async {
    return await Permission.camera.status;
  }

  /// Get the path to the ticket item in the documents directory
  Future<String> getAssetPath(TicketType type) async {
    // Get the documents directory
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    // Create a folder for the ticket items
    final String assetFolder = p.join(appDocumentsDir.path, ticketPath);
    if (!Directory(assetFolder).existsSync()) {
      Directory(assetFolder).createSync();
    }

    // Return the path to the ticket item
    return p.join(assetFolder, type.name + '.png');
  }

  /// Check if a ticket item file exists in the documents directory
  Future<bool> exists(TicketType type) async {
    final String assetPath = await getAssetPath(type);
    return File(assetPath).exists();
  }

  /// Initialize an ImagePicker instance
  final ImagePicker picker = ImagePicker();

  /// Open the photo gallery to select a photo
  /// and save it to the documents directory
  Future<bool> choosePhoto(TicketType type) async {
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery, requestFullMetadata: false);
    return saveFile(image, type);
  }

  /// Open the camera to take a photo
  /// and save it to the documents directory
  Future<bool> takePhoto(TicketType type) async {
    final XFile? image = await picker.pickImage(
        source: ImageSource.camera, requestFullMetadata: false);
    return saveFile(image, type);
  }

  /// Save the selected image to the documents directory
  Future<bool> saveFile(XFile? image, TicketType type) async {
    // Check if an image exists
    if (image == null) throw ErrorDescription("No image selected");

    // Save image to documents directory
    final String assetPath = await getAssetPath(type);
    await image.saveTo(assetPath).catchError((error) => print(error));

    // Check again if the file exists
    final bool exists = await File(assetPath).exists();

    // Update the satet of the ticket item and return the result
    updateState(stateKey(type), data: exists);
    return exists;
  }

  /// Delete the ticket item file from the documents directory
  deleteTicket(TicketType type) async {
    /// Rmove the asset
    final String assetPath = await getAssetPath(type);
    File(assetPath).deleteSync();

    /// Update the ticket item state
    updateState(stateKey(type), data: false);
  }

  /// Delete all ticket item files from the documents directory
  clearAllTicketData() async {
    /// Get the tickets directory in the documents directory
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final String assetFolder = p.join(appDocumentsDir.path, ticketPath);

    /// Check if the ticket items folder exists
    if (!Directory(assetFolder).existsSync()) {
      print('Ticket items folder does not exist');
      return;
    }

    /// Delete the ticket item files
    Directory(assetFolder).deleteSync(recursive: true);

    /// Update all the ticket item states
    TicketType.values.forEach((type) {
      updateState(stateKey(type), data: false);
    });
  }
}
