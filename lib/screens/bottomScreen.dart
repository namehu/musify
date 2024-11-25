import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:musify/constant.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/widgets/m_cover.dart';
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
  final AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: bottomHeight,
        color: ThemeService.color.bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 进度条
            MusicSeekBar(dotRaidus: 5),
            // 歌曲区域
            Container(
              height: 80,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Obx(
                      () {
                        var _song = audioPlayerService.currentSong.value;
                        return Row(
                          children: [
                            InkWell(
                                onTap: () async {
                                  //正在播放的弹窗入口

                                  await showMaterialModalBottomSheet(
                                    context: context,
                                    isDismissible: false,
                                    builder: (BuildContext _contenxt) =>
                                        PlayScreen(),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  height: bottomImageWidthAndHeight,
                                  width: bottomImageWidthAndHeight,
                                  child: MCover(
                                      url: _song.coverUrl,
                                      size: bottomImageWidthAndHeight),
                                )),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  // if (_song.isNotEmpty) {
                                  //   activeID.value = _song["albumId"];
                                  //   indexValue.value = 8;
                                  // }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildOverflowTitle(_song.title),
                                    _buildOverflowTitle(_song.artist),
                                    _buildOverflowTitle(_song.album),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(flex: 2, child: PlayerControBar()),
                  Expanded(flex: 1, child: PlayerVolumeBar(player))
                ],
              ),
            ),
          ],
        ));
  }

  _buildOverflowTitle(String text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 12, color: ThemeService.color.textSecondColor),
    );
  }
}
