import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '/app/controllers/controller.dart';

class MyContactController extends Controller {
  construct(BuildContext context) {
    super.construct(context);
  }

  selectContact() {
    print("Select Contact");
  }

  createQRCode() {
    String vcfData = """BEGIN:VCARD
VERSION:3.0
N:Lastname;Firstname
FN:Firstname Lastname
ORG:CompanyName
TITLE:JobTitle
ADR:;;123 Sesame St;SomeCity;CA;12345;USA
TEL;WORK;VOICE:1234567890
TEL;CELL:Mobile
TEL;FAX:
EMAIL;WORK;INTERNET:foo@email.com
URL:http://website.com
END:VCARD""";
    const double size = 280.0;

    print(vcfData);

    return CustomPaint(
      size: const Size.square(size),
      painter: QrPainter(
        data: vcfData,
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
