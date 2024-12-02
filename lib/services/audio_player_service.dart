import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:get/get.dart';
import 'package:musify/util/m_lyric_ui.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
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

/// 播放器服务
/// 提供全局的播放器实例
class AudioPlayerService extends GetxService {
  static late AudioPlayer player;
  static final hideMusicEventBus = EventBus();

  /// 播放列表中歌曲
  RxList<Songs> playSongs = <Songs>[].obs;

  /// 当前播放歌曲
  Rx<Songs> currentSong = Songs.fromInitial().obs;

  /// 当前播放歌曲索引
  RxInt currentSongIndex = 0.obs;

  /// 当前歌曲歌词
  Rx<String> lyric = ''.obs;

  MLyricUI lyricUI = MLyricUI(highlight: true);

  // 初始化播放列表
  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    children: [],
  );

  /// 播放模式
  Rx<PlayModeEnum> playMode = PlayModeEnum.loop.obs;
  bool _shuffleModeEnabled = false;
  LoopMode _loopMode = LoopMode.all;

  /// 当前歌曲播放进度
  Stream<PositionData> get positionDataStream {
    return rx_dart.Rx.combineLatest3<Duration, Duration, Duration?,
        PositionData>(
      player.positionStream,
      player.bufferedPositionStream,
      player.durationStream,
      (position, bufferedPosition, duration) =>
          PositionData(position, bufferedPosition, duration ?? Duration.zero),
    );
  }

  late Worker _playListWorker;
  late StreamSubscription<int?> _currentIndexStream;

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
        _setAudioSource(songs);
      }
    });

    _currentIndexStream = player.currentIndexStream.listen((event) async {
      if (player.sequenceState == null) return;
      // 更新当前歌曲
      final currentItem = player.sequenceState!.currentSource;
      // final playlist = player.sequenceState!.effectiveSequence;
      if (currentItem != null) {
        MediaItem mediaItem = currentItem.tag;
        scrobble(mediaItem.id, false);
        await getSongDetail(mediaItem.id);
      }
    });

    return this;
  }

  @override
  onClose() {
    hideMusicEventBus.destroy();
    _playListWorker.dispose();
    _currentIndexStream.cancel();
  }

  // 显示播放列表
  static showPlayList() async {
    var context = navigatorKey.currentState!.context;
    hideMusicBar.value = true;

    await showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext ctx) => PlayListModal(),
    );
  }

  /// 将歌曲列表添加进播放列表并播放指定歌曲歌单
  /// [song] 歌曲对象
  /// [index] 歌曲索引
  /// [songs] 歌曲列表
  palySongList(
    List<Songs> songs, {
    Songs? song,
    int? index = 0,
  }) {
    int idx = index!;
    if (song != null) {
      idx = songs.indexWhere((element) => element.id == song.id);

      if (idx < 0) {
        return MToast.show(S.current.noContent);
      }
    }

    Songs playSong = song ?? songs[idx];

    if (listEquals(playSongs.value, songs)) {
      player.seek(Duration.zero, index: idx);
    } else {
      activeSongValue.value = playSong.id;
      currentSongIndex(idx);
      playSongs(songs); //歌曲所在专辑歌曲List
    }
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
    for (var el in songs) {
      if (el.suffix != "ape") {
        children.add(
          AudioSource.uri(
            Uri.parse(el.stream),
            tag: MediaItem(
              id: el.id,
              album: el.album,
              artist: el.artist,
              genre: el.genre,
              title: el.title,
              duration: Duration(milliseconds: el.duration.toInt()),
              artUri: Uri.parse(getCoverArt(el.id)),
            ),
          ),
        );
      }
    }

    playlist =
        ConcatenatingAudioSource(useLazyPreparation: true, children: children);

    await player.setAudioSource(
      playlist,
      initialIndex: currentSongIndex.value,
      initialPosition: Duration.zero,
    );

    player.play();

    final currentItem = player.sequenceState!.currentSource;
    MediaItem mediaItem = currentItem?.tag;

    await getSongDetail(mediaItem.id);
  }
}
