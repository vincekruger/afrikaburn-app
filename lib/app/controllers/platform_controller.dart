import 'dart:io';

import 'package:afrikaburn/app/controllers/controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PlatformController extends Controller {
  /// Platform Channel
  static const platform = MethodChannel('io.wheresmyshit.afrikaburn/platform');

  /// Set this to true if you want to use a singleton controller
  @override
  bool get singleton => false;

  construct(BuildContext context) {
    super.construct(context);
  }

  Future<void> showIOSStatusBar() async {
    try {
      if (!Platform.isIOS) throw new UnimplementedError();
      await platform.invokeMethod<int>('showStatusBar');
      print('iOS status bar shown');
    } on PlatformException catch (e) {
      print("Failed to show iOS status bar: '${e.message}'.");
    }
  }

  Future<void> hideIOSStatusBar() async {
    try {
      if (!Platform.isIOS) throw new UnimplementedError();
      await platform.invokeMethod<int>('hideStatusBar');
      print('iOS status bar hidden');
    } on PlatformException catch (e) {
      print("Failed to hide iOS status bar: '${e.message}'.");
    }
  }
}
