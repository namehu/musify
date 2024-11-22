import 'package:get/get.dart';
import 'package:musify/enums/tab_type_enmu.dart';

class GloabalService extends GetxService {
  /// 是否隐藏PC布局
  static final hidePCLayout = false.obs;

  /// 桌面端侧边tab激活类型
  static final tabType = TabTypeEnmu.home.obs;

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
