import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;
import 'package:afrikaburn/app/controllers/controller.dart';
import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/resources/widgets/buy_ticket_widget.dart';
import 'package:afrikaburn/resources/widgets/ticket_slot_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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
  // bool get singleton => true;

  final TicketType _ticketType;
  TicketController(this._ticketType);

  /// Ticket item folder name
  static final String ticketPath = 'Tickets';
  static final String ticketThumbPath = 'tickets-thumbs';

  /// A pretty filename for the ticket item
  /// This can be seen in the system documents directory
  String get prettyFilename {
    switch (this._ticketType.name) {
      case "entry":
        return "Entry";
      case "wap":
        return "WAP";
      case "etoll":
        return "E-Toll";
      case "identification":
        return "Identification";
      default:
        throw Exception("Invalid Ticket Type");
    }
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
    // Get the documents paths
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final String assetFolder = p.join(appDocumentsDir.path, ticketPath);

    /// Put in a check for the old ticket path
    final String oldTicketPath = p.join(appDocumentsDir.path, 'tickets');
    if (Directory(oldTicketPath).existsSync()) {
      /// Android no peudo rename with existing files. :(
      if (Platform.isAndroid) {
        Directory(oldTicketPath).deleteSync(recursive: true);
        Directory(assetFolder).createSync();
      } else {
        Directory(oldTicketPath).renameSync(oldTicketPath + ".tmp");
        Directory(oldTicketPath + '.tmp').renameSync(assetFolder);
      }
    }

    // Create a folder for the ticket items
    if (!Directory(assetFolder).existsSync()) {
      Directory(assetFolder).createSync();
    }

    // Return the path to the ticket item
    return p.join(
      assetFolder,
      this.prettyFilename + (isPdf ? '.pdf' : '.png'),
    );
  }

  /// Get the ticket item file from the documents directory
  Future<File> getAssetFile({bool isPdf = false}) async {
    return File(await getAssetPath(isPdf: isPdf));
  }

  /// Get the ticket thubmanil directory
  static Future<Directory> getThumbsDirectory() async {
    /// Get the paths
    final Directory appLibraryDir = await ((Platform.isIOS)
        ? getLibraryDirectory()
        : getApplicationDocumentsDirectory());
    final Directory ticketThumbsDir =
        Directory(p.join(appLibraryDir.path, ticketThumbPath));

    /// Create the folder if it doesn't exist
    if (!ticketThumbsDir.existsSync()) {
      ticketThumbsDir.createSync(recursive: true);
    }

    return ticketThumbsDir;
  }

  /// Update the ticket item state
  Future<void> notifiyTicketSlot(bool exists, {bool isPdf = false}) async {
    updateState(BuyTicketContent.state, data: {"ticketExists": exists});
    updateState(stateKey(this._ticketType), data: {
      "exists": exists,
      "isPdf": isPdf,
      "assetPath": (await getAssetFile(isPdf: isPdf)).path,
      "thumbnailPath": (await getThumbnail()).path
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

  /// Save the selected image to the documents directory
  Future<bool> saveFile(XFile? file, {bool isPdf = false}) async {
    // Check if an image exists
    if (file == null) return false;

    /// Read the file
    final Uint8List bytes = await file.readAsBytes();

    // Save image to the documents directory
    final File ticketFile = await getAssetFile(isPdf: isPdf);
    await ticketFile.writeAsBytes(bytes);

    /// Create a thumbnail
    await saveThumbnail(bytes);

    // Check again if the file exists
    final bool exists = ticketFile.existsSync();

    // Update the satet of the ticket item and return the result
    notifiyTicketSlot(exists, isPdf: isPdf);
    return exists;
  }

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

    /// Save the file
    File pdf = File(result.files.first.path!);
    String pdfPath = await getAssetPath(isPdf: true);

    /// move to correct location & delete cached file
    pdf.copySync(pdfPath);
    pdf.deleteSync();

    /// Generate an image from the pdf
    final PDF = await PdfDocumentFactory.instance.openFile(pdfPath);
    final PdfImage? pdfImage = await PDF.pages.first.render();
    final ui.Image uiImage = await pdfImage!.createImage();
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = Uint8List.view(byteData!.buffer);

    /// Save thumbnail
    await saveThumbnail(bytes);

    /// Update the state
    notifiyTicketSlot(true, isPdf: true);
    return true;
  }

  /// Get the thumbnail path for the selected file
  Future<File> getThumbnail() async {
    final Directory thumbsDir = await getThumbsDirectory();
    return File(p.join(thumbsDir.path, this._ticketType.name + '-thumb.png'));
  }

  /// Save a thumbnail of the selected file
  Future<void> saveThumbnail(Uint8List bytes) async {
    final File thumbnail = await getThumbnail();
    final cmd = img.Command()
      // Decode the image file
      ..decodeImage(bytes)
      // Resize the image to a width of 64 pixels and a height that maintains the aspect ratio of the original.
      ..copyResize(width: 250)
      // Write the image to a PNG file (determined by the suffix of the file path).
      ..writeToFile(thumbnail.path);
    // On platforms that support Isolates, execute the image commands asynchronously on an isolate thread.
    // Otherwise, the commands will be executed synchronously.
    await cmd.executeThread();
  }

  /// Delete the thumbnail of the selected file
  Future<void> deleteThumbnail() async {
    /// Catching the error here because if the file doesn't delete or it's
    /// already gone it's ok. I don't really need to chuck and error here
    await (await getThumbnail()).delete();
  }

  /// Delete the ticket item file from the documents directory
  Future<void> deleteTicket(String _assetPath) async {
    /// Rmove the asset
    File(_assetPath).deleteSync();
    await deleteThumbnail();

    /// Update the ticket item state
    notifiyTicketSlot(false);

    /// Log the event
    FirebaseProvider().logEvent(
      'ticket_delete',
      {"ticket_type": this._ticketType.name},
    );
  }

  static Future<int> getDataSize() async {
    int totalSize = 0;

    /// Get the tickets directory in the documents directory
    final Directory documentsDir = Directory(
        p.join((await getApplicationDocumentsDirectory()).path, ticketPath));
    final Directory thumbnailsDir = await getThumbsDirectory();

    /// Tally documents directory
    if (documentsDir.existsSync()) {
      var files = await documentsDir.list(recursive: true).toList();
      var dirSize =
          files.fold(0, (int sum, file) => sum + file.statSync().size);
      totalSize = totalSize + dirSize;
    }

    /// Tally thumbnails directory
    if (thumbnailsDir.existsSync()) {
      var files = await thumbnailsDir.list(recursive: true).toList();
      var dirSize =
          files.fold(0, (int sum, file) => sum + file.statSync().size);
      totalSize = totalSize + dirSize;
    }

    return totalSize;
  }

  /// Delete all ticket item files from the documents directory
  static Future<void> clearAllTicketData() async {
    final Directory documentsDir = Directory(
        p.join((await getApplicationDocumentsDirectory()).path, ticketPath));
    final Directory thumbnailsDir = await getThumbsDirectory();

    /// If the folders don't exist, return
    if (!documentsDir.existsSync() && !thumbnailsDir.existsSync()) return;

    /// Delete all the files in the documents dirctory
    documentsDir.deleteSync(recursive: true);
    thumbnailsDir.deleteSync(recursive: true);

    /// Update the buy ticket content state
    updateState(BuyTicketContent.state, data: {"ticketExists": false});

    /// Update the ticket slots states
    TicketType.values.forEach((ticketType) {
      updateState(stateKey(ticketType), data: {
        "exists": false,
        "isPdf": false,
        "assetPath": '',
        "thumbnailPath": ''
      });
    });

    /// Log the event
    FirebaseProvider().logEvent('ticket_clear_all', {});
  }
}
