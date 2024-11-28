import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/util/util.dart';

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
  final player = AudioPlayerService.player;
  final audioPlayerService = Get.find<AudioPlayerService>();
  double? _dragValue;

  // get slidePadding => widget.padding! - widget.dotSize!;

  double get _innerTrachHeight => min<double>(5.0, widget.dotRaidus!);

  double get _thumbSize => max(_innerTrachHeight, min(10, widget.dotRaidus!));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioPlayerService.positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;

        var duration = positionData?.duration ?? Duration.zero;
        var position = positionData?.position ?? Duration.zero;
        // var bufferedPosition = positionData?.bufferedPosition ?? Duration.zero;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: ThemeService.color.primaryColor,
                inactiveTrackColor: ThemeService.color.sliderBorderColor,
                thumbColor: ThemeService.color.primaryColor,
                overlayColor: ThemeService.color.primaryColor.withOpacity(0.3),
                overlayShape:
                    RoundSliderOverlayShape(overlayRadius: widget.dotRaidus!),
                trackHeight: _innerTrachHeight,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: _thumbSize,
                ),
              ),
              child: Slider(
                min: 0.0,
                max: duration.inMilliseconds.toDouble(),
                value: min(
                  _dragValue ?? position.inMilliseconds.toDouble(),
                  duration.inMilliseconds.toDouble(),
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
                  var time = Duration(milliseconds: value.round());
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(time);
                  }
                  player.seek(time);
                  _dragValue = null;
                },
              ),
            ),
            if (widget.timeShow!)
              Container(
                padding: EdgeInsets.only(
                    left: widget.dotRaidus!, right: widget.dotRaidus!),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatSongDuration(position),
                      style: TextStyle(fontSize: 12, color: gray1),
                    ),
                    Text(
                      formatSongDuration(duration),
                      style: TextStyle(fontSize: 12, color: gray1),
                    )
                  ],
                ),
              )
          ],
        );
      },
    );
  }

  //Duration get _remaining => widget.duration - widget.position;
}
