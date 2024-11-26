import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/util/httpClient.dart';
import 'package:musify/util/util.dart';
import 'package:musify/widgets/m_toast.dart';

import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/songs.dart';

class SearchViewController extends GetxController {
  final audioPlayerService = Get.find<AudioPlayerService>();
  final searchController = new TextEditingController();
  ScrollController albumscontroller = ScrollController();
  ScrollController artistcontroller = ScrollController();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
  }

  RxList<Songs> songs = <Songs>[].obs;
  RxList<Albums> albums = <Albums>[].obs;
  RxList<Artists> artists = <Artists>[].obs;

  search() async {
    String _title1 = searchController.text.trim();
    String _title2 = converToTraditional(_title1);
    if (_title1 == '') {
      MToast.show(S.current.noContent);
      return;
    }

    List<Songs> _listSong = [];
    List<Albums> _listAlbums = [];
    List<Artists> _listArtists = [];

    final _searchData = await search3(_title1);
    final _searchDat2 = await search3(_title2);

    List<dynamic> resSong = _mergeAndDeduplicate(
        _searchData["song"] ?? [], _searchDat2["song"] ?? []);

    for (var _element in resSong) {
      String _stream = getServerInfo("stream");
      String _url = getCoverArt(_element["id"]);
      _element["stream"] = _stream + '&id=' + _element["id"];
      _element["coverUrl"] = _url;
      Songs _tem = Songs.fromJson(_element);
      _listSong.add(_tem);
    }

    List<dynamic> resAlbum = _mergeAndDeduplicate(
        _searchData["album"] ?? [], _searchDat2["album"] ?? []);

    for (var _element in resAlbum) {
      String _url = getCoverArt(_element["id"]);
      _element["coverUrl"] = _url;
      Albums _tem = Albums.fromJson(_element);
      _listAlbums.add(_tem);
    }

    List<dynamic> resArtist = _mergeAndDeduplicate(
        _searchData["artist"] ?? [], _searchDat2["artist"] ?? []);

    for (var _element in resArtist) {
      String _url = getCoverArt(_element["id"]);
      _element["artistImageUrl"] = _url;
      Artists _tem = Artists.fromJson(_element);
      _listArtists.add(_tem);
    }

    songs(_listSong);
    albums(_listAlbums);
    artists(_listArtists);
  }

  List<dynamic> _mergeAndDeduplicate(List<dynamic> list1, List<dynamic> list2) {
    var mergedList = <dynamic>[];
    var idSet = Set<String>();

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
