import 'dart:async';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:musify/api/index.dart';
import 'package:musify/models/navidrome/nd_lyrics.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/util/m_lyric_ui.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/views/play/play_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:musify/constant.dart';
import 'package:musify/enums/play_mode_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/widgets/m_toast.dart';
import 'package:musify/widgets/music_bar/play_list_modal.dart';
import 'package:permission_handler/permission_handler.dart';
import '../dao/song_lyric_repository.dart';
import '../util/httpclient.dart';
import '../views/play/play_view.dart';

class HideMusicBarEvent {}

/// 播放器服务
/// 提供全局的播放器实例
class AudioPlayerService extends GetxService {
  late final Player player;

  static final hideMusicEventBus = EventBus();

  /// 播放列表中歌曲
  RxList<Songs> playSongs = <Songs>[].obs;

  /// 当前播放歌曲
  Rx<Songs> currentSong = Songs.fromInitial().obs;

  /// 当前播放音量
  Rx<double> volume = 1.0.obs;

  /// 静音
  RxBool volumeMute = false.obs;

  /// 当前歌曲歌词
  Rx<String> lyric = ''.obs;

  MLyricUI lyricUI = MLyricUI(highlight: true);

  /// 播放模式
  Rx<PlayModeEnum> playMode = PlayModeEnum.loop.obs;

  bool _shuffleModeEnabled = false;

  PlaylistMode _loopMode = PlaylistMode.loop;

  late StreamSubscription<dynamic> _playListStream;

  Stream<Duration> get positionStream => player.stream.position;

  /// 歌词模型
  get lyricModel =>
      LyricsModelBuilder.create().bindLyricToMain(lyric.value).getModel();

  /// 初始化
  Future<AudioPlayerService> init() async {
    // Necessary initialization for package:media_kit.
    MediaKit.ensureInitialized();

    player = Player();

    NativePlayer nativePlayer = player.platform as NativePlayer;

    if (Platform.isAndroid) {
      // 修复 鸿蒙系统播放高码率文件时闪退问题
      await nativePlayer.setProperty("ao", "audiotrack,opensles,");
    }

    _playListStream = player.stream.playlist.listen((Playlist event) async {
      // print('audioParams: $event');
      if (event.medias.isEmpty) return;

      var media = event.medias[event.index];

      if (media.extras == null || media.extras!['song'] == null) {
        return;
      }

      var song = media.extras!['song'];
      if (currentSong.value.id != song.id) {
        scrobble(song.id, false);
        try {
          var songDetail = await _getSongDetail(song.id);
          if (songDetail != null) {
            song = songDetail;
          }
        } catch (e) {
          //
        }
      }
      currentSong(song);
    });

    return this;
  }

  @override
  onClose() async {
    hideMusicEventBus.destroy();
    _playListStream.cancel();

    await player.dispose();
  }

  // 显示播放列表
  static showPlayList() async {
    var context = navigatorKey.currentState!.context;

    if (GetPlatform.isDesktop) {
      SmartDialog.show(
        alignment: Alignment.centerRight,
        maskColor: Colors.transparent,
        builder: (BuildContext ctx) => PlayListModal(),
      );
    } else {
      showMaterialModalBottomSheet(
        context: context,
        settings: RouteSettings(name: Routes.PLAY_LIST_MODAL),
        builder: (BuildContext ctx) => PlayListModal(),
      );
    }
  }

