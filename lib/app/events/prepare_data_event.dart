import 'package:afrikaburn/app/models/guide.dart';
import 'package:afrikaburn/app/providers/guide_download_provider.dart';
import 'package:nylo_framework/nylo_framework.dart';

class PrepareEventDataEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    Guide wtfGuide = Guide(GuideType.WTF, 2024, protected: true);
    Guide mapGuide = Guide(GuideType.MAP, 2024, protected: true);

    GuideDownloadProvider wtfProvider =
        GuideDownloadProvider.instance(wtfGuide);
    if (!await wtfProvider.existsLocal()) wtfProvider.downloadGuide('nil');

    GuideDownloadProvider mapProvider =
        GuideDownloadProvider.instance(mapGuide);
    if (!await mapProvider.existsLocal()) mapProvider.downloadGuide('nil');
  }
}
