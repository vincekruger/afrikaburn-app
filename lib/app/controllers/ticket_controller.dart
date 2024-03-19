import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:flutter_app/app/models/ticket.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

class TicketController extends Controller {
  construct(BuildContext context) {
    super.construct(context);
  }

  Future<PermissionStatus> get getPhotosPermission async {
    return await Permission.photos.status;
  }

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

  final String ticketPath = 'tickets';

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
    // TODO NEED TO ASK FOR PERMISSION

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
    return File(assetPath).exists();
  }

  deleteTicket() async {}
}
