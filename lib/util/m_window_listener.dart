import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:musify/constant.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:window_manager/window_manager.dart';

class MWindowListener with WindowListener {
  @override
  void onWindowResize() {
    super.onWindowResize();

    var context = navigatorKey.currentState?.context;
    if (context != null) {
      windowsWidth.value = MediaQuery.of(Get.context!).size.width;
      windowsHeight.value = MediaQuery.of(Get.context!).size.height;
    }
  }
}
