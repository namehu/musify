import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/server_service.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../screens/myAppBar.dart';
import '../../util/roter.dart';
import 'home_controller.dart';

class HomeViewPC extends GetView<HomeController> {
  final serverService = Get.find<ServerService>();
  final player = AudioPlayerService.player;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> myLeftStateKey = GlobalKey<ScaffoldState>();

    windowsWidth.value = MediaQuery.of(context).size.width;
    windowsHeight.value = MediaQuery.of(context).size.height;
    return Scaffold(
      key: myLeftStateKey,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          MyAppBar(),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: windowsWidth.value - drawerWidth,
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
          // BottomScreen(),
        ],
      ),
    );
  }
}
