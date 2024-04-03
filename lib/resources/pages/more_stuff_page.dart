import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:afrikaburn/resources/appbars/custom_app_bar.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';
import 'package:afrikaburn/resources/pages/map_pdf_page.dart';
import 'package:afrikaburn/resources/pages/wtf_guide_page.dart';
import 'package:afrikaburn/resources/themes/extensions/gradient_icon.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:afrikaburn/resources/widgets/ab_divider_widget.dart';
import 'package:afrikaburn/resources/widgets/default_world_navigation_bar_widget.dart';
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

  /// Use boot if you need to load data before the [view] is rendered.
  // @override
  // boot() async {
  //
  // }

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
    NavigationItem(AB24Icons.rft, "menu-item.radio-free-tankwa".tr()),
    NavigationItem(Icons.phonelink, "menu-item.my-contact".tr()),
    NavigationItem(AB24Icons.map, "menu-item.map".tr()),
    NavigationItem(AB24Icons.art, "menu-item.artwork".tr()),
    NavigationItem(AB24Icons.theme_camp, "menu-item.theme-camps".tr()),
    NavigationItem(AB24Icons.mutant_vehicle, "menu-item.mutant-vehicles".tr()),
    NavigationItem(AB24Icons.heart, "menu-item.favorites".tr()),
    NavigationItem(AB24Icons.share, "menu-item.share-app".tr()),
    NavigationItem(AB24Icons.support, "menu-item.support-app".tr()),
    NavigationItem(AB24Icons.settings, "menu-item.settings".tr()),
  ];

  /// Pointing Hand Widget
  Widget _pointingHand(BuildContext context) => Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(left: 12, top: 20),
        child: Image.asset(
          context.isDarkMode
              ? "public/assets/images/pointing-hand-dark.png"
              : "public/assets/images/pointing-hand-light.png",
          width: 58,
        ),
      );

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "menu-item.more-stuff".tr(),
        height: 60,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.only(bottom: 40),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];

            /// Add the pointing hand to the first item
            if (index == 0)
              return Column(children: [
                _pointingHand(context),
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

  /// Rendered Navigation ListTile
  ListTile _navigationListTile(NavigationItem item) {
    var trailing = (item.routeName != null)
        ? Icon(
            AB24Icons.chevron_right,
            size: 20,
          ).withGradeint(GradientStyles.appbarIcon)
        : Text("coming soon").bodySmall(context).setFontSize(08);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      horizontalTitleGap: 28,
      visualDensity: VisualDensity.compact,
      leading:
          Icon(item.icon, size: 30).withGradeint(GradientStyles.appbarIcon),
      trailing: trailing,
      title: Text(item.label.toUpperCase()).titleMedium(context),
      subtitle: item.labelDetail != null
          ? Text(item.labelDetail!.toUpperCase()).bodyMedium(context).setColor(
              context, (color) => ThemeColor.get(context).primaryAlternate)
          : null,
      onTap: item.routeName == null
          ? null
          : () {
              routeTo(item.routeName!);
            },
    );
  }
}
