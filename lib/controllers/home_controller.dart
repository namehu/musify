import 'package:get/get.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/server_service.dart';

class HomeController extends GetxController {
  final serverService = Get.find<ServerService>();

  @override
  void onReady() {
    super.onInit();

    if (serverService.serverInfo.value.baseurl.isEmpty) {
      Get.toNamed(Routes.LOGIN);
    }
  }
}
