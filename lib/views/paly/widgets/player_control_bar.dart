import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
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
  final AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();
  final AudioPlayer player = AudioPlayerService.player;

  final double iconSize = 24;
  final int loopMode = 0;
  bool isactivePlay = true;

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
        Obx(() => IconButton(
              icon: Icon(
                Icons.playlist_play,
                color: audioPlayerService.playSongs.isNotEmpty
                    ? textGray
                    : badgeDark,
                size: 30.0,
              ),
              onPressed: () {
                if (audioPlayerService.playSongs.isNotEmpty) {
                  AudioPlayerService.showPlayList();
                }
              },
            )),
      ],
    );
  }
}
