import 'package:get/get.dart';
import 'home_controller.dart';

class HomeViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }
}
