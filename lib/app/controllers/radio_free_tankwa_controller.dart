import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '/config/storage_keys.dart';
import '/app/controllers/controller.dart';

class RadioFreeTankwaController extends Controller {
  construct(BuildContext context) {
    super.construct(context);
  }

  /// Singleton Factory
  final _player = AudioPlayer();

  /// Get the player
  AudioPlayer get player => _player;

  /// Get the album artwork.
  Future<Uri> getAlbumArt() async {
    List<dynamic> artworks = await FirebaseRemoteConfig.instance
        .getString('rft_album_art')
        .parseJson();
    int artworkIndex = Random().nextInt(artworks.length);
    return Uri.parse(artworks[artworkIndex]);
  }

  /// Store the state of the player in storage for the whole app to use
  Future<void> updatePlayerStorageState() async {
    await StorageKey.radioFreeTankwasPlaying.store(_player.playing);
  }

  /// Setup Play Listerners
  void setupListeners() {
    // Listen for errors during playback.
    // _player.playbackEventStream.listen((event) {
    //   /// not sure if I need to do something here
    // }, onError: (Object e, StackTrace stackTrace) {
    //   print('A stream error occurred: $e');
    // });

    /// Save the player state to local storage
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.idle ||
          state.processingState == ProcessingState.ready) {
        updatePlayerStorageState();
      }
    });
  }

  /// Configure the audio source
  Future<void> configureSource() async {
    /// Configure the audio session type
    final session = await AudioSession.instance;
    session.configure(AudioSessionConfiguration.music());

    /// Get the stream url && album art
    Uri streamUrl = Uri.parse(
        await FirebaseRemoteConfig.instance.getString("rft_stream_url"));
    Uri albumArt = await getAlbumArt();

    /// Create the audio source
    AudioSource _audioSource = AudioSource.uri(
      streamUrl,
      tag: MediaItem(
        id: 'rft-stream',
        title: "Radio Free Tankwa",
        artUri: albumArt,
      ),
    );

    /// Set the audio source
    await _player.setAudioSource(_audioSource, preload: false);
  }
}
