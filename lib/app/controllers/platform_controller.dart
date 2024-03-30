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
}
