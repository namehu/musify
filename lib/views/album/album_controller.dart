import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/util/httpclient.dart';

import '../../models/songs.dart';

class AlbumController extends GetxController {
  final AudioPlayer player = AudioPlayerService.player;

  final _album = (Albums.fromJson({})).obs;
  final _songs = <Songs>[].obs;

  final staralbum = false.obs; // 是否收藏专辑

  Albums get album => _album.value;
  List<Songs> get songs => _songs.value;

  @override
  void onInit() {
    super.onInit();

    var id = Get.arguments?['id'] ?? null;
    if (id != null) {
      _getAlbum(id);
    }
  }

  //
  _getAlbum(String albumId) async {
    final _albumtem = await getAlbum(albumId);
    if (_albumtem == null || _albumtem.length <= 0) {
      return;
    }

    final _songsList = _albumtem["song"];

    String _url = getCoverArt(_albumtem["id"]);

    _albumtem["coverUrl"] = _url;
    _albumtem["title"] = _albumtem["name"];
    Albums _albums = Albums.fromJson(_albumtem);
    _album.value = _albums;

    if (_songsList != null) {
      List<Songs> _songtem = [];
      List<bool> _startem = [];
      for (var _element in _songsList) {
        String _stream = getServerInfo("stream");
        String _url = await getCoverArt(_element["id"]);
        _element["stream"] = _stream + '&id=' + _element["id"];
        _element["coverUrl"] = _url;
        if (_element["starred"] != null) {
          _startem.add(true);
        } else {
          _startem.add(false);
        }
        Songs _song = Songs.fromJson(_element);
        _songtem.add(_song);
      }
      if (_albumtem["starred"] != null) {
        staralbum.value = true;
      } else {
        staralbum.value = false;
      }

      _songs.value = _songtem;
    }
  }

  /// 处理播放
  handlePlay([bool? shuffle]) {
    if (songs.length <= 0) {
      return;
    }

    if (listEquals(activeList.value, songs)) {
      player.seek(Duration.zero, index: 0);
    } else {
      //当前歌曲队列
      activeIndex.value = 0;
      activeSongValue.value = songs[0].id;
      activeList.value = songs; //歌曲所在专辑歌曲List
    }
  }

  ///
  ///
  /// 点击歌曲播放
  handleSongClick(Songs _song, int index) {
    if (listEquals(activeList.value, songs)) {
      player.seek(Duration.zero, index: index);
    } else {
      //当前歌曲队列
      activeIndex.value = index;
      activeSongValue.value = _song.id;
      activeList.value = songs; //歌曲所在专辑歌曲List
    }
  }
}
