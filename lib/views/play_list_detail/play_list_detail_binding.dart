import 'package:get/get.dart';
import 'play_list_detail_controller.dart';

class PlayListDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayListDetailController());
  }
}
