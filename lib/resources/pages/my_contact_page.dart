import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/my_contact_controller.dart';

class MyContactPage extends NyStatefulWidget<MyContactController> {
  static const path = '/my-contact';

  MyContactPage() : super(path, child: _MyContactPageState());
}

class _MyContactPageState extends NyState<MyContactPage> {
  /// [MyContactController] controller
  MyContactController get controller => widget.controller;

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Contact")),
      body: SafeArea(
        child: ListView(
          children: [
            Text("My Contact"),
            ElevatedButton(
              child: const Text('Check permission'),
              onPressed: () =>
                  {widget.controller.checkContactPermission(context)},
            ),
            ElevatedButton(
              child: Text("Select Contact"),
              onPressed: () => {widget.controller.selectContact()},
            ),
            widget.controller.createQRCode(),
          ],
        ),
      ),
    );
  }
}