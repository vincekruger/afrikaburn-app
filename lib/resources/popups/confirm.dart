import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/resources/widgets/confirm_popup_widget.dart';

Future<bool?> confirmDialogBuilder(BuildContext context, String langPath) =>
    !Platform.isIOS
        ? showDialog<bool>(
            context: context,
            builder: (BuildContext context) => ConfirmPopup(
              title: "$langPath.title".tr(),
              message: "$langPath.message".tr(),
              actions: [
                AlertAction(
                  label: "$langPath.cancel".tr(),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                AlertAction(
                  label: "$langPath.confirm".tr(),
                  onPressed: () => Navigator.of(context).pop(true),
                )
              ],
            ),
          )
        : showCupertinoDialog<bool>(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text("$langPath.title".tr()),
              content: Text("$langPath.message".tr()),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("$langPath.cancel".tr()).setColor(context,
                      (color) => context.color.cupertinoDialogActionColor),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text("$langPath.confirm".tr()),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          );
