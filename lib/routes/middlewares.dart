import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/enums/tab_type_enmu.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/global_service.dart';
import 'package:musify/services/music_bar_service.dart';
import 'package:musify/util/mycss.dart';

List<String> _hiddenRoutes = [
  Routes.SETTING,
  Routes.CHANGE_SERVER,
  Routes.LOGIN,
  Routes.PLAY,
  Routes.PLAY_LIST_MODAL,
  Routes.PLAY_DETAIL_MODAL,
]; //

bool inited = false;

/// 切换音乐栏显示与否
toggleMusicBar(Routing? routing) {
  var route = routing?.current;
  if (route != null && isMobile) {
    var hide = _hiddenRoutes.firstWhereOrNull((el) => el == route);
    if (!inited) {
      inited = true;
      return;
    }
    if (hide == null) {
      MusicBarService.show();
    } else {
      MusicBarService.hide();
    }
  }
}

/// 路由变更更新tabbar激活栏
togglePCTabActive(Routing? routing) {
  var route = routing?.current;
  if (route != null && !isMobile) {
    if (GloabalService.tabTypeMap.containsValue(route)) {
      var key = GloabalService.tabTypeMap.entries.firstWhere((element) {
        return element.value == route;
      }).key;
      Future.delayed(Duration(milliseconds: 50), () {
        GloabalService.tabType(key);
      });
    } else {
      GloabalService.tabType(TabTypeEnmu.none);
    }
  }
}

/// 音乐播放器中间件
/// 用于控制显示 隐藏 音乐栏
class MusicBarMiddleware extends GetMiddleware {
  static bool inited = false;

  List<String> hiddenRoutes = [
    Routes.SETTING,
    Routes.CHANGE_SERVER,
    Routes.LOGIN,
    Routes.PLAY,
  ]; // 需要隐藏的路由

  // @override
  // RouteSettings? redirect(String? route) {
  // // final authService = MusicBarService.show();
  // if (isMobile) {
  //   if (inited) {
  //     var hide = hiddenRoutes.firstWhereOrNull((el) => el == route);

  //     if (hide == null) {
  //       MusicBarService.show();
  //     } else {
  //       MusicBarService.hide();
  //     }
  //   } else {
  //     MusicBarMiddleware.inited = true;
  //   }
  // }

  // return null;
  // }

  @override
  onPageDispose() {
    // if (isMobile) {
    //   // 这里有点慢
    //   var show = hiddenRoutes.every((el) => el != Get.previousRoute);

    //   if (show) {
    //     MusicBarService.show();
    //   } else {
    //     MusicBarService.hide();
    //   }
    // }
  }
}

class PCloginMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (GetPlatform.isDesktop) {
      GloabalService.hidePCLayout(true);
    }

    return null;
  }

  @override
  onPageDispose() {
    if (GetPlatform.isDesktop) {
      GloabalService.hidePCLayout(false);
    }
  }
}
