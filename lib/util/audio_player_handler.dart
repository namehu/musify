import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:musify/constant.dart';
import 'package:musify/services/audio_player_service.dart';

class AudioPlayerHandler extends BaseAudioHandler
    with
        QueueHandler, // mix in default queue callback implementations
        SeekHandler {
  // mix in default seek callback implementations

  final audioPlayerService = Get.find<AudioPlayerService>();
  late Player _player;

  AudioPlayerHandler() {
    _player = audioPlayerService.player;

    _notifyAudioHandlerAboutPlayListEvents();
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
    return audioPlayerService.playNext();
  }

  @override
  Future<void> skipToPrevious() async {
    return audioPlayerService.playPre();
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    queue.value.clear();
    queue.add(mediaItems);
  }

  /// Handling new queue items in AudioHandler
  _notifyAudioHandlerAboutPlayListEvents() {
    _player.stream.playlist.listen((Playlist event) {
      if (event.medias.isEmpty) {
        addQueueItems([]);
        return;
      }

      var mediaItems = event.medias.map((el) {
        return el.extras!['mediaItem'] as MediaItem;
      }).toList();

      addQueueItems(mediaItems);

      var queueIndex = event.index;
      playbackState.add(
        playbackState.value.copyWith(
          queueIndex: queueIndex,
        ),
      );

      // 更新正在播放
      Future.delayed(Duration(milliseconds: 200), () {
        mediaItem.add(mediaItems[event.index]);
      });
    });
  }

  /// Passing on events in AudioHandler
  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.stream.playing.listen(
      (playing) async {
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
          processingState: AudioProcessingState.ready,
          // processingState: const {
          //   ProcessingState.idle: AudioProcessingState.idle,
          //   ProcessingState.loading: AudioProcessingState.loading,
          //   ProcessingState.buffering: AudioProcessingState.buffering,
          //   ProcessingState.ready: AudioProcessingState.ready,
          //   ProcessingState.completed: AudioProcessingState.completed,
          // }[_player.state.]!,
          playing: playing,
          // queueIndex: queueIndex,
        ));
      },
    );

    _player.stream.position.listen(
      (position) {
        playbackState.add(
          playbackState.value.copyWith(
            updatePosition: position,
            bufferedPosition: _player.state.buffer,
          ),
        );
      },
    );
  }
}
