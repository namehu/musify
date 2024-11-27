import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/audio_player_service.dart';

class PlayListDetailController extends GetxController {
  AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();

  var coverUrl = ''.obs;
  var name = "".obs;
  var playCount = 0.obs;
  var duration = 0.obs;
  var songsNum = 0.obs;
  var songslist = <Songs>[].obs;

  @override
  void onInit() {
    super.onInit();

    var id = Get.arguments?['id'] ?? null;
    if (id != null) {
      _getData(id);
    }
  }

  _getData(String id) async {
    var _playList = await MRequest.api.getPlaylist(id);

    if (_playList != null) {
      songslist.value = _playList.songs ?? [];
      songsNum.value = _playList.songCount;
      name.value = _playList.name;
      duration.value = _playList.duration;
      coverUrl.value = _playList.imageUrl;

      if (_playList.songs != null && _playList.songs!.isNotEmpty) {
        playCount.value = (_playList.songs ?? [])
            .map((e) => e.playCount)
            .reduce((a, b) => a + b);
      }
    }
  }
}
