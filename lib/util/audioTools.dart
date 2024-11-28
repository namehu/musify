// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/models/lyrics.dart';
import 'package:musify/services/audio_player_service.dart';

getSongDetail(String id) async {
  var song = await MRequest.api.getSong(id);
  if (song == null) {
    return null;
  }
  var audioPlayerService = Get.find<AudioPlayerService>();
  audioPlayerService.currentSong.value = song;

  var lyric = Lyrics.fromJsonString(song.lyrics);
  var lyrictem = lyric.toPlayerlyric();
  audioPlayerService.lyric.value = lyrictem;

  return song;
}
