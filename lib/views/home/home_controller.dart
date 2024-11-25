import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/models/play_list.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/language_service.dart';
import 'package:musify/services/music_bar_service.dart';
import 'package:musify/services/server_service.dart';
import 'package:musify/util/mycss.dart';

class HomeController extends GetxController {
  final serverService = Get.find<ServerService>();

  final languageService = Get.find<LanguageService>();

  RxList<Playlist> playList = <Playlist>[].obs;

  get hasServer => serverService.serverInfo.value.baseurl.isNotEmpty;

  @override
  void onInit() {
    super.onInit();

    languageService.loadLanguage(languageService.languageCode.value); // 加载国际化
  }

  @override
  void onReady() {
    super.onReady();

    MusicBarService.show();

    if (!hasServer) {
      Get.toNamed(Routes.LOGIN);
    } else {
      onFinishLogin();
    }
  }

  onFinishLogin() {
    if (isMobile) {
      _getPlaylists();
    }
  }

  _getPlaylists() async {
    playList.value = await MRequest.api.getPlaylists();
  }
}
