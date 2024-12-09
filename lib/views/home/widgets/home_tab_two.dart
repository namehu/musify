import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/views/home/home_controller.dart';
import 'package:musify/widgets/m_bottom_placeholder.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/m_logo.dart';
import 'package:musify/widgets/m_title.dart';
import 'package:musify/widgets/m_toast.dart';

import '../../../routes/pages.dart';

class HomeTabTwo extends StatelessWidget {
  final HomeController controller;

  const HomeTabTwo({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width),
      padding: EdgeInsets.symmetric(horizontal: StyleSize.space),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: StyleSize.space)),
          SliverToBoxAdapter(child: _buildSearch()),
          SliverToBoxAdapter(child: SizedBox(height: StyleSize.space)),
          SliverToBoxAdapter(child: _buildSummaryCard()),
          SliverToBoxAdapter(
            child: SizedBox(height: StyleSize.space),
          ),
          SliverToBoxAdapter(
            child: MTitle(
              title: S.current.playlist,
              actions: [
                Icon(
                  Icons.add,
                  color: ThemeService.color.textSecondColor,
                ),
                SizedBox(
                  width: StyleSize.spaceSmall,
                ),
                Icon(
                  Icons.more_horiz,
                  color: ThemeService.color.textSecondColor,
                ),
              ],
              onActionsTap: (index) {
                if (index == 0) {
                  controller.playListService.addPlayList();
                } else {
                  Get.toNamed(Routes.PLAY_LIST);
                }
              },
            ),
          ),
          Obx(
            () => SliverList.builder(
              itemCount: min(controller.playList.length, 5),
              itemBuilder: (context, index) {
                var item = controller.playList[index];

                return ListTile(
                  dense: true,
                  onTap: () => Get.toNamed(
                    Routes.PLAY_LIST_DETAIL,
                    arguments: {'id': item.id},
                  ),
                  contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                  leading: MCover(url: item.imageUrl),
                  title: Text(item.name),
                  subtitle: Row(
                    children: [
                      Text(
                        '${item.songCount}',
                        style: TextStyle(
                          color: ThemeService.color.textSecondColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: ThemeService.color.textSecondColor,
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: MBottomPlaceholder()),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    var serachText =
        '${S.current.search}${S.current.song}、${S.current.artist}、${S.current.album}';
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 36,
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.SEARCH),
              child: Container(
                decoration: BoxDecoration(
                  color: ThemeService.color.cardColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(36),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 18,
                      color: ThemeService.color.textDisabledColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      serachText,
                      style: TextStyle(
                        color: ThemeService.color.textDisabledColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: StyleSize.space),
      decoration: BoxDecoration(
        color: ThemeService.color.cardColor,
        borderRadius: BorderRadius.circular(StyleSize.borderRadius),
        // boxShadow: [
        //   BoxShadow(
        //     color: ThemeService.color.thirdBgColor,
        //     blurRadius: 10,
        //     offset: Offset(0, 5),
        //   ),
        // ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: StyleSize.space),
            child: Row(
              children: [
                Obx(
                  () => MLogo(
                    size: 60,
                    serverType: controller.serverService.serverType,
                  ),
                ),
                SizedBox(width: StyleSize.space),
                SizedBox(
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MTitle(
                        title: controller.serverTypeString,
                        level: 3,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.music_note,
                            size: 13,
                            color: ThemeService.color.textSecondColor,
                          ),
                          SizedBox(width: 5),
                          Text(
                            S.current.unknown,
                            style: TextStyle(
                              fontSize: 13,
                              color: ThemeService.color.textSecondColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: StyleSize.space),
            child: Divider(
              height: 1,
              // thickness: 10,
              endIndent: 15,
              indent: 15,
              color: ThemeService.color.dividerColor.withOpacity(0.5),
            ),
          ),
          Row(
            children: [
              _summaryItem(Icons.library_music, S.current.allSong, () {
                Get.toNamed(Routes.SONG_LIST);
              }),
              _summaryItem(Icons.favorite, S.current.favorite, () {
                Get.toNamed(Routes.FAVORITE);
              }),
              _summaryItem(Icons.download, S.current.download, () {
                // TODO: not do
                MToast.show('comming soon');
              }),
            ],
          ),
          SizedBox(height: StyleSize.spaceLarge),
          Row(
            children: [
              _summaryItem(Icons.album, S.current.album, () {
                Get.toNamed(Routes.ALBUM_LIST);
              }),
              _summaryItem(Icons.person, S.current.artist, () {
                Get.toNamed(Routes.ARTISTS);
              }),
              _summaryItem(Icons.folder, S.current.directory, () {
                // TODO: not do
                MToast.show('comming soon');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
    IconData icon,
    String title,
    void Function() onClick,
  ) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onClick,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
            ),
            SizedBox(height: StyleSize.spaceSmall),
            Text(
              title,
            ),
          ],
        ),
      ),
    );
  }
}
