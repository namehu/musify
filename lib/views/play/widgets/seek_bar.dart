import 'dart:math';
import 'package:flutter/material.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/util/util.dart';

class PlayerSeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final double trackWidth;
  final double padding;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const PlayerSeekBar({
    super.key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    required this.trackWidth,
    required this.padding,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  PlayerSeekBarState createState() => PlayerSeekBarState();
}

class PlayerSeekBarState extends State<PlayerSeekBar> {
  double? _dragValue;

  double overlaySize = 15.0;

  get slidePadding => widget.padding - overlaySize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(left: slidePadding, right: slidePadding),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: ThemeService.color.primaryColor,
              inactiveTrackColor: ThemeService.color.sliderBorderColor,
              thumbColor: ThemeService.color.primaryColor,
              overlayColor: ThemeService.color.primaryColor.withOpacity(0.3),
              overlayShape: RoundSliderOverlayShape(overlayRadius: overlaySize),
              trackHeight: 5.0,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: SizedBox(
              width: widget.trackWidth,
              child: Slider(
                min: 0.0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: min(
                  _dragValue ?? widget.position.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble(),
                ),
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(Duration(milliseconds: value.round()));
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(Duration(milliseconds: value.round()));
                  }
                  _dragValue = null;
                },
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: widget.padding, right: widget.padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatSongDuration(widget.position),
                style: TextStyle(fontSize: 12),
              ),
              Text(
                formatSongDuration(widget.duration),
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        )
      ],
    );
  }

  //Duration get _remaining => widget.duration - widget.position;
}
