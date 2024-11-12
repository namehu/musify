import 'package:get/get.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/language_service.dart';
import 'package:musify/services/server_service.dart';

class HomeController extends GetxController {
  final serverService = Get.find<ServerService>();
  final languageService = Get.find<LanguageService>();

  @override
  void onInit() {
    super.onInit();

    /// 加载国际化
    languageService.loadLanguage(languageService.languageCode);
  }

  @override
  void onReady() {
    super.onInit();

    if (serverService.serverInfo.value.baseurl.isEmpty) {
      Get.toNamed(Routes.LOGIN);
    }
  }
}
