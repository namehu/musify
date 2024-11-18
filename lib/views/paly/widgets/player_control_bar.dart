import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/widgets/m_toast.dart';
import '../../../generated/l10n.dart';
import '../../../models/notifierValue.dart';
import '../../../util/mycss.dart';

class PlayerControlBar extends StatefulWidget {
  const PlayerControlBar({Key? key}) : super(key: key);
  @override
  _PlayerControlBarState createState() => _PlayerControlBarState();
}

class _PlayerControlBarState extends State<PlayerControlBar> {
  final AudioPlayer player = AudioPlayerService.player;

  final double iconSize = 24;
  final int loopMode = 0;
  bool isactivePlay = true;
  late OverlayEntry activePlaylistOverlay;

  @override
  initState() {
    super.initState();
    activePlaylistOverlay = OverlayEntry(builder: (context) {
      List _songs = activeList.value;
      double _height = (_songs.length * 40 + 60) < windowsHeight.value / 2 + 60
          ? _songs.length * 40 + 60
          : windowsHeight.value / 2 + 60;
      return Positioned(
          bottom: 85,
          right: 10,
          child: Material(
              color: badgeDark,
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                  width: 200,
                  height: _height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: badgeDark,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.current.playqueue,
                                style: nomalText,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "(" + _songs.length.toString() + ")",
                                style: subText,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.only(bottom: 10),
                          height: _height - 60,
                          child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: _songs.length,
                                  itemExtent: 40.0, //强制高度为50.0
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Songs _tem = _songs[index];
                                    return ListTile(
                                        title: InkWell(
                                            onTap: () async {
                                              await player.seek(Duration.zero,
                                                  index: index);
                                            },
                                            child: ValueListenableBuilder<Map>(
                                                valueListenable: activeSong,
                                                builder:
                                                    ((context, value, child) {
                                                  return Container(
                                                      width: 200,
                                                      child: Text(
                                                        _tem.title,
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: (value
                                                                    .isNotEmpty &&
                                                                value["value"] ==
                                                                    _tem.id)
                                                            ? activeText
                                                            : nomalText,
                                                      ));
                                                }))));
                                  })))
                    ],
                  ))));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueListenableBuilder<LoopMode>(
          valueListenable: playerLoopModeNotifier,
          builder: (_, playerLoopMode, __) {
            return ValueListenableBuilder<bool>(
                valueListenable: isShuffleModeEnabledNotifier,
                builder: (_, isShuffle, __) {
                  int _action = 0; //0全部循环；1单曲循环；2随机循环
                  String _msg = S.current.repeatall;
                  Widget _icon = Icon(Icons.loop, color: textGray);

                  if (playerLoopMode == LoopMode.all) {
                    if (isShuffle) {
                      _action = 0;
                      _msg = S.current.shuffle;
                      _icon = Icon(
                        Icons.shuffle,
                        color: ThemeService.color.primaryColor,
                      );
                    } else {
                      _action = 1;
                      _msg = S.current.repeatall;
                      _icon = Icon(
                        Icons.loop,
                        color: textGray,
                      );
                    }
                  } else if (playerLoopMode == LoopMode.one) {
                    _action = 2;
                    _msg = S.current.repeatone;
                    _icon = Icon(Icons.loop,
                        color: ThemeService.color.primaryColor);
                  }
                  return Tooltip(
                      message: _msg,
                      child: IconButton(
                        icon: _icon,
                        iconSize: iconSize,
                        onPressed: () {
                          switch (_action) {
                            case 0:
                              player.setLoopMode(LoopMode.all);
                              player.setShuffleModeEnabled(false);
                              isShuffleModeEnabledNotifier.value = false;
                              playerLoopModeNotifier.value = LoopMode.all;
                              MToast.show(S.current.repeatall);
                              break;
                            case 1:
                              player.setLoopMode(LoopMode.one);
                              player.setShuffleModeEnabled(false);
                              isShuffleModeEnabledNotifier.value = false;
                              playerLoopModeNotifier.value = LoopMode.one;
                              MToast.show(S.current.repeatone);
                              break;
                            case 2:
                              player.setLoopMode(LoopMode.all);
                              player.setShuffleModeEnabled(true);
                              isShuffleModeEnabledNotifier.value = true;
                              playerLoopModeNotifier.value = LoopMode.all;
                              MToast.show(S.current.shuffle);
                              break;
                            default:
                          }
                        },
                      ));
                });
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: isFirstSongNotifier,
          builder: (_, isFirst, __) {
            return IconButton(
              icon: Icon(
                Icons.skip_previous,
                color: isFirst ? badgeDark : textGray,
              ),
              onPressed: () {
                // ignore: unnecessary_statements
                (isFirst) ? null : player.seekToPrevious();
              },
            );
          },
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (player.sequenceState == null) {
              return IconButton(
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.play_circle,
                  color: badgeDark,
                ),
                iconSize: 64.0,
                onPressed: null,
              );
            } else if (playing != true) {
              return IconButton(
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.play_circle,
                  color: textGray,
                ),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.pause_circle_filled,
                  color: textGray,
                ),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.play_circle,
                  color: badgeDark,
                ),
                iconSize: 64.0,
                onPressed: null,
              );
            }
          },
        ),
        ValueListenableBuilder<bool>(
            valueListenable: isLastSongNotifier,
            builder: (_, isLast, __) {
              return IconButton(
                icon: Icon(
                  Icons.skip_next,
                  color: isLast ? badgeDark : textGray,
                ),
                onPressed: () {
                  // ignore: unnecessary_statements
                  (isLast) ? null : player.seekToNext();
                },
              );
            }),
        ValueListenableBuilder<List>(
          valueListenable: activeList,
          builder: (context, _activeList, child) {
            return IconButton(
              icon: Icon(
                Icons.playlist_play,
                color: (_activeList.length > 0) ? textGray : badgeDark,
                size: 30.0,
              ),
              onPressed: (_activeList.length > 0)
                  ? () {
                      if (isactivePlay) {
                        Overlay.of(context).insert(activePlaylistOverlay);
                        setState(() {
                          isactivePlay = false;
                        });
                      } else {
                        if (activePlaylistOverlay.mounted) {
                          activePlaylistOverlay.remove();
                        }
                        setState(() {
                          isactivePlay = true;
                        });
                      }
                    }
                  : null,
            );
          },
        ),
      ],
    );
  }
}