  /// 显示播放详情
  static showPlayView() async {
    var context = navigatorKey.currentState!.context;

    await showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      useRootNavigator: !isMobile,
      settings: RouteSettings(name: Routes.PLAY_DETAIL_MODAL),
      builder: (BuildContext ctx) {
        return GetBuilder<PlayController>(
          init: PlayController(),
          builder: (ctr) => PlayView(),
        );
      },
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
    bool showView = true,
  }) async {
    int idx = index!;
    if (song != null) {
      idx = songs.indexWhere((element) => element.id == song.id);

      if (idx < 0) {
        return MToast.show(S.current.noContent);
      }
    }

    if (listEquals(playSongs.value, songs)) {
      player.jump(idx);
    } else {
      playSongs(songs); //歌曲所在专辑歌曲List

      if (showView) showPlayView();

      await _requsetPermission();
      _resetLoopModeAndShuffle();
      _setAudioSource(songs, idx);
    }
  }

  playPre() {
    if (player.state.playlistMode == PlaylistMode.single) {
      player.seek(Duration.zero);
      return;
    }
    player.previous();
  }

  playNext() {
    if (player.state.playlistMode == PlaylistMode.single) {
      player.seek(Duration.zero);
      return;
    }
    player.next();
  }

  seek(Duration duration) async {
    await player.seek(duration);
  }

  /// 根据索引下标移除播放中的歌曲
  removeFromPlayList(int index) async {
    var songs = playSongs.value.map((item) => item).toList();
    var removedSong = songs.removeAt(index);

    if (songs.isEmpty) {
      await player.stop();
      currentSong(Songs.fromInitial());
    }
    playSongs(songs);
    player.remove(index);
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
        _loopMode = PlaylistMode.single;
        _shuffleModeEnabled = false;
        if (toast) MToast.show(S.current.repeatone);
        break;
      case PlayModeEnum.shuffle:
        _loopMode = PlaylistMode.loop;
        _shuffleModeEnabled = true;
        if (toast) MToast.show(S.current.shuffle);
        break;
      default:
        _loopMode = PlaylistMode.loop;
        _shuffleModeEnabled = false;
        if (toast) MToast.show(S.current.repeatall);
    }

    playMode(nextMode);
    _setLoopModeAndShuffle();
  }

  _setLoopModeAndShuffle() async {
    player.setPlaylistMode(_loopMode);
    await player.setShuffle(_shuffleModeEnabled);
  }

  _resetLoopModeAndShuffle() async {
    _loopMode = PlaylistMode.loop;
    _shuffleModeEnabled = false;

    playMode(PlayModeEnum.loop);
    _setLoopModeAndShuffle();
  }

// 设置播放歌曲和列表
  Future<void> _setAudioSource(List<Songs> songs, int index) async {
    /// 停止播放
    player.stop();

    List<Media> children = [];
    for (var song in songs) {
      children.add(
        Media(
          song.stream,
          extras: {
            'song': song,
            'mediaItem': MediaItem(
              // Specify a unique ID for each media item:
              id: song.id,
              // Metadata to display in the notification:
              album: song.album,
              title: song.title,
              artist: song.artist,
              duration: Duration(milliseconds: song.duration.toInt()),
              artUri: Uri.parse(getCoverArt(song.id)),
              genre: song.genre,
            )
          },
        ),
      );
    }

    final playable = Playlist(children, index: index);

    _setLoopModeAndShuffle();

    await player.open(playable);
  }

  _getSongDetail(String id) async {
    // 从存储库获取歌词
    var songLyricRepository = SongLyricRepository();
    var songLyric = await songLyricRepository.queryBySongId(id);
    if (songLyric != null) {
      lyric.value = songLyric.lyric;
      return null;
    }

    var song = await MRequest.api.getSong(id);
    if (song == null) {
      return null;
    }
    var lyrics = NdLyrics.fromJsonString(song.lyrics);
    var lyrictem = lyrics.toPlayerlyric(song);
    lyric.value = lyrictem;

    await songLyricRepository.insert(lyrictem, id);

    return song;
  }

  ///  请求权限
  /// https://pub.dev/packages/media_kit#permissions
  /// TODO: IOS / macOS 权限未配置
  _requsetPermission() async {
    int versionNum = 0;
    if (GetPlatform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String version = androidInfo.version.release.substring(0, 2);
      versionNum = int.parse(version);
    }

    ///  Android 13 or higher.
    if (versionNum >= 13) {
      // Video permissions.
      if (await Permission.videos.isDenied ||
          await Permission.videos.isPermanentlyDenied) {
        final state = await Permission.videos.request();
        if (!state.isGranted) {
          await SystemNavigator.pop();
        }
      }
      // Audio permissions.
      if (await Permission.audio.isDenied ||
          await Permission.audio.isPermanentlyDenied) {
        final state = await Permission.audio.request();
        if (!state.isGranted) {
          await SystemNavigator.pop();
        }
      }
    } else {
      if (await Permission.storage.isDenied ||
          await Permission.storage.isPermanentlyDenied) {
        final state = await Permission.storage.request();
        if (!state.isGranted) {
          await SystemNavigator.pop();
        }
      }
    }
  }
}
