import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/resources/widgets/confirm_popup_widget.dart';

/// General Error
Future<void> generalErrorDialogBuilder(BuildContext context, String langPath) =>
    !Platform.isIOS
        ? showDialog<void>(
            context: context,
            builder: (BuildContext context) => ConfirmPopup(
              title: "$langPath.title".tr(),
              message: "$langPath.message".tr(),
              action: AlertAction(
                label: "$langPath.confirm".tr(),
              ),
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

/// Settings Error - Open Notification Settings
Future<void> notifcationSettingsErrorDialogBuilder(
  BuildContext context,
  String langPath,
) =>
    settingsErrorDialogBuilder(context, langPath, AppSettingsType.notification);

/// Settings Error - Builder
Future<void> settingsErrorDialogBuilder(
  BuildContext context,
  String langPath,
  AppSettingsType location,
) =>
    !Platform.isIOS
        ? showDialog<void>(
            context: context,
            builder: (BuildContext context) => ConfirmPopup(
              title: "$langPath.title".tr(),
              message: "$langPath.message".tr(),
              actions: [
                AlertAction(
                  label: "$langPath.confirm".tr(),
                ),
                AlertAction(
                  label: "$langPath.open-settings".tr(),
                  onPressed: () {
                    Navigator.of(context).pop();
                    AppSettings.openAppSettings(type: location);
                  },
                ),
              ],
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
                CupertinoDialogAction(
                  child: Text("$langPath.open-settings".tr()).setColor(context,
                      (color) => context.color.cupertinoDialogActionColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                    AppSettings.openAppSettings(type: location);
                  },
                ),
              ],
            ),
          );
