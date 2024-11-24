import 'package:get/get.dart';
import 'package:musify/models/play_list.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/util/httpClient.dart';

class PlayListDetailController extends GetxController {
  AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();

  var songslist = <Songs>[].obs;
  var songsnum = 0.obs;

  var albumsname = "".obs;
  var playCount = 0.obs;
  var duration = 0.obs;
  var palylistId = "".obs;
  var arturl = ''.obs;

  @override
  void onInit() {
    super.onInit();

    var id = Get.arguments?['id'] ?? null;
    if (id != null) {
      _getSongs(id);
    }
  }

  _getSongs(String _playlistId) async {
    final _playlisttem = await getPlaylistbyId(_playlistId);

    int _playCount = 0;
    if (_playlisttem != null) {
      String _url = await getCoverArt(_playlisttem['id']);
      _playlisttem["imageUrl"] = _url;
      Playlist _playlist = Playlist.fromJson(_playlisttem);
      List<Songs> _temsong = [];
      if (_playlisttem["entry"] != null && _playlisttem["entry"].length > 0) {
        for (var _element in _playlisttem["entry"]) {
          String _stream = getServerInfo("stream");
          String _url = await getCoverArt(_element["id"]);
          _element["stream"] = _stream + '&id=' + _element["id"];
          _element["coverUrl"] = _url;
          Songs _song = Songs.fromJson(_element);
          _playCount += _song.playCount;
          _temsong.add(_song);
        }
      }

      playCount.value = _playCount;
      songslist.value = _temsong;
      songsnum.value = _playlist.songCount;
      albumsname.value = _playlist.name;
      duration.value = _playlist.duration;
      arturl.value = _playlist.imageUrl;
      palylistId.value = _playlist.id;
    }
  }
}
