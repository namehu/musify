import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:musify/constant.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/util/audioTools.dart';
import 'package:musify/util/httpClient.dart';
import 'package:musify/widgets/music_bar/play_list_modal.dart';

class HideMusicBarEvent {
  // HideMusicBarEvent();
}

/**
 * 播放器服务
 * 提供全局的播放器实例
 */
class AudioPlayerService extends GetxService {
  static late AudioPlayer player;
  static final hideMusicEventBus = EventBus();

  Rx<Songs> currentSong = Songs.fromInitial().obs;
  Rx<String> lyric = ''.obs;
  RxList<Songs> playSongs = <Songs>[].obs;

  // 初始化播放列表
  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    children: [],
  );

  late Worker _playListWorker;

  /// 歌词模型
  get lyricModel =>
      LyricsModelBuilder.create().bindLyricToMain(lyric.value).getModel();

  /// 初始化
  Future<AudioPlayerService> init() async {
    player = AudioPlayer(); // 实例化播放器

    // 监听播放器bar显示隐藏事件
    hideMusicEventBus.on<HideMusicBarEvent>().listen((event) {
      hideMusicBar.value = false;
    });

    // 监听替换播放列表
    _playListWorker = ever(playSongs, (songs) {
      if (activeSongValue.value != "1") {
        //新加列表的时候关闭乱序，避免出错
        player.setShuffleModeEnabled(false);
        player.setLoopMode(LoopMode.all);
        isShuffleModeEnabledNotifier.value = false;
        playerLoopModeNotifier.value = LoopMode.all;
        _setAudioSource(songs);
      }
    });

    return this;
  }

  @override
  onClose() {
    hideMusicEventBus.destroy();
    _playListWorker.dispose();
  }

  // 显示播放列表
  static showPlayList() async {
    var context = navigatorKey.currentState!.context;
    hideMusicBar.value = true;

    await showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (BuildContext _contenxt) => PlayListModal());
  }

  // 设置播放歌曲和列表
  Future<void> _setAudioSource(List<Songs> songs) async {
    if (player.sequenceState != null) {
      player.sequenceState!.effectiveSequence.clear();
    }

    List<AudioSource> children = [];
    for (var element in songs) {
      Songs _song = element;
      if (_song.suffix != "ape") {
        children.add(
          AudioSource.uri(
            Uri.parse(_song.stream),
            tag: MediaItem(
              id: _song.id,
              album: _song.album,
              artist: _song.artist,
              genre: _song.genre,
              title: _song.title,
              duration: Duration(milliseconds: _song.duration.toInt()),
              artUri: Uri.parse(getCoverArt(_song.id)),
            ),
          ),
        );
      }
    }

    playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: children,
    );

    await player.setAudioSource(
      playlist,
      initialIndex: activeIndex.value,
      initialPosition: Duration.zero,
    );

    player.play();
    final currentItem = player.sequenceState!.currentSource;
    MediaItem _tag = currentItem?.tag;

    await getSongDetail(_tag.id);

    //更新上下首歌曲
    if (playlist.sequence.isEmpty || currentItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playlist.sequence.first == currentItem;
      isLastSongNotifier.value = playlist.sequence.last == currentItem;
    }
  }
}
