import 'dart:math';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/colors.dart';

class MusicSeekBar extends StatefulWidget {
  final bool? timeShow;
  final double? dotRaidus;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const MusicSeekBar({
    super.key,
    this.dotRaidus = 15,
    this.timeShow = false,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  MusicSeekBarState createState() => MusicSeekBarState();
}

class MusicSeekBarState extends State<MusicSeekBar> {
  final audioPlayerService = Get.find<AudioPlayerService>();

  double get _innerTrachHeight => min<double>(5.0, widget.dotRaidus!);

  double get _thumbSize => max(_innerTrachHeight, min(10, widget.dotRaidus!));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioPlayerService.positionStream,
      builder: (context, snapshot) {
        var state = audioPlayerService.player.state;

        var position =
            state.position < Duration.zero ? Duration.zero : state.position;
        var duration = state.duration;
        var buffered = state.buffer;

        return ProgressBar(
          progress: position.compareTo(duration) < 0 ? position : duration,
          buffered: buffered,
          total: duration,
          barHeight: _innerTrachHeight,
          progressBarColor: ThemeService.color.primaryColor,
          bufferedBarColor: ThemeService.color.primaryColor.withOpacity(0.3),
          baseBarColor: ThemeService.color.sliderBorderColor,
          thumbRadius: _thumbSize,
          thumbGlowRadius: widget.dotRaidus!,
          timeLabelLocation: widget.timeShow!
              ? TimeLabelLocation.sides
              : TimeLabelLocation.none,
          timeLabelTextStyle: TextStyle(fontSize: 12, color: gray1),
          onSeek: (time) {
            if (duration <= Duration.zero) {
              return;
            }
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd!(time);
            }
            audioPlayerService.seek(time);
          },
        );
      },
    );
  }

  //Duration get _remaining => widget.duration - widget.position;
}
