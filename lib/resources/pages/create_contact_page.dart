import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/create_contact_controller.dart';

class CreateContactPage extends NyStatefulWidget<CreateContactController> {
  static const path = '/create-contact';

  CreateContactPage() : super(path, child: _CreateContactPageState());
}

class _CreateContactPageState extends NyState<CreateContactPage> {

  /// [CreateContactController] controller
  CreateContactController get controller => widget.controller;

  @override
  init() async {

  }
  
  /// Use boot if you need to load data before the view is rendered.
  // @override
  // boot() async {
  //
  // }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Contact")
      ),
      body: SafeArea(
         child: Container(),
      ),
    );
  }
}
