import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/models/songs.dart';

/**
 * 播放器服务
 * 提供全局的播放器实例
 */
class AudioPlayerService extends GetxService {
  static late AudioPlayer player;

  Rx<Songs> songs = Songs.fromInitial().obs;
  Rx<String> lyric = ''.obs;

  get lyricModel =>
      LyricsModelBuilder.create().bindLyricToMain(lyric.value).getModel();

  Future<AudioPlayerService> init() async {
    player = AudioPlayer();
    return this;
  }
}
