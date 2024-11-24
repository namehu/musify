import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/views/home/home_controller.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/m_title.dart';

import '../../../routes/pages.dart';

class HomeTabView extends StatelessWidget {
  final HomeController controller;
  HomeTabView({super.key, required this.controller});

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width),
      padding: EdgeInsets.all(StyleSize.space),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _search(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: StyleSize.space),
          ),
          SliverToBoxAdapter(
            child: _summaryCard(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: StyleSize.space),
          ),
          SliverToBoxAdapter(
            child: MTitle(title: S.current.playlist),
          ),
          SliverToBoxAdapter(
            child: Container(
              constraints: BoxConstraints(maxHeight: 320),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Obx(
                  () => ListView.builder(
                    // itemExtent: 60,
                    itemCount: min(controller.playList.length, 5),
                    itemBuilder: (context, index) {
                      var _item = controller.playList[index];

                      return Container(
                        // margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          dense: true,
                          onTap: () => Get.toNamed(Routes.PLAY_LIST_DETAIL,
                              arguments: {'id': _item.id}),
                          contentPadding:
                              EdgeInsets.only(left: 0.0, right: 0.0),
                          leading: MCover(url: _item.imageUrl),
                          title: Text(_item.name),
                          subtitle: Row(
                            children: [
                              Text(
                                '${_item.songCount}',
                                style: TextStyle(
                                  color: ThemeService.color.textSecondColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.more_vert,
                            color: ThemeService.color.iconColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _search() {
    return Row(
      children: [
        Expanded(
          child: Container(
            // margin: EdgeInsets.symmetric(horizontal: StyleSize.space),
            width: 300,
            height: 36,
            child: TextField(
              controller: _searchController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                // label: Text(''),
                hintText: S.current.pleaseInput + S.current.search,
                hintStyle: TextStyle(color: ThemeService.color.textSecondColor),
                prefix: Icon(Icons.search),
                filled: true,
                fillColor: ThemeService.color.dividerColor,
                contentPadding: EdgeInsets.all(0),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: ThemeService.color.secondBgColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: ThemeService.color.secondBgColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
              ),
              onTap: () {},
              onSubmitted: (val) {},
            ),
          ),
        )
      ],
    );
  }

  Widget _summaryCard() {
    return Container(
      constraints: BoxConstraints(maxHeight: 220),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1,
        children: [
          _summaryItem(Icons.library_music, S.current.allSong),
          _summaryItem(Icons.favorite, S.current.favorite),
          _summaryItem(Icons.download, S.current.download),
          _summaryItem(Icons.album, S.current.album),
          _summaryItem(Icons.person, S.current.artist),
          _summaryItem(Icons.folder, S.current.directory),
        ],
      ),
    );
  }

  Widget _summaryItem(
    IconData icon,
    String title,
  ) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          SizedBox(height: 5),
          Text(title),
        ],
      ),
    );
  }
}
