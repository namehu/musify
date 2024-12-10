import 'package:media_kit/media_kit.dart';
import 'package:musify/services/audio_player/playback_state.dart';
import 'package:musify/util/logger.dart';
import 'package:flutter/foundation.dart';
import 'custom_player.dart';
import 'dart:async';

import 'package:media_kit/media_kit.dart' as mk;

part 'audio_players_streams_mixin.dart';
part 'audio_player_impl.dart';

abstract class AudioPlayerInterface {
  final CustomPlayer mkPlayer;

  AudioPlayerInterface()
      : mkPlayer = CustomPlayer(
          configuration: const mk.PlayerConfiguration(
            title: "Musify",
            logLevel: kDebugMode ? mk.MPVLogLevel.info : mk.MPVLogLevel.error,
          ),
        ) {
    mkPlayer.stream.error.listen((event) {
      AppLogger.reportError(event, StackTrace.current);
    });
  }

  /// Whether the current platform supports the audioplayers plugin
  static const bool _mkSupportedPlatform = true;

  bool get mkSupportedPlatform => _mkSupportedPlatform;

  Duration get duration {
    return mkPlayer.state.duration;
  }

  Playlist get playlist {
    return mkPlayer.state.playlist;
  }

  Duration get position {
    return mkPlayer.state.position;
  }

  Duration get bufferedPosition {
    return mkPlayer.state.buffer;
  }

  Future<mk.AudioDevice> get selectedDevice async {
    return mkPlayer.state.audioDevice;
  }

  Future<List<mk.AudioDevice>> get devices async {
    return mkPlayer.state.audioDevices;
  }

  bool get hasSource {
    return mkPlayer.state.playlist.medias.isNotEmpty;
  }

  // states
  bool get isPlaying {
    return mkPlayer.state.playing;
  }

  bool get isPaused {
    return !mkPlayer.state.playing;
  }

  bool get isStopped {
    return !hasSource;
  }

  Future<bool> get isCompleted async {
    return mkPlayer.state.completed;
  }

  bool get isShuffled {
    return mkPlayer.shuffled;
  }

  PlaylistMode get loopMode {
    return mkPlayer.state.playlistMode;
  }

  /// Returns the current volume of the player, between 0 and 1
  double get volume {
    return mkPlayer.state.volume / 100;
  }

  bool get isBuffering {
    return mkPlayer.state.buffering;
  }
}
