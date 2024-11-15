import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_ui/ui_netease.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:flutter_lyric/lyrics_reader_widget.dart';
import 'package:get/get.dart' hide Rx;
import 'package:musify/models/myModel.dart';
import 'package:musify/screens/components/myAudio/playerControBar.dart';
import 'package:musify/screens/components/myAudio/playerSeekBar.dart';
import 'package:musify/screens/components/myAudio/playerVolumeBar.dart';
import 'package:musify/util/util.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:rxdart/rxdart.dart';
import '../../generated/l10n.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import 'play_controller.dart';

class PlayBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayController>(() => PlayController());
  }
}

class PlayView extends GetView<PlayController> {
  final lyricPadding = 40.0;
  final playing = true;

  Widget _buildReaderWidget() {
    return ValueListenableBuilder<String>(
        valueListenable: activeLyric,
        builder: ((context, value, child) {
          var _model =
              LyricsModelBuilder.create().bindLyricToMain(value).getModel();
          return StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                final position = positionData?.position.inMilliseconds ?? 0;

                return LyricsReader(
                  padding: EdgeInsets.symmetric(horizontal: lyricPadding),
                  model: _model,
                  position: position,
                  lyricUi: controller.lyricUI,
                  playing: playing,
                  size: !isMobile
                      ? Size(windowsWidth.value / 2, windowsHeight.value - 350)
                      : Size(windowsWidth.value, windowsHeight.value - 385),
                  emptyBuilder: () => Center(
                    child: Text(
                      S.current.no + S.current.lyric,
                      style: controller.lyricUI.getOtherMainTextStyle(),
                    ),
                  ),
                  selectLineBuilder: (progress, confirm) {
                    return Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              confirm.call();
                              //setState(() {
                              controller.player
                                  .seek(Duration(milliseconds: progress));
                              controller.lyricUI =
                                  UINetease.clone(controller.lyricUI);
                              // });
                            },
                            icon: Icon(Icons.play_arrow, color: textGray)),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: textGray),
                            height: 1,
                            width: double.infinity,
                          ),
                        ),
                        Text(
                          formatDurationMilliseconds(progress),
                          style: TextStyle(color: textGray),
                        )
                      ],
                    );
                  },
                );
              });
        }));
  }

  Stream<PositionData> get _positionDataStream {
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        controller.player.positionStream,
        controller.player.bufferedPositionStream,
        controller.player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
            position, bufferedPosition, duration ?? Duration.zero));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBackendCover(),
          _buidMain(),
        ],
      ),
    );
  }

  Widget _buildBackendCover() {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: ValueListenableBuilder<Map>(
        valueListenable: activeSong,
        builder: ((context, value, child) => MCover(url: value["url"])),
      ),
    );
  }

  Widget _buidMain() {
    return SizedBox.expand(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          child: Column(
            children: [
              _buildHeader(),
              Container(height: 50, child: PlayerVolumeBar(controller.player)),
              Container(
                  height: 5,
                  child: StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;

                      return PlayerSeekBar(
                        trackWidth: windowsWidth.value,
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        bufferedPosition:
                            positionData?.bufferedPosition ?? Duration.zero,
                        onChangeEnd: controller.player.seek,
                      );
                    },
                  )),
              SizedBox(height: 5),
              Container(
                height: 60,
                child: PlayerControBar(
                  isPlayScreen: true,
                  player: controller.player,
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    double _width = windowsWidth.value;
    return ValueListenableBuilder<Map>(
      valueListenable: activeSong,
      builder: ((context, value, child) {
        return Container(
          width: _width,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                height: windowsHeight.value - 80 - 50 - 25,
                width: _width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 50,
                      width: _width,
                      child: Text(
                          (value.isEmpty) ? S.current.unknown : value["title"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: titleText2),
                    ),
                    Container(
                        width: _width,
                        child: Text(
                          (value.isEmpty)
                              ? S.current.unknown
                              : S.current.artist + ": " + value["artist"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: nomalText,
                          textAlign: TextAlign.center,
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        width: !isMobile ? _width / 2 : _width,
                        child: Text(
                          (value.isEmpty)
                              ? S.current.unknown
                              : S.current.album + ": " + value["album"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: nomalText,
                          textAlign: TextAlign.center,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    _buildReaderWidget()
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
