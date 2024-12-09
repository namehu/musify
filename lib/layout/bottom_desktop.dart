import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/widgets/m_cover.dart';
import '../widgets/music/music_seek_bar.dart';
import '../widgets/music/player_contro_bar.dart';
import '../widgets/music/player_volume_bar.dart';

class BottomDesktop extends StatefulWidget {
  const BottomDesktop({super.key});
  @override
  State<BottomDesktop> createState() => _BottomDesktopState();
}

class _BottomDesktopState extends State<BottomDesktop>
    with TickerProviderStateMixin {
  final AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ThemeService.color.bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 进度条
            MusicSeekBar(
              dotRaidus: 5,
              timeShow: false,
            ),
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
                        return InkWell(
                          onTap: () {
                            AudioPlayerService.showPlayView();
                          },
                          child: Row(
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: ThemeService.color.secondBgColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: ThemeService.color.borderColor,
                                        blurRadius: 5,
                                      )
                                    ],
                                  ),
                                  child: csong.coverUrl.isEmpty
                                      ? Container(
                                          padding: EdgeInsets.all(10),
                                          child: SvgPicture.asset(
                                            'assets/images/icon_bottom_icon.svg',
                                          ),
                                        )
                                      : MCover(
                                          url: csong.coverUrl,
                                          size: 60,
                                        ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildOverflowTitle(
                                        csong.title,
                                        fontSize: 14,
                                        color: ThemeService.color.textColor,
                                      ),
                                      _buildOverflowTitle(
                                        csong.artist,
                                        onTap: () => {
                                          Get.toNamed(
                                            Routes.ARTIST_DETAIL,
                                            arguments: {"id": csong.artistId},
                                          )
                                        },
                                      ),
                                      _buildOverflowTitle(
                                        csong.album,
                                        onTap: () => {
                                          Get.toNamed(
                                            Routes.ALBUM,
                                            arguments: {"id": csong.albumId},
                                          )
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
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

  _buildOverflowTitle(
    String text, {
    double? fontSize = 12,
    Color? color,
    void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          color: color ?? ThemeService.color.textSecondColor,
        ),
      ),
    );
  }
}
