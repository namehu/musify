import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/constant.dart';
import 'package:musify/enums/tab_type_enmu.dart';
import 'package:musify/models/play_list.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/global_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/widgets/m_title.dart';
import '../generated/l10n.dart';
import '../util/mycss.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({
    Key? key,
  }) : super(key: key);

  @override
  LeftDrawerState createState() => LeftDrawerState();
}

class LeftDrawerState extends State<LeftDrawer> {
  List<Playlist> palyList = [];

  @override
  void initState() {
    super.initState();
    _getPlayList();
  }

  // 处理点击事件
  _handleClick(TabTypeEnmu type) {
    // 将swich转换成map
    var map = {
      TabTypeEnmu.home: Routes.HOME,
      TabTypeEnmu.playList: Routes.PLAY_LIST,
      TabTypeEnmu.favorite: Routes.FAVORITE,
      TabTypeEnmu.artist: Routes.ARTISTS,
      TabTypeEnmu.album: Routes.ALBUM_LIST,
      TabTypeEnmu.genres: Routes.GENRE,
      TabTypeEnmu.setting: Routes.SETTING,
      TabTypeEnmu.allSong: Routes.SONG_LIST,
    };

    if (map[type] != null) {
      GloabalService.tabType(type);
      if (isMobile) Navigator.pop(context);
      Get.toNamed(map[type]!);
    }
  }

  _getPlayList() async {
    var res = await MRequest.api.getPlaylists();
    setState(() {
      palyList = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: drawerWidth,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: ThemeService.color.secondBgColor,
      child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: StyleSize.space),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: isMobile ? 38.0 : 0),
                  child: Row(
                    children: <Widget>[],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Obx(() {
                    var _value = GloabalService.tabType;
                    return Column(
                      children: [
                        SizedBox(height: isMobile ? 40 : 0),
                        if (!isMobile) _buidSettingRow(),
                        MyTextIconButton(
                          icon: Icons.home_outlined,
                          activeIcon: Icons.home,
                          title: S.current.index,
                          active: _value == TabTypeEnmu.home,
                          press: () => _handleClick(TabTypeEnmu.home),
                        ),
                        if (!isMobile)
                          MyTextIconButton(
                            icon: Icons.music_note_outlined,
                            activeIcon: Icons.music_note,
                            title: S.current.song,
                            active: _value == TabTypeEnmu.allSong,
                            press: () => _handleClick(TabTypeEnmu.allSong),
                          ),
                        if (!isMobile)
                          MyTextIconButton(
                            icon: Icons.favorite_outline,
                            activeIcon: Icons.favorite,
                            title: S.current.favorite,
                            active: _value == TabTypeEnmu.favorite,
                            press: () => _handleClick(TabTypeEnmu.favorite),
                          ),
                        if (!isMobile)
                          MyTextIconButton(
                            icon: Icons.album_outlined,
                            activeIcon: Icons.album_rounded,
                            title: S.current.album,
                            active: _value == TabTypeEnmu.album,
                            press: () => _handleClick(TabTypeEnmu.album),
                          ),
                        if (!isMobile)
                          MyTextIconButton(
                            icon: Icons.people_alt_outlined,
                            activeIcon: Icons.people_alt_rounded,
                            title: S.current.artist,
                            active: _value == TabTypeEnmu.artist,
                            press: () => _handleClick(TabTypeEnmu.artist),
                          ),
                        MyTextIconButton(
                          icon: Icons.style_outlined,
                          activeIcon: Icons.style_rounded,
                          title: S.current.genres,
                          active: _value == TabTypeEnmu.genres,
                          press: () => _handleClick(TabTypeEnmu.genres),
                        ),
                        if (isMobile)
                          MyTextIconButton(
                            icon: Icons.settings_outlined,
                            activeIcon: Icons.settings_rounded,
                            title: S.current.settings,
                            active: _value == TabTypeEnmu.setting,
                            press: () => _handleClick(TabTypeEnmu.setting),
                          )
                      ],
                    );
                  }),
                ),
                Divider(
                  height: 1,
                  color: ThemeService.color.dividerColor,
                ),
                Expanded(
                  flex: 1,
                  child: _buidPlayList(),
                )
              ],
            ),
          )),
    );
  }

  _buidSettingRow() {
    return Container(
      height: appBarHeight,
      // margin: EdgeInsets.only(bottom: StyleSize.spaceSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.SEARCH);
            },
            icon: Icon(
              Icons.search,
              color: ThemeService.color.textSecondColor,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.SETTING);
            },
            icon: Icon(
              Icons.settings,
              color: ThemeService.color.textSecondColor,
            ),
          ),
        ],
      ),
    );
  }

  _buidPlayList() {
    return Column(
      children: [
        MTitle(title: S.current.playlist),
        Container(
          height: 300,
          child: ListView.builder(
            itemBuilder: (ctx, index) {
              var _data = palyList[index];
              return PlayListItem(data: _data);
            },
            itemCount: palyList.length,
          ),
        )
      ],
    );
  }
}

class PlayListItem extends StatefulWidget {
  final Playlist data;
  const PlayListItem({
    super.key,
    required this.data,
  });

  @override
  State<PlayListItem> createState() => _PlayListItemState();
}

class _PlayListItemState extends State<PlayListItem> {
  bool isHover = false;

  _haldePlay() async {
    var _playList = await MRequest.api.getPlaylist(widget.data.id);

    if (_playList != null &&
        _playList.songs != null &&
        _playList.songs!.isNotEmpty) {
      var songs = (_playList.songs ?? []);

      Get.find<AudioPlayerService>().palySongList(songs);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHover = false;
        });
      },
      child: Container(
        child: InkWell(
          onTap: () {
            var _currentPath = Get.currentRoute;

            if (Get.routing?.args != null) {
              _currentPath += Get.routing.args['id'];
            }

            if ('${Routes.PLAY_LIST_DETAIL}${widget.data.id}' == _currentPath) {
              return;
            }

            if (Get.currentRoute == Routes.PLAY_LIST_DETAIL) {
              Get.offNamed(
                Routes.PLAY_LIST_DETAIL,
                arguments: {'id': widget.data.id},
                preventDuplicates: false,
              );
            } else {
              Get.toNamed(
                Routes.PLAY_LIST_DETAIL,
                arguments: {'id': widget.data.id},
                preventDuplicates: false,
              );
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: StyleSize.spaceSmall,
              horizontal: StyleSize.spaceSmall,
            ),
            child: Row(
              children: [
                Expanded(child: Text(widget.data.name)),
                Visibility(
                  visible: isHover,
                  child: InkWell(
                    onTap: () {
                      _haldePlay();
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: ThemeService.color.cardColor,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextIconButton extends StatelessWidget {
  const MyTextIconButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.press,
    required this.active,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final IconData activeIcon;
  final bool active;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: StyleSize.spaceSmall),
        child: Row(
          children: [
            if (GetPlatform.isDesktop)
              Container(
                width: 3,
                height: 16,
                color: active
                    ? ThemeService.color.primaryColor
                    : Colors.transparent,
                margin: EdgeInsets.only(right: StyleSize.spaceSmall),
              ),
            Icon(
              active ? activeIcon : icon,
              size: 20,
              color: ThemeService.color.textColor,
            ),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: ThemeService.color.textColor,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
