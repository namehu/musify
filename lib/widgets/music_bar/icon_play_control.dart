import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class IconPlayControl extends StatefulWidget {
  final double size;

  const IconPlayControl({
    super.key,
    this.size = 40.0,
  });

  @override
  State<IconPlayControl> createState() => _IconPlayControlState();
}

class _IconPlayControlState extends State<IconPlayControl> {
  var audioPlayerService = Get.find<AudioPlayerService>();

  double _sliderValue = 0.0;
  late StreamSubscription<Duration> _durationSubscription;

  @override
  void initState() {
    super.initState();

    _durationSubscription =
        audioPlayerService.positionStream.listen((position) {
      if (audioPlayerService.player.state.duration.inMilliseconds > 0) {
        setState(() {
          _sliderValue = min(
            position.inMilliseconds.toDouble() /
                audioPlayerService.player.state.duration.inMilliseconds
                    .toDouble(),
            1.0,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _durationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: audioPlayerService.player.stream.duration,
      builder: (context, snapshot) {
        return SizedBox(
          width: 42,
          height: 42,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildIcon(),
              _buildCircle(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircle() {
    return IgnorePointer(
      child: SleekCircularSlider(
        min: 0,
        max: 1,
        initialValue: _sliderValue,
        innerWidget: (percentage) => Container(),
        appearance: CircularSliderAppearance(
          size: 38,
          startAngle: 270,
          angleRange: 360,
          animationEnabled: false,
          customWidths: CustomSliderWidths(
            trackWidth: 2,
            progressBarWidth: _sliderValue == 0 ? 0 : 2,
            handlerSize: _sliderValue == 0 ? 0 : 3,
          ),
          customColors: CustomSliderColors(
            trackColor: ThemeService.color.dividerColor,
            progressBarColor: ThemeService.color.primaryColor,
            dotColor: ThemeService.color.primaryColor.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (audioPlayerService.player.state.playlist.medias.isNotEmpty) {
      var playing = audioPlayerService.player.state.playing;
      if (playing == false) {
        return InkWell(
          child: Icon(
            Icons.play_circle,
            color: ThemeService.color.textSecondColor,
            size: widget.size,
          ),
          onTap: () => audioPlayerService.player.play(),
        );
      }

      if (!audioPlayerService.player.state.completed) {
        return InkWell(
          child: Icon(
            Icons.pause_circle_filled,
            color: ThemeService.color.textSecondColor,
            size: widget.size,
          ),
          onTap: () => audioPlayerService.player.pause(),
        );
      }
    }

    return Icon(
      Icons.play_circle,
      color: ThemeService.color.textDisabledColor,
      size: widget.size,
    );
  }
}
