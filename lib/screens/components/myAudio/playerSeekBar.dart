import 'dart:math';
import 'package:flutter/material.dart';
import 'package:musify/util/mycss.dart';

class PlayerSeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final double trackWidth;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const PlayerSeekBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
    required this.trackWidth,
  }) : super(key: key);

  @override
  PlayerSeekBarState createState() => PlayerSeekBarState();
}

class PlayerSeekBarState extends State<PlayerSeekBar> {
  double? _dragValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
            activeTrackColor: textGray,
            inactiveTrackColor: borderColor,
            trackHeight: 3.0,
            thumbColor: textGray,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
            overlayShape: SliderComponentShape.noThumb),
        child: Container(
          width: widget.trackWidth,
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
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
    ]);
  }

  //Duration get _remaining => widget.duration - widget.position;
}
