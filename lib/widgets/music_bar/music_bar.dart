import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/music_bar/icon_play_list.dart';
import 'icon_play_control.dart';

class MusicBar extends StatefulWidget {
  const MusicBar({super.key});

  @override
  State<MusicBar> createState() => _MusicBarState();
}

class _MusicBarState extends State<MusicBar> {
  final audioPlayerService = Get.find<AudioPlayerService>();

  handleToPlay() {
    AudioPlayerService.showPlayView();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.transparent,
      padding: EdgeInsets.only(left: 32, right: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: ThemeService.color.dialogBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: gray7,
                  blurRadius: 2,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    handleToPlay();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5, right: 10),
                    child: Obx(() {
                      return MCover(
                        url: audioPlayerService.currentSong.value.coverUrl,
                        imagePlaceholder: false,
                        size: audioPlayerService
                                .currentSong.value.coverUrl.isEmpty
                            ? 0
                            : 50,
                        shape: MCoverShapeEnum.round,
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(builder: (ctx, constraints) {
                    return Container(
                      constraints: constraints,
                      child: InkWell(
                        onTap: () {
                          handleToPlay();
                        },
                        child: Obx(() {
                          var currentSong =
                              audioPlayerService.currentSong.value;
                          if (currentSong.id.isEmpty) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.current.slogan,
                                  style: ThemeService.subTextStyle,
                                ),
                              ],
                            );
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentSong.title,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ThemeService.color.textColor,
                                ),
                              ),
                              Text(
                                currentSong.artist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ThemeService.subTextStyle,
                              ),
                            ],
                          );
                        }),
                      ),
                    );
                  }),
                ),
                SizedBox(
                  width: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconPlayControl(),
                      IconPlayList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
