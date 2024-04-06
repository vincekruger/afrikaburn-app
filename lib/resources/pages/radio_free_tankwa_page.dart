import 'package:afrikaburn/app/controllers/sharing_controller.dart';
import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/resources/appbars/rft_app_bar.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';
import 'package:afrikaburn/resources/themes/extensions/gradient_icon.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/radio_free_tankwa_controller.dart';

class RadioFreeTankwaPage extends NyStatefulWidget<RadioFreeTankwaController> {
  static const path = '/radio-free-tankwa';
  static const name = 'Radio Free Tankwa';
  RadioFreeTankwaPage() : super(path, child: _RadioFreeTankwaPageState());
}

class _RadioFreeTankwaPageState extends NyState<RadioFreeTankwaPage> {
  /// [RadioFreeTankwaController] controller
  RadioFreeTankwaController get controller => widget.controller;
  SharingController sharingController = SharingController();

  // @override
  init() async {}

  /// Use boot if you need to load data before the view is rendered.
  @override
  boot() async {
    widget.controller.setupListeners();
    await widget.controller.configureSource();
  }

  @override
  stateUpdated(dynamic data) async {
    print(data);
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: RFTAppBar(100),
      body: Stack(
        children: [
          Positioned(
            top: 30,
            right: 0,
            child: Container(
              width: scale(376, context),
              height: scale(572, context),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage("public/assets/images/rft/background-eye.png"),
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.topRight,
                ),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -10,
            child: Container(
              width: scale(359, context),
              child: Image.asset(context.isDarkMode
                  ? "public/assets/images/rft/tower-light.png"
                  : "public/assets/images/rft/tower-light.png"),
            ),
          ),
          Positioned(
            top: 400,
            right: 60,
            child: Transform(
              transform: Matrix4.identity()
                ..translate(0.0, 0.0)
                ..rotateZ(-0.05),
              child: Container(
                width: scale(150, context),
                child: Text(
                  "rft-content.page-blurb".tr(),
                  softWrap: true,
                )
                    .titleLarge(context)
                    .setColor(context, (color) => context.color.thirdAccent),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(right: 24, bottom: 30, left: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            AB24Icons.share,
                            size: 30,
                          ).withGradeint(GradientStyles.appbarIcon),
                          highlightColor: Colors.transparent,
                          onPressed: sharingController.shareRadioFreeTankwa,
                        ),
                        // IconButton(
                        //   icon: Icon(
                        //     AB24Icons.heart,
                        //     size: 30,
                        //   ).withGradeint(GradientStyles.appbarIcon),
                        //   highlightColor: Colors.transparent,
                        //   onPressed: () {
                        //     // TODO - Show a popover one day
                        //   },
                        // ),
                      ],
                    ),
                    playerControls(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<PlayerState> playerControls() {
    return StreamBuilder<PlayerState>(
      stream: widget.controller.player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final ProcessingState? processingState = playerState?.processingState;
        final bool playing = playerState?.playing ?? false;

        /// Show a loader
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(18.0),
            width: 30.0,
            height: 30.0,
            child: Center(child: const CircularProgressIndicator()),
          );
        }

        /// Show the Play/Pause button
        return IconButton(
          icon: Icon(
            playing ? AB24Icons.pause : AB24Icons.play,
            size: 50,
          ).withGradeint(GradientStyles.appbarIcon),
          highlightColor: Colors.transparent,
          onPressed: () {
            if (playing) {
              /// Stop the player
              widget.controller.player.stop();

              /// Log firebase event
              FirebaseProvider().logEvent('rft_player_stop', {});
            } else {
              /// Start the player
              widget.controller.player.play();

              /// Log firebase event
              FirebaseProvider().logEvent('rft_player_play', {});
            }
          },
        );
      },
    );
  }
}
