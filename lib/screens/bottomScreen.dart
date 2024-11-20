import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/constant.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import '../models/notifierValue.dart';
import '../util/mycss.dart';
import '../widgets/music/music_seek_bar.dart';
import 'components/myAudio/playerControBar.dart';
import 'components/myAudio/playerVolumeBar.dart';
import 'layout/playScreen.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({Key? key}) : super(key: key);
  @override
  _BottomScreenState createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen>
    with TickerProviderStateMixin {
  final AudioPlayer player = AudioPlayerService.player;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: bottomHeight,
        color: ThemeService.color.bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 进度条
            Container(
              // height: 10,
              child: MusicSeekBar(
                padding: 5,
                dotSize: 5,
              ),
              // child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     StreamBuilder<PositionData>(
              //       stream: audioPlayerService.positionDataStream,
              //       builder: (context, snapshot) {
              //         final positionData = snapshot.data;
              //         if (positionData != null &&
              //             activeSong.value.isNotEmpty &&
              //             (positionData.duration.inMilliseconds -
              //                         positionData.position.inMilliseconds <
              //                     20000 &&
              //                 positionData.duration.inMilliseconds -
              //                         positionData.position.inMilliseconds >
              //                     19800)) {
              //           scrobble(activeSong.value["value"], true);
              //         }

              //         return PlayerSeekBar(
              //           trackWidth: windowsWidth.value,
              //           duration: positionData?.duration ?? Duration.zero,
              //           position: positionData?.position ?? Duration.zero,
              //           bufferedPosition:
              //               positionData?.bufferedPosition ?? Duration.zero,
              //           onChangeEnd: player.seek,
              //         );
              //       },
              //     ),
              //   ],
              // ),
            ),
            Expanded(
              // height: 70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 歌曲区域
                  Container(
                      width: windowsWidth.value / 4,
                      child: ValueListenableBuilder<Map>(
                        valueListenable: activeSong,
                        builder: (context, _song, child) {
                          return Row(
                            children: [
                              InkWell(
                                  onTap: () async {
                                    //正在播放的弹窗入口
                                    showBottomSheet(
                                      constraints: BoxConstraints(
                                        maxWidth: windowsWidth.value,
                                      ),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PlayScreen(player: player);
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    height: bottomImageWidthAndHeight,
                                    width: bottomImageWidthAndHeight,
                                    child: (_song.isEmpty)
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Image.asset(mylogoAsset))
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: CachedNetworkImage(
                                              imageUrl: _song["url"],
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) {
                                                return AnimatedSwitcher(
                                                  child:
                                                      Image.asset(mylogoAsset),
                                                  duration: const Duration(
                                                      milliseconds: imageMilli),
                                                );
                                              },
                                            )),
                                  )),
                              InkWell(
                                  onTap: () {
                                    if (_song.isNotEmpty) {
                                      activeID.value = _song["albumId"];
                                      indexValue.value = 8;
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth:
                                                windowsWidth.value / 4 - 70),
                                        child: Text(
                                            _song.isEmpty ? "" : _song["title"],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: nomalText),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth:
                                                windowsWidth.value / 4 - 70),
                                        child: Text(
                                            _song.isEmpty
                                                ? ""
                                                : _song["artist"],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: subText),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth:
                                                windowsWidth.value / 4 - 70),
                                        child: Text(
                                            _song.isEmpty ? "" : _song["album"],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: subText),
                                      )
                                    ],
                                  ))
                            ],
                          );
                        },
                      )),
                  Container(
                    width: windowsWidth.value / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PlayerControBar(isPlayScreen: false, player: player),
                      ],
                    ),
                  ),
                  PlayerVolumeBar(player)
                ],
              ),
            )
          ],
        ));
  }
}
