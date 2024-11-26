import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/enums/tab_type_enmu.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/global_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
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
  // 处理点击事件
  handleClick(TabTypeEnmu type) {
    // 将swich转换成map
    var map = {
      TabTypeEnmu.home: Routes.HOME,
      TabTypeEnmu.playList: Routes.PLAY_LIST,
      TabTypeEnmu.favorite: Routes.FAVORITE,
      TabTypeEnmu.artist: Routes.ARTISTS,
      TabTypeEnmu.album: Routes.ALBUM_LIST,
      TabTypeEnmu.genres: Routes.GENRE,
      TabTypeEnmu.setting: Routes.SETTING,
    };

    if (map[type] != null) {
      GloabalService.tabType(type);
      if (isMobile) Navigator.pop(context);
      Get.toNamed(map[type]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: drawerWidth,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: ThemeService.color.bgColor,
      child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Padding(
            padding: EdgeInsets.only(left: StyleSize.space),
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
                          press: () => handleClick(TabTypeEnmu.home),
                        ),
                        if (!isMobile)
                          MyTextIconButton(
                            icon: Icons.library_music_outlined,
                            activeIcon: Icons.library_music,
                            title: S.current.playlist,
                            active: _value == TabTypeEnmu.playList,
                            press: () => handleClick(TabTypeEnmu.playList),
                          ),
                        if (!isMobile)
                          MyTextIconButton(
                            icon: Icons.favorite_outline,
                            activeIcon: Icons.favorite,
                            title: S.current.favorite,
                            active: _value == TabTypeEnmu.favorite,
                            press: () => handleClick(TabTypeEnmu.favorite),
                          ),
                        if (!isMobile)
                          MyTextIconButton(
                            icon: Icons.album_outlined,
                            activeIcon: Icons.album_rounded,
                            title: S.current.album,
                            active: _value == TabTypeEnmu.album,
                            press: () => handleClick(TabTypeEnmu.album),
                          ),
                        if (!isMobile)
                          MyTextIconButton(
                            icon: Icons.people_alt_outlined,
                            activeIcon: Icons.people_alt_rounded,
                            title: S.current.artist,
                            active: _value == TabTypeEnmu.artist,
                            press: () => handleClick(TabTypeEnmu.artist),
                          ),
                        MyTextIconButton(
                          icon: Icons.style_outlined,
                          activeIcon: Icons.style_rounded,
                          title: S.current.genres,
                          active: _value == TabTypeEnmu.genres,
                          press: () => handleClick(TabTypeEnmu.genres),
                        ),
                        if (isMobile)
                          MyTextIconButton(
                            icon: Icons.settings_outlined,
                            activeIcon: Icons.settings_rounded,
                            title: S.current.settings,
                            active: _value == TabTypeEnmu.setting,
                            press: () => handleClick(TabTypeEnmu.setting),
                          )
                      ],
                    );
                  }),
                ),
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
        padding: EdgeInsets.symmetric(vertical: StyleSize.space),
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
