import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/api/subsonic/utils.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import '../../util/httpclient.dart' hide getCoverArt;

class ArtistDetailController extends GetxController {
  final AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();
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

  final ScrollController scrollController = ScrollController();

  final double headHeight = GetPlatform.isMobile ? 200 : 300;

  RxBool showTitle = false.obs;

  Color? get imageMainColor => ThemeService.color.bgColor;
  Color? get textColor {
    return ThemeService.color.textColor;
  }

  @override
  void onInit() async {
    super.onInit();

    scrollController.addListener(() {
      showTitle(scrollController.offset > headHeight - 50);
    });

    String id = Get.arguments?['id'] ?? '';
    if (id.isNotEmpty) {
      _getArtist(id);
      _getArtistInfo2(id);
    }
  }

  @override
  void onClose() {
    super.onClose();

    scrollController.dispose();
  }

  playSong([int? index = 0]) {
    var songs = topSongs.value;
    audioPlayerService.palySongList(songs, index: index);
  }

  _getArtist(String artistId) async {
    final artist = await getArtist(artistId);

    var pCount = 0;
    var pduration = 0;
    var songsCount = 0;

    if (artist != null) {
      List<Albums> list = [];
      if (artist != null && artist.length > 0) {
        _getTopSongs(artist["name"]);
        for (var element in artist["album"]) {
          String url = getCoverArt(element["id"]);
          element["coverUrl"] = url;
          Albums album = Albums.fromJson(element);
          list.add(album);
          pCount += album.playCount;
          pduration += album.duration;
          songsCount += album.songCount;
        }
      }

      if (artist["starred"] != null) {
        star.value = true;
      } else {
        star.value = false;
      }

      playCount(pCount);
      duration(pduration);
      songCount(songsCount);

      albums(list);
      albumsnum.value = artist["albumCount"];
      artilstname.value = artist["name"];
      arturl.value = getCoverArt(artist["id"]);
    }
  }

  _getTopSongs(String artilstname) async {
    final albumtem = await getTopSongs(artilstname);
    if (albumtem != null && albumtem["song"] != null) {
      final songsList = albumtem["song"];
      List<Songs> songtem = [];
      List<bool> startem = [];
      for (var element in songsList) {
        String url = getCoverArt(element["id"]);
        element["stream"] = getSongStream(element["id"]);
        element["coverUrl"] = url;
        if (element["starred"] != null) {
          startem.add(true);
        } else {
          startem.add(false);
        }
        Songs song = Songs.fromJson(element);
        songtem.add(song);
      }

      topSongs(songtem);
      topSongsFav(startem);
    }
  }

  _getArtistInfo2(String artistId) async {
    final artist = await getArtistInfo2(artistId);
    if (artist != null) {
      if (artist["biography"] != null) {
        String tem = artist["biography"];
        while (tem.contains("<a") && tem.contains("a>")) {
          String sub1 = "";
          String sub2 = "";
          sub1 = tem.substring(0, tem.indexOf("<a"));
          sub2 = tem.substring(tem.indexOf("a>") + 2, tem.length);
          tem = sub1 + sub2;
        }

        biography.value = tem;
      }

      if (artist["similarArtist"] != null &&
          artist["similarArtist"].length > 0) {
        List similarList = [];
        for (var element in artist["similarArtist"]) {
          element["coverUrl"] = getCoverArt(element["id"]);
          similarList.add(element);
        }
        similarArtist.value = similarList;
      }
    }
  }
}
