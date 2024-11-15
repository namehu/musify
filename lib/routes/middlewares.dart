import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/music_bar_service.dart';
import 'package:musify/util/mycss.dart';

/// 音乐播放器中间件
/// 用于控制显示 隐藏 音乐栏
class MusicBarMiddleware extends GetMiddleware {
  static bool inited = false;

  List<String> hiddenRoutes = [
    Routes.SETTING,
    Routes.LOGIN,
    Routes.PLAY,
  ]; // 需要隐藏的路由

  @override
  RouteSettings? redirect(String? route) {
    // final authService = MusicBarService.show();
    if (isMobile) {
      if (inited) {
        var hide = hiddenRoutes.firstWhereOrNull((el) => el == route);

        if (hide == null) {
          MusicBarService.show();
        } else {
          MusicBarService.hide();
        }
      } else {
        MusicBarMiddleware.inited = true;
      }
    }

    return null;
  }

  @override
  onPageDispose() {
    if (isMobile) {
      // 这里有点慢
      var show = hiddenRoutes.every((el) => el != Get.previousRoute);

      if (show) {
        MusicBarService.show();
      } else {
        MusicBarService.hide();
      }
    }
  }
}
