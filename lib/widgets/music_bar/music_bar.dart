import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/music_bar_service.dart';
import 'package:musify/services/theme_service.dart';
import '../../../models/notifierValue.dart';
import '../../../util/mycss.dart';
import '../../screens/components/myAudio/playerControBar.dart';

class MusicBar extends StatefulWidget {
  const MusicBar({super.key});

  @override
  State<MusicBar> createState() => _MusicBarState();
}

class _MusicBarState extends State<MusicBar> {
  final AudioPlayer player = AudioPlayerService.player;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(left: 32, right: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: ThemeService.color.musicBarColor,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      // width: windowsWidth.value - 110,
                      child: ValueListenableBuilder<Map>(
                    valueListenable: activeSong,
                    builder: (context, _song, child) {
                      return Row(
                        children: [
                          // cover image
                          InkWell(
                              onTap: () async {
                                //正在播放的弹窗入口
                                // showBottomSheet(
                                //   constraints: BoxConstraints(
                                //     maxWidth: windowsWidth.value,
                                //   ),
                                //   context: context,
                                //   builder: (BuildContext context) {
                                //     return PlayScreen(player: player);
                                //   },
                                // );

                                // FIXME: 逻辑补充
                                Get.toNamed(Routes.SETTING);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                height: bottomImageWidthAndHeight,
                                width: bottomImageWidthAndHeight,
                                child: (_song.isEmpty)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Image.asset(mylogoAsset))
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: CachedNetworkImage(
                                          imageUrl: _song["url"],
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) {
                                            return AnimatedSwitcher(
                                              child: Image.asset(mylogoAsset),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: windowsWidth.value - 180),
                                    child: Text(
                                        _song.isEmpty ? "" : _song["title"],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: nomalText),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: windowsWidth.value - 180),
                                    child: Text(
                                        _song.isEmpty ? "" : _song["artist"],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: subText),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: windowsWidth.value - 180),
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
                    width: 110,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PlayerControBar(isPlayScreen: false, player: player),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
