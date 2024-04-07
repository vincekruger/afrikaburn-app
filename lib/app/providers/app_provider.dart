import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/config/localization.dart';
import 'package:afrikaburn/config/decoders.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/config/theme.dart';
import 'package:afrikaburn/config/validation_rules.dart';

class AppProvider implements NyProvider {
  @override
  boot(Nylo nylo) async {
    await NyLocalization.instance.init(
      localeType: localeType,
      languageCode: languageCode,
      assetsDirectory: assetsDirectory,
    );

    nylo.addLoader(loader);
    nylo.addLogo(logo);
    nylo.addThemes(appThemes);
    nylo.addToastNotification(getToastNotificationWidget);
    nylo.addValidationRules(validationRules);
    nylo.addModelDecoders(modelDecoders);
    nylo.addControllers(controllers);
    nylo.addApiDecoders(apiDecoders);

    // Optional
    // nylo.showDateTimeInLogs(); // Show date time in logs
    // nylo.monitorAppUsage(); // Monitor the app usage

    return nylo;
  }

  @override
  afterBoot(Nylo nylo) async {}
}
