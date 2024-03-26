import 'dart:io';

import 'package:afrikaburn/resources/pages/my_contact_page.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vcf_dart/vcf_dart.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import '/app/controllers/controller.dart';

class MyContactController extends Controller {
  construct(BuildContext context) {
    super.construct(context);
  }

  /// Permission status for Photos
  Future<PermissionStatus> get getContactsPermission async {
    return await Permission.contacts.status;
  }

  /// Check contacts access permission
  checkContactPermission(BuildContext context) async {}

  /// Get the path to the VCF in the documents directory
  Future<String> getAssetPath() async {
    // Get the documents directory
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    // Create a folder for the ticket items
    return p.join(appDocumentsDir.path, 'contact.vcf');
  }

  /// Check if a vcf file already exists in the documents directory
  Future<bool> exists() async {
    final String assetPath = await getAssetPath();
    return File(assetPath).exists();
  }

  /// Remove Local VCF file
  Future<void> remove() async {
    final File file = File(await getAssetPath());

    // Delete the file if it esists and notify the state
    if (file.existsSync()) await file.delete();
    updateState(MyContactPage.path, data: {"vcfExists": false});
  }

  void selectContact() async {
    final FlutterContactPicker _contactPicker = new FlutterContactPicker();
    Contact? contact = await _contactPicker.selectContact().catchError((error) {
      print(error);
      return null;
    });
    print(contact);
  }

  String createVCard() {
    final stack = VCardStack();
    final builder = VCardItemBuilder()
      ..addProperty(
        const VCardProperty(
          name: VConstants.name,
          values: ['User', 'Test'],
        ),
      )
      ..addPropertyFromEntry(
        VConstants.formattedName,
        'Test User',
      )
      ..addProperty(VCardProperty(
        name: VConstants.phone,
        nameParameters: [
          VCardNameParameter(VConstants.nameParamType, VConstants.phoneTypeCell)
        ],
        values: ['+1234567890'],
      ))
      ..addProperty(VCardProperty(
        name: VConstants.email,
        nameParameters: [
          VCardNameParameter(VConstants.nameParamType, VConstants.phoneTypeHome)
        ],
        values: ['test@mail.com'],
      ));
    stack.items.add(builder.build());

    return stack.vcardStack;
  }

  /// Create a Contact QR Code image
  createQRCode() {
    const double size = 280.0;
    const Color qrColor = Color(0xff1a5441);

    return CustomPaint(
      size: const Size.square(size),
      painter: QrPainter(
        data: createVCard(),
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.circle,
          color: qrColor,
        ),
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.circle,
          color: qrColor,
        ),
        // size: 320.0,
      ),
    );
  }
}
