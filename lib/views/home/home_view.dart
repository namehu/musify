import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/views/home/widgets/home_tab_view.dart';
import 'package:musify/widgets/keep_alive_wrapper.dart';
import 'home_controller.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/server_service.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import 'widgets/home_view_pc.dart';

class HomeViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }
}

class HomeView extends GetResponsiveView<HomeController> {
  final serverService = Get.find<ServerService>();
  final player = AudioPlayerService.player;

  HomeView({super.key});

  @override
  Widget desktop() {
    final GlobalKey<ScaffoldState> myLeftStateKey = GlobalKey<ScaffoldState>();

    windowsWidth.value = MediaQuery.of(screen.context).size.width;
    windowsHeight.value = MediaQuery.of(screen.context).size.height;
    return Scaffold(
      key: myLeftStateKey,
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          SizedBox(
            width: windowsWidth.value - drawerWidth,
            child: Obx(
              () {
                var isNotEmpty =
                    serverService.serverInfo.value.baseurl.isNotEmpty;
                return isNotEmpty ? IndexScreen() : Container();
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget phone() {
    List<Widget> tabs = [
      Icon(Icons.search),
      Icon(Icons.music_note),
    ];
    return DefaultTabController(
      initialIndex: 1,
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: Container(width: 56),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: appBarHeight,
                child: TabBar(
                  dividerHeight: 0,
                  labelPadding: EdgeInsets.only(bottom: 5),
                  unselectedLabelColor: gray1,
                  tabs: tabs,
                ),
              )
            ],
          ),
          actions: [
            SizedBox(
              width: 56,
              child: IconButton(
                onPressed: () {
                  Get.toNamed(Routes.SETTING);
                },
                icon: Icon(
                  Icons.settings,
                  size: 20,
                ),
              ),
            )
          ],
        ),
        // drawer: LeftDrawer(),
        body: _buildTabView(),
      ),
    );
  }

  _buildTabView() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          if (windowsWidth.value < windowsHeight.value) {
            double tem = windowsWidth.value;
            windowsWidth.value = windowsHeight.value;
            windowsHeight.value = tem;
          }
        }
        if (orientation == Orientation.portrait) {
          if (windowsWidth.value > windowsHeight.value) {
            double tem = windowsWidth.value;
            windowsWidth.value = windowsHeight.value;
            windowsHeight.value = tem;
          }
        }
        return TabBarView(children: [
          KeepAliveWrapper(child: IndexScreen()),
          KeepAliveWrapper(child: HomeTabView(controller: controller)),
        ]);
      },
    );
  }
}
