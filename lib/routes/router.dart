import 'package:afrikaburn/resources/pages/guide_map_2024_page.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/resources/pages/guide_map_2023_page.dart';
import 'package:afrikaburn/resources/pages/more_stuff_page.dart';
import 'package:afrikaburn/resources/pages/radio_free_tankwa_page.dart';
import 'package:afrikaburn/resources/pages/root.dart';
import 'package:afrikaburn/resources/pages/news_detail_page.dart';
import 'package:afrikaburn/resources/pages/news_page.dart';
import 'package:afrikaburn/resources/pages/ticket_page.dart';
import 'package:afrikaburn/resources/pages/map_page.dart';
import 'package:afrikaburn/resources/pages/guide_wtf_2023_page.dart';
import 'package:afrikaburn/resources/pages/guide_wtf_2024_page.dart';
import 'package:afrikaburn/resources/pages/support_page.dart';
import 'package:afrikaburn/resources/pages/settings_page.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
| Learn more https://nylo.dev/docs/5.20.0/router
|-------------------------------------------------------------------------- */

pdfRoute(NyRouter router, String path, NyRouteView view) => router.route(
      path,
      view,
      transition: PageTransitionType.bottomToTop,
      pageTransitionSettings: PageTransitionSettings(
        alignment: Alignment.bottomCenter,
        fullscreenDialog: true,
      ),
    );

appRouter() => nyRoutes((router) {
      router.route(
        RootPage.path,
        (context) => RootPage(),
        initialRoute: true,
      );

      /// News
      router.route(NewsPage.path, (context) => NewsPage());
      router.route(
        NewsDetailPage.path,
        (context) => NewsDetailPage(),
        transition: PageTransitionType.bottomToTop,
        pageTransitionSettings: PageTransitionSettings(
          alignment: Alignment.bottomCenter,
          fullscreenDialog: true,
        ),
      );

      /// Shared Pages
      router.route(
        TicketPage.path,
        (context) => TicketPage(),
      );
      router.route(
        RadioFreeTankwaPage.path,
        (context) => RadioFreeTankwaPage(),
      );
      router.route(
        MoreStuffPage.path,
        (context) => MoreStuffPage(),
      );

      // PDF Viewers
      pdfRoute(router, GuideWtf2023Page.path, (context) => GuideWtf2023Page());
      pdfRoute(router, GuideMap2023Page.path, (context) => GuideMap2023Page());
      pdfRoute(router, GuideWtf2024Page.path, (context) => GuideWtf2024Page());
      pdfRoute(router, GuideMap2024Page.path, (context) => GuideMap2024Page());

      /// On-Site Pages
      router.route(MapPage.path, (context) => MapPage());

      /// Other stuff
      router.route(
        SettingsPage.path,
        (context) => SettingsPage(),
        transition: PageTransitionType.bottomToTop,
        pageTransitionSettings: PageTransitionSettings(
          alignment: Alignment.bottomCenter,
          fullscreenDialog: true,
        ),
      );
      router.route(SupportPage.path, (context) => SupportPage());
    });
