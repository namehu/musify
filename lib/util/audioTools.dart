import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musify/api/index.dart';
import 'package:musify/models/lyrics.dart';
import 'package:musify/models/songs.dart';
import '../generated/l10n.dart';
import '../models/notifierValue.dart';
import 'httpClient.dart';
import 'mycss.dart';
import '../screens/common/myTextButton.dart';
import 'dbProvider.dart';

getSongDetail(String id) async {
  try {
    var _song = await MRequest.api.getSong(id);
    if (_song == null) {
      return null;
    }

    //拼装当前歌曲
    Map _activeSong = new Map();
    _activeSong["value"] = _song.id;
    _activeSong["artist"] = _song.artist;
    _activeSong["url"] = _song.coverUrl;
    _activeSong["title"] = _song.title;
    _activeSong["album"] = _song.album;
    _activeSong["albumId"] = _song.albumId;
    _activeSong["starred"] = _song.starred;

    activeSong.value = _activeSong;

    if (_song.lyrics != null && _song.lyrics.isNotEmpty) {
      setSongLyric(id, _song.lyrics);
    }

    return _song;
  } catch (e) {
    print(e);
  }
}

setSongLyric(String id, [String? text]) async {
  if (text != null) {
    //获取歌词
    // var text =
    //     "[{\"lang\":\"xxx\",\"line\":[{\"start\":0,\"value\":\"作词 : 方文山\"},{\"start\":1000,\"value\":\"作曲 : 周杰伦\"},{\"start\":2000,\"value\":\"编曲 : 黄雨勋\"},{\"start\":3000,\"value\":\"制作人 : 周杰伦\"},{\"start\":32010,\"value\":\"信札拆封谁为难 不过寥寥数行\"},{\"start\":35790,\"value\":\"娟秀字迹温柔 却感伤\"},{\"start\":39560,\"value\":\"你将心事 上了淡妆\"},{\"start\":43120,\"value\":\"该说的话 却被仔细收藏\"},{\"start\":46150,\"value\":\"暮色望垂杨 拱桥粼粼月光\"},{\"start\":49490,\"value\":\"忆往事我走笔 也阑珊\"},{\"start\":53620,\"value\":\"红颜如霜 凝结了过往\"},{\"start\":60430,\"value\":\"芦苇花开岁已寒 若霜又降路遥漫长\"},{\"start\":67390,\"value\":\"墙外是谁在吟唱 凤求凰\"},{\"start\":74360,\"value\":\"梨园台上 西皮二黄\"},{\"start\":77820,\"value\":\"却少了你 无人问暖\"},{\"start\":81220,\"value\":\"谁在彼岸 天涯一方\"},{\"start\":85940,\"value\":\"一句甚安勿念 你说落笔太难\"},{\"start\":89380,\"value\":\"窗外古琴幽兰 琴声平添孤单\"},{\"start\":92730,\"value\":\"我墨走了几行 泪潸然落了款\"},{\"start\":96180,\"value\":\"思念徒留纸上 一整篇被晕染\"},{\"start\":99650,\"value\":\"一句甚安勿念 你说落笔太难\"},{\"start\":103040,\"value\":\"何故远走潇湘 你却语多委婉\"},{\"start\":106480,\"value\":\"走过萧瑟秋凉 等来芒草催黄\"},{\"start\":109930,\"value\":\"而我遥望轻轻叹\"},{\"start\":128020,\"value\":\"信札拆封谁为难 不过寥寥数行\"},{\"start\":131790,\"value\":\"娟秀字迹温柔 却感伤\"},{\"start\":135590,\"value\":\"你将心事 上了淡妆\"},{\"start\":139040,\"value\":\"该说的话 却被仔细收藏\"},{\"start\":142090,\"value\":\"捎来的他乡 到底隔几条江\"},{\"start\":145440,\"value\":\"一封信到底转了 几道弯\"},{\"start\":149730,\"value\":\"缘分飘落 在山外山\"},{\"start\":156350,\"value\":\"芦苇花开岁已寒 若霜又降路遥漫长\"},{\"start\":163440,\"value\":\"墙外是谁在吟唱 凤求凰\"},{\"start\":170420,\"value\":\"梨园台上 西皮二黄\"},{\"start\":173800,\"value\":\"却少了你 无人问暖\"},{\"start\":177280,\"value\":\"谁在彼岸 天涯一方\"},{\"start\":182020,\"value\":\"一句甚安勿念 你说落笔太难\"},{\"start\":185260,\"value\":\"窗外古琴幽兰 琴声平添孤单\"},{\"start\":188670,\"value\":\"我墨走了几行 泪潸然落了款\"},{\"start\":192150,\"value\":\"思念徒留纸上 一整篇被晕染\"},{\"start\":195680,\"value\":\"一句甚安勿念 你说落笔太难\"},{\"start\":199070,\"value\":\"何故远走潇湘 你却语多委婉\"},{\"start\":202530,\"value\":\"走过萧瑟秋凉 等来芒草催黄\"},{\"start\":205900,\"value\":\"而我遥望轻轻叹\"},{\"start\":209420,\"value\":\"一句甚安勿念 你说落笔太难\"},{\"start\":211610,\"value\":\"你说落笔太难\"},{\"start\":212900,\"value\":\"窗外古琴幽兰 琴声平添孤单\"},{\"start\":215050,\"value\":\"琴声平添孤单\"},{\"start\":216290,\"value\":\"我墨走了几行 泪潸然落了款\"},{\"start\":218530,\"value\":\"泪潸然落了款\"},{\"start\":219610,\"value\":\"思念徒留纸上 一整篇被晕染\"},{\"start\":223040,\"value\":\"一句甚安勿念 你说落笔太难\"},{\"start\":226470,\"value\":\"何故远走潇湘 你却语多委婉\"},{\"start\":229870,\"value\":\"走过萧瑟秋凉 等来芒草催黄\"},{\"start\":233300,\"value\":\"而鱼雁不再往返\"},{\"start\":239250,\"value\":\"OP : JVR Music Int'l Ltd\"},{\"start\":245200,\"value\":\"录音师 : 杨瑞代\"},{\"start\":251150,\"value\":\"混音师 : 黄雨勋\"},{\"start\":257100,\"value\":\"SP : Universal Music Publishing Ltd\"}],\"synced\":true}]";

    var lyric = Lyrics.fromJsonString(text);
    activeLyric.value = lyric.toPlayerlyric();
    return;
  }

  //获取歌词
  final _lyrictem = await DbProvider.instance.getLyricById(id);
  if (_lyrictem != null && _lyrictem!.isNotEmpty) {
    activeLyric.value = _lyrictem;
  } else {
    activeLyric.value = "";
  }
}

