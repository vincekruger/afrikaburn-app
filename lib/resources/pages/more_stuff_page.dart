import 'package:afrikaburn/app/controllers/sharing_controller.dart';
import 'package:afrikaburn/app/models/navigation_item.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:afrikaburn/resources/appbars/more_stuff_app_bar.dart';
import 'package:afrikaburn/resources/artworks/pointing_hand.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';
import 'package:afrikaburn/resources/pages/map_pdf_page.dart';
import 'package:afrikaburn/resources/pages/settings_page.dart';
import 'package:afrikaburn/resources/pages/wtf_guide_page.dart';
import 'package:afrikaburn/resources/themes/extensions/gradient_icon.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:afrikaburn/resources/widgets/ab_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class MoreStuffPage extends NyStatefulWidget {
  static const path = '/more-stuff';
  static const name = 'More Stuff Page';
  MoreStuffPage() : super(path, child: _MoreStuffPageState());
}

class _MoreStuffPageState extends NyState<MoreStuffPage> {
  @override
  init() async {}

  final List<NavigationItem> _items = [
    /// PDF Viewers
    NavigationItem(
      AB24Icons.file,
      "menu-item.wtf-guide-pdf".tr(),
      routeName: WtfGuidePage.path,
    ),
    NavigationItem(
      AB24Icons.file,
      "menu-item.map-pdf".tr(),
      routeName: MapPdfPage.path,
    ),

    /// Other stuff
    // NavigationItem(Icons.phonelink, "menu-item.my-contact".tr()),
    // NavigationItem(AB24Icons.map, "menu-item.map".tr()),
    // NavigationItem(AB24Icons.art, "menu-item.artwork".tr()),
    // NavigationItem(AB24Icons.theme_camp, "menu-item.theme-camps".tr()),
    // NavigationItem(AB24Icons.mutant_vehicle, "menu-item.mutant-vehicles".tr()),
    // NavigationItem(AB24Icons.heart, "menu-item.favorites".tr()),
    NavigationItem(
      AB24Icons.share,
      "menu-item.share-app".tr(),
      onTap: () => SharingController().shareApp(),
    ),
    NavigationItem(AB24Icons.support, "menu-item.support-app".tr()),
    NavigationItem(
      AB24Icons.settings,
      "menu-item.settings".tr(),
      routeName: SettingsPage.path,
      hideChevron: true,
    ),
  ];

  @override
  Widget view(BuildContext context) {
    final double appBarHeight = MediaQuery.of(context).viewPadding.top + 30.0;
    final double appBarHeightPadding = 40.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MoreStuffAppBar(
        title: "menu-item.more-stuff".tr(),
        height: appBarHeight,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: appBarHeight + appBarHeightPadding),
        child: ListView.separated(
          padding: EdgeInsets.only(bottom: 10),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];

            /// Add the pointing hand to the first item
            if (index == 0)
              return Column(children: [
                pointingHand(context),
                _navigationListTile(item),
              ]);

            /// render the list tile
            return _navigationListTile(item);
          },
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 0,
            ),
            child: AbDivider(width: double.infinity, height: 0.5),
          ),
        ),
      ),
    );
  }

  /// Render the trailing navigation item
  Widget? trailingNavigationItem(NavigationItem item) {
    /// There is a route, show the chevron right icon
    if (item.routeName != null && item.hideChevron == false)
      return Icon(AB24Icons.chevron_right, size: 20)
          .withGradeint(GradientStyles.appbarIcon);

    /// there is an onTap method, don't show anything
    if (item.onTap != null || item.hideChevron == true) return null;

    /// Return a coming soon text
    return Text("coming soon").bodySmall(context).setFontSize(08);
  }

  /// Rendered Navigation ListTile
  ListTile _navigationListTile(NavigationItem item) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      horizontalTitleGap: 28,
      visualDensity: VisualDensity.compact,
      leading:
          Icon(item.icon, size: 30).withGradeint(GradientStyles.appbarIcon),
      trailing: trailingNavigationItem(item),
      title: Text(item.label.toUpperCase()).titleMedium(context),
      subtitle: item.labelDetail != null
          ? Text(item.labelDetail!.toUpperCase()).bodyMedium(context).setColor(
              context, (color) => ThemeColor.get(context).primaryAlternate)
          : null,
      onTap: () {
        /// Route to Page
        if (item.routeName != null) return routeTo(item.routeName!);

        /// Run onTap Method
        if (item.onTap != null) item.onTap!();
      },
    );
  }
}
