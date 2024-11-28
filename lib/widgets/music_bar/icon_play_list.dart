import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';

class IconPlayList extends StatelessWidget {
  final audioPlayerService = Get.find<AudioPlayerService>();

  IconPlayList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IconButton(
        icon: Icon(
          Icons.playlist_play,
          color: (audioPlayerService.playSongs.isNotEmpty)
              ? ThemeService.color.textSecondColor
              : ThemeService.color.textDisabledColor,
          size: 30.0,
        ),
        onPressed: () {
          if (audioPlayerService.playSongs.isNotEmpty) {
            AudioPlayerService.showPlayList();
          }
        },
      ),
    );
  }
}
