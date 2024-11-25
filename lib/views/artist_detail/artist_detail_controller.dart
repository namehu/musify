import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/util/httpClient.dart';

class ArtistDetailController extends GetxController {
  ScrollController albumscontroller = ScrollController();
  ScrollController similarArtistcontroller = ScrollController();

  var artilstname = ''.obs; //歌手名字
  var arturl = ''.obs; //歌手头像
  var albumsnum = 0.obs; //专辑数量
  var albums = <Albums>[].obs; //专辑

  var biography = ''.obs; //歌手简介
  var similarArtist = <dynamic>[].obs; //相似歌手

  var playCount = 0.obs; //播放次数
  var duration = 0.obs; //总时长
  var songCount = 0.obs; //歌曲数量
  var star = false.obs; //是否收藏

  var topSongs = <Songs>[].obs; // top歌曲
  var topSongsFav = <bool>[].obs; //top歌曲是否收藏

  @override
  void onInit() async {
    super.onInit();

    String id = Get.arguments?['id'] ?? '';
    if (id.isNotEmpty) {
      _getArtist(id);
      _getArtistInfo2(id);
    }
  }

  _getArtist(String artistId) async {
    final _artist = await getArtist(artistId);

    var _playCount = 0;
    var _duration = 0;
    var _songs = 0;

    if (_artist != null) {
      List<Albums> _list = [];
      if (_artist != null && _artist.length > 0) {
        _getTopSongs(_artist["name"]);
        for (var _element in _artist["album"]) {
          String _url = getCoverArt(_element["id"]);
          _element["coverUrl"] = _url;
          Albums _album = Albums.fromJson(_element);
          _list.add(_album);
          _playCount += _album.playCount;
          _duration += _album.duration;
          _songs += _album.songCount;
        }
      }

      if (_artist["starred"] != null) {
        star.value = true;
      } else {
        star.value = false;
      }

      playCount(_playCount);
      duration(_duration);
      songCount(_songs);

      albums(_list);
      albumsnum.value = _artist["albumCount"];
      artilstname.value = _artist["name"];
      arturl.value = getCoverArt(_artist["id"]);
    }
  }

  _getTopSongs(String _artilstname) async {
    final _albumtem = await getTopSongs(_artilstname);
    if (_albumtem != null && _albumtem["song"] != null) {
      final _songsList = _albumtem["song"];
      List<Songs> _songtem = [];
      List<bool> _startem = [];
      for (var _element in _songsList) {
        String _stream = getServerInfo("stream");
        String _url = getCoverArt(_element["id"]);
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

      topSongs(_songtem);
      topSongsFav(_startem);
    }
  }

  _getArtistInfo2(String _artistId) async {
    final _artist = await getArtistInfo2(_artistId);
    if (_artist != null) {
      if (_artist["biography"] != null) {
        String _tem = _artist["biography"];
        while (_tem.contains("<a") && _tem.contains("a>")) {
          String _sub1 = "";
          String _sub2 = "";
          _sub1 = _tem.substring(0, _tem.indexOf("<a"));
          _sub2 = _tem.substring(_tem.indexOf("a>") + 2, _tem.length);
          _tem = _sub1 + _sub2;
        }

        biography.value = _tem;
      }

      if (_artist["similarArtist"] != null &&
          _artist["similarArtist"].length > 0) {
        List _similarList = [];
        for (var _element in _artist["similarArtist"]) {
          _element["coverUrl"] = getCoverArt(_element["id"]);
          _similarList.add(_element);
        }
        similarArtist.value = _similarList;
      }
    }
  }
}
