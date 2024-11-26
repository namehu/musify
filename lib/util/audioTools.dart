import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/models/lyrics.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/widgets/m_toast.dart';
import '../generated/l10n.dart';
import 'httpClient.dart';
import 'mycss.dart';

getSongDetail(String id) async {
  try {
    var _song = await MRequest.api.getSong(id);
    if (_song == null) {
      return null;
    }

    var audioPlayerService = Get.find<AudioPlayerService>();
    audioPlayerService.currentSong.value = _song;

    var lyric = Lyrics.fromJsonString(_song.lyrics ?? '');
    var _lyrictem = lyric.toPlayerlyric();
    audioPlayerService.lyric.value = _lyrictem;

    return _song;
  } catch (e) {
    print(e);
  }
}

//新增播放列表
Future<int> newPlaylistDialog(BuildContext context) async {
  TextEditingController controller = TextEditingController();
  var hitText = S.current.pleaseInput + S.current.playlist + S.current.name;

  var addresult = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: UnconstrainedBox(
                child: Container(
              width: 250,
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ThemeService.color.dialogBackgroundColor,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: allPadding,
                      child: Text(S.current.create + S.current.playlist),
                    ),
                    Container(
                      width: 200,
                      height: 35,
                      margin: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: hitText,
                          labelStyle: nomalText,
                          border: InputBorder.none,
                          hintStyle: nomalText,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.edit_note,
                            color: ThemeService.color.iconColor,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: allPadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.of(context).pop(0);
                            },
                            child: Text(S.current.cancel),
                          ),
                          InkWell(
                            onTap: () async {
                              if (controller.text.isNotEmpty) {
                                var _response =
                                    await createPlaylist(controller.text, "");
                                if (_response != null &&
                                    _response["status"] == "ok") {
                                  Navigator.of(context).pop(0);
                                } else {
                                  Navigator.of(context).pop(1);
                                }
                              } else {
                                MToast.show(S.current.pleaseInput +
                                    S.current.playlist +
                                    S.current.name);
                              }
                            },
                            child: Text(S.current.create),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
      });
  return addresult;
}
