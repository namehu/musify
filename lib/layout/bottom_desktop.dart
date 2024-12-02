import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/widgets/m_cover.dart';
import '../util/mycss.dart';
import '../widgets/music/music_seek_bar.dart';
import '../widgets/music/player_contro_bar.dart';
import '../widgets/music/player_volume_bar.dart';
import 'play_desktop.dart';

class BottomDesktop extends StatefulWidget {
  const BottomDesktop({super.key});
  @override
  State<BottomDesktop> createState() => _BottomDesktopState();
}

class _BottomDesktopState extends State<BottomDesktop>
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
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Obx(
                      () {
                        var csong = audioPlayerService.currentSong.value;
                        return Row(
                          children: [
                            InkWell(
                                onTap: () async {
                                  //正在播放的弹窗入口

                                  await showMaterialModalBottomSheet(
                                    context: context,
                                    isDismissible: false,
                                    builder: (BuildContext ctx) =>
                                        PlayDesktop(),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  height: bottomImageWidthAndHeight,
                                  width: bottomImageWidthAndHeight,
                                  child: csong.coverUrl.isEmpty
                                      ? SvgPicture.asset(
                                          'assets/images/icon_music.svg',
                                          semanticsLabel: 'Acme Logo')
                                      : MCover(
                                          url: csong.coverUrl,
                                          size: bottomImageWidthAndHeight),
                                )),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  // TODO: 跳转到歌曲详情页
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildOverflowTitle(csong.title),
                                    _buildOverflowTitle(csong.artist),
                                    _buildOverflowTitle(csong.album),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: PlayerControllBar(
                        dark: true,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: PlayerVolumeBar(
                      dark: true,
                    ),
                  ),
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
