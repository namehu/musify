import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Rx;
import 'package:musify/models/myModel.dart';
import 'package:musify/util/httpclient.dart';
import 'package:musify/views/paly/widgets/lyric_reader.dart';
import 'package:musify/views/paly/widgets/player_control_bar.dart';
import 'package:musify/widgets/m_star_toogle.dart';
import 'package:musify/widgets/music/music_seek_bar.dart';
import './widgets/seek_bar.dart';
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
      child: ValueListenableBuilder<Map>(
        valueListenable: activeSong,
        builder: ((context, value, child) =>
            MCover(url: value.isNotEmpty ? value["url"] : '')),
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
                child: MusicSeekBar(timeShow: true, padding: 30),
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
              lyricUI: controller.lyricUI,
              onLyricUIChange: (ui) => controller.lyricUI = ui,
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    InkWell(onTap: () {}, child: Icon(Icons.more_vert))
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
                    ),
                    ValueListenableBuilder<Map>(
                      valueListenable: activeSong,
                      builder: (context, _song, child) {
                        var value = (_song.isNotEmpty && _song["starred"])
                            ? true
                            : false;

                        return MStarToogle(
                            value: value,
                            size: 24,
                            onChange: (val) async {
                              if (_song.isNotEmpty) {
                                Favorite _favorite =
                                    Favorite(id: _song["value"], type: 'song');

                                value
                                    ? await delStarred(_favorite)
                                    : await addStarred(_favorite);

                                // activeSong.value["starred"] = !value;
                                activeSong.value = Map.from(
                                  activeSong.value..addAll({"starred": !value}),
                                );
                              }
                            });
                      },
                    )
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
