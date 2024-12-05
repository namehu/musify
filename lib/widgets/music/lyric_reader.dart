import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader_widget.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/util/m_lyric_ui.dart';
import 'package:musify/util/util.dart';

typedef Change = void Function(MLyricUI ui);

class LyricReader extends StatefulWidget {
  const LyricReader({super.key});

  @override
  State<LyricReader> createState() => _LyricReaderState();
}

class _LyricReaderState extends State<LyricReader> {
  final audioPlayerService = Get.find<AudioPlayerService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var model = audioPlayerService.lyricModel;

      return StreamBuilder(
          stream: audioPlayerService.positionStream,
          builder: (context, snapshot) {
            var position = snapshot.data ?? Duration.zero;
            position = position < Duration.zero ? Duration.zero : position;
            return LyricsReader(
              padding: EdgeInsets.symmetric(horizontal: 40),
              model: model,
              position: position.inMilliseconds,
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
                          audioPlayerService
                              .seek(Duration(milliseconds: progress));
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
