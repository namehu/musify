import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:musify/api/subsonic/utils.dart';
import 'package:musify/services/audio_player_service.dart';

import '../models/songs.dart';

class AudioPlayerHandler extends BaseAudioHandler
    with
        QueueHandler, // mix in default queue callback implementations
        SeekHandler {
  // mix in default seek callback implementations

  final _player = Get.find<AudioPlayerService>().player;

  AudioPlayerHandler() {
    // _notifyAudioHandlerAboutPlayListEvents();
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  // The most common callbacks:
  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) => _player.jump(index);

  @override
  Future<void> skipToNext() async {
    return _player.next();
  }

  @override
  Future<void> skipToPrevious() async {
    return _player.previous();
  }

  /// Handling new queue items in AudioHandler
  _notifyAudioHandlerAboutPlayListEvents() {
    _player.stream.playlist.listen((Playlist event) {
      if (event.medias.isEmpty) {
        queue.add([]);
      } else {
        var mediaItems = event.medias.map((el) {
          Songs song = el.extras!['mediaItem'];
          return MediaItem(
            // Specify a unique ID for each media item:
            id: song.id,
            // Metadata to display in the notification:
            album: song.album,
            title: song.title,
            artUri: Uri.parse(getCoverArt(song.id)),
            artist: song.artist,
            genre: song.genre,
            duration: Duration(milliseconds: song.duration.toInt()),
          );
        }).toList();
        // queue.add(mediaItems);
        addQueueItems(mediaItems);
      }
    });
  }

  /// Passing on events in AudioHandler
  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.stream.playing.listen(
      (playing) async {
        AudioProcessingState processingState = AudioProcessingState.idle;
        if (_player.state.buffering) {
          processingState = AudioProcessingState.buffering;
        }

        if (_player.state.completed) {
          processingState = AudioProcessingState.completed;
        }

        if (playing) {
          processingState = AudioProcessingState.ready;
        } else if (_player.state.duration > Duration.zero) {
          processingState = AudioProcessingState.ready;
        }

        playbackState.add(playbackState.value.copyWith(
          controls: [
            MediaControl.skipToPrevious,
            if (playing) MediaControl.pause else MediaControl.play,
            MediaControl.stop,
            MediaControl.skipToNext,
          ],
          systemActions: const {
            MediaAction.seek,
          },
          androidCompactActionIndices: const [0, 1, 3],
          processingState: processingState,
          // processingState: const {
          //   ProcessingState.idle: AudioProcessingState.idle,
          //   ProcessingState.loading: AudioProcessingState.loading,
          //   ProcessingState.buffering: AudioProcessingState.buffering,
          //   ProcessingState.ready: AudioProcessingState.ready,
          //   ProcessingState.completed: AudioProcessingState.completed,
          // }[_player.state.]!,
          playing: playing,
          updatePosition: _player.state.position,
          bufferedPosition: _player.state.buffer,
          // speed: _player.state.speed,
          queueIndex: _player.state.playlist.index,
        ));
      },
    );
  }
}
