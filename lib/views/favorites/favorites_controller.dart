import 'package:get/get.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/star_service.dart';
import '../../util/httpclient.dart' hide getCoverArt;
import '../../api/subsonic/utils.dart';
import '../../generated/l10n.dart';

class FavoritesController extends GetxController {
  StarService starService = Get.find<StarService>();
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
    _getFavoritesData();
  }

  _getFavoritesData() async {
    final favoriteList = await getStarred();

    if (favoriteList != null) {
      var songList = favoriteList["song"];
      var albumsList = favoriteList["album"];
      var artistsList = favoriteList["artist"];

      List<Songs> songs1 = [];
      List<Albums> albums1 = [];
      List<Artists> artists1 = [];

      if (songList != null && songList.length > 0) {
        for (var song in songList) {
          song["stream"] = getSongStream(song["id"]);
          song["coverUrl"] = getCoverArt(song["id"]);
          songs1.add(Songs.fromJson(song));
          songsFav.add(true);
        }
      }
      songs(songs1);

      if (albumsList != null && albumsList.length > 0) {
        for (var album in albumsList) {
          album["coverUrl"] = getCoverArt(album["id"]);
          albums1.add(Albums.fromJson(album));
          albumsFav.add(true);
        }
      }
      albums(albums1);

      if (artistsList != null && artistsList.length > 0) {
        for (var artist in artistsList) {
          artist["artistImageUrl"] = getCoverArt(artist["id"]);
          artists1.add(Artists.fromJson(artist));
          artistsFav.add(true);
        }
      }
      artists(artists1);
    }
  }
}
