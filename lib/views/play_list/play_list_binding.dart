import 'package:get/get.dart';
import 'package:musify/views/play_list/play_list_controller.dart';

class PlayListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayListController());
  }
}
