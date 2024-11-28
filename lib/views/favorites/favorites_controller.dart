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
    return '${S.current.song}(${songsFav.value.where((it) => it).length})';
  }

  String get albumsFavCountText {
    return '${S.current.album}(${albumsFav.value.where((it) => it).length})';
  }

  String get artistsFavCountText {
    var str = S.current.artist;
    str = '${S.current.artist}(${artistsFav.value.where((it) => it).length})';
    return str;
  }

  @override
  void onInit() {
    super.onInit();
    _getFavorite();
  }

  _getFavorite() async {
    final favoriteList = await getStarred();

    if (favoriteList != null) {
      var songs = favoriteList["song"];
      var albums = favoriteList["album"];
      var artists = favoriteList["artist"];

      List<Songs> songs1 = [];
      List<Albums> albums1 = [];
      List<Artists> artists1 = [];

      if (songs != null && songs.length > 0) {
        for (var song in songs) {
          String stream = await getServerInfo("stream");
          String url = await getCoverArt(song["id"]);
          song["stream"] = '$stream&id=${song["id"]}';
          song["coverUrl"] = url;
          songs1.add(Songs.fromJson(song));
          songsFav.add(true);
        }
      }
      songs(songs1);

      if (albums != null && albums.length > 0) {
        for (var album in albums) {
          String url = await getCoverArt(album["id"]);
          album["coverUrl"] = url;
          albums1.add(Albums.fromJson(album));
          albumsFav.add(true);
        }
      }
      albums(albums1);

      if (artists != null && artists.length > 0) {
        for (var artist in artists) {
          String url = await getCoverArt(artist["id"]);
          artist["artistImageUrl"] = url;
          artists1.add(Artists.fromJson(artist));
          artistsFav.add(true);
        }
      }
      artists(artists1);
    }
  }
}
