import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/widgets/music/operation_icons.dart';

class PlayerVolumeBar extends StatefulWidget {
  final bool? dark;

  const PlayerVolumeBar({
    super.key,
    this.dark = false,
  });
  @override
  State<PlayerVolumeBar> createState() => _PlayerVolumeBarState();
}

class _PlayerVolumeBarState extends State<PlayerVolumeBar> {
  var audioPlayerService = Get.find<AudioPlayerService>();

  // double _activevolume = 1.0;
  bool isVolume = true;
  bool isactivePlay = true;
  // late OverlayEntry volumeOverlay;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var color = widget.dark! ? operationIconDarkColor : operationIconColor;

    return Container(
      padding: EdgeInsets.only(right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PlayStarIcon(
            color: color,
            size: 18,
          ),
          SizedBox(width: 10),
          StreamBuilder<double>(
            stream: audioPlayerService.player.stream.volume,
            builder: (context, snapshot) => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () {
                    var icons = Icons.volume_up;
                    if (audioPlayerService.volumeMute.value) {
                      icons = Icons.volume_off;
                    } else if (audioPlayerService.player.state.volume == 0.0) {
                      icons = Icons.volume_off;
                    }
                    return IconButton(
                      icon: Icon(
                        icons,
                        color: color,
                        size: 18,
                      ),
                      onPressed: () {
                        if (audioPlayerService.volumeMute.value) {
                          audioPlayerService.player
                              .setVolume(audioPlayerService.volume.value);
                          audioPlayerService.volumeMute(false);
                        } else {
                          audioPlayerService.player.setVolume(0.0);
                          audioPlayerService.volumeMute(true);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          _buildVolumeBar(),
        ],
      ),
    );
  }

  _buildVolumeBar() {
    return SizedBox(
      width: 100,
      child: StreamBuilder<double>(
        stream: audioPlayerService.player.stream.volume,
        builder: (context, snapshot) {
          return FlutterSlider(
            values: [audioPlayerService.player.state.volume],
            disabled: audioPlayerService.currentSong.value.id.isEmpty,
            onDragging: (handlerIndex, lowerValue, upperValue) {
              audioPlayerService.player.setVolume(lowerValue);
              audioPlayerService.volume(lowerValue);
            },
            min: 0.0,
            max: 100.0,
            handler: FlutterSliderHandler(
              foregroundDecoration: BoxDecoration(color: null),
              decoration: BoxDecoration(color: null),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: operationIconDarkColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            trackBar: FlutterSliderTrackBar(
              activeTrackBarHeight: 5,
              inactiveTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ThemeService.color.borderColor,
              ),
              activeTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: ThemeService.color.iconColor,
              ),
            ),
            tooltip: FlutterSliderTooltip(custom: (value) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: gray1, borderRadius: BorderRadius.circular(4)),
                child: Text(value.toStringAsFixed(0)),
              );
            }),
          );
        },
      ),
    );
  }
}
