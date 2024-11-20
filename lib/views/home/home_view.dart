import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/widgets/keep_alive_wrapper.dart';
import 'home_controller.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/server_service.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../screens/leftScreen.dart';
import './widgets/roter.dart';

class HomeView extends GetView<HomeController> {
  final serverService = Get.find<ServerService>();
  final player = AudioPlayerService.player;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> myLeftStateKey = GlobalKey<ScaffoldState>();
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        key: myLeftStateKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child: TabBar(
                  dividerHeight: 0,
                  labelPadding: EdgeInsets.only(bottom: 5),
                  tabs: [
                    Icon(Icons.search),
                    Icon(Icons.music_note),
                  ],
                ),
              )
            ],
          ),
          actions: [
            SizedBox(width: 56),
          ],
        ),
        drawer: LeftScreen(),
        body: _buildTabView(),
      ),
    );
  }

  _buildTabView() {
    return Expanded(
      child: OrientationBuilder(
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
          return TabBarView(children: [
            Text('1111'),
            KeepAliveWrapper(
              child: Container(
                width: windowsWidth.value,
                child: Obx(
                  () {
                    var isNotEmpty =
                        serverService.serverInfo.value.baseurl.isNotEmpty;
                    return isNotEmpty
                        ? Container(
                            child: ValueListenableBuilder<int>(
                                valueListenable: indexValue,
                                builder: ((context, value, child) =>
                                    Roter(roter: value, player: player))))
                        : Container();
                  },
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
