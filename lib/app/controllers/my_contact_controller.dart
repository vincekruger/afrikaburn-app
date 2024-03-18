import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vcf_dart/vcf_dart.dart';
import '/app/controllers/controller.dart';

class MyContactController extends Controller {
  construct(BuildContext context) {
    super.construct(context);
  }

  checkContactPermission(BuildContext context) async {}

  selectContact() async {
    final FlutterContactPicker _contactPicker = new FlutterContactPicker();
    Contact? contact = await _contactPicker.selectContact();
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

  createQRCode() {
    const double size = 280.0;

    String vcfData = createVCard();
    print(vcfData);

    return CustomPaint(
      size: const Size.square(size),
      painter: QrPainter(
        data: createVCard(),
        version: QrVersions.auto,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Color(0xff128760),
        ),
        // size: 320.0,
      ),
    );
  }
}
