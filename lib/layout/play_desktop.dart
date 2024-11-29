import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:get/get.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/music/lyric_reader.dart';
import 'package:musify/widgets/music/music_seek_bar.dart';
import '../generated/l10n.dart';
import '../models/notifierValue.dart';
import '../util/mycss.dart';
import 'player_contro_bar.dart';

class PlayDesktop extends StatefulWidget {
  const PlayDesktop({super.key});

  @override
  State<PlayDesktop> createState() => _PlayDesktopState();
}

class _PlayDesktopState extends State<PlayDesktop> {
  final audioPlayerService = Get.find<AudioPlayerService>();
  final player = AudioPlayerService.player;

  var lyricUI = UINetease();
  var lyricPadding = 40.0;
  var playing = true;

  @override
  initState() {
    super.initState();
    lyricUI.highlight = true;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {},
      child: Stack(
        children: <Widget>[
          ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: Obx(
                () {
                  var song = audioPlayerService.currentSong.value;
                  return MCover(url: song.id.isNotEmpty ? song.coverUrl : '');
                },
              )),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: windowsWidth.value,
                height: windowsHeight.value,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    leading: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                  body: Column(
                    children: [
                      _buildHeader(),
                      SizedBox(
                        height: 10,
                        child: MusicSeekBar(dotRaidus: 5),
                      ),
                      SizedBox(height: 80, child: PlayerControBar()),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      var value = audioPlayerService.currentSong.value;
      return Expanded(
          child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(StyleSize.spaceLarge),
              child: Column(
                children: [
                  Expanded(child: MCover(url: value.coverUrl)),
                  Container(
                    margin: EdgeInsets.only(
                        top: StyleSize.spaceLarge,
                        bottom: StyleSize.spaceLarge),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            (value.title.isEmpty)
                                ? S.current.unknown
                                : value.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: titleText2)
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (value.artist.isEmpty)
                            ? S.current.unknown
                            : value.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: nomalText,
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: StyleSize.space,
                          right: StyleSize.space,
                        ),
                        child: Text('-'),
                      ),
                      Text(
                        (value.album.isEmpty) ? S.current.unknown : value.album,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: nomalText,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: StyleSize.space)
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(30),
              child: LyricReader(
                positionDataStream: audioPlayerService.positionDataStream,
              ),
            ),
          ),
        ],
      ));
    });
  }
}
