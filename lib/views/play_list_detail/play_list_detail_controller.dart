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

    var id = Get.arguments?['id'];
    if (id != null) {
      _getData(id);
    }
  }

  _getData(String id) async {
    var playListRes = await MRequest.api.getPlaylist(id);

    if (playListRes != null) {
      songslist.value = playListRes.songs ?? [];
      songsNum.value = playListRes.songCount;
      name.value = playListRes.name;
      duration.value = playListRes.duration;
      coverUrl.value = playListRes.imageUrl;

      if (playListRes.songs != null && playListRes.songs!.isNotEmpty) {
        playCount.value = (playListRes.songs ?? [])
            .map((e) => e.playCount)
            .reduce((a, b) => a + b);
      }
    }
  }
}
