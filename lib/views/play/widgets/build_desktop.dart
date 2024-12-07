import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/enums/size_enums.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/views/play/play_controller.dart';
import 'package:musify/widgets/keep_alive_wrapper.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/m_tag.dart';
import 'package:musify/widgets/m_text.dart';
import 'package:musify/widgets/music/lyric_reader.dart';
import 'package:musify/widgets/music/music_seek_bar.dart';
import 'package:musify/widgets/music/player_contro_bar.dart';

class BuildDeskTop extends GetView<PlayController> {
  const BuildDeskTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(context),
        Expanded(child: _buildTabContainer()),
        _buildSeekBar(),
        _buildControls(),
      ],
    );
  }

  _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: StyleSize.space,
        vertical: StyleSize.space,
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
          SizedBox(width: 24),
        ],
      ),
    );
  }

  _buildTabContainer() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: KeepAliveWrapper(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildCover(),
                ),
                _buildSongInfo(),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: KeepAliveWrapper(
            child: Container(
              alignment: Alignment.center,
              child: LyricReader(),
            ),
          ),
        ),
      ],
    );
  }

  // 封面
  Widget _buildCover() {
    return Obx(() {
      var value = controller.currentSong;
      return LayoutBuilder(
        builder: (context, constraints) {
          double size = min(constraints.maxWidth, constraints.maxHeight) / 1.2;
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
        margin: EdgeInsets.all(StyleSize.spaceLarge),
        child: LayoutBuilder(builder: (ctx, constraints) {
          return Obx(
            () {
              var value = controller.currentSong;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MText(
                    text:
                        (value.title.isEmpty) ? S.current.unknown : value.title,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: gray1,
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: GestureDetector(
                      onTap: () {
                        controller.navToAlubum();
                      },
                      child: Text(
                        value.album.isEmpty ? '-' : value.album,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: gray1,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    constraints: constraints,
                    margin: EdgeInsets.symmetric(
                      vertical: StyleSize.spaceSmall,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth / 2),
                          child: GestureDetector(
                            onTap: () {
                              controller.navToArtist();
                            },
                            child: Text(
                              (value.artist.isEmpty) ? '-' : value.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: gray1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32,
                    child: (value.id.isNotEmpty)
                        ? MTag(
                            size: SizeEnum.normal,
                            radius: 12,
                            child: Text(
                              '${value.suffix}  ${value.bitRate.toString()}',
                            ),
                          )
                        : null,
                  )
                ],
              );
            },
          );
        }));
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

  _buildControls() {
    return SizedBox(
      height: 80,
      child: PlayerControllBar(),
    );
  }
}
