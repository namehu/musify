import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/widgets/m_toast.dart';
import 'audio_player_service.dart';

/// 专辑服务
class AlbumServrice extends GetxService {
  Future<AlbumServrice> init() async {
    return this;
  }

  /// 播放专辑
  playAlbum(String id) async {
    Albums? albumsData = await MRequest.api.getAlbum(id);

    if (albumsData != null) {
      if (albumsData.song.isEmpty) {
        MToast.show(S.current.noSong);
      } else {
        Get.find<AudioPlayerService>().palySongList(albumsData.song);
      }
    } else {
      MToast.warning(S.current.noSong);
    }
  }
}
