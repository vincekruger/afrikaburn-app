import 'package:afrikaburn/app/providers/app_mode_provider.dart';
import 'package:nylo_framework/nylo_framework.dart';

class RemoteConfigUpdatesEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    Set<String>? updatedKeys = event?['updatedKeys'];
    if (updatedKeys == null) return;

    /// Last News Update
    // if (updatedKeys.contains('last_news_update')) {
    // updateState(NewsPage.path, data: {'udpate_news': true});
    // }

    if (updatedKeys.contains('guides_predownload_available')) {
      AppModeProvider.preDownloadGuides();
    }
  }
}