import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/views/home/widgets/home_tab_two.dart';
import 'package:musify/widgets/keep_alive_wrapper.dart';
import 'home_controller.dart';
import 'package:musify/services/server_service.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import 'widgets/home_tab_one.dart';

class HomeViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }
}

class HomeView extends GetResponsiveView<HomeController> {
  final serverService = Get.find<ServerService>();

  HomeView({super.key});

  @override
  Widget desktop() {
    final GlobalKey<ScaffoldState> myLeftStateKey = GlobalKey<ScaffoldState>();

    windowsWidth.value = MediaQuery.of(screen.context).size.width;
    windowsHeight.value = MediaQuery.of(screen.context).size.height;
    return Scaffold(
      key: myLeftStateKey,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: windowsWidth.value - drawerWidth,
        child: Obx(
          () {
            var isNotEmpty = serverService.serverInfo.value.baseurl.isNotEmpty;
            return isNotEmpty ? HomeTabOne() : Container();
          },
        ),
      ),
    );
  }

  @override
  Widget phone() {
    List<Widget> tabs = [
      Icon(Icons.search),
      Icon(Icons.music_note),
    ];

    return Scaffold(
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
                controller: controller.tabController,
                dividerHeight: 0,
                tabs: tabs,
              ),
            )
          ],
        ),
        actions: [
          SizedBox(
            width: 56,
            child: IconButton(
              onPressed: () => Get.toNamed(Routes.SETTING),
              icon: Icon(Icons.settings, size: 20),
            ),
          )
        ],
      ),
      body: _buildTabView(),
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
        return TabBarView(
          controller: controller.tabController,
          children: [
            KeepAliveWrapper(child: HomeTabOne()),
            KeepAliveWrapper(child: HomeTabTwo(controller: controller)),
          ],
        );
      },
    );
  }
}
