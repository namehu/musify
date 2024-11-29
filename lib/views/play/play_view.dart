import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Rx;
import 'package:musify/routes/pages.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/widgets/m_text.dart';
import 'package:musify/widgets/music/lyric_reader.dart';
import 'package:musify/views/play/widgets/player_control_bar.dart';
import 'package:musify/widgets/music/music_seek_bar.dart';
import 'package:musify/widgets/music/operation_icons.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/widgets/keep_alive_wrapper.dart';
import 'package:musify/widgets/m_cover.dart';
import '../../generated/l10n.dart';
import 'play_controller.dart';

class PlayBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayController>(() => PlayController());
  }
}

class PlayView extends GetResponsiveView<PlayController> {
  final double _commonPadding = 30;

  PlayView({super.key});

  @override
  Widget phone() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.keyboard_arrow_down)),
        title: Center(
          child: SizedBox(
            width: 190,
            child: TabBar(
              controller: controller.tabController,
              dividerHeight: 0,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ThemeService.color.primaryColor,
                    width: 3,
                  ),
                ),
              ),
              tabs:
                  controller.tabs.map((e) => Tab(text: e, height: 32)).toList(),
            ),
          ),
        ),
        actions: [SizedBox(width: 24)],
      ),
      body: Stack(
        children: [
          // 背景图片
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Obx(
              () {
                var song = controller.audioPlayerService.currentSong.value;
                return MCover(url: song.id.isNotEmpty ? song.coverUrl : '');
              },
            ),
          ),
          _buidMain(),
        ],
      ),
    );
  }

  Widget _buidMain() {
    return SizedBox.expand(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: EdgeInsets.only(top: 96),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          child: Column(
            children: [
              _buildTabBarView(),
              // 进度条
              Container(
                margin: EdgeInsets.only(top: StyleSize.spaceLarge),
                padding: EdgeInsets.only(left: 15, right: 15),
                child: MusicSeekBar(timeShow: true),
              ),
              Container(
                margin: EdgeInsets.only(top: 48, bottom: 48),
                padding: EdgeInsets.only(
                  left: _commonPadding,
                  right: _commonPadding,
                ),
                child: PlayerControlBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 顶部tabbar 区域
  Widget _buildTabBarView() {
    List<Widget> children = [];

    for (var i = 0; i < controller.tabs.length; i++) {
      if (i == 0) {
        children.add(KeepAliveWrapper(child: _buildHeader()));
      } else {
        children.add(KeepAliveWrapper(
          child: Container(
            alignment: Alignment.center,
            child: LyricReader(
              positionDataStream: controller.positionDataStream,
            ),
          ),
        ));
      }
    }
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          top: StyleSize.space,
          left: _commonPadding,
          right: _commonPadding,
        ),
        child: TabBarView(
          controller: controller.tabController,
          children: children,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      var value = controller.audioPlayerService.currentSong.value;
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 320,
            child: MCover(
              url: value.coverUrl,
              size: 320,
              shape: MCoverShapeEnum.squareRound,
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: StyleSize.space, bottom: StyleSize.spaceSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MText(
                        text: (value.title.isEmpty)
                            ? S.current.unknown
                            : value.title,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: gray1,
                        ),
                      ),
                    ),
                    PlayStarIcon(
                      color: gray3,
                    ),
                    SizedBox(width: StyleSize.spaceSmall),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.more_vert,
                        color: gray3,
                      ),
                    ),
                  ],
                ),
              ),
              LayoutBuilder(
                builder: (ctx, constraints) {
                  return Container(
                    constraints: constraints,
                    child: Row(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth / 2),
                          child: GestureDetector(
                            onTap: () {
                              if (value.artistId.isNotEmpty) {
                                Get.toNamed(
                                  Routes.ARTIST_DETAIL,
                                  arguments: {"id": value.artistId},
                                );
                              }
                            },
                            child: Text(
                              (value.artist.isEmpty)
                                  ? S.current.unknown
                                  : value.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: gray1),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (value.albumId.isNotEmpty) {
                                  Get.toNamed(Routes.ALBUM,
                                      arguments: {"id": value.albumId});
                                }
                              },
                              child: Text(
                                ' - ${value.album.isEmpty ? S.current.unknown : value.album}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: gray1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      );
    });
  }
}
