import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Rx;
import 'package:musify/views/play/widgets/build_desktop.dart';
import 'package:musify/views/play/widgets/build_phone.dart';
import 'package:musify/widgets/m_cover.dart';
import 'play_controller.dart';

class PlayBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayController>(() => PlayController());
  }
}

class PlayView extends GetResponsiveView<PlayController> {
  PlayView({super.key});

  @override
  Widget phone() {
    return Scaffold(
      body: Stack(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Obx(
              () => MCover(url: controller.currentSong.coverUrl),
            ),
          ),
          SizedBox.expand(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
                child: SafeArea(
                  child: BuildPhone(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget desktop() {
    return Scaffold(
      body: Stack(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Obx(() => MCover(url: controller.currentSong.coverUrl)),
          ),
          SizedBox.expand(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
                child: BuildDeskTop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
