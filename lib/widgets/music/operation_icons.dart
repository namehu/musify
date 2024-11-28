import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/enums/play_mode_enum.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/util/httpClient.dart';
import 'package:musify/widgets/m_star_toogle.dart';

/// 播放模式切换按钮
class PlayModeToggleIcon extends StatelessWidget {
  PlayModeToggleIcon({super.key});

  final audioPlayerService = Get.find<AudioPlayerService>();
  final double iconSize = 24;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var playMode = audioPlayerService.playMode.value;
      var canClick = audioPlayerService.playSongs.isNotEmpty;

      Widget icon = playMode == PlayModeEnum.loop
          ? Icon(Icons.loop, color: ThemeService.color.iconColor)
          : playMode == PlayModeEnum.single
              ? Icon(Icons.repeat_one, color: ThemeService.color.primaryColor)
              : Icon(Icons.shuffle, color: ThemeService.color.primaryColor);

      if (!canClick) {
        icon = Icon(Icons.loop, color: ThemeService.color.textDisabledColor);
      }

      return IconButton(
        icon: icon,
        iconSize: iconSize,
        onPressed: canClick ? audioPlayerService.tooglePlayMode : null,
      );
    });
  }
}

/// 播放上一曲
class PlayPreIcon extends StatelessWidget {
  PlayPreIcon({super.key});
  final player = AudioPlayerService.player;
  final audioPlayerService = Get.find<AudioPlayerService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var canClick = audioPlayerService.playSongs.isNotEmpty;
      return IconButton(
        icon: Icon(
          Icons.skip_previous,
          color: canClick
              ? ThemeService.color.iconColor
              : ThemeService.color.textDisabledColor,
        ),
        onPressed: canClick ? player.seekToPrevious : null,
      );
    });
  }
}

/// 下一曲
class PlayNextIcon extends StatelessWidget {
  PlayNextIcon({super.key});
  final player = AudioPlayerService.player;
  final audioPlayerService = Get.find<AudioPlayerService>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var canClick = audioPlayerService.playSongs.isNotEmpty;
        return IconButton(
          icon: Icon(
            Icons.skip_next,
            color: canClick
                ? ThemeService.color.iconColor
                : ThemeService.color.textDisabledColor,
          ),
          onPressed: canClick ? player.seekToNext : null,
        );
      },
    );
  }
}

/// 播放暂停按钮
class PlayToggleIcon extends StatelessWidget {
  final double? iconSize;
  PlayToggleIcon({super.key, this.iconSize = 40});
  final player = AudioPlayerService.player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (player.sequenceState == null) {
          return IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.play_circle,
              color: ThemeService.color.textDisabledColor,
            ),
            iconSize: iconSize,
            onPressed: null,
          );
        } else if (playing != true) {
          return IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.play_circle,
              color: ThemeService.color.iconColor,
            ),
            iconSize: iconSize,
            onPressed: player.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.pause_circle_filled,
              color: ThemeService.color.iconColor,
            ),
            iconSize: iconSize,
            onPressed: player.pause,
          );
        } else {
          return IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.play_circle,
              color: ThemeService.color.textDisabledColor,
            ),
            iconSize: iconSize,
            onPressed: null,
          );
        }
      },
    );
  }
}

/// 播放列表
class PlayListIcon extends StatelessWidget {
  PlayListIcon({super.key});
  final player = AudioPlayerService.player;
  final audioPlayerService = Get.find<AudioPlayerService>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IconButton(
        icon: Icon(
          Icons.playlist_play,
          color: audioPlayerService.playSongs.isNotEmpty
              ? ThemeService.color.iconColor
              : ThemeService.color.textDisabledColor,
          size: 30.0,
        ),
        onPressed: audioPlayerService.playSongs.isNotEmpty
            ? () {
                AudioPlayerService.showPlayList();
              }
            : null,
      ),
    );
  }
}

class PlayFastRewindIcon extends StatelessWidget {
  final player = AudioPlayerService.player;
  final audioPlayerService = Get.find<AudioPlayerService>();

  PlayFastRewindIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IconButton(
        icon: Icon(
          Icons.fast_rewind,
          color: audioPlayerService.playSongs.isNotEmpty
              ? ThemeService.color.iconColor
              : ThemeService.color.textDisabledColor,
        ),
        onPressed: audioPlayerService.playSongs.isNotEmpty
            ? () {
                if (player.position.inSeconds - 15 > 0) {
                  player
                      .seek(Duration(seconds: player.position.inSeconds - 15));
                }
              }
            : null,
      );
    });
  }
}

class PlayFastForwardIcon extends StatelessWidget {
  final player = AudioPlayerService.player;
  final audioPlayerService = Get.find<AudioPlayerService>();

  PlayFastForwardIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IconButton(
        icon: Icon(
          Icons.fast_forward,
          color: audioPlayerService.playSongs.isNotEmpty
              ? ThemeService.color.iconColor
              : ThemeService.color.textDisabledColor,
        ),
        onPressed: audioPlayerService.playSongs.isNotEmpty
            ? () {
                player.seek(Duration(seconds: player.position.inSeconds + 15));
              }
            : null,
      );
    });
  }
}

class PlayStarIcon extends StatelessWidget {
  PlayStarIcon({super.key});
  final audioPlayerService = Get.find<AudioPlayerService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var song = audioPlayerService.currentSong.value;
      var value = song.starred;
      return MStarToogle(
        value: value,
        size: 24,
        disabled: song.id.isEmpty,
        onChange: song.id.isNotEmpty
            ? (val) async {
                if (song.id.isNotEmpty) {
                  Favorite _favorite = Favorite(id: song.id, type: 'song');

                  value
                      ? await delStarred(_favorite)
                      : await addStarred(_favorite);
                  audioPlayerService.currentSong.update((song) {
                    song?.starred = !value;
                  });
                }
              }
            : null,
      );
    });
  }
}
