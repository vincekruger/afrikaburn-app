import 'package:afrikaburn/app/models/file_size.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/resources/appbars/settings_app_bar.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';
import 'package:afrikaburn/resources/popups/confirm.dart';
import 'package:afrikaburn/resources/themes/extensions/gradient_icon.dart';
import 'package:afrikaburn/resources/themes/extensions/outlined_button.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:permission_handler/permission_handler.dart';
import '/app/controllers/settings_controller.dart';

class SettingsPage extends NyStatefulWidget<SettingsController> {
  static const path = '/settings';
  static const name = 'Settings';
  SettingsPage({super.key}) : super(path, child: _SettingsPageState());
}

class _SettingsPageState extends NyState<SettingsPage>
    with WidgetsBindingObserver {
  /// [SettingsController] controller
  SettingsController get controller => widget.controller;

  /// Initialize the page
  @override
  init() async {
    WidgetsBinding.instance.addObserver(this);
    await checkRequiredStuff();
  }

  /// Dippose
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Handle app lifecycle
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) return;
    await checkRequiredStuff();
  }

  @override
  stateUpdated(data) async {
    /// Started deleting ticket data
    if (data['action'] == "ticket-data-deleting")
      return setState(() {
        _deletingTicketdata = true;
      });

    /// Ticket data deleted, recheck sizes and stuff
    if (data['action'] == "ticket-data-deleted") {
      await widget.controller.calculateTicketDataSize();
      setState(() {
        _deletingTicketdata = false;
      });
      return;
    }

    /// no idea what to so just reload the page
    setState(() {});
  }

  /// This will check the required stuff like
  /// notification subscriptions and ticket data size
  Future<void> checkRequiredStuff() async {
    await widget.controller.checkNotificationSubscriptions();
    await widget.controller.checkPrivacySettings();
    await widget.controller.calculateTicketDataSize();
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: SettingsAppBar(
        height: 70,
        title: "settings.page-title".tr(),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
            .copyWith(top: 140),
        children: [
          ...notificationsSection(context),
          SizedBox(height: 20),
          ...localStorageSection(context),
          SizedBox(height: 20),
          ...privacySection(context),
        ],
      ),
    );
  }

  /// Notifications section
  List<Widget> notificationsSection(BuildContext context) {
    return [
      Text('settings.notifications.section-title'.tr())
          .titleLarge(context)
          .setColor(context, (color) => context.color.primaryContent),
      SizedBox(height: 20),

      /// Notifications denied
      if (!widget.controller.notificationsAllowed) notificationsDenied(),

      /// notifications allowed topc list
      if (widget.controller.notificationsAllowed) notificationTopicList(),
    ];
  }

  /// Notifications Denied
  Widget notificationsDenied() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("settings.notifications.notifications-disabled".tr())
            .bodyMedium(context)
            .setColor(context, (color) => context.color.primaryAccent),
        SizedBox(height: 12),

        /// Permanently denied
        if (widget.controller.notificationsPermanentlyDenied) ...[
          OutlinedButton(
            onPressed: openAppSettings,
            child:
                Text('settings.notifications.open-settings-button-label'.tr()),
          ).withGradient(
            strokeWidth: 2,
            gradient: GradientStyles.outlinedButtonBorder,
          ),
        ],

        /// Only just Denied
        if (!widget.controller.notificationsPermanentlyDenied) ...[
          OutlinedButton(
            onPressed: widget.controller.requestNotificationsPermission,
            child: Text(
                'settings.notifications.request-permission-button-label'.tr()),
          ).withGradient(
            strokeWidth: 2,
            gradient: GradientStyles.outlinedButtonBorder,
          ),
        ],

        SizedBox(height: 12),
      ],
    );
  }

  /// Notification Topic List
  Widget notificationTopicList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        notificationSetting(
          context,
          key: 'news',
          title: "News Updates",
          subTitle: "You’ll get a ping when there is exciting news",
          checked: widget.controller.notificationNewsUpdates,
        ),
        notificationSetting(
          context,
          key: 'burn',
          title: "Burn Updates",
          subTitle: "Dates, Themes, Decompression - burn 2025 🫶",
          checked: widget.controller.notificationBurnUpdates,
        ),
        notificationSetting(
          context,
          key: 'app',
          title: "App Updates",
          subTitle: "Now and then the app gets some cool new stuff.",
          checked: widget.controller.notificationAppUpdates,
        ),
      ],
    );
  }

  /// Notification setting
  Widget notificationSetting(
    BuildContext context, {
    required String key,
    required String title,
    required String subTitle,
    required bool checked,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          await controller.setNotification(key, !checked);
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              checked ? AB24Icons.checkbox_tick : AB24Icons.checkbox,
            ).withGradeint(GradientStyles.appbarIcon),
            SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title)
                    .bodyMedium(context)
                    .setColor(context, (color) => context.color.primaryContent),
                Text(subTitle).bodySmall(context).setColor(
                    context, (color) => context.color.primaryAlternate),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _deletingTicketdata = false;

  /// Local storage section
  List<Widget> localStorageSection(BuildContext context) {
    return [
      Text('settings.local-storage.section-title'.tr()).titleLarge(context),
      SizedBox(height: 20),
      storageItem(
        context,
        title: "settings.local-storage.tickets.title".tr(),
        description: "settings.local-storage.tickets.description".tr(),
        buttonLabel: "settings.local-storage.tickets.button-label".tr(),
        calculator: widget.controller.calculateTicketDataSize,
        loadingInidicator: _deletingTicketdata,
        onPressed: () async {
          bool? result = await confirmDialogBuilder(
            context,
            'settings.local-storage.tickets.delete-confirm',
          );

          // User cancelled
          if (result == null || !result) return;

          /// Set the loading indicator && Delete the ticket data
          await widget.controller.deleteTicketData();
        },
      ),
      // storageItem(
      //   context,
      //   title: "settings.local-storage.maps.title".tr(),
      //   description: "settings.local-storage.maps.description".tr(),
      //   buttonLabel: "settings.local-storage.maps.button-label".tr(),
      //   onPressed: () {},
      // ),
    ];
  }

  /// Privary section
  List<Widget> privacySection(BuildContext context) {
    return [
      Text('settings.privacy.section-title'.tr()).titleLarge(context),
      SizedBox(height: 20),
      InkWell(
        onTap: () => widget.controller
            .setPrivacySettings(!widget.controller.analyticsAllowed),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  widget.controller.analyticsAllowed
                      ? AB24Icons.checkbox_tick
                      : AB24Icons.checkbox,
                ).withGradeint(GradientStyles.appbarIcon),
                SizedBox(width: 12),
                Text("settings.privacy.analytics.title".tr())
                    .bodyMedium(context)
                    .setColor(context, (color) => context.color.primaryContent),
              ],
            ),
            SizedBox(height: 6),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(
                "settings.privacy.analytics.description".tr(),
                softWrap: true,
              )
                  .bodySmall(context)
                  .setColor(context, (color) => context.color.primaryAlternate),
            ),
          ],
        ),
      )
    ];
  }

  /// Storage item
  Widget storageItem(
    BuildContext context, {
    required String title,
    required String description,
    Future<FileSize> Function()? calculator,
    required String buttonLabel,
    required bool loadingInidicator,
    required void Function() onPressed,
  }) {
    return FutureBuilder(
      future: (calculator != null) ? calculator() : null,
      builder: (context, snapshot) {
        /// Default loading text
        bool buttonEnabled = false;
        String display = "settings.local-storage.space-calculating".tr();

        /// Display file size
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data!.bytes > 0) {
          buttonEnabled = true;
          display = "settings.local-storage.space-used".tr(arguments: {
            "size": snapshot.data!.display,
          });
        }

        /// Nothing stored
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data!.bytes < 1) {
          buttonEnabled = false;
          display = "settings.local-storage.nothing-stored".tr();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title).bodyMedium(context),
                  if (calculator != null) ...[
                    Text(display)
                        .bodySmall(context)
                        .setStyle(TextStyle(fontStyle: FontStyle.italic))
                        .setColor(
                            context, (color) => context.color.secondaryAccent),
                  ],
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0, bottom: 14.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(description, softWrap: true)
                      .bodySmall(context)
                      .setColor(
                          context, (color) => context.color.primaryAlternate),
                ),
              ),
              if (loadingInidicator) ...[
                Container(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(),
                ),
              ],
              if (!loadingInidicator) ...[
                Opacity(
                  opacity: buttonEnabled ? 1 : 0.3,
                  child: OutlinedButton(
                    onPressed: buttonEnabled ? onPressed : null,
                    child: Text(buttonLabel),
                  ).withGradient(
                      strokeWidth: 2,
                      gradient: GradientStyles.outlinedButtonBorder),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
