import 'package:get/get.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/language_service.dart';
import 'package:musify/services/music_bar_service.dart';
import 'package:musify/services/server_service.dart';

class HomeController extends GetxController {
  final serverService = Get.find<ServerService>();

  final languageService = Get.find<LanguageService>();

  get hasServer => serverService.serverInfo.value.baseurl.isNotEmpty;

  @override
  void onInit() {
    super.onInit();

    /// 加载国际化
    languageService.loadLanguage(languageService.languageCode.value);
  }

  @override
  void onReady() {
    super.onReady();

    if (!hasServer) {
      Get.toNamed(Routes.LOGIN);
    } else {
      MusicBarService.show();
    }
  }
}
