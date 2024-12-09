import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/enums/play_mode_enum.dart';
import 'package:musify/enums/star_type_enum.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/star_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/widgets/m_star_toogle.dart';

/// 播放模式切换按钮
class PlayModeToggleIcon extends StatelessWidget {
  final audioPlayerService = Get.find<AudioPlayerService>();
  final double iconSize = 24;
  final Color? color;

  PlayModeToggleIcon({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var playMode = audioPlayerService.playMode.value;
      var canClick = audioPlayerService.playSongs.isNotEmpty;

      Widget icon = playMode == PlayModeEnum.loop
          ? Icon(Icons.loop, color: color ?? operationIconColor)
          : playMode == PlayModeEnum.single
              ? Icon(Icons.repeat_one, color: ThemeService.color.primaryColor)
              : Icon(Icons.shuffle, color: ThemeService.color.primaryColor);

      // if (!canClick) {
      //   icon = Icon(Icons.loop, color: ThemeService.color.textDisabledColor);
      // }

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
  final audioPlayerService = Get.find<AudioPlayerService>();
  final Color? color;

  PlayPreIcon({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var canClick = audioPlayerService.playSongs.isNotEmpty;
      return IconButton(
        icon: Icon(
          Icons.skip_previous,
          color: color ?? operationIconColor,
        ),
        onPressed: canClick ? audioPlayerService.playPre : null,
      );
    });
  }
}

/// 下一曲
class PlayNextIcon extends StatelessWidget {
  final audioPlayerService = Get.find<AudioPlayerService>();
  final Color? color;

  PlayNextIcon({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var canClick = audioPlayerService.playSongs.isNotEmpty;
        return IconButton(
          icon: Icon(
            Icons.skip_next,
            color: color ?? operationIconColor,
          ),
          onPressed: canClick ? audioPlayerService.playNext : null,
        );
      },
    );
  }
}

/// 播放暂停按钮
class PlayToggleIcon extends StatelessWidget {
  final audioPlayerService = Get.find<AudioPlayerService>();

  final Color? color;
  final double? iconSize;

  PlayToggleIcon({
    super.key,
    this.iconSize = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioPlayerService.player.stream.position,
      builder: (context, snapshot) {
        var player = audioPlayerService.player;
        final playing = player.state.playing;

        if (!playing) {
          return IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.play_circle, color: color ?? operationIconColor),
            iconSize: iconSize,
            onPressed: player.play,
          );
        } else if (!player.state.completed) {
          return IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.pause_circle_filled,
                color: color ?? operationIconColor),
            iconSize: iconSize,
            onPressed: player.pause,
          );
        }

        return IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.play_circle, color: color ?? operationIconColor),
          iconSize: iconSize,
          onPressed: null,
        );
      },
    );
  }
}

/// 播放列表
class PlayListIcon extends StatelessWidget {
  final audioPlayerService = Get.find<AudioPlayerService>();
  final Color? color;

  PlayListIcon({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IconButton(
        icon: Icon(
          Icons.playlist_play,
          color: color ?? operationIconColor,
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
  final audioPlayerService = Get.find<AudioPlayerService>();
  final Color? color;

  PlayFastRewindIcon({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IconButton(
        icon: Icon(
          Icons.fast_rewind,
          color: color ?? operationIconColor,
        ),
        onPressed: audioPlayerService.playSongs.isNotEmpty
            ? () {
                var seconds =
                    audioPlayerService.player.state.position.inSeconds - 15;
                if (seconds > 0) {
                  audioPlayerService.player.seek(Duration(seconds: seconds));
                }
              }
            : null,
      );
    });
  }
}

class PlayFastForwardIcon extends StatelessWidget {
  final audioPlayerService = Get.find<AudioPlayerService>();
  final Color? color;

  PlayFastForwardIcon({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IconButton(
        icon: Icon(
          Icons.fast_forward,
          color: color ?? operationIconColor,
        ),
        onPressed: audioPlayerService.playSongs.isNotEmpty
            ? () {
                audioPlayerService.player.seek(
                  Duration(
                      seconds:
                          audioPlayerService.player.state.position.inSeconds +
                              15),
                );
              }
            : null,
      );
    });
  }
}

// 收藏歌曲
class PlayStarIcon extends StatelessWidget {
  final audioPlayerService = Get.find<AudioPlayerService>();
  final starService = Get.find<StarService>();
  final Color? color;
  final double? size;

  PlayStarIcon({
    super.key,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var song = audioPlayerService.currentSong.value;
      var value = song.starred;
      return MStarToogle(
        value: value,
        size: size,
        color: color,
        onChange: song.id.isNotEmpty
            ? (val) async {
                if (song.id.isNotEmpty) {
                  await starService.toggleStar(
                    id: song.id,
                    type: StarTypeEnum.song,
                    star: val,
                  );
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
