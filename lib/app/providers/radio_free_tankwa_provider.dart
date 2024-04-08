import 'package:just_audio_background/just_audio_background.dart';
import 'package:nylo_framework/nylo_framework.dart';

class RadioFreeTankwaProvider implements NyProvider {
  boot(Nylo nylo) async {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'io.wheresmyshit.afrikaburn.channel.audio',
      androidNotificationChannelName: 'Radio Free Tankwa',
      androidNotificationOngoing: true,
    );

    return nylo;
  }

  afterBoot(Nylo nylo) async {}
}
