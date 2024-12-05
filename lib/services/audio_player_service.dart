import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:musify/api/index.dart';
import 'package:musify/models/lyrics.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/util/m_lyric_ui.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/views/play/play_controller.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:musify/constant.dart';
import 'package:musify/enums/play_mode_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/util/httpClient.dart';
import 'package:musify/widgets/m_toast.dart';
import 'package:musify/widgets/music_bar/play_list_modal.dart';
import 'package:permission_handler/permission_handler.dart';
import '../views/play/play_view.dart';

class HideMusicBarEvent {}

/// 播放器服务
/// 提供全局的播放器实例
class AudioPlayerService extends GetxService {
  static late AudioPlayer audioPlayer;
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

  PlaylistMode _loopMode = PlaylistMode.loop;

  late Worker _playListWorker;

  late StreamSubscription<dynamic> _currentIndexStream;

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

    // audioPlayer = AudioPlayer(); // 实例化播放器

    // 监听替换播放列表
    _playListWorker = ever(playSongs, (songs) async {
      await _requsetPermission();

      _setAudioSource(songs);
    });

    _currentIndexStream = player.stream.playlist.listen((Playlist event) {
      // print('audioParams: $event');
      if (event.medias.isEmpty) return;

      var media = event.medias[event.index];

      if (media.extras == null || media.extras!['id'] == null) {
        return;
      }

      var id = media.extras!['id'];
      if (currentSong.value.id != id) {
        scrobble(id, false);
        _getSongDetail(id);
      }
    });

    return this;
  }

  @override
  onClose() async {
    await player.dispose();

    // audioPlayer.dispose();
    hideMusicEventBus.destroy();
    _playListWorker.dispose();
    _currentIndexStream.cancel();
  }

  // 显示播放列表
  static showPlayList() async {
    var context = navigatorKey.currentState!.context;

    await showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      settings: RouteSettings(name: Routes.PLAY_LIST_MODAL),
      builder: (BuildContext ctx) => PlayListModal(),
    );
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
  }) {
    int idx = index!;
    if (song != null) {
      idx = songs.indexWhere((element) => element.id == song.id);

      if (idx < 0) {
        return MToast.show(S.current.noContent);
      }
    }

    // Songs playSong = song ?? songs[idx];

    if (listEquals(playSongs.value, songs)) {
      player.jump(idx);
    } else {
      currentSongIndex(idx);
      playSongs(songs); //歌曲所在专辑歌曲List

      if (showView) {
        showPlayView();
      }
    }
  }

  playPre() {
    if (player.state.playlistMode == PlaylistMode.single) {
      return;
    }
    player.previous();
  }

  playNext() {
    if (player.state.playlistMode == PlaylistMode.single) {
      return;
    }
    player.next();
  }

  seek(Duration duration) async {
    await player.seek(duration);
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

// 设置播放歌曲和列表
  Future<void> _setAudioSource(List<Songs> songs) async {
    /// 停止播放
    player.stop();

    List<Media> children = [];
    List<MediaItem> mediaItems = [];
    for (var song in songs) {
      children.add(
        Media(
          song.stream,
          extras: {
            // Specify a unique ID for each media item:
            'id': song.id,
            // Metadata to display in the notification:
            'album': song.album,
            'title': song.title,
            'artUri': Uri.parse(getCoverArt(song.id)),
            'artist': song.artist,
            'genre': song.genre,
            'duration': Duration(milliseconds: song.duration.toInt()),
            'mediaItem': song
          },
        ),
      );

      mediaItems.add(MediaItem(
        // Specify a unique ID for each media item:
        id: song.id,
        displayTitle: song.title,
        displaySubtitle: song.artist,
        displayDescription: song.album,

        // Metadata to display in the notification:
        album: song.album,
        title: song.title,
        artUri: Uri.parse(getCoverArt(song.id)),
        artist: song.artist,
        genre: song.genre,
        duration: Duration(milliseconds: song.duration.toInt()),
      ));
    }

    audioHandler.addQueueItems(mediaItems);

    final playable = Playlist(
      children,
      index: currentSongIndex.value,
    );

    await player.open(playable);
  }

  _getSongDetail(String id) async {
    var song = await MRequest.api.getSong(id);
    if (song == null) {
      return null;
    }
    currentSong.value = song;

    var lyrics = Lyrics.fromJsonString(song.lyrics);
    var lyrictem = lyrics.toPlayerlyric();
    lyric.value = lyrictem;

    return song;
  }

  // 设置播放歌曲和列表
  Future<void> _setAudioSourceold(List<Songs> songs) async {
    if (audioPlayer.sequenceState != null) {
      audioPlayer.sequenceState!.effectiveSequence.clear();
    }

    /// Define the playlist
    List<AudioSource> children = [];
    for (var song in songs) {
      if (song.suffix != "ape") {
        children.add(
          AudioSource.uri(
            Uri.parse(song.stream),

            /// just_audio_background support
            tag: MediaItem(
              // Specify a unique ID for each media item:
              id: song.id,
              // Metadata to display in the notification:
              album: song.album,
              title: song.title,
              artUri: Uri.parse(getCoverArt(song.id)),
              artist: song.artist,
              genre: song.genre,
              duration: Duration(milliseconds: song.duration.toInt()),
            ),
          ),
        );
      }
    }

    try {
      playlist = ConcatenatingAudioSource(
          useLazyPreparation: true, children: children);

      /// Load and play the playlist
      await audioPlayer.setAudioSource(
        playlist,
        initialIndex: currentSongIndex.value,
        initialPosition: Duration.zero,
      );

      _setLoopModeAndShuffle();

      /// FIXME: windows 播放bug
      if (GetPlatform.isWindows) {
        await Future.delayed(Duration(milliseconds: 500));
      }

      audioPlayer.play();

      final currentSong = songs[currentSongIndex.value];
      _getSongDetail(currentSong.id);
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      // Linux/Windows: maps to PlayerErrorCode.index
      logger.e("Error code: ${e.code}");
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web/Linux: a generic message
      // Windows: MediaPlayerError.message
      logger.e("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      logger.e("Connection aborted: ${e.message}");
    } catch (e) {
      // Fallback for all other errors
      logger.e('An error occured: $e');
    }
  }

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
