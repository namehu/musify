import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/views/home/widgets/home_tab_view.dart';
import 'package:musify/widgets/keep_alive_wrapper.dart';
import 'home_controller.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/server_service.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../screens/leftScreen.dart';
import './widgets/roter.dart';
import 'widgets/app_bar.dart';

class HomeViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }
}

class HomeView extends GetResponsiveView<HomeController> {
  final serverService = Get.find<ServerService>();
  final player = AudioPlayerService.player;

  @override
  Widget phone() {
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
                  unselectedLabelColor: gray1,
                  tabs: [
                    Icon(Icons.search),
                    Icon(Icons.music_note),
                  ],
                ),
              )
            ],
          ),
          actions: [SizedBox(width: 56)],
        ),
        drawer: LeftScreen(),
        body: _buildTabView(),
      ),
    );
  }

  @override
  Widget desktop() {
    final GlobalKey<ScaffoldState> myLeftStateKey = GlobalKey<ScaffoldState>();

    windowsWidth.value = MediaQuery.of(screen.context).size.width;
    windowsHeight.value = MediaQuery.of(screen.context).size.height;
    return Scaffold(
      key: myLeftStateKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HomeAppBar(),
      ),
      body: Row(
        children: [
          Container(
            width: windowsWidth.value - drawerWidth,
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
          )
        ],
      ),
    );
  }

  _buildTabView() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          if (windowsWidth.value < windowsHeight.value) {
            double _tem = windowsWidth.value;
            windowsWidth.value = windowsHeight.value;
            windowsHeight.value = _tem;
          }
        }
        if (orientation == Orientation.portrait) {
          if (windowsWidth.value > windowsHeight.value) {
            double _tem = windowsWidth.value;
            windowsWidth.value = windowsHeight.value;
            windowsHeight.value = _tem;
          }
        }
        return TabBarView(children: [
          KeepAliveWrapper(
            child: Container(
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
          KeepAliveWrapper(
            child: HomeTabView(),
          ),
        ]);
      },
    );
  }
}
