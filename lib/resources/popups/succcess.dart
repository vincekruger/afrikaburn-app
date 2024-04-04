import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/resources/widgets/confirm_popup_widget.dart';

Future<void> successDialogBuilder(BuildContext context, String langPath) =>
    !Platform.isIOS
        ? showDialog<void>(
            context: context,
            builder: (BuildContext context) => ConfirmPopup(
              title: "$langPath.title".tr(),
              message: "$langPath.message".tr(),
              action: AlertAction(label: "$langPath.confirm".tr()),
            ),
          )
        : showCupertinoDialog<void>(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text("$langPath.title".tr()),
              content: Text("$langPath.message".tr()),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("$langPath.confirm".tr()).setColor(context,
                      (color) => context.color.cupertinoDialogActionColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
