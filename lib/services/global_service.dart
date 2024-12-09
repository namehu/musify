import 'package:get/get.dart';
import 'package:musify/enums/tab_type_enmu.dart';
import 'package:musify/routes/pages.dart';

class GloabalService extends GetxService {
  /// 是否隐藏PC布局
  static final hidePCLayout = false.obs;

  /// 桌面端侧边tab激活类型
  static final tabType = TabTypeEnmu.home.obs;

  /// 桌面端侧边tab激活类型
  static final tabTypeMap = <TabTypeEnmu, String>{
    TabTypeEnmu.home: Routes.HOME,
    TabTypeEnmu.playList: Routes.PLAY_LIST,
    TabTypeEnmu.favorite: Routes.FAVORITE,
    TabTypeEnmu.artist: Routes.ARTISTS,
    TabTypeEnmu.album: Routes.ALBUM_LIST,
    TabTypeEnmu.genres: Routes.GENRE,
    TabTypeEnmu.setting: Routes.SETTING,
    TabTypeEnmu.allSong: Routes.SONG_LIST,
  };

  void restartApp() {
    Get.forceAppUpdate();
    // navigatorKey.currentState!
    //     .pushNamedAndRemoveUntil(Routes.HOME, (route) => false);
  }

  /// 内容区最大宽度
  static final double contentMaxWidth = GetPlatform.isMobile ? Get.width : 564;

  Future<GloabalService> init() async {
    return this;
  }
}
