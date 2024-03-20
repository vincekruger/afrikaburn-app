import 'package:flutter/material.dart';
import 'package:flutter_app/bootstrap/extensions.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/my_contact_controller.dart';

class MyContactPage extends NyStatefulWidget<MyContactController> {
  static const path = '/my-contact';

  MyContactPage() : super(path, child: _MyContactPageState());
}

class _MyContactPageState extends NyState<MyContactPage> {
  /// [MyContactController] controller
  MyContactController get controller => widget.controller;

  late bool vcfExists;
  late String contactPermission;

  @override
  init() async {
    vcfExists = await widget.controller.exists().catchError((error) => false);
    contactPermission = (await widget.controller.getContactsPermission)
        .toString()
        .substring(17);
  }

  @override
  stateUpdated(data) {
    if (data.containsKey("vcfExists")) {
      vcfExists = data["vcfExists"];
    }

    // reload page state
    setState(() {});
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Contact".tr()),
      ),
      body: SafeArea(
        child: ListView(
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
              title: Text("Contacts Permission").bodySmall(context),
              trailing: Text(contactPermission).bodySmall(context),
            ),
            Divider(color: Colors.grey.shade300),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('Select Contact')
                        .bodySmall(context)
                        .fontWeightBold()
                        .setColor(context, (color) => Colors.white),
                    onPressed: widget.controller.selectContact,
                  ),
                  ElevatedButton(
                    child: Text('Enter Manually')
                        .bodySmall(context)
                        .fontWeightBold()
                        .setColor(context, (color) => Colors.white),
                    onPressed: null,
                  ),
                ],
              ),
            ),
            if (vcfExists) ...[
              Divider(color: Colors.grey.shade300),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 26),
                alignment: Alignment.center,
                child: widget.controller.createQRCode(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.delete, size: 18, color: Colors.white),
                    label: Text('Remove My Data')
                        .bodySmall(context)
                        .fontWeightBold()
                        .setColor(context, (color) => Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                    ),
                    onPressed: widget.controller.remove,
                  )
                ],
              )
            ],
          ],
        ),
      ),
    );
  }
}
