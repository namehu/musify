import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/controllers/home_controller.dart';
// import 'package:get/get.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/server_service.dart';
import 'models/notifierValue.dart';
import 'util/mycss.dart';
import 'screens/bottomScreen.dart';
import 'screens/myAppBar.dart';
import 'screens/leftScreen.dart';
import 'util/roter.dart';

class HomeViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }
}

class MainScreen extends GetView<HomeController> {
  final serverService = Get.find<ServerService>();
  final player = AudioPlayerService.player;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> myLeftStateKey = GlobalKey<ScaffoldState>();

    _drawer() {
      myLeftStateKey.currentState?.openDrawer();
    }

    //当不是移动端的时候使用这个可以动态监听窗体变化
    //如果是移动端的话，窗体不会变化
    if (!isMobile) {
      windowsWidth.value = MediaQuery.of(context).size.width;
      windowsHeight.value = MediaQuery.of(context).size.height;
    }

    return Scaffold(
      key: myLeftStateKey,
      resizeToAvoidBottomInset: false,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: drawerWidth),
        child: LeftScreen(),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (isMobile && orientation == Orientation.landscape) {
            if (windowsWidth.value < windowsHeight.value) {
              double _tem = windowsWidth.value;
              windowsWidth.value = windowsHeight.value;
              windowsHeight.value = _tem;
            }
          }
          if (isMobile && orientation == Orientation.portrait) {
            if (windowsWidth.value > windowsHeight.value) {
              double _tem = windowsWidth.value;
              windowsWidth.value = windowsHeight.value;
              windowsHeight.value = _tem;
            }
          }
          return Column(
            children: [
              if (isMobile)
                Container(
                  height: topSafeheight,
                  color: bkColor,
                ),
              MyAppBar(
                drawer: () => _drawer(),
              ),
              Container(
                  height: (isMobile)
                      ? windowsHeight.value -
                          bottomHeight -
                          appBarHeight -
                          safeheight
                      : windowsHeight.value - bottomHeight - appBarHeight,
                  child: Row(
                    children: [
                      if (!isMobile)
                        Container(
                          width: drawerWidth,
                          child: LeftScreen(),
                        ),
                      Container(
                        width: isMobile
                            ? windowsWidth.value
                            : windowsWidth.value - drawerWidth,
                        color: bkColor,
                        child: Obx(() {
                          var isNotEmpty =
                              serverService.serverInfo.value.baseurl.isNotEmpty;
                          return isNotEmpty
                              ? Container(
                                  child: ValueListenableBuilder<int>(
                                      valueListenable: indexValue,
                                      builder: ((context, value, child) {
                                        return Roter(
                                            roter: value, player: player);
                                      })))
                              : Text('111');
                        }),
                      )
                    ],
                  )),
              Container(
                  height: bottomHeight,
                  width: windowsWidth.value,
                  child: Column(
                    children: [
                      BottomScreen(player: player),
                    ],
                  )),
              if (isMobile)
                Container(
                  height: bottomSafeheight,
                  color: bkColor,
                ),
            ],
          );
        },
      ),
    );
  }
}
