import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/enums/tab_type_enmu.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/global_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/styles/size.dart';
import '../generated/l10n.dart';
import '../models/notifierValue.dart';
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
    GloabalService.tabType(type);
    if (isMobile) Navigator.pop(context);

    switch (type) {
      case TabTypeEnmu.home:
        Get.toNamed(Routes.HOME);
        break;
      case TabTypeEnmu.playList:
        Get.toNamed(Routes.PLAY_LIST);
        break;
      case TabTypeEnmu.favorite:
        Get.toNamed(Routes.FAVORITE);
        break;
      case TabTypeEnmu.artist:
        Get.toNamed(Routes.ARTISTS);
        break;
      case TabTypeEnmu.album:
        Get.toNamed(Routes.ALBUM_LIST);
        break;
      case TabTypeEnmu.genres:
        Get.toNamed(Routes.GENRE);
        break;
      default:
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
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 38.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/icon_music.png",
                            width: 80,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    var _value = GloabalService.tabType;
                    return Column(
                      children: [
                        SizedBox(height: isMobile ? 40 : 0),
                        MyTextIconButton(
                          icon: Icons.home,
                          title: S.current.index,
                          active: _value == TabTypeEnmu.home,
                          press: () => handleClick(TabTypeEnmu.home),
                        ),
                        MyTextIconButton(
                          icon: Icons.queue_music,
                          title: S.current.playlist,
                          active: _value == TabTypeEnmu.playList,
                          press: () => handleClick(TabTypeEnmu.playList),
                        ),
                        if (!isMobile)
                          MyTextIconButton(
                            icon: Icons.favorite,
                            title: S.current.favorite,
                            active: _value == TabTypeEnmu.favorite,
                            press: () => handleClick(TabTypeEnmu.favorite),
                          ),
                        if (!isMobile)
                          MyTextIconButton(
                            icon: Icons.album,
                            title: S.current.album,
                            active: _value == TabTypeEnmu.album,
                            press: () => handleClick(TabTypeEnmu.album),
                          ),
                        if (!isMobile)
                          MyTextIconButton(
                            icon: Icons.people_alt,
                            title: S.current.artist,
                            active: _value == TabTypeEnmu.artist,
                            press: () => handleClick(TabTypeEnmu.artist),
                          ),
                        MyTextIconButton(
                          icon: Icons.public,
                          title: S.current.genres,
                          active: _value == TabTypeEnmu.genres,
                          press: () => handleClick(TabTypeEnmu.genres),
                        ),
                        MyTextIconButton(
                            active: indexValue.value == 15,
                            press: () {
                              indexValue.value = 15;
                              if (isMobile) Navigator.pop(context);
                            },
                            title: S.current.share,
                            icon: Icons.share),
                        // if (_value.neteaseapi.isNotEmpty)
                        //   MyTextIconButton(
                        //       active: indexValue.value == 7,
                        //       press: () {
                        //         indexValue.value = 7;
                        //         if (isMobile) Navigator.pop(context);
                        //       },
                        //       title: S.current.search + S.current.lyric,
                        //       icon: Icons.public),
                        MyTextIconButton(
                          active: indexValue.value == 8,
                          press: () {
                            indexValue.value = 8;
                            Get.toNamed(Routes.SETTING);
                          },
                          title: S.current.settings,
                          icon: Icons.settings,
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
}

class MyTextIconButton extends StatelessWidget {
  const MyTextIconButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
    required this.active,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final bool active;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: StyleSize.space),
        color: (active && GetPlatform.isDesktop) ? gray4 : null,
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
              icon,
              size: 20,
              color: ThemeService.color.textColor,
            ),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: ThemeService.color.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