void audioCurrentIndexStream(AudioPlayer _player) {
  _player.currentIndexStream.listen((event) async {
    if (_player.sequenceState == null) return;
    // 更新当前歌曲
    final currentItem = _player.sequenceState!.currentSource;
    final playlist = _player.sequenceState!.effectiveSequence;
    if (currentItem == null) {
      //更新上下首歌曲
      if (playlist.isEmpty) {
        isFirstSongNotifier.value = true;
        isLastSongNotifier.value = true;
      }
    } else {
      isFirstSongNotifier.value = playlist.first == currentItem;
      isLastSongNotifier.value = playlist.last == currentItem;

      MediaItem _tag = currentItem.tag;
      scrobble(_tag.id, false);
      var _song = await getSongDetail(_tag.id);
    }
  });
}

void audioActiveSongListener(AudioPlayer _player) {
  activeList.addListener(() {
    if (activeSongValue.value != "1") {
//新加列表的时候关闭乱序，避免出错
      _player.setShuffleModeEnabled(false);
      _player.setLoopMode(LoopMode.all);
      isShuffleModeEnabledNotifier.value = false;
      playerLoopModeNotifier.value = LoopMode.all;
      setAudioSource(_player);
    }
  });
}

Future<void> setAudioSource(AudioPlayer _player) async {
  if (_player.sequenceState != null) {
    _player.sequenceState!.effectiveSequence.clear();
  }

  List<AudioSource> children = [];
  List _songs = activeList.value;
  for (var element in _songs) {
    Songs _song = element;
    if (_song.suffix != "ape") {
      children.add(
        AudioSource.uri(
          Uri.parse(_song.stream),
          tag: MediaItem(
              id: _song.id,
              album: _song.album,
              artist: _song.artist,
              genre: _song.genre,
              title: _song.title,
              duration: Duration(milliseconds: _song.duration.toInt()),
              artUri: Uri.parse(getCoverArt(_song.id))),
        ),
      );
    }
  }

  final playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: children,
  );

  await _player.setAudioSource(playlist,
      initialIndex: activeIndex.value, initialPosition: Duration.zero);

  _player.play();
  final currentItem = _player.sequenceState!.currentSource;
  MediaItem _tag = currentItem?.tag;

  var _song = await getSongDetail(_tag.id);

  //更新上下首歌曲
  if (playlist.sequence.isEmpty || currentItem == null) {
    isFirstSongNotifier.value = true;
    isLastSongNotifier.value = true;
  } else {
    isFirstSongNotifier.value = playlist.sequence.first == currentItem;
    isLastSongNotifier.value = playlist.sequence.last == currentItem;
  }
}

//新增播放列表
Future<int> newPlaylistDialog(
    BuildContext context, TextEditingController controller) async {
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
                color: badgeDark,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: allPadding,
                      child: Text(
                        S.current.create + S.current.playlist,
                        style: nomalText,
                      ),
                    ),
                    Container(
                        width: 200,
                        height: 35,
                        margin: EdgeInsets.all(5),
                        child: TextField(
                          controller: controller,
                          style: nomalText,
                          cursorColor: textGray,
                          onSubmitted: (value) {},
                          decoration: InputDecoration(
                              hintText: S.current.pleaseInput +
                                  S.current.playlist +
                                  S.current.name,
                              labelStyle: nomalText,
                              border: InputBorder.none,
                              hintStyle: nomalText,
                              filled: true,
                              fillColor: badgeDark,
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
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              prefixIcon: Icon(
                                Icons.edit_note,
                                color: textGray,
                                size: 14,
                              )),
                        )),
                    Container(
                      padding: allPadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyTextButton(
                            press: () async {
                              Navigator.of(context).pop(3);
                            },
                            title: S.current.cancel,
                          ),
                          MyTextButton(
                            press: () async {
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
                                Navigator.of(context).pop(2);
                              }
                            },
                            title: S.current.create,
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
