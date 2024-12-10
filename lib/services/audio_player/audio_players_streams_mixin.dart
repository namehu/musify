part of 'audio_player.dart';

mixin SpotubeAudioPlayersStreams on AudioPlayerInterface {
  // stream getters
  Stream<Duration> get durationStream {
    return mkPlayer.stream.duration;
  }

  Stream<Duration> get positionStream {
    return mkPlayer.stream.position;
  }

  Stream<Duration> get bufferedPositionStream {
    return mkPlayer.stream.buffer;
  }

  Stream<void> get completedStream {
    return mkPlayer.stream.completed;
  }

  /// Stream that emits when the player is almost (%) complete
  Stream<int> percentCompletedStream(double percent) {
    return positionStream
        .asyncMap(
          (position) async => duration == Duration.zero
              ? 0
              : (position.inSeconds / duration.inSeconds * 100).toInt(),
        )
        .where((event) => event >= percent);
  }

  Stream<bool> get playingStream {
    return mkPlayer.stream.playing;
  }

  Stream<bool> get shuffledStream {
    return mkPlayer.shuffleStream;
  }

  Stream<PlaylistMode> get loopModeStream {
    return mkPlayer.stream.playlistMode;
  }

  Stream<double> get volumeStream {
    return mkPlayer.stream.volume.map((event) => event / 100);
  }

  Stream<bool> get bufferingStream {
    return Stream.value(false);
  }

  Stream<AudioPlaybackState> get playerStateStream {
    return mkPlayer.playerStateStream;
  }

  Stream<int> get currentIndexChangedStream {
    return mkPlayer.indexChangeStream;
  }

  Stream<String> get activeSourceChangedStream {
    return mkPlayer.indexChangeStream
        .map((event) {
          return mkPlayer.state.playlist.medias.elementAtOrNull(event)?.uri;
        })
        .where((event) => event != null)
        .cast<String>();
  }

  Stream<List<mk.AudioDevice>> get devicesStream =>
      mkPlayer.stream.audioDevices.asBroadcastStream();

  Stream<mk.AudioDevice> get selectedDeviceStream =>
      mkPlayer.stream.audioDevice.asBroadcastStream();

  Stream<String> get errorStream => mkPlayer.stream.error;

  Stream<mk.Playlist> get playlistStream =>
      mkPlayer.stream.playlist.map((s) => s);
}
