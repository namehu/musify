import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rxDart;
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:musify/constant.dart';
import 'package:musify/enums/play_mode_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/util/audioTools.dart';
import 'package:musify/util/httpClient.dart';
import 'package:musify/widgets/m_toast.dart';
import 'package:musify/widgets/music_bar/play_list_modal.dart';

import '../models/myModel.dart';

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

  /// 播放列表中歌曲
  RxList<Songs> playSongs = <Songs>[].obs;
  // 初始化播放列表
  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    children: [],
  );

  /// 播放模式
  Rx<PlayModeEnum> playMode = PlayModeEnum.loop.obs;
  bool _shuffleModeEnabled = false;
  LoopMode _loopMode = LoopMode.all;

  /// 当前播放歌曲
  Rx<Songs> currentSong = Songs.fromInitial().obs;

  /// 当前歌曲歌词
  Rx<String> lyric = ''.obs;

  /// 当前歌曲播放进度
  Stream<PositionData> get positionDataStream {
    return rxDart.Rx.combineLatest3<Duration, Duration, Duration?,
        PositionData>(
      player.positionStream,
      player.bufferedPositionStream,
      player.durationStream,
      (position, bufferedPosition, duration) =>
          PositionData(position, bufferedPosition, duration ?? Duration.zero),
    );
  }

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
        // player.setShuffleModeEnabled(false);
        // player.setLoopMode(LoopMode.all);
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
      builder: (BuildContext _contenxt) => PlayListModal(),
    );
  }

  /// 切换播放模式
  tooglePlayMode([PlayModeEnum? mode, bool toast = true]) {
    PlayModeEnum nextMode;

    if (mode != null) {
      nextMode = mode;
    } else {
      switch (playMode.value) {
        case PlayModeEnum.loop:
          nextMode = PlayModeEnum.single;
          break;
        case PlayModeEnum.single:
          nextMode = PlayModeEnum.shuffle;
          break;
        default:
          nextMode = PlayModeEnum.loop;
          break;
      }
    }

    switch (nextMode) {
      case PlayModeEnum.single:
        _loopMode = LoopMode.one;
        _shuffleModeEnabled = false;
        if (toast) MToast.show(S.current.repeatone);
        break;
      case PlayModeEnum.shuffle:
        _loopMode = LoopMode.all;
        _shuffleModeEnabled = true;
        if (toast) MToast.show(S.current.shuffle);
        break;
      default:
        _loopMode = LoopMode.all;
        _shuffleModeEnabled = false;
        if (toast) MToast.show(S.current.repeatall);
    }

    playMode(nextMode);
    player.setLoopMode(_loopMode);
    player.setShuffleModeEnabled(_shuffleModeEnabled);
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

    playlist =
        ConcatenatingAudioSource(useLazyPreparation: true, children: children);

    await player.setAudioSource(
      playlist,
      initialIndex: activeIndex.value,
      initialPosition: Duration.zero,
    );

    player.play();

    final currentItem = player.sequenceState!.currentSource;
    MediaItem _tag = currentItem?.tag;

    await getSongDetail(_tag.id);
  }
}
