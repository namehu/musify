import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/enums/play_mode_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';

class PlayListModal extends StatefulWidget {
  const PlayListModal({super.key});

  @override
  State<PlayListModal> createState() => _PlayListModalState();
}

class _PlayListModalState extends State<PlayListModal> {
  final audioPlayerService = Get.find<AudioPlayerService>();

  handleItemClick(Songs song, int index) {
    audioPlayerService.player.jump(index);
  }

  handleItemRemove(Songs song, int index) {
    var songs = audioPlayerService.playSongs.value.map((item) => item).toList();
    songs.removeAt(index);
    audioPlayerService.playSongs.value = songs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 500),
      decoration: BoxDecoration(
        color: ThemeService.color.dialogBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(StyleSize.borderRadius),
          topRight: Radius.circular(StyleSize.borderRadius),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(StyleSize.space),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: ThemeService.color.dividerColor,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 100),
                Expanded(
                  child: Obx(
                    () => Text(
                      '${S.current.playlist}(${audioPlayerService.playSongs.length})',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  // width: 100,
                  child: Obx(() {
                    var playMode = audioPlayerService.playMode.value;

                    late String label;
                    late IconData iconData;

                    switch (playMode) {
                      case PlayModeEnum.loop:
                        label = S.current.repeatall;
                        iconData = Icons.loop;
                        break;
                      case PlayModeEnum.single:
                        label = S.current.repeatone;
                        iconData = Icons.repeat_one;
                        break;
                      case PlayModeEnum.shuffle:
                        label = S.current.shuffle;
                        iconData = Icons.shuffle;
                    }

                    return GestureDetector(
                      onTap: () => audioPlayerService.tooglePlayMode(),
                      child: Row(
                        children: [
                          Icon(
                            iconData,
                            size: 12,
                            color: ThemeService.color.textSecondColor,
                          ),
                          SizedBox(width: 5),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              color: ThemeService.color.textSecondColor,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Obx(
                () {
                  var currentSong = audioPlayerService.currentSong.value;
                  return ListView.separated(
                    itemCount: audioPlayerService.playSongs.length,
                    separatorBuilder: (c, i) => Divider(
                      height: 1,
                      color: ThemeService.color.dividerColor,
                    ),
                    itemBuilder: (context, index) {
                      var item = audioPlayerService.playSongs[index];
                      var isActive = item.id == currentSong.id;

                      return ListTile(
                        onTap: () {
                          handleItemClick(item, index);
                        },
                        leading: Text(
                          (index + 1).toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: isActive ? 16 : 14,
                            color: isActive
                                ? ThemeService.color.primaryColor
                                : ThemeService.color.textSecondColor,
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            color: isActive
                                ? ThemeService.color.primaryColor
                                : null,
                          ),
                        ),
                        trailing: isActive
                            ? null
                            : GestureDetector(
                                onTap: () {
                                  handleItemRemove(item, index);
                                },
                                child: Icon(Icons.close),
                              ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
