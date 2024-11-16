import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/widgets/m_button.dart';
import 'package:musify/widgets/m_star_toogle.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../generated/l10n.dart';

import '../../../models/notifierValue.dart';
import '../../../util/mycss.dart';
import '../../../util/httpClient.dart';
import '../../../util/util.dart';
import '../../../screens/common/myTextButton.dart';

class AlbumDetailScreen extends StatefulWidget {
  const AlbumDetailScreen({
    Key? key,
  }) : super(key: key);
  @override
  _AlbumDetailScreenState createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  // final audioPlayerService = Get.find<AudioPlayerService>();
  AudioPlayer _player = AudioPlayerService.player;

  List<Songs> _songs = [];
  int _songsnum = 0;
  int _playCount = 0;
  int _duration = 0;
  String _albumsname = "";
  String _artistID = "";
  String _genre = "";
  String? _arturl;
  String _artist = "";
  int _year = 0;
  bool _staralbum = false; // 是否收藏专辑
  List<bool> _starsong = [];

  _getSongs(String albumId) async {
    final _albumtem = await getAlbum(albumId);
    if (_albumtem != null && _albumtem.length > 0) {
      final _songsList = _albumtem["song"];
      String _url = getCoverArt(_albumtem["id"]);
      _albumtem["coverUrl"] = _url;
      _albumtem["title"] = _albumtem["name"];
      Albums _albums = Albums.fromJson(_albumtem);

      if (_songsList != null) {
        List<Songs> _songtem = [];
        List<bool> _startem = [];
        for (var _element in _songsList) {
          String _stream = getServerInfo("stream");
          String _url = await getCoverArt(_element["id"]);
          _element["stream"] = _stream + '&id=' + _element["id"];
          _element["coverUrl"] = _url;
          if (_element["starred"] != null) {
            _startem.add(true);
          } else {
            _startem.add(false);
          }
          Songs _song = Songs.fromJson(_element);
          _songtem.add(_song);
        }
        if (_albumtem["starred"] != null) {
          _staralbum = true;
        } else {
          _staralbum = false;
        }

        if (mounted) {
          setState(() {
            _songs = _songtem;
            _songsnum = _albums.songCount;
            _albumsname = _albums.title;
            _playCount = _albums.playCount;
            _duration = _albums.duration;
            _year = _albums.year;
            _artist = _albums.artist;
            _artistID = _albums.artistId;
            _genre = _albums.genre;
            _arturl = _albums.coverUrl;
            _starsong = _startem;
          });
        }
      }
    }
  }

  @override
  initState() {
    super.initState();
    _getSongs(activeID.value);
  }

