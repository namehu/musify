import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/api/index.dart';
import 'package:musify/enums/play_mode_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/util/httpclient.dart';
import 'package:musify/widgets/m_toast.dart';

import '../../models/songs.dart';

class AlbumController extends GetxController {
  final AudioPlayer player = AudioPlayerService.player;
  final AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();

  final _album = (Albums.fromJson({})).obs;
  final _songs = <Songs>[].obs;

  final staralbum = false.obs; // 是否收藏专辑

  Albums get album => _album.value;
  List<Songs> get songs => _songs.value;

  @override
  void onInit() {
    super.onInit();

    var id = Get.arguments?['id'];
    if (id != null) {
      _getAlbum(id);
    }
  }

  _getAlbum(String albumId) async {
    final albumRes = await MRequest.api.getAlbum(albumId);
    if (albumRes == null || albumRes.length <= 0) {
      return;
    }

    final albumSongList = albumRes["song"];

    String songCoverUrl = getCoverArt(albumRes["id"]);

    albumRes["coverUrl"] = songCoverUrl;
    albumRes["title"] = albumRes["name"];
    Albums albumsData = Albums.fromJson(albumRes);
    _album.value = albumsData;

    if (albumSongList != null) {
      List<Songs> songtem = [];
      List<bool> startem = [];
      for (var elementAl in albumSongList) {
        elementAl["stream"] =
            '${getServerInfo("stream")}&id=${elementAl["id"]}';
        elementAl["coverUrl"] = getCoverArt(elementAl["id"]);
        if (elementAl["starred"] != null) {
          startem.add(true);
        } else {
          startem.add(false);
        }
        songtem.add(Songs.fromJson(elementAl));
      }
      if (albumRes["starred"] != null) {
        staralbum.value = true;
      } else {
        staralbum.value = false;
      }

      _songs.value = songtem;
    }
  }

  /// 处理播放
  handlePlay([PlayModeEnum? mode = PlayModeEnum.loop]) {
    if (songs.isEmpty) {
      MToast.show(S.current.noSong);
      return;
    }

    audioPlayerService.tooglePlayMode(mode, false);
    int index = 0;
    Songs song = songs[0];

    handleSongClick(song, index);
  }

  /// 点击歌曲播放
  handleSongClick(Songs songData, int index) {
    audioPlayerService.palySongList(songs, index: index);
  }
}
