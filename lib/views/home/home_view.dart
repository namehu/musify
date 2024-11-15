import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/widgets/music_bar/music_bar.dart';
import 'home_controller.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/server_service.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../screens/myAppBar.dart';
import '../../screens/leftScreen.dart';
import './widgets/roter.dart';

class HomeViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }
}

class HomeView extends GetView<HomeController> {
  final serverService = Get.find<ServerService>();
  final player = AudioPlayerService.player;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> myLeftStateKey = GlobalKey<ScaffoldState>();

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
              MyAppBar(
                drawer: () => myLeftStateKey.currentState?.openDrawer(),
              ),
              Expanded(
                // height: windowsHeight.value - bottomHeight - appBarHeight,
                child: Row(
                  children: [
                    Container(
                      width: isMobile
                          ? windowsWidth.value
                          : windowsWidth.value - drawerWidth,
                      // color: bkColor,
                      child: Obx(() {
                        var isNotEmpty =
                            serverService.serverInfo.value.baseurl.isNotEmpty;
                        return isNotEmpty
                            ? Container(
                                child: ValueListenableBuilder<int>(
                                    valueListenable: indexValue,
                                    builder: ((context, value, child) =>
                                        Roter(roter: value, player: player))))
                            : Container();
                      }),
                    )
                  ],
                ),
              ),
              Container(
                height: bottomHeight,
                child: MusicBar(),
              ),
            ],
          );
        },
      ),
    );
  }
}
