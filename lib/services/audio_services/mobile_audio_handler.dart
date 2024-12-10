import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:media_kit/media_kit.dart';
import 'package:musify/services/audio_player/playback_state.dart';
import 'package:musify/util/logger.dart';

import '../../util/platform.dart';
import '../audio_player/audio_player.dart';

class MobileAudioHandler extends BaseAudioHandler with SeekHandler {
  AudioSession? session;

  MobileAudioHandler() {
    AudioSession.instance.then((s) {
      session = s;
      session?.configure(const AudioSessionConfiguration.music());

      bool wasPausedByBeginEvent = false;

      s.interruptionEventStream.listen((event) async {
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.duck:
              await audioPlayer.setVolume(0.5);
              break;
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              {
                wasPausedByBeginEvent = audioPlayer.isPlaying;
                await audioPlayer.pause();
                break;
              }
          }
        } else {
          switch (event.type) {
            case AudioInterruptionType.duck:
              await audioPlayer.setVolume(1.0);
              break;
            case AudioInterruptionType.pause when wasPausedByBeginEvent:
            case AudioInterruptionType.unknown when wasPausedByBeginEvent:
              await audioPlayer.resume();
              wasPausedByBeginEvent = false;
              break;
            default:
              break;
          }
        }
      });

      s.becomingNoisyEventStream.listen((_) {
        audioPlayer.pause();
      });
    });

    audioPlayer.playerStateStream.listen((state) async {
      if (state == AudioPlaybackState.playing) {
        await session?.setActive(true);
      }
      playbackState.add(await _transformEvent());
    });

    audioPlayer.positionStream.listen((pos) async {
      playbackState.add(await _transformEvent());
    });
    audioPlayer.bufferedPositionStream.listen((pos) async {
      playbackState.add(await _transformEvent());
    });
  }

  void addItem(MediaItem item) {
    session?.setActive(true);
    mediaItem.add(item);
  }

  // The most common callbacks:
  @override
  Future<void> play() => audioPlayer.resume();

  @override
  Future<void> pause() => audioPlayer.pause();

  @override
  Future<void> stop() => audioPlayer.stop();

  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);

  @override
  Future<void> skipToQueueItem(int index) => audioPlayer.jumpTo(index);

  @override
  Future<void> skipToNext() async {
    await audioPlayer.skipToNext();
    await super.skipToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await audioPlayer.skipToPrevious();
    await super.skipToPrevious();
  }

  @override
  Future<void> onTaskRemoved() async {
    await audioPlayer.pause();
    if (kIsAndroid) exit(0);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    await super.setShuffleMode(shuffleMode);

    audioPlayer.setShuffle(shuffleMode == AudioServiceShuffleMode.all);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    super.setRepeatMode(repeatMode);
    audioPlayer.setLoopMode(switch (repeatMode) {
      AudioServiceRepeatMode.all ||
      AudioServiceRepeatMode.group =>
        PlaylistMode.loop,
      AudioServiceRepeatMode.one => PlaylistMode.single,
      _ => PlaylistMode.none,
    });
  }

  Future<PlaybackState> _transformEvent() async {
    try {
      return PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          audioPlayer.isPlaying ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
          MediaControl.stop,
        ],
        systemActions: {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 2],
        playing: audioPlayer.isPlaying,
        updatePosition: audioPlayer.position,
        bufferedPosition: audioPlayer.bufferedPosition,
        shuffleMode: audioPlayer.isShuffled == true
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        repeatMode: switch (audioPlayer.loopMode) {
          PlaylistMode.loop => AudioServiceRepeatMode.all,
          PlaylistMode.single => AudioServiceRepeatMode.one,
          _ => AudioServiceRepeatMode.none,
        },
        processingState: audioPlayer.isBuffering
            ? AudioProcessingState.loading
            : AudioProcessingState.ready,
      );
    } catch (e, stack) {
      AppLogger.reportError(e, stack);
      rethrow;
    }
  }
  // /// Passing on events in AudioHandler
  // void _notifyAudioHandlerAboutPlaybackEvents() {
  //   player.stream.playing.listen(
  //     (playing) async {
  //       playbackState.add(playbackState.value.copyWith(
  //         controls: [
  //           MediaControl.skipToPrevious,
  //           if (playing) MediaControl.pause else MediaControl.play,
  //           MediaControl.stop,
  //           MediaControl.skipToNext,
  //         ],
  //         systemActions: const {
  //           MediaAction.seek,
  //         },
  //         androidCompactActionIndices: const [0, 1, 3],
  //         processingState: AudioProcessingState.ready,
  //         // processingState: const {
  //         //   ProcessingState.idle: AudioProcessingState.idle,
  //         //   ProcessingState.loading: AudioProcessingState.loading,
  //         //   ProcessingState.buffering: AudioProcessingState.buffering,
  //         //   ProcessingState.ready: AudioProcessingState.ready,
  //         //   ProcessingState.completed: AudioProcessingState.completed,
  //         // }[_player.state.]!,
  //         playing: playing,
  //         // queueIndex: queueIndex,
  //       ));
  //     },
  //   );

  //   player.stream.position.listen(
  //     (position) {
  //       playbackState.add(
  //         playbackState.value.copyWith(
  //           updatePosition: position,
  //           bufferedPosition: player.state.buffer,
  //         ),
  //       );
  //     },
  //   );
  // }
}
