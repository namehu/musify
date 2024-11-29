import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader_widget.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/util/m_lyric_ui.dart';
import 'package:musify/util/util.dart';

typedef Change = void Function(MLyricUI ui);

class LyricReader extends StatefulWidget {
  final Stream<PositionData> positionDataStream;

  const LyricReader({
    super.key,
    required this.positionDataStream,
  });

  @override
  State<LyricReader> createState() => _LyricReaderState();
}

class _LyricReaderState extends State<LyricReader> {
  final audioPlayerService = Get.find<AudioPlayerService>();
  final player = AudioPlayerService.player;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var model = audioPlayerService.lyricModel;

      return StreamBuilder<PositionData>(
          stream: widget.positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            final position = positionData?.position.inMilliseconds ?? 0;

            return LyricsReader(
              padding: EdgeInsets.symmetric(horizontal: 40),
              model: model,
              position: position,
              lyricUi: audioPlayerService.lyricUI,
              playing: true,
              emptyBuilder: () => Center(
                child: Text(
                  S.current.no + S.current.lyric,
                  style: audioPlayerService.lyricUI.getOtherMainTextStyle(),
                ),
              ),
              selectLineBuilder: (progress, confirm) {
                return Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          confirm.call();
                          player.seek(Duration(milliseconds: progress));
                          audioPlayerService.lyricUI =
                              MLyricUI.clone(audioPlayerService.lyricUI);
                        },
                        icon: Icon(
                          Icons.play_arrow,
                          color: gray3,
                        )),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(color: gray3),
                        height: 1,
                      ),
                    ),
                    Text(
                      formatDurationMilliseconds(progress),
                      style: TextStyle(color: gray3),
                    )
                  ],
                );
              },
            );
          });
    });
  }
}
