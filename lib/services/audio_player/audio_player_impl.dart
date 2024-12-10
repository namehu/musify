part of 'audio_player.dart';

late final MyAudioPlayer audioPlayer;

class MyAudioPlayer extends AudioPlayerInterface
    with SpotubeAudioPlayersStreams {
  Future<void> pause() async {
    await mkPlayer.pause();
  }

  Future<void> resume() async {
    await mkPlayer.play();
  }

  Future<void> stop() async {
    await mkPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await mkPlayer.seek(position);
  }

  /// Volume is between 0 and 1
  Future<void> setVolume(double volume) async {
    assert(volume >= 0 && volume <= 1);
    await mkPlayer.setVolume(volume * 100);
  }

  Future<void> setSpeed(double speed) async {
    await mkPlayer.setRate(speed);
  }

  Future<void> setAudioDevice(mk.AudioDevice device) async {
    await mkPlayer.setAudioDevice(device);
  }

  Future<void> dispose() async {
    await mkPlayer.dispose();
  }

  // Playlist related

  Future<void> openPlaylist(
    List<mk.Media> tracks, {
    bool autoPlay = true,
    int initialIndex = 0,
  }) async {
    assert(tracks.isNotEmpty);
    assert(initialIndex <= tracks.length - 1);
    await mkPlayer.open(
      mk.Playlist(tracks, index: initialIndex),
      play: autoPlay,
    );
  }

  List<String> get sources {
    return mkPlayer.state.playlist.medias.map((e) => e.uri).toList();
  }

  String? get currentSource {
    if (mkPlayer.state.playlist.index == -1) return null;
    return mkPlayer.state.playlist.medias
        .elementAtOrNull(mkPlayer.state.playlist.index)
        ?.uri;
  }

  String? get nextSource {
    if (loopMode == PlaylistMode.loop &&
        mkPlayer.state.playlist.index ==
            mkPlayer.state.playlist.medias.length - 1) {
      return sources.first;
    }

    return mkPlayer.state.playlist.medias
        .elementAtOrNull(mkPlayer.state.playlist.index + 1)
        ?.uri;
  }

  String? get previousSource {
    if (loopMode == PlaylistMode.loop && mkPlayer.state.playlist.index == 0) {
      return sources.last;
    }

    return mkPlayer.state.playlist.medias
        .elementAtOrNull(mkPlayer.state.playlist.index - 1)
        ?.uri;
  }

  int get currentIndex => mkPlayer.state.playlist.index;

  Future<void> skipToNext() async {
    await mkPlayer.next();
  }

  Future<void> skipToPrevious() async {
    await mkPlayer.previous();
  }

  Future<void> jumpTo(int index) async {
    await mkPlayer.jump(index);
  }

  Future<void> addTrack(mk.Media media) async {
    await mkPlayer.add(media);
  }

  Future<void> addTrackAt(mk.Media media, int index) async {
    await mkPlayer.insert(index, media);
  }

  Future<void> removeTrack(int index) async {
    await mkPlayer.remove(index);
  }

  Future<void> moveTrack(int from, int to) async {
    await mkPlayer.move(from, to);
  }

  Future<void> clearPlaylist() async {
    mkPlayer.stop();
  }

  Future<void> setShuffle(bool shuffle) async {
    await mkPlayer.setShuffle(shuffle);
  }

  Future<void> setLoopMode(PlaylistMode loop) async {
    await mkPlayer.setPlaylistMode(loop);
  }

  Future<void> setAudioNormalization(bool normalize) async {
    await mkPlayer.setAudioNormalization(normalize);
  }
}
