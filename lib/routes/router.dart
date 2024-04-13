import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/resources/pages/map_pdf_page.dart';
import 'package:afrikaburn/resources/pages/more_stuff_page.dart';
import 'package:afrikaburn/resources/pages/radio_free_tankwa_page.dart';
import 'package:afrikaburn/resources/pages/root.dart';
import 'package:afrikaburn/resources/pages/news_detail_page.dart';
import 'package:afrikaburn/resources/pages/news_page.dart';
import 'package:afrikaburn/resources/pages/create_contact_page.dart';
import 'package:afrikaburn/resources/pages/ticket_page.dart';
import 'package:afrikaburn/resources/pages/map_page.dart';
import 'package:afrikaburn/resources/pages/my_contact_page.dart';
import 'package:afrikaburn/resources/pages/wtf_guide_page.dart';
import 'package:afrikaburn/resources/pages/support_page.dart';
import 'package:afrikaburn/resources/pages/settings_page.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
| Learn more https://nylo.dev/docs/5.20.0/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
      router.route(
        RootPage.path,
        (context) => RootPage(),
        initialRoute: true,
      );

      /// Default World Pages
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
      router.route(TicketPage.path, (context) => TicketPage());
      router.route(MyContactPage.path, (context) => MyContactPage());
      router.route(CreateContactPage.path, (context) => CreateContactPage());
      router.route(
          RadioFreeTankwaPage.path, (context) => RadioFreeTankwaPage());
      router.route(MoreStuffPage.path, (context) => MoreStuffPage());

      // PDF Viewers
      router.route(
        WtfGuidePage.path,
        (context) => WtfGuidePage(),
        transition: PageTransitionType.bottomToTop,
        pageTransitionSettings: PageTransitionSettings(
          alignment: Alignment.bottomCenter,
          fullscreenDialog: true,
        ),
      );
      router.route(
        MapPdfPage.path,
        (context) => MapPdfPage(),
        transition: PageTransitionType.bottomToTop,
        pageTransitionSettings: PageTransitionSettings(
          alignment: Alignment.bottomCenter,
          fullscreenDialog: true,
        ),
      );

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
