import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/enums/tab_type_enmu.dart';
import 'package:musify/models/play_list.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/global_service.dart';
import 'package:musify/services/play_list_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/widgets/m_tag.dart';
import 'package:musify/widgets/m_title.dart';
import '../generated/l10n.dart';
import '../util/mycss.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  LeftDrawerState createState() => LeftDrawerState();
}

class LeftDrawerState extends State<LeftDrawer> {
  PlayListService playListService = Get.find<PlayListService>();
  List<Playlist> palyList = [];

  @override
  void initState() {
    super.initState();
  }

  // 处理点击事件
  _handleClick(TabTypeEnmu type) {
    // 将swich转换成map
    var path = GloabalService.tabTypeMap[type];
    if (path != null) {
      if (isMobile) Navigator.pop(context);
      Get.offAndToNamed(path);
    }
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
                Obx(() {
                  var value = GloabalService.tabType.value;
                  return Column(
                    children: [
                      SizedBox(height: isMobile ? 40 : 0),
                      if (!isMobile) _buidSettingRow(),
                      MyTextIconButton(
                        icon: Icons.home_outlined,
                        activeIcon: Icons.home,
                        title: S.current.index,
                        active: value == TabTypeEnmu.home,
                        press: () => _handleClick(TabTypeEnmu.home),
                      ),
                      if (!isMobile)
                        MyTextIconButton(
                          icon: Icons.music_note_outlined,
                          activeIcon: Icons.music_note,
                          title: S.current.song,
                          active: value == TabTypeEnmu.allSong,
                          press: () => _handleClick(TabTypeEnmu.allSong),
                        ),
                      if (!isMobile)
                        MyTextIconButton(
                          icon: Icons.favorite_outline,
                          activeIcon: Icons.favorite,
                          title: S.current.favorite,
                          active: value == TabTypeEnmu.favorite,
                          press: () => _handleClick(TabTypeEnmu.favorite),
                        ),
                      if (!isMobile)
                        MyTextIconButton(
                          icon: Icons.album_outlined,
                          activeIcon: Icons.album_rounded,
                          title: S.current.album,
                          active: value == TabTypeEnmu.album,
                          press: () => _handleClick(TabTypeEnmu.album),
                        ),
                      if (!isMobile)
                        MyTextIconButton(
                          icon: Icons.people_alt_outlined,
                          activeIcon: Icons.people_alt_rounded,
                          title: S.current.artist,
                          active: value == TabTypeEnmu.artist,
                          press: () => _handleClick(TabTypeEnmu.artist),
                        ),
                      MyTextIconButton(
                        icon: Icons.style_outlined,
                        activeIcon: Icons.style_rounded,
                        title: S.current.genres,
                        active: value == TabTypeEnmu.genres,
                        press: () => _handleClick(TabTypeEnmu.genres),
                      ),
                      if (isMobile)
                        MyTextIconButton(
                          icon: Icons.settings_outlined,
                          activeIcon: Icons.settings_rounded,
                          title: S.current.settings,
                          active: value == TabTypeEnmu.setting,
                          press: () => _handleClick(TabTypeEnmu.setting),
                        )
                    ],
                  );
                }),
                Divider(
                  height: StyleSize.spaceLarge,
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
    return SizedBox(
      height: appBarHeight,
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
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: [
          SizedBox(
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: MTitle(title: S.current.playlist)),
                MTag(
                  child: Icon(
                    Icons.add,
                    size: 13,
                  ),
                  onTap: () {
                    playListService.addPlayList();
                  },
                ),
                SizedBox(
                  width: StyleSize.spaceSmall,
                ),
                MTag(
                  child: Icon(
                    Icons.list,
                    size: 13,
                  ),
                  onTap: () {
                    Get.offAndToNamed(Routes.PLAY_LIST);
                  },
                )
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight - 35),
            child: Obx(
              () {
                if (playListService.playList.isEmpty) {
                  return Center(
                    child: Text(S.current.noPlaylist),
                  );
                }

                return ListView.builder(
                  itemBuilder: (ctx, index) {
                    var data = playListService.playList.value[index];
                    return PlayListItem(data: data);
                  },
                  itemCount: playListService.playList.value.length,
                );
              },
            ),
          )
        ],
      );
    });
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
    var playList = await MRequest.api.getPlaylist(widget.data.id);

    if (playList != null &&
        playList.songs != null &&
        playList.songs!.isNotEmpty) {
      var songs = (playList.songs ?? []);

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
      child: InkWell(
        onTap: () {
          var currentPath = Get.currentRoute;

          if (Get.routing.args != null) {
            currentPath += Get.routing.args['id'];
          }

          if ('${Routes.PLAY_LIST_DETAIL}${widget.data.id}' == currentPath) {
            return;
          }

          if (Get.currentRoute == Routes.PLAY_LIST_DETAIL) {
            Get.offNamed(
              Routes.PLAY_LIST_DETAIL,
              arguments: {'id': widget.data.id},
              preventDuplicates: false,
            );
          } else {
            Get.offAndToNamed(
              Routes.PLAY_LIST_DETAIL,
              arguments: {'id': widget.data.id},
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
    );
  }
}

class MyTextIconButton extends StatelessWidget {
  const MyTextIconButton({
    super.key,
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.press,
    required this.active,
  });

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
