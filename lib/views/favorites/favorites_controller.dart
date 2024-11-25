import 'package:get/get.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/util/httpclient.dart';

import '../../generated/l10n.dart';

class FavoritesController extends GetxController {
  var songs = <Songs>[].obs;
  var songsFav = <bool>[].obs;

  var albums = <Albums>[].obs;
  var albumsFav = <bool>[].obs;

  var artists = <Artists>[].obs;
  var artistsFav = <bool>[].obs;

  String get songFavText {
    return S.current.song +
        '(' +
        songsFav.value.where((it) => it).length.toString() +
        ')';
  }

  String get albumsFavCountText {
    return S.current.album +
        '(' +
        albumsFav.value.where((it) => it).length.toString() +
        ')';
  }

  String get artistsFavCountText {
    var _str = S.current.artist;
    _str = S.current.artist +
        '(' +
        artistsFav.value.where((it) => it).length.toString() +
        ')';
    return _str;
  }

  @override
  void onInit() {
    super.onInit();
    _getFavorite();
  }

  _getFavorite() async {
    final _favoriteList = await getStarred();

    if (_favoriteList != null) {
      var _songs = _favoriteList["song"];
      var _albums = _favoriteList["album"];
      var _artists = _favoriteList["artist"];

      List<Songs> _songs1 = [];
      List<Albums> _albums1 = [];
      List<Artists> _artists1 = [];

      if (_songs != null && _songs.length > 0) {
        for (var _song in _songs) {
          String _stream = await getServerInfo("stream");
          String _url = await getCoverArt(_song["id"]);
          _song["stream"] = _stream + '&id=' + _song["id"];
          _song["coverUrl"] = _url;
          _songs1.add(Songs.fromJson(_song));
          songsFav.add(true);
        }
      }
      songs(_songs1);

      if (_albums != null && _albums.length > 0) {
        for (var _album in _albums) {
          String _url = await getCoverArt(_album["id"]);
          _album["coverUrl"] = _url;
          _albums1.add(Albums.fromJson(_album));
          albumsFav.add(true);
        }
      }
      albums(_albums1);

      if (_artists != null && _artists.length > 0) {
        for (var _artist in _artists) {
          String _url = await getCoverArt(_artist["id"]);
          _artist["artistImageUrl"] = _url;
          _artists1.add(Artists.fromJson(_artist));
          artistsFav.add(true);
        }
      }
      artists(_artists1);
    }
  }
}
