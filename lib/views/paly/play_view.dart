import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Rx;
import 'package:musify/styles/colors.dart';
import 'package:musify/widgets/music/lyric_reader.dart';
import 'package:musify/views/paly/widgets/player_control_bar.dart';
import 'package:musify/widgets/music/music_seek_bar.dart';
import 'package:musify/widgets/music/operation_icons.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/views/paly/widgets/cover.dart';
import 'package:musify/widgets/keep_alive_wrapper.dart';
import 'package:musify/widgets/m_cover.dart';
import '../../generated/l10n.dart';
import '../../models/notifierValue.dart';
import 'play_controller.dart';

class PlayBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayController>(() => PlayController());
  }
}

class PlayView extends GetView<PlayController> {
  final double _appBarHeight = 96;

  final double commonPadding = 30;
  final List<String> tabs = ["歌曲", "歌词"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildTabTitle(),
        body: Stack(
          children: <Widget>[
            _buildBackendCover(),
            _buidMain(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTabTitle() {
    return PreferredSize(
      preferredSize: Size.fromHeight(_appBarHeight),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.keyboard_arrow_down,
            )),
        title: Center(
          child: Container(
            width: 190,
            child: TabBar(
              dividerHeight: 0,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ThemeService.color.primaryColor,
                    width: 4,
                  ),
                ),
              ),
              // dividerColor: ThemeService.color.primaryColor,
              tabs: tabs.map((e) => Tab(text: e, height: 32)).toList(),
            ),
          ),
        ),
        actions: [SizedBox(width: 24)],
      ),
    );
  }

  Widget _buildBackendCover() {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Obx(
        () {
          var song = controller.audioPlayerService.currentSong.value;
          return MCover(url: song.id.isNotEmpty ? song.coverUrl : '');
        },
      ),
    );
  }

  Widget _buidMain() {
    return SizedBox.expand(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          padding: EdgeInsets.only(top: _appBarHeight),
          child: Column(
            children: [
              _buildTabBarView(),
              // 进度条
              Container(
                margin: EdgeInsets.only(top: 32),
                padding: EdgeInsets.only(left: 15, right: 15),
                child: MusicSeekBar(timeShow: true),
              ),
              Container(
                margin: EdgeInsets.only(top: 48, bottom: 48),
                padding:
                    EdgeInsets.only(left: commonPadding, right: commonPadding),
                child: PlayerControlBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    List<Widget> children = [];

    for (var i = 0; i < tabs.length; i++) {
      if (i == 0) {
        children.add(KeepAliveWrapper(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildHeader(),
          ],
        )));
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
        padding: EdgeInsets.only(left: commonPadding, right: commonPadding),
        child: TabBarView(children: children),
      ),
    );
  }

  Widget _buildHeader() {
    return ValueListenableBuilder<Map>(
      valueListenable: activeSong,
      builder: ((context, value, child) {
        return Container(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlayCoverWidget(url: value.isNotEmpty ? value["url"] : ''),
              Container(
                margin: EdgeInsets.only(
                    top: StyleSize.space, bottom: StyleSize.spaceSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (value.isEmpty) ? S.current.unknown : value["title"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: gray1,
                      ),
                    ),
                    InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.more_vert,
                          color: ThemeService.color.iconColor,
                        ))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: StyleSize.spaceSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (value.isEmpty) ? S.current.unknown : value["artist"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: gray1),
                    ),
                    PlayStarIcon(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
