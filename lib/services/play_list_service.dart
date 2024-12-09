import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/play_list.dart';
import 'package:musify/widgets/m_toast.dart';
import '../widgets/dialogs/play_list_dialog.dart';

class PlayListService extends GetxService {
  RxList<Playlist> playList = <Playlist>[].obs;

  Future<PlayListService> init() async {
    return this;
  }

  /// 获取列表
  getPlayList() async {
    var res = await MRequest.api.getPlaylists();
    playList(res);
  }

  /// 创建播放列表
  addPlayList() async {
    var res = await showPlayListDialog();
    if (res == 1) {
      getPlayList();
    }
  }

  /// 删除播放列表
  deletePlayList(String id) async {
    await MRequest.api.deletePlaylist(id);
    getPlayList();
    MToast.success(S.current.delete + S.current.success);
  }
}
