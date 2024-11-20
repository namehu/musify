import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import '../../../util/mycss.dart';

class PlayerVolumeBar extends StatefulWidget {
  final AudioPlayer player;

  const PlayerVolumeBar(this.player, {Key? key}) : super(key: key);
  @override
  _PlayerVolumeBarState createState() => _PlayerVolumeBarState();
}

class _PlayerVolumeBarState extends State<PlayerVolumeBar> {
  double _activevolume = 1.0;
  bool isVolume = true;
  bool isactivePlay = true;
  late OverlayEntry volumeOverlay;

  @override
  initState() {
    super.initState();
    volumeOverlay = OverlayEntry(builder: (context) {
      return Positioned(
        bottom: 55,
        right: 20,
        child: Material(
          color: ThemeService.color.dialogBackgroundColor,
          borderRadius: BorderRadius.circular(StyleSize.borderRadius),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
                activeTrackColor: textGray,
                inactiveTrackColor: borderColor,
                trackHeight: 1.0,
                thumbColor: textGray,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                overlayShape: SliderComponentShape.noThumb),
            child: Container(
              width: 30,
              padding: EdgeInsets.only(top: 15),
              child: StreamBuilder<double>(
                stream: widget.player.volumeStream,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      RotatedBox(
                        quarterTurns: 3, //旋转次数，一次为90度
                        child: Slider(
                            min: 0.0,
                            max: 1.0,
                            value: widget.player.volume,
                            onChanged: widget.player.setVolume),
                      ),
                      widget.player.volume == 0.0
                          ? IconButton(
                              padding: EdgeInsets.only(bottom: 10),
                              icon: Icon(
                                Icons.volume_off_outlined,
                                color: textGray,
                              ),
                              onPressed: () {
                                widget.player.setVolume(_activevolume);
                              },
                            )
                          : IconButton(
                              padding: EdgeInsets.only(bottom: 10),
                              icon: Icon(
                                Icons.volume_up,
                                color: textGray,
                              ),
                              onPressed: () {
                                _activevolume = widget.player.volume;
                                widget.player.setVolume(0.0);
                              },
                            )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<double>(
            stream: widget.player.volumeStream,
            builder: (context, snapshot) => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.volume_mute,
                      color: ThemeService.color.textColor),
                  onPressed: () {
                    if (isVolume) {
                      Overlay.of(context).insert(volumeOverlay);
                      setState(() {
                        isVolume = false;
                      });
                    } else {
                      if (volumeOverlay.mounted) {
                        volumeOverlay.remove();
                      }
                      setState(() {
                        isVolume = true;
                      });
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
