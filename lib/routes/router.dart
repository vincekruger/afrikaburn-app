import '/resources/pages/create_contact_page.dart';
import '/resources/pages/ticket_page.dart';
import '/resources/pages/map_page.dart';
import '/resources/pages/my_contact_page.dart';
import '/resources/pages/wtf_guide_page.dart';
import '/resources/pages/home_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
| Learn more https://nylo.dev/docs/5.20.0/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
      router.route(HomePage.path, (context) => HomePage(), initialRoute: true);
      router.route(WtfGuidePage.path, (context) => WtfGuidePage());
     router.route(MyContactPage.path, (context) => MyContactPage());
 router.route(MapPage.path, (context) => MapPage());
 router.route(TicketPage.path, (context) => TicketPage());
 router.route(CreateContactPage.path, (context) => CreateContactPage());
});
