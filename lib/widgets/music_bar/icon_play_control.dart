import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';

class IconPlayControl extends StatelessWidget {
  final player = AudioPlayerService.player;

  final double size;

  IconPlayControl({
    super.key,
    this.size = 40.0,
  });

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
            icon: Icon(
              Icons.play_circle,
              color: ThemeService.color.dialogBackgroundColor,
            ),
            iconSize: size,
            onPressed: null,
          );
        } else if (playing != true) {
          return IconButton(
            icon: Icon(
              Icons.play_circle,
              color: ThemeService.color.textSecondColor,
            ),
            iconSize: size,
            onPressed: player.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: Icon(
              Icons.pause_circle_filled,
              color: ThemeService.color.textSecondColor,
            ),
            iconSize: size,
            onPressed: player.pause,
          );
        } else {
          return IconButton(
            icon: Icon(
              Icons.play_circle,
              color: ThemeService.color.dialogBackgroundColor,
            ),
            iconSize: size,
            onPressed: null,
          );
        }
      },
    );
  }
}
