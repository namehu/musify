import 'package:get/get.dart';

class GloabalService extends GetxService {
  static final hidePCLayout = false.obs;

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
