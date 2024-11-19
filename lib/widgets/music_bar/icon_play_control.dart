import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class IconPlayControl extends StatefulWidget {
  final double size;

  IconPlayControl({
    super.key,
    this.size = 40.0,
  });

  @override
  State<IconPlayControl> createState() => _IconPlayControlState();
}

class _IconPlayControlState extends State<IconPlayControl> {
  final player = AudioPlayerService.player;

  double _sliderValue = 0.0;
  late StreamSubscription<Duration> _durationSubscription;

  @override
  void initState() {
    super.initState();

    _durationSubscription = player.positionStream.listen((position) {
      if (player.duration != null) {
        setState(() {
          _sliderValue = position.inMilliseconds.toDouble() /
              player.duration!.inMilliseconds.toDouble();
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
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;

        return Container(
          width: 42,
          height: 42,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildIcon(playerState),
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

  Widget _buildIcon(PlayerState? playerState) {
    final processingState = playerState?.processingState;
    final playing = playerState?.playing ?? false;

    if (player.sequenceState != null) {
      if (playing == false) {
        return InkWell(
          child: Icon(
            Icons.play_circle,
            color: ThemeService.color.textSecondColor,
            size: widget.size,
          ),
          onTap: () => player.play(),
        );
      }

      if (processingState != ProcessingState.completed) {
        return InkWell(
          child: Icon(
            Icons.pause_circle_filled,
            color: ThemeService.color.textSecondColor,
            size: widget.size,
          ),
          onTap: () => player.pause(),
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
