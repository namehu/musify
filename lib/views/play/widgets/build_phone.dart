import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/views/play/play_controller.dart';
import 'package:musify/widgets/keep_alive_wrapper.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/m_text.dart';
import 'package:musify/widgets/music/lyric_reader.dart';
import 'package:musify/widgets/music/music_seek_bar.dart';
import 'package:musify/widgets/music/operation_icons.dart';
import 'package:musify/widgets/music/player_contro_bar.dart';

class BuildPhone extends GetView<PlayController> {
  const BuildPhone({super.key});
  final double _commonPadding = 30;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (ctx, orientation) {
        // 横屏
        if (orientation == Orientation.landscape) {
          return Column(
            children: [
              _buildAppBar(orientation),
              Expanded(
                child: Row(
                  children: [
                    Expanded(flex: 1, child: _buildTabContainer()),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildSongInfo(),
                          _buildSeekBar(),
                          _buildControls(0),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }

        return Column(
          children: [
            _buildAppBar(orientation),
            Expanded(child: _buildTabContainer()),
            _buildSongInfo(),
            _buildSeekBar(),
            _buildControls(),
          ],
        );
      },
    );
  }

  _buildAppBar(Orientation orientation) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: StyleSize.space,
        vertical: orientation == Orientation.landscape ? 0 : 5,
      ),
      child: Row(
        children: [
          InkWell(
            child: Icon(
              Icons.keyboard_arrow_down,
              color: gray1,
            ),
            onTap: () {
              controller.navBack();
            },
          ),
          Expanded(
            flex: 1,
            child: Center(
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
                  tabs: controller.tabs
                      .map((e) => Tab(text: e, height: 32))
                      .toList(),
                ),
              ),
            ),
          ),
          if (orientation == Orientation.landscape)
            Expanded(
              flex: 1,
              child: Container(),
            ),
          SizedBox(width: 24),
        ],
      ),
    );
  }

  _buildTabContainer() {
    return Container(
      padding: EdgeInsets.only(
        top: StyleSize.space,
        bottom: StyleSize.space,
        left: _commonPadding,
        right: _commonPadding,
      ),
      child: TabBarView(
        controller: controller.tabController,
        children: [
          KeepAliveWrapper(child: _buildCover()),
          KeepAliveWrapper(
            child: Container(
              alignment: Alignment.center,
              child: LyricReader(),
            ),
          ),
        ],
      ),
    );
  }

  // 封面
  Widget _buildCover() {
    return Obx(() {
      var value = controller.currentSong;
      return LayoutBuilder(
        builder: (context, constraints) {
          double size = min(320, constraints.maxHeight);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size,
                child: MCover(
                  url: value.coverUrl,
                  size: size,
                  shape: MCoverShapeEnum.squareRound,
                  placeholder: Container(
                    color: gray7.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  // 歌曲信息
  _buildSongInfo() {
    return Container(
      margin: EdgeInsets.only(
        left: StyleSize.spaceLarge,
        right: StyleSize.spaceLarge,
        bottom: StyleSize.spaceLarge,
      ),
      child: Obx(
        () {
          var value = controller.currentSong;
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: StyleSize.space,
                  bottom: StyleSize.spaceSmall,
                ),
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
                      onTap: () {
                        // TODO: 详情操作
                      },
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
                              controller.navToArtist();
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
                                controller.navToAlubum();
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
          );
        },
      ),
    );
  }

  /// 进度条
  _buildSeekBar() {
    return Container(
      margin: EdgeInsets.only(
        left: StyleSize.space,
        right: StyleSize.space,
      ),
      child: MusicSeekBar(timeShow: true),
    );
  }

  _buildControls([double bottom = 48]) {
    return Container(
      margin: EdgeInsets.only(top: StyleSize.spaceLarge, bottom: bottom),
      padding: EdgeInsets.only(
        left: _commonPadding,
        right: _commonPadding,
      ),
      child: PlayerControllBar(),
    );
  }
}
