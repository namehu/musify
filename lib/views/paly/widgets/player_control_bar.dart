import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/enums/play_mode_enum.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import '../../../models/notifierValue.dart';
import '../../../util/mycss.dart';

class PlayerControlBar extends StatefulWidget {
  const PlayerControlBar({Key? key}) : super(key: key);
  @override
  _PlayerControlBarState createState() => _PlayerControlBarState();
}

class _PlayerControlBarState extends State<PlayerControlBar> {
  final AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();
  final AudioPlayer player = AudioPlayerService.player;

  final double iconSize = 24;
  final int loopMode = 0;
  bool isactivePlay = true;

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() {
          var playMode = audioPlayerService.playMode.value;
          Widget icon = playMode == PlayModeEnum.loop
              ? Icon(Icons.loop, color: textGray)
              : playMode == PlayModeEnum.single
                  ? Icon(Icons.repeat_one,
                      color: ThemeService.color.primaryColor)
                  : Icon(Icons.shuffle, color: ThemeService.color.primaryColor);

          return IconButton(
            icon: icon,
            iconSize: iconSize,
            onPressed: () => audioPlayerService.tooglePlayMode(),
          );
        }),
        Obx(() {
          var canClick = audioPlayerService.playSongs.isNotEmpty;
          return IconButton(
            icon: Icon(
              Icons.skip_previous,
              color: canClick
                  ? ThemeService.color.textColor
                  : ThemeService.color.textDisabledColor,
            ),
            onPressed: () {
              if (canClick) player.seekToPrevious();
            },
          );
        }),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (player.sequenceState == null) {
              return IconButton(
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.play_circle,
                  color: badgeDark,
                ),
                iconSize: 64.0,
                onPressed: null,
              );
            } else if (playing != true) {
              return IconButton(
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.play_circle,
                  color: textGray,
                ),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.pause_circle_filled,
                  color: textGray,
                ),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.play_circle,
                  color: badgeDark,
                ),
                iconSize: 64.0,
                onPressed: null,
              );
            }
          },
        ),
        Obx(() {
          var canClick = audioPlayerService.playSongs.isNotEmpty;
          return IconButton(
            icon: Icon(
              Icons.skip_next,
              color: canClick
                  ? ThemeService.color.textColor
                  : ThemeService.color.textDisabledColor,
            ),
            onPressed: () {
              player.seekToNext();
            },
          );
        }),
        Obx(() => IconButton(
              icon: Icon(
                Icons.playlist_play,
                color: audioPlayerService.playSongs.isNotEmpty
                    ? textGray
                    : badgeDark,
                size: 30.0,
              ),
              onPressed: () {
                if (audioPlayerService.playSongs.isNotEmpty) {
                  AudioPlayerService.showPlayList();
                }
              },
            )),
      ],
    );
  }
}