  // 顶部区域
  double _toprightwidth =
      windowsWidth.value - screenImageWidthAndHeight - 40 - 15;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildTopWidget()),
        SliverToBoxAdapter(child: _buildOperations()),
        SliverToBoxAdapter(child: _songsBody(context)),
      ],
    );
  }

  Widget _buildTopWidget() {
    return Container(
      padding: leftrightPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 封面
          Container(
            height: 136,
            width: 136,
            margin: EdgeInsets.only(right: 15),
            child: (_arturl != null)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: _arturl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
          ),
          // 右侧区域
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    _albumsname,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: titleText2,
                  ),
                ),
                _buildTopUser(),
                if (_genre != "")
                  Container(
                      width: _toprightwidth,
                      child: Row(
                        children: [
                          MyTextButton(
                              press: () {
                                indexValue.value = 6;
                              },
                              title: S.current.genres),
                          SizedBox(
                            width: 5,
                          ),
                          MyTextButton(
                              press: () {
                                activeID.value = _genre;
                                indexValue.value = 4;
                              },
                              title: _genre),
                        ],
                      )),
                if (_year != 0)
                  Container(
                    width: _toprightwidth,
                    child: Text(
                      S.current.year + ": " + _year.toString(),
                      style: nomalText,
                    ),
                  ),
                Container(
                  width: _toprightwidth,
                  child: Text(
                    S.current.song + ": " + _songsnum.toString(),
                    style: nomalText,
                  ),
                ),
                Container(
                  width: _toprightwidth,
                  child: Text(
                    S.current.dration + ": " + formatDuration(_duration),
                    style: nomalText,
                  ),
                ),
                Container(
                  width: _toprightwidth,
                  child: Text(
                    S.current.playCount + ": " + _playCount.toString(),
                    style: nomalText,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildOperations() {
    return Container(
      padding: allPadding,
      child: Row(
        children: [
          Expanded(child: MButton(icon: Icons.play_arrow, title: '全部播放')),
          SizedBox(width: 10),
          Expanded(
            child: MButton(
              icon: Icons.shuffle,
              title: '随机播放',
              type: ButtonType.secondary,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  /// 歌手名称
  Widget _buildTopUser() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 歌手名
          Container(
            constraints: BoxConstraints(
              maxWidth: _toprightwidth,
            ),
            child: MyTextButton(
              press: () {
                activeID.value = _artistID;
                indexValue.value = 9;
              },
              title: _artist,
            ),
          ),
          // 收藏按钮
          Container(
            height: 20,
            width: 25,
            child: MStarToogle(
              value: _staralbum,
              onChange: (val) async {
                var _favorite = Favorite(id: activeID.value, type: 'album');
                _staralbum
                    ? await delStarred(_favorite)
                    : await addStarred(_favorite);
                setState(() {
                  _staralbum = !_staralbum;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> mylistView(List<String> _title) {
    List<Widget> _list = [];
    for (var i = 0; i < _title.length; i++) {
      _list.add(Container(
        padding: EdgeInsets.only(left: 5),
        child: MyTextButton(
            press: () {
              activeID.value = _title[i];
              indexValue.value = 4;
            },
            title: _title[i]),
      ));
    }
    return _list;
  }

  Widget _songsBody(BuildContext _context) {
    return MediaQuery.removePadding(
      context: _context,
      removeTop: true,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _songs.length,
        itemExtent: 50.0, //强制高度为50.0
        itemBuilder: (BuildContext context, int index) {
          Songs _song = _songs[index];
          List<String> _title = [
            _song.title,
            formatDuration(_song.duration),
            _song.id
          ];
          return ListTile(
            title: InkWell(
              onTap: () async {
                if (listEquals(activeList.value, _songs)) {
                  _player.seek(Duration.zero, index: index);
                } else {
                  //当前歌曲队列
                  activeIndex.value = index;
                  activeSongValue.value = _song.id;
                  //歌曲所在专辑歌曲List
                  activeList.value = _songs;
                }
              },
              child: ValueListenableBuilder<Map>(
                valueListenable: activeSong,
                builder: ((context, value, child) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _songlistView(
                      _title,
                      value.isNotEmpty && value["value"] == _song.id,
                      index,
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _songlistView(
    List<String> _title,
    bool active,
    int _index,
  ) {
    return _title.asMap().keys.map((i) {
      if (i == 0) {
        return Expanded(
          flex: 1,
          child: Text(
            _title[i],
            textDirection: (i == 0) ? TextDirection.ltr : TextDirection.rtl,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: active
                  ? ThemeService.color.textPrimaryColor
                  : ThemeService.color.textColor,
            ),
          ),
        );
      } else if (i == _title.length - 1) {
        return InkWell(
          onTap: () {
            print('还没做');
          },
          child: Icon(
            Icons.more_vert,
            size: 24,
            color: textGray,
          ),
        );
      }
      // 时长
      return Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Text(
          _title[i],
          textDirection: (i == 0) ? TextDirection.ltr : TextDirection.rtl,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: ThemeService.color.textSecondColor, fontSize: 12),
        ),
      );
    }).toList();
  }
}
