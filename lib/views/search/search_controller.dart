import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:musify/api/subsonic/utils.dart';
import 'package:musify/services/audio_player_service.dart';
import '../../util/httpclient.dart' hide getCoverArt;
import 'package:musify/util/util.dart';
import 'package:musify/widgets/m_toast.dart';

import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/songs.dart';

class SearchViewController extends GetxController {
  final audioPlayerService = Get.find<AudioPlayerService>();
  final searchController = TextEditingController();
  ScrollController albumscontroller = ScrollController();
  ScrollController artistcontroller = ScrollController();

  @override
  void onClose() {
    searchController.dispose();
  }

  RxList<Songs> songs = <Songs>[].obs;
  RxList<Albums> albums = <Albums>[].obs;
  RxList<Artists> artists = <Artists>[].obs;

  search() async {
    String title1 = searchController.text.trim();
    String title2 = converToTraditional(title1);
    if (title1 == '') {
      MToast.show(S.current.noContent);
      return;
    }

    List<Songs> listSong = [];
    List<Albums> listAlbums = [];
    List<Artists> listArtists = [];

    final searchData = await search3(title1);
    final searchDat2 = await search3(title2);

    List<dynamic> resSong = _mergeAndDeduplicate(
        searchData["song"] ?? [], searchDat2["song"] ?? []);

    for (var element in resSong) {
      element["stream"] = getSongStream(element["id"]);
      element["coverUrl"] = getCoverArt(element["id"]);
      Songs tem = Songs.fromJson(element);
      listSong.add(tem);
    }

    List<dynamic> resAlbum = _mergeAndDeduplicate(
        searchData["album"] ?? [], searchDat2["album"] ?? []);

    for (var albumElement in resAlbum) {
      String url = getCoverArt(albumElement["id"]);
      albumElement["coverUrl"] = url;
      Albums tem = Albums.fromJson(albumElement);
      listAlbums.add(tem);
    }

    List<dynamic> resArtist = _mergeAndDeduplicate(
        searchData["artist"] ?? [], searchDat2["artist"] ?? []);

    for (var artistElement in resArtist) {
      String url = getCoverArt(artistElement["id"]);
      artistElement["artistImageUrl"] = url;
      Artists tem = Artists.fromJson(artistElement);
      listArtists.add(tem);
    }

    songs(listSong);
    albums(listAlbums);
    artists(listArtists);
  }

  List<dynamic> _mergeAndDeduplicate(List<dynamic> list1, List<dynamic> list2) {
    var mergedList = <dynamic>[];
    var idSet = <String>{};

    void addItems(List<dynamic> list) {
      for (var item in list) {
        if (!idSet.contains(item['id'])) {
          idSet.add(item['id']);
          mergedList.add(item);
        }
      }
    }

    addItems(list1);
    addItems(list2);

    return mergedList;
  }
}
