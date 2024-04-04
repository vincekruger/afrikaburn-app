import '/app/controllers/radio_free_tankwa_controller.dart';
import 'package:afrikaburn/app/controllers/platform_controller.dart';

import '/app/models/news_tag.dart';
import '/app/models/news_category.dart';
import '/app/controllers/news_detail_controller.dart';
import '/app/controllers/news_controller.dart';
import '/app/controllers/create_contact_controller.dart';
import '/app/controllers/ticket_controller.dart';
import '/app/controllers/map_controller.dart';
import '/app/controllers/my_contact_controller.dart';
import '/app/controllers/wtf_guide_controller.dart';
import '/app/controllers/home_controller.dart';
import '/app/models/user.dart';
import '/app/networking/api_service.dart';

/* Model Decoders
|--------------------------------------------------------------------------
| Model decoders are used in 'app/networking/' for morphing json payloads
| into Models.
|
| Learn more https://nylo.dev/docs/5.20.0/decoders#model-decoders
|-------------------------------------------------------------------------- */

final Map<Type, dynamic> modelDecoders = {
  List<User>: (data) =>
      List.from(data).map((json) => User.fromJson(json)).toList(),
  //
  User: (data) => User.fromJson(data),

  // User: (data) => User.fromJson(data),

  List<NewsCategory>: (data) =>
      List.from(data).map((json) => NewsCategory.fromJson(json)).toList(),

  NewsCategory: (data) => NewsCategory.fromJson(data),

  List<NewsTag>: (data) =>
      List.from(data).map((json) => NewsTag.fromJson(json)).toList(),

  NewsTag: (data) => NewsTag.fromJson(data),
};

/* API Decoders
| -------------------------------------------------------------------------
| API decoders are used when you need to access an API service using the
| 'api' helper. E.g. api<MyApiService>((request) => request.fetchData());
|
| Learn more https://nylo.dev/docs/5.20.0/decoders#api-decoders
|-------------------------------------------------------------------------- */

final Map<Type, dynamic> apiDecoders = {
  ApiService: () => ApiService(),

  // ...
};

/* Controller Decoders
| -------------------------------------------------------------------------
| Controller are used in pages.
|
| Learn more https://nylo.dev/docs/5.20.0/controllers
|-------------------------------------------------------------------------- */
final Map<Type, dynamic> controllers = {
  HomeController: () => HomeController(),

  // ...

  WtfGuideController: () => WtfGuideController(),

  MyContactController: () => MyContactController(),

  MapController: () => MapController(),

  // TicketController: () => TicketController(),

  CreateContactController: () => CreateContactController(),

  NewsController: () => NewsController(),

  NewsDetailController: () => NewsDetailController(),

  PlatformController: () => PlatformController(),

  RadioFreeTankwaController: () => RadioFreeTankwaController(),
};
